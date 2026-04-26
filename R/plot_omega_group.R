plot_omega_group <- function(df_full, selected_contestant_id, current_role, current_division) {

  df_grouped_contestants <- get_df_omega_current_division(df_full, selected_contestant_id, current_role, current_division)$df_grouped_contestants
  col_division           <- unname(unlist(col_palette$divisions[unique(df_contestant_scatter$division_adj)]))

  df_grouped_contestants |>
    dplyr::group_by(contestant_id) |>
    echarts4r::e_chart(x = event_date) |>
    echarts4r::e_line(
      serie       = omega,
      symbol      = "circle",
      symbolSize  = 2,
      tooltip     = list(show = FALSE),
      smooth      = 0.3,
      itemStyle   = list(color = col_palette$global$primary_light, opacity = 0.1),
      lineStyle   = list(color = col_palette$global$primary_light, opacity = 0.1, width = 0.5),
      legend      = FALSE,
      emphasis    = list(
        lineStyle = list(
          color = col_palette$global$primary,
          width = 2, opacity = 1
        ),
        itemStyle = list(color = col_palette$global$primary)
      )
    ) |>
    echarts4r::e_data(
      df_grouped_contestants |>
        dplyr::distinct(event_date, event_name, selected_omega) |>
        dplyr::filter(!is.na(selected_omega))
    ) |>
    echarts4r::e_line(
      serie       = selected_omega,
      symbol      = "none",
      color       = col_division,
      symbol_size = 10,
      smooth      = 0.3,
      bind        = event_name,
      lineStyle  = list(
        width       = 2,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      )
    ) |>
    echarts4r::e_color(background = col_palette$global$solid_bg) |>
    echarts4r::e_x_axis(
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
          let current_date = new Date(params.value);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        }"
      ))),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(
        color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300,
        formatter = htmlwidgets::JS("
          function(value) {
            const d = new Date(value);
            return d.toLocaleDateString('en-GB', {month: 'short', year: 'numeric'});
          }
      ")
      )
    ) |>
    echarts4r::e_y_axis(
      min       = 0,
      max       = 100.1,
      position  = "left",
      formatter = htmlwidgets::JS("function(value) {return value + '\U03A9';}"),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_tooltip(show = FALSE) |>
    echarts4r::e_grid(right = "5%", left = "5%", top = "10%", bottom = "7%") |>
    echarts4r::e_title(
      #text      = "Omega Details",
      subtext   = "Each line represents another dancer’s progression in this division during the period when you competed in it.",
      textAlign = "left",
      left      = "5%",
      textStyle = list(color = col_palette$global$font_primary, fontWeight = 300, fontSize = 25),
      subtextStyle = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 12)
    ) |>
    echarts4r::e_toolbox(show = FALSE)
}
