get_df_average_comp <- function(df_comps, df_events) {

  divisions_advancing    <- c("Newcomer", "Novice", "Intermediate", "Advanced", "All-Stars", "Champions")
  divisions_nonadvancing <- c("Juniors", "Sophisticated", "Masters")

  df_comps_stand <- df_comps |>
    dplyr::mutate(
      division = stringr::str_replace(division, "/.*", ""),
      division = factor(division, levels = c(divisions_advancing, divisions_nonadvancing))
    ) |>
    dplyr::filter(!is.na(division))


  # 1. Global Level (global = all available & valid events)
  ## 1.1 Get the global average number of dancers per role
  df_comps_total_01 <- df_comps_stand |>
    dplyr::group_by(event_id, role) |>
    dplyr::summarise(size_tot = sum(size), .groups = "drop") |>
    dplyr::group_by(role) |>
    dplyr::summarise(avg_size_tot = round(mean(size_tot)), .groups = "drop") |>
    tidyr::pivot_wider(names_from = "role", values_from = "avg_size_tot")

  ## 1.2 Get the global average of % of leaders and followers in the final
  df_comps_total_02 <- df_comps_stand |>
    dplyr::group_by(role) |>
    dplyr::summarise(avg_perc_in_final = mean(n_final / size), .groups = "drop") |>
    tidyr::pivot_wider(names_from = "role", values_from = "avg_perc_in_final")

  ## 1.3 Get the global average of follower-to-leader ratio
  df_comps_total_03 <- df_comps_stand |>
    dplyr::distinct(event_id, division, role, size) |>
    tidyr::pivot_wider(names_from = "role", values_from = "size") |>
    dplyr::summarise(avg_f_t_l_ratio = mean(Follower / Leader))


  # 2. Division Level
  ## 2.1 Get the average number of dancers per role per division
  df_comps_div_01 <- df_comps_stand |>
    dplyr::group_by(event_id, division, role) |>
    dplyr::summarise(size_tot = sum(size), .groups = "drop") |>
    dplyr::group_by(division, role) |>
    dplyr::summarise(avg_size = round(mean(size_tot)), .groups = "drop") |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_avg_size")) |>
    tidyr::pivot_wider(names_from = "role", values_from = "avg_size")

  ## 2.2 Get the average of % of leaders and followers in the final per division
  df_comps_div_02 <- df_comps_stand |>
    dplyr::group_by(division, role) |>
    dplyr::summarise(
      avg_perc_in_final    = mean(n_final / size),
      median_perc_in_final = median(n_final / size),
      .groups = "drop"
    ) |>
    tidyr::pivot_longer(c("avg_perc_in_final", "median_perc_in_final")) |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_", name)) |>
    dplyr::select(-name) |>
    tidyr::pivot_wider(names_from = "role", values_from = "value")

  ## 2.3 Get the average of follower-to-leader ratio per division
  df_comps_div_03 <- df_comps_stand |>
    dplyr::distinct(event_id, division, role, size) |>
    tidyr::pivot_wider(names_from = "role", values_from = "size") |>
    dplyr::mutate(avg_f_t_l_ratio = Follower / Leader) |>
    dplyr::group_by(division) |>
    dplyr::summarise(avg_f_t_l_ratio = mean(avg_f_t_l_ratio), .groups = "drop")


  # 3. Scatter level
  ## 3.1 Number of dancers per event
  df_comps_scatter_01 <- df_comps_stand |>
    dplyr::distinct(event_id, division, role, size) |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_size")) |>
    tidyr::pivot_wider(names_from = "role", values_from = "size")

  ## 3.2 % of leader and followers in the final
  df_comps_scatter_02 <- df_comps_stand |>
    dplyr::distinct(event_id, division, role, size, n_final) |>
    dplyr::mutate(
      perc = n_final / size,
      role = paste0(tolower(substr(role, 1, 1)), "_perc_in_final")
    ) |>
    dplyr::select(-size, -n_final) |>
    tidyr::pivot_wider(names_from = "role", values_from = "perc")

  ## 3.3 Follower-to-leader ratio
  df_comps_scatter_03 <- df_comps_stand |>
    dplyr::distinct(event_id, division, role, size) |>
    tidyr::pivot_wider(names_from = "role", values_from = "size") |>
    dplyr::mutate(f_t_l_ratio = Follower / Leader) |>
    dplyr::select(-Follower, -Leader)


  df_comps_scatter_01 |>
    dplyr::left_join(df_comps_scatter_02, by = c("event_id", "division")) |>
    dplyr::left_join(df_comps_scatter_03, by = c("event_id", "division")) |>
    dplyr::left_join(df_comps_div_01, by = "division") |>
    dplyr::left_join(df_comps_div_02, by = "division") |>
    dplyr::left_join(df_comps_div_03, by = "division") |>
    dplyr::arrange(dplyr::desc(division)) |>
    dplyr::left_join(
      df_events |> dplyr::distinct(event_id, event_name),
      by = "event_id"
    )
}


