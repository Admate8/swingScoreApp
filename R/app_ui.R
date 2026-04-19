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
            tags$h1("Welcome to the Omega Project"),
            tags$div(class = "accent-line"),
            tags$div("I want to...", class = "faq-header"), br(),
            actionButton(
              inputId = "button_go_individual",
              label   = label_button_indivdual_analysis,
              onclick = "fullpage_api.moveTo(2, 0);",
              class   = "btn-glow",
              style   = "font-size: 1.5rem;"
            ),
            actionButton(
              inputId = "button_go_group",
              label   = label_button_group_analysis,
              onclick = "fullpage_api.silentMoveTo(2, 1);",
              class   = "btn-glow",
              style   = "font-size: 1.5rem;"
            )
          )
        ),

        tags$div(
          class = "section",
          tags$div(
            class = "slide",
            tags$div(
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
                  open     = FALSE,
                  multiple = FALSE,
                  bslib::accordion_panel(
                    title = "What is Omega?",
                    lorem::ipsum(1)
                  ),
                  bslib::accordion_panel(
                    title = "My data looks incorrect. What should I do?",
                    lorem::ipsum(2)
                  ),
                  bslib::accordion_panel(
                    title = "Competition is missing. Why?",
                    lorem::ipsum(1)
                  ),
                  bslib::accordion_panel(
                    title = "Title 4",
                    lorem::ipsum(1)
                  )
                )
              )
            )

          ),

          tags$div(
            class = "slide"
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
              echarts4r::echarts4rOutput("test"),
              tableOutput("test2")
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
        ),

        # Footer ----
        tags$div(
          class = "section fp-auto-height",
          tags$div(
            class = "customFooter",
            "XXX"
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
    # Cache-busting link — version changes every run
    tags$link(
      rel  = "stylesheet",
      type = "text/css",
      href = paste0("www/custom_styles.css?v=", as.integer(Sys.time()))
    ),
    shinyjs::useShinyjs(),

    # Import and add the fullPage.js files
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/4.0.20/fullpage.min.css"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/4.0.20/fullpage.min.js")
  )
}
