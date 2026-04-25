ui_individual_analysis_adv_dom <- tags$div(
  class = "glass-wrapper",

  uiOutput("ui_selected_dancer"),
  br(),

  tags$div(
    class = "comparison-container",

    # Bottom plot
    tags$div(
      class = "plot-layer echarts-wrap",
      echarts4r::echarts4rOutput("plot_nonomega_individual", height = "70vh")
    ),

    # Top plot (clipped)
    tags$div(
      class = "plot-layer top-plot echarts-wrap",
      echarts4r::echarts4rOutput("plot_omega_individual", height = "70vh")
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
    echarts4r::echarts4rOutput("plot_omega_individual_nonadv", height = "70vh")
  )
)



ui_individual_analysis_nondom <- tags$div(
  class = "glass-wrapper",
  tags$div(class = "glass-div-header", "Non-dominant Role"),
  br(),
  tags$div(
    class = "echarts-wrap w-100",
    echarts4r::echarts4rOutput("plot_omega_individual_nondom", height = "70vh")
  )
)