# Use df from reactive as it's repeated for all plot functions here
plot_average_comp_size <- function(df_comps_avgs) {

  df_comps_avgs |>
    echarts4r::e_chart(x = division) |>
    echarts4r::e_scatter(
      serie = f_size, name = "Followers", bind = event_name, symbol_size = 7,
      color = scales::alpha(col_palette$roles$follower, 0.2),
    ) |>
    echarts4r::e_scatter(
      serie = l_size, name = "Leaders", , bind = event_name, symbol_size = 7,
      color = scales::alpha(col_palette$roles$leader, 0.2), symbol = "triangle"
    ) |>
    echarts4r::e_jitter() |>
    echarts4r::e_data(
      df_comps_avgs |> dplyr::distinct(division, f_avg_size, l_avg_size)
    ) |>
    echarts4r::e_line(
      serie = f_avg_size, name = "Followers", symbol = "circle", symbolSize = 10,
      lineStyle = list(width = 0), color = col_palette$roles$follower,
      label = list(show = TRUE, color = "inherit", fontWeight = "bolder", fontSize = 15),
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {return 'mean: ' + parseFloat(value);}
    "))
    ) |>
    echarts4r::e_line(
      serie = l_avg_size, name = "Leaders", symbol = "triangle", symbolSize = 10,
      lineStyle = list(width = 0), color = col_palette$roles$leader,
      label = list(show = TRUE, color = "inherit", fontWeight = "bolder", fontSize = 15),
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {return 'mean: ' + parseFloat(value);}
    "))
    ) |>
    echarts4r::e_x_axis(
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      name         = "Number of Contestants",
      nameLocation = "middle",
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_flip_coords() |>
    echarts4r::e_tooltip(
      backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.92),
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      textStyle       = list(color = col_palette$global$tertiary, fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px ", scales::alpha(col_palette$global$secondary, 0.2), ";"
      ),
      borderRadius    = 15,
      padding         = 15
    ) |>
    get_echart_legend() |>
    echarts4r::e_grid(left = "5%", right = "5%", bottom = "5%", top = "5%")
}


