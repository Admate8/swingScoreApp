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

        tags$div(class = "section", ui_welcome_page),

        tags$div(
          class = "section",
          tags$div(class = "slide", ui_individual_analysis_setup),
          tags$div(class = "slide", ui_competitive_analysis)
        ),

        tags$div(
          class = "section",
          tags$div(class = "slide", ui_individual_analysis_adv_dom),
          tags$div(class = "slide", ui_individual_analysis_nonadv),
          tags$div(class = "slide", ui_individual_analysis_nondom)
        ),

        tags$div(class = "section", ui_individual_analysis_details),
        tags$div(class = "section", ui_individual_analysis_group),

        tags$div(class = "section fp-auto-height", ui_footer)
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
