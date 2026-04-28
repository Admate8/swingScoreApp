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
  # df_all_events <- DBI::dbGetQuery(db_con, "SELECT * FROM df_all_events")
  #
  # on.exit(DBI::dbDisconnect(db_con))

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

}
