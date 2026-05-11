ui_footer <- tags$div(
  class = "customFooter",
  style = glue::glue("display: flex; justify-content: space-between; color: {col_palette$global$primary_light};"),
  tags$div(
    class = "left-text",
    style = "font-size: 1.2rem;",
    HTML(paste("&copy", lubridate::year(Sys.Date()), "Adrian Wisnios"))
  ),
  tags$div(
    class = "right-text",
    htmltools::tagList(
      tags$a(
        href = "mailto:omega.dancing.score@gmail.com",
        icon("square-envelope", style = glue::glue("color: {col_palette$global$primary_light}; font-size: 2rem;")),
        target = "_blank"
      ),

      tags$a(
        href = "https://www.linkedin.com/in/adrian-wisnios-022408215/",
        icon("linkedin", style = glue::glue("color: {col_palette$global$primary_light}; font-size: 2rem;")),
        target = "_blank"
      ),

      tags$a(
        href = "https://github.com/Admate8/swingScoreApp",
        icon("square-github", style = glue::glue("color: {col_palette$global$primary_light}; font-size: 2rem;")),
        target = "_blank"
      ),

      tags$a(
        href = "https://www.instagram.com/admate8/",
        icon("square-instagram", style = glue::glue("color: {col_palette$global$primary_light}; font-size: 2rem;")),
        target = "_blank"
      )
    )
  )
)