plot_average_perc_in_final <- function(df_comps_avgs) {

  df_comps_avgs |>
    echarts4r::e_chart(x = division) |>
    echarts4r::e_scatter(
      serie = f_perc_in_final, name = "Followers", bind = event_name,
      color = scales::alpha(col_palette$roles$follower, 0.2), symbol_size = 7,
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {
        return (parseFloat(value) * 100).toFixed(0) + '%';
      }
    "))
    ) |>
    echarts4r::e_scatter(
      serie = l_perc_in_final, name = "Leaders", , bind = event_name, symbol = "triangle",
      color = scales::alpha(col_palette$roles$leader, 0.2), symbol_size = 7,
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {
        return (parseFloat(value) * 100).toFixed(0) + '%';
      }
    "))
    ) |>
    echarts4r::e_jitter() |>
    echarts4r::e_data(
      df_comps_avgs |>
        dplyr::distinct(division, f_avg_perc_in_final, l_avg_perc_in_final)
    ) |>
    echarts4r::e_line(
      serie = f_avg_perc_in_final, name = "Followers", symbol = "circle",
      color = col_palette$roles$follower,
      lineStyle = list(width = 0), symbolSize = 10,
      label = list(
        show = TRUE, color = "inherit", fontWeight = "bolder", fontSize = 15,
        formatter = htmlwidgets::JS("
        function(params) {
          return (100 * parseFloat(params.value)).toFixed(0) + '%';
        }
      ")
      ),
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {
        return 'mean: ' + (parseFloat(value) * 100).toFixed(0) + '%';
      }
    "))
    ) |>
    echarts4r::e_line(
      serie = l_avg_perc_in_final, name = "Leaders", symbol = "triangle",
      color = col_palette$roles$leader, symbolSize = 10,
      lineStyle = list(width = 0),
      label = list(
        show = TRUE, color = "inherit", fontWeight = "bolder", fontSize = 15,
        formatter = htmlwidgets::JS("
        function(params) {
          return (100 * parseFloat(params.value)).toFixed(0) + '%';
        }
      ")
      ),
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {
        return 'mean: ' + (parseFloat(value) * 100).toFixed(0) + '%';
      }
    "))
    ) |>
    echarts4r::e_x_axis(
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      name         = "Percent in Final",
      nameLocation = "middle",
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed")),
      formatter = echarts4r::e_axis_formatter(
        style  = "percent",
        digits = 0
      )
    ) |>
    echarts4r::e_flip_coords() |>
    echarts4r::e_tooltip(
      backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.92),
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      textStyle       = list(color = col_palette$global$tertiary, fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px ", scales::alpha(col_palette$global$secondary, 0.2), ";"
      ),
      borderRadius    = 15,
      padding         = 15
    ) |>
    get_echart_legend() |>
    echarts4r::e_grid(left = "5%", right = "5%", bottom = "5%", top = "5%")
}


plot_average_f_t_l_ratio <- function(df_comps_avgs) {

  df_comps_avgs |>
    echarts4r::e_chart(x = division) |>
    echarts4r::e_scatter(
      serie = f_t_l_ratio, bind = event_name, symbol_size = 7,
      color = scales::alpha(col_palette$global$primary, 0.2),
      name  = "Follower-to-Leader Ratio",
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {return parseFloat(value).toFixed(2);}
    "))
    ) |>
    echarts4r::e_jitter() |>
    echarts4r::e_data(
      df_comps_avgs |> dplyr::distinct(division, avg_f_t_l_ratio)
    ) |>
    echarts4r::e_line(
      serie = avg_f_t_l_ratio,
      symbol = "circle", name  = "Follower-to-Leader Ratio", symbolSize = 10,
      color = col_palette$global$primary,
      lineStyle = list(width = 0),
      label = list(
        show = TRUE, color = "inherit", fontWeight = "bolder", fontSize = 15,
        formatter = htmlwidgets::JS("
      function(params) {return parseFloat(params.value).toFixed(2);}
    ")
      ),
      tooltip = list(valueFormatter = htmlwidgets::JS("
      function(value) {return 'mean: ' + parseFloat(value).toFixed(2);}
    "))
    ) |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_x_axis(
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      name         = "Follower-to-Leader Ratio",
      nameLocation = "middle",
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_flip_coords() |>
    echarts4r::e_tooltip(
      backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.92),
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      textStyle       = list(color = col_palette$global$tertiary, fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px ", scales::alpha(col_palette$global$secondary, 0.2), ";"
      ),
      borderRadius    = 15,
      padding         = 15
    ) |>
    echarts4r::e_grid(left = "5%", right = "5%", bottom = "5%", top = "5%")
}
