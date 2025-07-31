#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # JavaScript to show/hide triangle with smooth animation
  observe({
    if (exists("input") && !is.null(input$select_dancer)) {
      if (input$select_dancer != "") {
        shinyjs::runjs("$('.nav-triangle').addClass('show');")
      } else {
        shinyjs::runjs("$('.nav-triangle').removeClass('show');")
      }
    }
  })


  observe({
    output$text_test <- renderText({if (is.null(input$select_dancer) | input$select_dancer == "") 1 else 0})
  })

  output$test <- echarts4r::renderEcharts4r({
    mtcars$name <- rownames(mtcars)
    mtcars |> echarts4r::e_chart(name) |> echarts4r::e_bar(serie = disp)
  })
}
