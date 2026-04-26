ui_individual_analysis_adv_dom <- tags$div(
  class = "glass-wrapper",

  uiOutput("ui_selected_dancer"),
  br(),

  tags$div(
    class = "comparison-container",

    # Bottom plot
    tags$div(
      class = "plot-layer echarts-wrap",
      echarts4r::echarts4rOutput("plot_nonomega_individual", height = "70vh") |> add_spinner()
    ),

    # Top plot (clipped)
    tags$div(
      class = "plot-layer top-plot echarts-wrap",
      echarts4r::echarts4rOutput("plot_omega_individual", height = "70vh") |> add_spinner()
    ),

    # Vertical slider handle
    tags$div(class = "slider")
  )
)



ui_individual_analysis_nonadv <- tags$div(
  class = "glass-wrapper",
  tags$div(class = "glass-div-header", "Age Divisions"),
  br(),
  tags$div(
    class = "echarts-wrap w-100",
    echarts4r::echarts4rOutput("plot_omega_individual_nonadv", height = "70vh") |> add_spinner()
  )
)



ui_individual_analysis_nondom <- tags$div(
  class = "glass-wrapper",
  tags$div(class = "glass-div-header", "Non-dominant Role"),
  br(),
  tags$div(
    class = "echarts-wrap w-100",
    echarts4r::echarts4rOutput("plot_omega_individual_nondom", height = "70vh") |> add_spinner()
  )
)



ui_individual_analysis_details <- tags$div(
  class = "glass-wrapper",
  uiOutput("ui_omega_details"),
  br(),
  tags$div(
    class = "echarts-wrap w-100",
    echarts4r::echarts4rOutput("plot_omega_current_division", height = "70vh") |> add_spinner()
  )
)



ui_individual_analysis_group <- tags$div(
  class = "glass-wrapper",
  tags$div(
    tags$div(class = "glass-div-header", "Zooming Out"),
    tags$div(
      class = "subheader",
      "Your journey is uniquely yours - and I can prove it!"
    )
  ),
  br(),
  tags$div(
    class = "echarts-wrap w-100",
    echarts4r::echarts4rOutput("plot_omega_group", height = "70vh") |> add_spinner()
  )
)
