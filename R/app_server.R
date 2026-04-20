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

  # Table Event Details ----
  output$table_event_details <- reactable::renderReactable({
    table_event_details(df_events, df_subevents, df_comps)
  })

  # Plots Omega Change ----
  output$plot_nonomega_individual <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_nonomega_individual(df_dancers, input$select_dancer)
  })

  output$plot_omega_individual <- echarts4r::renderEcharts4r({
    req(input$select_dancer)
    plot_omega_individual(df_dancers, input$select_dancer)
  })


}
