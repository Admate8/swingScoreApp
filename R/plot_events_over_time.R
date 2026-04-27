get_trend_cont <- function(df_full, df, val_continent) {

  min_date <- df |>
    dplyr::filter(continent == val_continent) |>
    dplyr::pull(event_date) |>
    min()

  lm_model <- stats::lm(
    n ~ as.numeric(event_date),
    data = df |> dplyr::filter(continent == val_continent)
  )

  data_to_predicts <- df_full |>
    dplyr::filter(event_date >= min_date) |>
    dplyr::select(event_date)

  data_to_predicts[[paste0("lm_", val_continent)]] <- stats::predict(
    lm_model, newdata = data_to_predicts
  )

  df_full |>
    dplyr::left_join(
      data_to_predicts,
      by = "event_date"
    )
}


get_df_events_over_time <- function(df) {

  df_count_by_cont <- df |>
    dplyr::count(continent, event_date) |>
    dplyr::mutate(continent = stringr::str_to_lower(continent))

  df |>
    dplyr::count(event_date, name = "total") |>
    dplyr::mutate(lm_overall = stats::lm(total ~ as.numeric(event_date))$fitted) |>
    dplyr::left_join(
      df_count_by_cont |>
        dplyr::mutate(continent = paste0("n_", continent)) |>
        tidyr::pivot_wider(names_from = "continent", values_from = "n"),
      by = "event_date"
    ) |>
    get_trend_cont(df = df_count_by_cont, "americas") |>
    get_trend_cont(df = df_count_by_cont, "asia") |>
    get_trend_cont(df = df_count_by_cont, "europe") |>
    get_trend_cont(df = df_count_by_cont, "oceania")
}


plot_events_over_time <- function(df) {

  get_df_events_over_time(df) |>
    echarts4r::e_chart(x = event_date) |>

    # Scatters
    echarts4r::e_scatter(
      serie = total, name = "Total", symbol_size = 7,
      color = scales::alpha(col_palette$global$primary, 0.3)
    ) |>
    echarts4r::e_scatter(
      serie = n_americas, name = "Americas", symbol_size = 6,
      color = scales::alpha(col_palette$accents$acc2_light, 0.3)
    ) |>
    echarts4r::e_scatter(
      serie = n_asia, name = "Asia", symbol_size = 6,
      color = scales::alpha(col_palette$accents$acc3_dark, 0.3)
    ) |>
    echarts4r::e_scatter(
      serie = n_europe, name = "Europe", symbol_size = 6,
      color = scales::alpha(col_palette$accents$acc4_dark, 0.3)
    ) |>
    echarts4r::e_scatter(
      serie = n_oceania, name = "Oceania", symbol_size = 6,
      color = scales::alpha(col_palette$accents$acc5_dark, 0.3)
    ) |>

    # Trends
    echarts4r::e_line(
      serie = lm_americas, legend = FALSE, symbol = "none", name = "Americas",
      color = scales::alpha(col_palette$accents$acc2_light, 0.8),
      lineStyle = list(width = 1),
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
    echarts4r::e_line(
      serie = lm_asia, legend = FALSE, symbol = "none", name = "Asia",
      color = scales::alpha(col_palette$accents$acc3_dark, 0.8),
      lineStyle = list(width = 1),
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
    echarts4r::e_line(
      serie = lm_europe, legend = FALSE, symbol = "none", name = "Europe",
      color = scales::alpha(col_palette$accents$acc4_dark, 0.8),
      lineStyle = list(width = 1),
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
    echarts4r::e_line(
      serie = lm_oceania, legend = FALSE, symbol = "none", name = "Oceania",
      color = scales::alpha(col_palette$accents$acc5_dark, 0.8),
      lineStyle = list(width = 1),
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

    echarts4r::e_line(
      serie = lm_overall, legend = FALSE, symbol = "none", name = "Total",
      color = scales::alpha(col_palette$global$primary, 0.75),
      lineStyle  = list(
        width       = 2,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      ),
      endLabel  = list(
        show       = TRUE,
        formatter = htmlwidgets::JS("
        function(params) {
          return 'Overall\\nTrend';
        }
      "),
        color      = "inherit",
        fontWeight = "bold",
        backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.75),
        borderRadius    = 15,
        padding         = 10
      )
    ) |>
    echarts4r::e_x_axis(
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      name         = "Number of Events per Month",
      nameLocation = "middle",
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_legend(
      top = "top", left = "center",
      textStyle = list(
        color        = scales::alpha(col_palette$global$primary_light, 0.6),
        fontSize     = 12,
        fontWeight   = 300,
        fontFamily   = "system-ui, sans-serif"
      ),
      itemWidth   = 14,
      itemHeight  = 6,
      itemGap     = 16,
      itemStyle = list(
        borderWidth = 0,
        shadowColor = "rgba(165,180,252,0.35)",
        shadowBlur  = 6
      ),
      inactiveColor     = scales::alpha(col_palette$global$secondary, 0.15),
      inactiveBorderColor = scales::alpha(col_palette$global$secondary, 0.1),
    ) |>
    echarts4r::e_grid(left = "5%", right = "10%", bottom = "15%") |>
    get_data_zoom_date() |>
    echarts4r::e_toolbox(show = FALSE)
}
