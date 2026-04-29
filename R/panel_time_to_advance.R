penel_time_to_advance <- htmltools::tagList(
  bslib::layout_columns(
    col_widths = c(
      -1, 10, -1,
      6, 6,
      -1, 10, -1,
      6, 6,
      -1, 10, -1, 12
    ),
    class = "align-items-center",

    # Row 1
    tags$div(
      tags$div("Introduction", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "To answer this question, we focus on active dancers - those who have
          earned at least one WSDC point in the past three years - who follow a
          standard skill progression (i.e. no Intermediate without first competing in Novice).
          We assume that a dancer belongs to a given division if they have earned
          at least one WSDC point in it. While this assumption isn't perfect, it
          provides a clear and consistent cutoff. For example, it doesn't fully
          capture cases where someone qualifies for a higher division but continues
          competing in a lower one. However, it helps avoid complications arising
          from rule changes over time. To estimate progression speed, we calculate
          the time between a dancer's first final in a lower division and their
          first final in the next higher division. This gives us a practical measure
          of how long it typically takes to move up."
        )
      )
    ),

    # Row 2
    tags$div(
      tags$div("Time to Progress (or is it?)", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "The chart on the right shows the results by role and division,
          with medians highlighted in bold."
        ),
        tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
        tags$ul(
          tags$li(
            "The higher the division, the longer it typically takes to progress."
          ),
          tags$li(
            "The distributions are heavily right-skewed - you can see this more
            clearly by using the zoom feature at the bottom of the chart.
            Many dancers take a long time to move up."
          ),
          tags$li(
            "On average, there is no significant difference between roles when
            it comes to time to progress."
          )
        ),
        tags$p(
          "At first glance, these numbers might suggest that progressing to the
          next division doesn't take that long on average. But there's an important
          caveat: the chart doesn't show the time it takes ", tags$em("to progress"), "
           - it shows the time it takes ", tags$em("given that progression happens"), "."
        ),
        tags$p(
          "That distinction matters. We're only looking at dancers who ", tags$em("did"), "
          advance to the next division. What about those who haven't yet - or never will?"
        )
      )
    ),

    echarts4r::echarts4rOutput("plot_time_to_progress", height = "55vh") |> add_spinner(),


    # Row 3
    tags$div(
      style = "text-align: justify;padding:1rem;",
      tags$p(
        "A simple median (as shown in the chart above) tells us how long it takes
        for 50% of dancers in a given division to progress to the next -
        ", tags$em("assuming"), " they progress at all."
      ),
      tags$p(
        "When we look at dancers today, however, we don't know how many will actually
        advance. Some may stop competing altogether. That's partial information
        we need to account for - not ignore. Doing so requires slightly more
        sophisticated methods than a simple median. For clarity, we also combine
        roles here (welll examine them separately in the next question). As dancers
        progress month by month, we can update the probability of advancing -
        essentially making use of the data as it becomes available - in simplified
        terms, this is the ", tags$a(
          "Kaplan–Meier estimator",
          href = "https://en.wikipedia.org/wiki/Kaplan–Meier_estimator",
          target = "_blank"
        ), " with censored data in action,
        adapted from a \"survival\" context to a \"success\" one. (Don't worry - you
        don't need to wrestle with its Wikipedia page to understand the results.)"
      )
    ),

    # Row 4
    echarts4r::echarts4rOutput("plot_median_difference", height = "35vh") |> add_spinner(),

    tags$div(
      tags$div("More Accurate Medians", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "Computing medians using this method reveals a very different picture.
          Plot on the left compares the standard medians with the adjusted ones."
        ),
        tags$ul(
          tags$li(
            "The median time to reach Intermediate roughly doubles; to Advanced,
            it more than doubles; and to All-Stars, it nearly triples.
            The increase becomes more pronounced in higher divisions - which
            isn't surprising, as these divisions require more points and tend to
            be smaller (so placements earn fewer points), naturally slowing progression."
          ),
          tags$li(
            "There is no median for progression from All-Stars to Champions.
            This indicates that fewer than 50% of All-Star dancers ever make it to Champions."
          )
        )
      )
    ),

    # Row 5
    tags$div(
      tags$div("Time to Progress", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "Now that we have a more accurate estimate of the median time to progress,
          you might wonder: what about the time it takes for 75% of Novice dancers to
          reach Intermediate? Or 90%? Or even all of them? In other words,
          what does the full distribution look like? Think of it this way:
          ", tags$em("out of all dancers in a given division, how many have progressed at each point in time?")
        ),
        tags$p(
          "As time passes, more dancers advance, and the curve steadily rises -
          hover over the chart below to see exact figures for each division, and
          use the zoom at the bottom to focus on specific timeframes. Each dot
          represents actual dancers advancing to the next division.
          A small step upward means only a few dancers progressed at that time;
          a larger step indicates a bigger group moving up. If no one advances
          for a while, the curve remains flat - creating a \"waiting period\"
          visible as horizontal steps. Importantly, dancers who haven't yet
          advanced - or never will - are still included in the totals at every
          point in time. In other words, we're always considering those who are
          still \"eligible\" to progress."
        ),
        tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
        tags$ul(
          tags$li(
            "No division reaches 100%, meaning there are always dancers who have
            not yet reached the next division. If a division ever did reach 100%,
            it would effectively be \"empty\" - everyone would have already moved
            on, leaving no active competitors behind."
          ),
          tags$li(
            "Only about 25% of All-Stars dancers are observed to reach Champions.
            The remaining 75% either have not reached it yet or never will
            (we can't distinguish between the two). This also explains why we didn't
            observe a median earlier - it simply does not exist in this case."
          ),
          tags$li(
            "The Novice to Intermediate curve is steeper than the others.
            This indicates that progression from Novice to Intermediate tends to
            happen faster than in higher divisions, which makes sense since it
            requires fewer WSDC points."
          ),
          tags$li(
            "The Novice to Intermediate curve also sits above the others.
            This means a larger fraction of dancers progress at any given time
            compared to higher divisions. This reflects the fact that there are
            more Novice dancers overall - meaning higher competition tiers and more
            points when placing high. Progression tends to happen more frequently
            at lower levels."
          ),
          tags$li(
            "Some divisions do not show values on hover where others do.
            This occurs because points are only plotted when an advancement
            actually happens (i.e. when someone earns their first Intermediate,
            Advanced, etc. point). If no point appears at a given time, it simply
            means no one in the dataset reached that milestone at that moment - you
            can infer the trend from neighbouring points."
          ),
          tags$li(
            "There are visible outliers. These appear as points far to the right
            and represent dancers who took an exceptionally long time to progress.
            They are not representative of the typical journey."
          ),
          tags$li(
            "You can see a large jump from Advanced to All-Stars at the end of the series.
            The curve shows the percentage of all dancers in a given division,
            at a given point in time, who have progressed. When the remaining
            pool of dancers is small, even a single person moving up can create
            a relatively large jump in the curve - that's exactly what happened here."
          )
        )
      )
    ),

    # Row 6
    echarts4r::echarts4rOutput("plot_time_to_advance_survival", height = "55vh") |> add_spinner()
  )
)
