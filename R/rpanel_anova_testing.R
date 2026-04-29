penel_anova_testing <- htmltools::tagList(
  bslib::layout_columns(
    col_widths = c(-1, 10, -1),

    tags$div(
      style = "text-align: justify;padding:1rem;",
      tags$p(
        "When we looked at the simple medians in the previous question, we didn't see
    meaningful differences between roles. We then combined roles for the more
    advanced Kaplan-Meier analysis. So the question remains: if we account for
    dancers who stay in a division for a long time - or never leave it at all - can
    we say whether it is easier to progress as a Leader or as a Follower?"
      ),
      tags$p(
        "Without going too far into the technical details, we can answer this
        using a ", tags$a(
          "Cox proportional hazards model",
          href = "https://en.wikipedia.org/wiki/Proportional_hazards_model",
          target = "_blank"
        ), ", stratified by division and adjusted for repeated observations.
        Don't worry about the methodology itself - those curious can find the
        statistical test results in parentheses. Overall:"
      ),
      anova_results(df_first_final),
      tags$p(
        "In other words, we have no evidence to suggest that the time it takes
        to progress to the next division differs between Leaders and Followers - we're
        all on the same boat!"
      )
    )
  )
)
