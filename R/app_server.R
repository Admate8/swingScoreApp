#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  # Load data ----
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

  # observeEvent(input$button_go_individ, {
  #   shinyjs::runjs("fullpage_api.moveTo(2, 1);")
  # })

  output$table_event_details <- reactable::renderReactable({
    table_event_details(df_events, df_subevents, df_comps)
  })


  output$test <- echarts4r::renderEcharts4r({
    mtcars$name <- rownames(mtcars)
    mtcars |> echarts4r::e_chart(name) |> echarts4r::e_bar(serie = disp)
  })

  output$test2 <- renderTable({
    df_all_events
  })
}
