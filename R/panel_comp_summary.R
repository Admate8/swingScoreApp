penel_comp_summary <- htmltools::tagList(
  bslib::layout_columns(
    col_widths = c(4, 4, 4, 6, 6),
    class = "align-items-center",

    tags$div(
      style = "text-align: justify;padding:1rem;",
      tags$p(
        "It's difficult to determine what proportion of all dancers choose to
      compete without data on the total number of participants across events.
      What we can examine, however, is the division–role split among those who do
      compete."
      ),
      tags$p(
        "Let's start by looking at all competitors. The first thing to
      notice is that, in almost all divisions, there are more followers than
      leaders - often by a considerable margin in the lower divisions. That said,
      the distribution within each role is fairly similar."
      ),
      tags$p(
        "There is one caveat to this analysis: role classifications have evolved over time.
      Some of the earliest competitors in the dataset earned WSDC points as far
      back as 1990. Since then, divisions have shifted and been redefined,
      meaning that an \"Advanced\" dancer today may not be directly comparable
      to an \"Advanced\" dancer from 30 years ago."
      )
    ),

    echarts4r::echarts4rOutput("plot_active_dancers_prop", height = "40vh") |> add_spinner(),

    tags$div(
      style = "text-align: justify;padding:1rem;",
      tags$p(
        "For this reason, we define an ", tags$em("active competitor"), " as a dancer who has
        earned at least one WSDC point in the past three years. This definition
        significantly reduces the pool of competitors - which is, in itself, an
        interesting observation."
      ),
      tags$p(
        "The majority of competitors are no longer active. There could be many
        reasons for this, with age likely being one of them. Still, it's striking
        just how small the active group is."
      ),
      tags$p(
        "One caveat is that some Newcomer and Novice dancers may not yet have
        earned their first WSDC point and are therefore excluded from these figures."
      ),
      tags$p(
        "As with the full dataset, there are more followers than leaders,
        but the distribution within each role remains fairly similar."
      )
    ),

    tags$div(
      tags$div("All Dancers", class = "glass-div-header", style = "font-size:1.2rem;"),
      br(),
      reactable::reactableOutput("table_all_dancers_summary") |> add_spinner()
    ),
    tags$div(
      tags$div("Active Dancers", class = "glass-div-header", style = "font-size:1.2rem;"),
      br(),
      reactable::reactableOutput("table_active_dancers_summary") |> add_spinner()
    )
  )
)
