get_df_omega_current_division <- function(df_full, selected_contestant_id, current_role, current_division) {

  df_selected_contestant <- df_full |>
    dplyr::filter(
      contestant_id == selected_contestant_id &
        role == current_role &
        division_adj == current_division
    ) |>
    dplyr::select(
      event_id, event_date,
      division, division_adj,
      contestant_id, selected_omega = omega
    )

  date_start <- lubridate::ymd(min(df_selected_contestant$event_date, na.rm = TRUE)) - months(3)
  date_end   <- lubridate::ymd(max(df_selected_contestant$event_date, na.rm = TRUE)) + months(3)


  df_grouped_contestants <- df_full |>
    dplyr::filter(
      role == current_role &
        division_adj == current_division &
        event_date >= date_start & event_date <= date_end
    ) |>
    dplyr::left_join(
      df_selected_contestant |> dplyr::select(-event_date),
      by = c("event_id", "contestant_id")
    ) |>
    dplyr::select(event_date, event_name, contestant_id, omega, selected_omega) |>
    dplyr::arrange(event_date)


  df_contestant_scatter <- df_full |>
    # Filter for relevant events only
    dplyr::filter(event_id %in% unique(df_selected_contestant$event_id)) |>
    # And relevant role and division
    dplyr::filter(
      role == current_role &
        division %in% unique(df_selected_contestant$division)
    ) |>
    dplyr::select(event_id, event_date, event_name, division_adj, omega) |>
    # Join selected contestant's data
    dplyr::left_join(
      df_selected_contestant |> dplyr::select(event_id, selected_omega),
      by = "event_id"
    ) |>
    dplyr::group_by(event_id, event_date, event_name, division_adj) |>
    dplyr::mutate(
      median_omega = median(omega, na.rm = TRUE),
      percentile   = dplyr::percent_rank(omega)[
        match(dplyr::first(selected_omega), omega)
      ],
      event_date = lubridate::ymd(event_date)
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(event_date)

  list(
    "df_grouped_contestants" = df_grouped_contestants,
    "df_contestant_scatter"  = df_contestant_scatter
  )
}



plot_omega_current_division <- function(df_full, selected_contestant_id, current_role, current_division) {

  df_contestant_scatter <- get_df_omega_current_division(df_full, selected_contestant_id, current_role, current_division)$df_contestant_scatter
  col_division          <- unname(unlist(col_palette$divisions[unique(df_contestant_scatter$division_adj)]))

  lm_fit <- data.frame(
    event_date = unique(df_contestant_scatter$event_date),
    fit        = stats::lm(
      selected_omega ~ as.numeric(event_date),
      data = df_contestant_scatter |> dplyr::distinct(event_date, selected_omega)
    )$fitted
  )


  df_contestant_scatter |>
    echarts4r::e_chart(x = event_date) |>
    echarts4r::e_scatter(
      serie = omega,
      color = scales::alpha(col_palette$global$primary, 0.2),
      tooltip = list(show = FALSE),
      symbol_size = 6
    ) |>
    echarts4r::e_jitter() |>
    echarts4r::e_data(
      df_contestant_scatter |>
        dplyr::distinct(event_id, event_date, event_name, median_omega)
    ) |>
    echarts4r::e_scatter(
      serie = median_omega,
      bind = event_name,
      color = scales::alpha(col_palette$global$primary, 0.8),
      symbol = "diamond",
      symbol_size = 10
    ) |>
    echarts4r::e_data(
      df_contestant_scatter |>
        dplyr::distinct(event_id, event_date, event_name, selected_omega)
    ) |>
    echarts4r::e_line(
      serie      = selected_omega,
      symbol     = "circle",
      smooth     = 0.3,
      symbolSize = 7,
      bind       = event_name,
      color      = col_division,
      tooltip    = list(valueFormatter = htmlwidgets::JS(
        "function(value) {return parseFloat(value).toFixed(0) + '\U03A9';}"
      )),
      lineStyle  = list(
        width       = 2,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      )
    ) |>
    echarts4r::e_data(
      df_contestant_scatter |>
        dplyr::distinct(event_id, event_date, event_name, percentile)
    ) |>
    echarts4r::e_scatter(
      serie = percentile,
      color = "transparent"
    ) |>
    echarts4r::e_data(lm_fit) |>
    echarts4r::e_line(
      serie = fit, tooltip = FALSE,
      symbol = "none", lineStyle = list(width = 1),
      color  = scales::alpha(col_palette$global$primary, 0.75),
      endLabel = list(
        show       = TRUE,
        formatter  = "Trend",
        color      = "inherit",
        fontWeight = "bold",
        backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.75),
        borderRadius    = 15,
        padding         = 10
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
    echarts4r::e_tooltip(
      trigger      = "axis",
      backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.92),
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      textStyle       = list(color = col_palette$global$tertiary, fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px ", scales::alpha(col_palette$global$secondary, 0.2), ";"
      ),
      borderRadius    = 15,
      padding         = 15,
      formatter    = htmlwidgets::JS("
      function(params) {
        var date     = new Date(params[0].value[0]).toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        let event_name     = params[0].name;
        var score_median   = (parseFloat(params[0].value[1])).toFixed(0) + '\U03A9';
        var score_selected = (parseFloat(params[1].value[1])).toFixed(0) + '\U03A9';
        var percentile     = (100 * parseFloat(params[2].value[1])).toFixed(0) + '%';
        var col_median     = params[0].color;
        var col_selected   = params[1].color;

        return '<div style=\"text-align:center;font-size:1.2em;font-weight:bold;\">' +
              event_name + '</div>' +
             '<div style=\"text-align:center;font-size:1em;\">' + date + '</div>' +
             '<hr style=\"margin:10px 0;border:none;border-top:1px solid #ccc;\"/>' +
             '<div style=\"text-align:center;\">You scored <span style=\"font-weight:bold;color:' +
             col_selected + ';\">' + score_selected + '</span>' +
             ' and the typical score was <span style=\"font-weight:bold;color:' +
             col_median + ';\">' + score_median + '.</span><br>' +
             'You outperformed <span style=\"font-weight:bold;\">' +
             percentile + '</span> of contestants<br>in this division and your role.</div>';
      }
    ")
    ) |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_grid(right = "5%", left = "5%", top = "15%", bottom = "7%") |>
    echarts4r::e_title(
      text      = "Omega Details",
      subtext   =
        "Each tiny dot represents one of your competitors. Diamonds indicate the median Omega Score for each competition. Hover to see more details.",
      textAlign = "left",
      left      = "5%",
      textStyle = list(color = col_palette$global$font_primary, fontWeight = 300, fontSize = 25),
      subtextStyle = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 12)
    ) |>
    echarts4r::e_toolbox(show = FALSE)
}
