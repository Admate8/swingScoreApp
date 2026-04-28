penel_average_competition <- htmltools::tagList(
  bslib::layout_columns(
    col_widths = c(6, 6, 6, 6),
    class = "align-items-center",

    tags$div(
      tags$div("Average Competition Size", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "Using scoring.dance data (after some cleaning), we can plot the average
        number of competitors per division and role - this is exactly what the
        chart on the right shows. You can toggle roles in the legend to focus on
        a specific role."
        ),
        tags$p(
          "We excluded rare Jack & Jill categories such as Novice Masters or Newcomer
        Junior. The chart gives a good sense of what a typical WCS competition looks like.
        Note that we're using the arithmetic mean, so outliers (very large or very
        small events) have a proportionally greater influence on the results."
        ),
        tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
        tags$ul(
          tags$li(
            "Novice is by far the largest division, while Champions is the
          smallest - for both roles. This aligns with the overall distribution
          of dancers discussed earlier."
          ),
          tags$li(
            "In almost all divisions, there are, on average, more followers than
          leaders, with the largest gap in Novice. This difference becomes
          less pronounced in higher divisions."
          ),
          tags$li(
            "Among the age divisions, Sophisticated has the highest average number of competitors."
          )
        )
      )
    ),

    echarts4r::echarts4rOutput("plot_average_comp_size", height = "55vh") |> add_spinner(),
    echarts4r::echarts4rOutput("plot_average_perc_in_final", height = "55vh") |> add_spinner(),

    tags$div(
      tags$div("Percentage in Finals", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "For each competition, we can calculate the proportion of dancers who
          advanced to the final round (note that this doesn't necessarily mean
          they earned WSDC points). We then compute the average for each division
          and role - the chart on the left illustrates this."
        ),
        tags$p(
          "Again, we're using arithmetic means; otherwise, the Champions division
          would show 100% average final participation, which - given its small
          size - wouldn't be very informative."
        ),
        tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
        tags$ul(
          tags$li(
            "A key relationship emerges: the larger the competition, the smaller
            the percentage of dancers who reach the final. Compare this chart
            with the one above, and the pattern becomes clear."
          ),
          tags$li(
            "For this reason, it is generally more difficult, on average,
            to make the final as a follower than as a leader - this holds across
            most divisions."
          ),
          tags$li(
            "By the same logic, advancing to the final becomes easier, on average, in higher divisions."
          ),
          tags$li(
            "You may notice a cluster of data points at the 100% mark. These represent
            competitions where there weren't enough participants to run preliminary rounds,
            so everyone advanced to the final. As a result, these cases introduce
            the most distortion into the distribution."
          )
        )
      )
    ),

    tags$div(
      tags$div("Follower-to-Leader Ratio", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
      tags$div(
        style = "text-align: justify;padding:1rem;",
        tags$p(
          "As with the percentage of finalists, we can calculate the average
          follower-to-leader ratio for each division. The chart on the right
          presents these results."
        ),
        tags$p(
          "A ratio of 2 means that, on average, there are two followers for every
          leader - in other words, the higher the ratio, the greater the imbalance
          in favour of followers. A ratio of 1 would indicate a perfectly balanced
          field (the dream!)."
        ),
        tags$p(
          "One note: this is not the same as calculating the follower-to-leader
          ratio of the average competition in each division. Here, ratios are
          computed at the competition level first and then averaged, so you
          can't reproduce these numbers directly from the earlier chart."
        ),
        tags$div("Observations", class = "glass-div-header", style = "font-size:1.2rem;text-align:left;"),
        tags$ul(
          tags$li(
            "In almost all divisions, the follower-to-leader ratio is greater than 1,
            confirming that there are typically more followers than leaders."
          ),
          tags$li(
            "Among the skill divisions, Newcomer has the highest ratio and Champions
            the lowest. The ratio generally decreases as the division level increases,
            likely because the imbalance is less pronounced at higher levels."
          ),
          tags$li(
            "Among the age divisions, Juniors are heavily skewed towards followers."
          )
        )
      )
    ),
    echarts4r::echarts4rOutput("plot_average_f_t_l_ratio", height = "55vh") |> add_spinner()
  )
)
