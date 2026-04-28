ui_competitive_analysis <- htmltools::tagList(
  tags$div(class = "glass-div-header", "Popular Topics"),
  br(),
  bslib::accordion(
    open     = FALSE,
    multiple = FALSE,
    id       = "acc_questions",
    bslib::accordion_panel(
      title = "How many dancers compete? And how many of them are still active?",
      penel_comp_summary
    ),
    bslib::accordion_panel(
      title = "Is WCS becoming more popular? And what does the scene look like outside the States?",
      penel_events_over_time
    ),
    bslib::accordion_panel(
      title = "Is competing becoming more popular?",
      panel_competitors_over_time
    ),
    bslib::accordion_panel(
      title = "How many leaders and followers does an average competition have in each division? And how many make it to the finals?",
      lorem::ipsum(20)
    ),
    bslib::accordion_panel(
      title = "What is the follower-to-leader ratio by division?",
      lorem::ipsum(20)
    ),
    bslib::accordion_panel(
      title = "How long does it take to progress to the next division?",
      lorem::ipsum(20)
    ),
    bslib::accordion_panel(
      title = "Is it easier to progress as a Leader than as a Follower?",
      lorem::ipsum(20)
    )
  )
)


