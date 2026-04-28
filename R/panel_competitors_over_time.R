panel_competitors_over_time <- htmltools::tagList(
  bslib::layout_columns(
    col_widths = c(-1, 10, -1, 12),

    tags$div(
      style = "text-align: justify;padding:1rem;",
      tags$p(
        "Answering this question directly isn’t straightforward. A more practical
        approach is to reframe it as: ", tags$em("\"Are more people competing over time?\""), " - which makes it measurable."
      ),
      tags$p(
        "To explore this, we use data from scoring.dance to estimate the total
        number of dancers participating in competitions. There are a few caveats
        to keep in mind. A single dancer may compete in multiple categories - for
        example, Novice as a leader, Newcomer as a follower, and in Sophisticated - so
        they may be counted more than once. This can slightly inflate the numbers,
        though not dramatically."
      ),
      tags$p(
        "Another potential confounding factor is event size. An increase in
        competitors might simply reflect larger events rather than more individuals
        choosing to compete. However, larger events still imply greater participation
        overall, so this isn’t a major concern."
      ),
      tags$p(
        "It’s also worth noting that this dataset includes only Jack & Jill competitions.
        It excludes Strictly, Switch, and other special formats, which means
        the total number of competitors is understated."
      ),
      tags$p(
        "Finally, not all events are recorded on scoring.dance, so some data is
        inevitably missing. Even so, the dataset provides a sufficiently
        representative sample to draw meaningful conclusions."
      ),
      tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$ul(
        tags$li("The number of competitors is steadily increasing - more and more dancers are choosing to compete over time."),
        tags$li("Budafest stands out as a major outlier; the largest spikes in the data are driven by this event.")
      )
    ),

    echarts4r::echarts4rOutput("plot_comp_size_overtime", height = "50vh") |> add_spinner()
  )
)
