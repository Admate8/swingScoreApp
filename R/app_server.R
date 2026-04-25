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
        paste0("You competed the most often as a ", selected_dancer_role())
      )
    )
  })


  # Plots omega change ----
  ## Dominant role
  output$plot_nonomega_individual <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_nonomega_individual(df_selected_dancer(), selected_dancer_role(), TRUE, TRUE)
  })
  output$plot_omega_individual <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_selected_dancer(), selected_dancer_role(), TRUE, TRUE)
  })
  ## Age divisions
  output$plot_omega_individual_nonadv <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_selected_dancer(), selected_dancer_role(), TRUE, FALSE)
  })
  ## Non-dominant role
  output$plot_omega_individual_nondom <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_selected_dancer(), selected_dancer_role(), FALSE, TRUE)
  })


}
