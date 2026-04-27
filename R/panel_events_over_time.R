penel_events_over_time <- htmltools::tagList(
  bslib::layout_columns(
    col_widths = c(-1, 10, -1, 12),

    tags$div(
      style = "text-align: justify;padding:1rem;",
      tags$p(
        "The most direct way to answer this question would be to track the number
        of dancers over time. Unfortunately, that data isn't available. Instead,
        we use the number of events per month as a proxy - which is a reasonable
        approach, as we'd expect supply (events) to grow alongside increasing
        global demand (dancers). This data was compiled from the WSDC database by
        scraping all unique
        events where dancers earned WSDC points. Not every event is, or has been,
        WSDC-registered, so some are inevitably missing. It's not perfect, but
        it provides a solid overall picture. You can toggle individual series on
        and off in the chart by clicking the legend."
      ),
      tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$ul(
        tags$li(
          "The overall trend is clearly positive - we see a steady increase in
          the number of events over time."
        ),
        tags$li(
          "There is a noticeable dip around 2021, likely due to the COVID-19
          pandemic and its broader societal impact, not just on the WCS community."
        ),
        tags$li(
          "The Americas and Europe make up the vast majority of the WCS scene."
        ),
        tags$li(
          "Events in the Americas dominate and continue to grow."
        ),
        tags$li(
          "Europe shows strong and consistent growth. Since WCS gained traction
          there, the number of events has increased at a notably steep rate - steeper
          than in any other region."
        ),
        tags$li(
          "Growth in Oceania and Asia remains comparatively modest, despite both
          regions hosting their first events not long after Europe."
        )
      )
    ),

    echarts4r::echarts4rOutput("plot_events_over_time", height = "50vh") |> add_spinner()
  )
)

