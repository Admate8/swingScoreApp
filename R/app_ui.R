#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),

    bslib::page_fluid(
      theme = app_theme,
      tags$div(
        id = "fullpage",

        tags$div(
          class = "section",
          tags$div(class = "halo"),
          tags$div(class = "geometric-pattern"),
          tags$div(
            class = "content-title",
            tags$h1("Welcome to the Omega App"),
            tags$div(class = "accent-line"),
            shinyWidgets::pickerInput(
              inputId    = "select_dancer",
              label      = NULL,
              selected   = NULL,
              multiple   = FALSE,
              width      = "25rem",
              choices    = rownames(mtcars),
              choicesOpt = list(
                subtext = paste0("(", mtcars$mpg, ")")
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
            ) |> tags$div(style = "display: flex; justify-content: center; margin-top: 1rem;")
          ),
          bslib::layout_columns(
            col_widths = c(-3, 6, -3),
            class = "home-content-container",
            tags$div(
              style = "z-index: 3;",
              tags$div("FAQ", class = "faq-header"),
              bslib::accordion(
                open  = FALSE,
                multiple = FALSE,
                bslib::accordion_panel(
                  title = "What is Omega?",
                  "text1jbkfhjwbfhewbfhjwebfjhwehbfvjewfhjwebfhhjewfjhwefbbhwejhbjcfewbfchjewbfchjewbfchjewbfhjebwfbewbfjhewbvfhjewvfjhewbvfhjewvfchewvfjhwevjhwvhfjwevfhejwvjvhfhjwevfhjwevhf"
                ),
                bslib::accordion_panel(
                  title = "My data looks incorrect. What should I do?",
                  "text2"
                ),
                bslib::accordion_panel(
                  title = "Competition is missing. Why?",
                  "text3"
                ),
                bslib::accordion_panel(
                  title = "Title 4",
                  "text4"
                )
              )
            )
          ),
          conditionalPanel(
            condition = "input.select_dancer != '' && input.select_dancer != null",
            tags$div(
              class = "glow-triangle-container",
              id    = "triangle_btn",
              "",
              tags$svg(
                class = "glow-triangle",
                viewBox = "0 0 120 60",  # maintains aspect ratio
                tags$defs(
                  tags$linearGradient(
                    id = "glow-gradient",
                    x1 = "0%", y1 = "0%",
                    x2 = "100%", y2 = "100%",
                    tags$stop(offset = "0%"),
                    tags$stop(offset = "100%")
                  )
                ),
                tags$polygon(
                  points = "10,10 110,10 60,50",
                  class = "glow-border",
                  fill = "url(#glow-gradient)"
                )
              )
            )

          )
        ),

        # Section 2
        tags$div(
          class = "section",

          # Slide 1
          tags$div(
            class = "slide",
            div(
              class = "content",
              echarts4r::echarts4rOutput("test")
            )
          ),
          # Slide 2
          tags$div(
            class = "slide"
          ),
          # Slide 3
          tags$div(
            class = "slide"
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "swingScore"
    ),
    shinyjs::useShinyjs(),

    # Import and add the fullPage.js files
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/4.0.20/fullpage.min.css"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/4.0.20/fullpage.min.js")
  )
}
