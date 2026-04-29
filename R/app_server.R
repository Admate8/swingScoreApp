#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  # Load Data ----
  # db_con <- DBI::dbConnect(
  #   RPostgres::Postgres(),
  #   host     = Sys.getenv("NEON_HOST"),
  #   dbname   = Sys.getenv("NEON_DBNAME"),
  #   user     = Sys.getenv("NEON_USER"),
  #   password = Sys.getenv("NEON_PASSWORD")
  # )
  db_con <- DBI::dbConnect(
    RPostgres::Postgres(),
    host     = db_host,
    user     = db_user,
    password = db_password,
    port     = 5432,
    dbname   = db_name
  )

  df_all_events       <- DBI::dbGetQuery(db_con, "SELECT * FROM df_all_events")
  df_events           <- DBI::dbGetQuery(db_con, "SELECT * FROM df_events")
  df_subevents        <- DBI::dbGetQuery(db_con, "SELECT * FROM df_subevents")
  df_dancers          <- DBI::dbGetQuery(db_con, "SELECT * FROM df_dancers") |>
    dplyr::mutate(contestant_id = paste0(contestant, "_", wsdc_id)) |>
    dplyr::left_join(
      df_events |> dplyr::distinct(event_id, event_date, event_name),
      by = "event_id"
    )
  df_first_final      <- DBI::dbGetQuery(db_con, "SELECT * FROM df_first_final")
  df_placement_counts <- DBI::dbGetQuery(db_con, "SELECT * FROM df_placement_counts")
  df_comps            <- DBI::dbGetQuery(db_con, "SELECT * FROM df_competitions")

  on.exit(DBI::dbDisconnect(db_con))


  # Picker for dancer options
  output$pickerInput_dancer <- renderUI({

    df_helper <- df_dancers |>
      dplyr::mutate(contestant = stringr::str_to_title(contestant)) |>
      dplyr::distinct(contestant, wsdc_id, contestant_id) |>
      dplyr::arrange(contestant)

    shinyWidgets::pickerInput(
      inputId    = "select_dancer",
      label      = NULL,
      selected   = NULL,
      multiple   = FALSE,
      width      = "25rem",
      choices    = stats::setNames(
        df_helper |> dplyr::pull(contestant_id),
        df_helper |> dplyr::pull(contestant)
      ),
      choicesOpt = list(
        subtext = paste0(
          "(", df_helper |> dplyr::pull(wsdc_id), ")"
        )
      ),
      options = shinyWidgets::pickerOptions(
        size                = 3,
        liveSearch          = TRUE,
        liveSearchNormalize = TRUE,
        liveSearchStyle     = "contains",
        noneResultsText     = "No matches...",
        showSubtext         = TRUE,
        title               = "Select your name or WSDC ID..."
      )
    )
  })

  # ~ ----
  # Table event details ----
  output$table_event_details <- reactable::renderReactable({
    table_event_details(df_events, df_subevents, df_comps)
  })

  # Main data for selected dancer
  df_selected_dancer <- reactive({
    req(input$select_dancer)
    df_dancers |> dplyr::filter(contestant_id == input$select_dancer)
  })
  selected_dancer_role <- reactive({
    req(input$select_dancer)

    df_helper <- df_selected_dancer() |> dplyr::count(role)
    df_helper$role[which.max(df_helper$n)]
  })
  selected_dancer_currdivision <- reactive({
    req(input$select_dancer)

    df_helper <- df_selected_dancer() |>
      dplyr::distinct(division_adj) |>
      dplyr::mutate(order = dplyr::case_when(
        division_adj == "Newcomer"     ~ 1,
        division_adj == "Novice"       ~ 2,
        division_adj == "Intermediate" ~ 3,
        division_adj == "Advanced"     ~ 4,
        division_adj == "All-Stars"    ~ 5,
        division_adj == "Champions"    ~ 5,
        TRUE                           ~ NA
      ))
    df_helper$division_adj[which.max(df_helper$order)]
  })


  # UI selected dancers ----
  output$ui_selected_dancer <- renderUI({
    req(input$select_dancer)

    dancer <- df_selected_dancer() |>
      dplyr::distinct(contestant, wsdc_id) |>
      dplyr::mutate(dancer_display = stringr::str_to_title(paste0(contestant, " (", wsdc_id, ")"))) |>
      dplyr::pull(dancer_display)

    tags$div(
      tags$div(class = "glass-div-header", dancer),
      tags$div(
        class = "subheader",
        htmltools::HTML(paste0("You competed the most often as a <b>", selected_dancer_role(), "</b>"))
      )
    )
  })

  # Hint notification ----
  debounced_button_dancer_selected <- reactive({
    input$button_dancer_selected
  }) |> debounce(3000)
  observeEvent(debounced_button_dancer_selected(), {
    showNotification(
      tags$div(
        tags$div(
          style = "text-align: center; padding-bottom: 10px;",
          tags$h5("Hint!")
        ),
        tags$p("Move the slider to see how Omega changes your perspective on performance!"),
        br(),
        tags$p(
          "You can navigate to slides showing your Age Divisions
          or non-dominant role competitions by using the navigation
          arrows or the small dots at the bottom of the page."
        )
      ),
      type = "default",
      duration = 15
    )
  })



  # ~ ----
  # Individual Analysis ----
  ## Plots omega change ----
  ### Dominant role
  output$plot_nonomega_individual <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_nonomega_individual(df_selected_dancer(), selected_dancer_role(), TRUE, TRUE)
  })
  output$plot_omega_individual <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_selected_dancer(), selected_dancer_role(), TRUE, TRUE)
  })
  ### Age divisions
  output$plot_omega_individual_nonadv <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_selected_dancer(), selected_dancer_role(), TRUE, FALSE)
  })
  ### Non-dominant role
  output$plot_omega_individual_nondom <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_selected_dancer(), selected_dancer_role(), FALSE, TRUE)
  })

  ## Plot omega details ----
  ### UI
  output$ui_omega_details <- renderUI({
    req(input$select_dancer)

    tags$div(
      tags$div(class = "glass-div-header", "Zooming In"),
      tags$div(
        class = "subheader",
        htmltools::HTML(paste0(
          "on your highest division - <b>", selected_dancer_currdivision(),
          "</b> (as determined from the data) as a <b>", selected_dancer_role(), "</b>"
        ))
      )
    )
  })

  ### Plot
  output$plot_omega_current_division <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_current_division(df_dancers, input$select_dancer, selected_dancer_role(), selected_dancer_currdivision())
  })

  ## Plot omega group ----
  output$plot_omega_group <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_group(df_dancers, input$select_dancer, selected_dancer_role(), selected_dancer_currdivision())
  })



  # ~ ----
  # Competition Analysis ----
  ## Comps summary ----
  output$plot_active_dancers_prop <- echarts4r::renderEcharts4r({
    plot_active_dancers_prop(df_placement_counts)
  })
  output$table_all_dancers_summary <- reactable::renderReactable({
    table_dancers_summary(get_df_dancers_summary(df_placement_counts)$df_all_dancers)
  })
  output$table_active_dancers_summary <- reactable::renderReactable({
    table_dancers_summary(get_df_dancers_summary(df_placement_counts)$df_active_dancers)
  })

  ## Events over time ----
  output$plot_events_over_time <- reactable::renderReactable({
    plot_events_over_time(df_all_events)
  })

  ## Competitors over time ----
  output$plot_comp_size_overtime <- reactable::renderReactable({
    plot_comp_size_overtime(df_comps, df_events)
  })

  ## Average competition plots ----
  df_comps_avgs <- reactive({get_df_average_comp(df_comps, df_events)})
  output$plot_average_comp_size <- reactable::renderReactable({
    plot_average_comp_size(df_comps_avgs())
  })
  output$plot_average_perc_in_final <- reactable::renderReactable({
    plot_average_perc_in_final(df_comps_avgs())
  })
  output$plot_average_f_t_l_ratio <- reactable::renderReactable({
    plot_average_f_t_l_ratio(df_comps_avgs())
  })

  ## Time to advance plots ----
  output$plot_time_to_progress <- reactable::renderReactable({
    plot_time_to_progress(df_first_final)
  })
  output$plot_median_difference <- reactable::renderReactable({
    plot_median_difference(df_first_final)
  })
  output$plot_time_to_advance_survival <- reactable::renderReactable({
    plot_time_to_advance_survival(df_first_final)
  })

  ## Panel anova testing ----
  output$penel_anova_testing <- renderUI({
    htmltools::tagList(
      bslib::layout_columns(
        col_widths = c(-1, 10, -1),

        tags$div(
          style = "text-align: justify;padding:1rem;",
          tags$p(
            "When we looked at the simple medians in the previous question, we didn't see
            meaningful differences between roles. We then combined roles for the more
            advanced Kaplan-Meier analysis. So the question remains: if we account for
            dancers who stay in a division for a long time - or never leave it at all - can
            we say whether it is easier to progress as a Leader or as a Follower?"
          ),
          tags$p(
            "Without going too far into the technical details, we can answer this
        using a ", tags$a(
          "Cox proportional hazards model",
          href = "https://en.wikipedia.org/wiki/Proportional_hazards_model",
          target = "_blank"
        ), ", stratified by division and adjusted for repeated observations.
        Don't worry about the methodology itself - those curious can find the
        statistical test results in parentheses. Overall:"
          ),
        anova_results(df_first_final),
        tags$p(
          "In other words, we have no evidence to suggest that the time it takes
        to progress to the next division differs between Leaders and Followers - we're
        all on the same boat!"
        )
        )
      )
    )
  })

}
