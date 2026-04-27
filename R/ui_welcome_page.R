ui_welcome_page <- htmltools::tagList(
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
)
