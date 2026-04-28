get_df_comp_size_overtime <- function(df_comps, df_events) {
  df_comps |>
    dplyr::left_join(
      df_events |>
        dplyr::distinct(event_id, event_date, event_name) |>
        dplyr::mutate(event_date),
      by = "event_id"
    ) |>
    dplyr::group_by(event_id, event_name, event_date) |>
    dplyr::summarise(size = sum(size), .groups = "drop") |>
    dplyr::mutate(
      event_date = lubridate::ymd(event_date),
      size_trend = stats::lm(size ~ as.numeric(event_date))$fitted
    ) |>
    dplyr::filter(event_date >= as.Date("2022-01-01"))
}



plot_comp_size_overtime <- function(df_comps, df_events) {

  df_comp_size_overtime <- get_df_comp_size_overtime(df_comps, df_events)

  df_comp_size_overtime |>
    echarts4r::e_chart(x = event_date) |>
    echarts4r::e_scatter(
      serie       = size,
      bind        = event_name,
      symbol_size = 7,
      color       = scales::alpha(col_palette$global$primary, 0.5)
    ) |>
    echarts4r::e_jitter() |>
    echarts4r::e_line(
      serie     = size_trend,
      name      = "Trend",
      symbol    = "none",
      color = scales::alpha(col_palette$global$primary, 0.75),
      lineStyle  = list(
        width       = 2,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      ),
      endLabel  = list(
        show       = TRUE,
        formatter  = "{a}",
        color      = "inherit",
        fontWeight = "bold",
        backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.75),
        borderRadius    = 15,
        padding         = 10
      )
    ) |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_x_axis(
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      name  = "Number of All Competitors",
      nameLocation = "middle",
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_tooltip(
      backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.92),
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      textStyle       = list(color = col_palette$global$tertiary, fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px ", scales::alpha(col_palette$global$secondary, 0.2), ";"
      ),
      borderRadius    = 15,
      padding         = 15,
      formatter = htmlwidgets::JS("
      function(params) {

        let date     = new Date(params.value[0]);
        let niceDate = date.toLocaleDateString(
          'en-GB', { year: 'numeric', month: 'long' }
        );
        let event_name = params.name;
        let event_size = params.value[1];

        return '<div style=\"font-weight:bold;text-align:center;font-size:1.1rem;\">' +
        event_name +
        '</div>' +
        '<hr style=\"margin: 4px 0; border: none; border-top: 1px solid #ccc;\" />' +
        '<div style=\"text-align: center; font-size: 1em;\">' + niceDate + '</div><br>' +
        '<div style=\"text-align:center;\"> Estimated competitors: <b>' +
        event_size + '</b></div>'
      }
    ")
    ) |>
    echarts4r::e_grid(left = "5%", right = "10%", bottom = "10%", top = "1%")
}
