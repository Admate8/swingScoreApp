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

  # JavaScript to show/hide triangle with smooth animation
  # observe({
  #   if (exists("input") && !is.null(input$select_dancer)) {
  #     if (input$select_dancer != "") {
  #       shinyjs::runjs("$('.nav-triangle').addClass('show');")
  #     } else {
  #       shinyjs::runjs("$('.nav-triangle').removeClass('show');")
  #     }
  #   }
  # })

  output$button_triangle_go <- renderUI({
    req(input$select_dancer)

    tags$div(
      class = "glow-triangle-container",
      id    = "triangle_btn",
      "",
      tags$svg(
        class = "glow-triangle",
        viewBox = "0 0 120 70",  # maintains aspect ratio
        tags$polygon(
          points = "10,10 110,10 60,58",
          class = "glow-border",
          fill = "url(#glow-gradient)"
        )
      )
    )
  })


  output$test <- echarts4r::renderEcharts4r({
    mtcars$name <- rownames(mtcars)
    mtcars |> echarts4r::e_chart(name) |> echarts4r::e_bar(serie = disp)
  })

  output$test2 <- renderTable({
    df_all_events
  })
}
