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

        # 1. Welcome Page ----
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

          # 2. Indiv Analysis Set-up ----
          tags$div(class = "slide", ui_individual_analysis_setup),

          tags$div(
            class = "slide"
          )


        ),

        tags$div(
          class = "section",
          tags$div(class = "slide", ui_individual_analysis_adv_dom),
          tags$div(class = "slide", ui_individual_analysis_nonadv),
          tags$div(class = "slide", ui_individual_analysis_nondom)
        ),

        tags$div(class = "section", ui_individual_analysis_details),
        tags$div(class = "section", ui_individual_analysis_group),

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
