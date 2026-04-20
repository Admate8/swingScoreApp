get_df_results_contestant <- function(df_dancers, selected_contestant_id) {
  df_helper <- df_dancers |>
    dplyr::filter(contestant_id == selected_contestant_id) |>
    dplyr::count(role)

  dominant_role <- df_helper$role[which.max(df_helper$n)]

  df_dancers |>
    dplyr::filter(
      contestant_id == selected_contestant_id &
        role == dominant_role &
        division_adj %in% divisions_advancing
    ) |>
    dplyr::arrange(event_date)
}



plot_omega_individual <- function(df_dancers, selected_contestant_id) {

  divisions_advancing     <- c("Newcomer", "Novice", "Intermediate", "Advanced", "All-Stars", "Champions")
  divisions_nonadvancing  <- c("Juniors", "Sophisticated", "Masters")
  df_results_contestant   <- get_df_results_contestant(df_dancers, selected_contestant_id) |>
    dplyr::mutate(division_adj = factor(division_adj, levels = divisions_advancing))

  df_results_contestant |>
    dplyr::group_by(division_adj) |>
    echarts4r::e_chart(x = event_date) |>
    echarts4r::e_line(
      serie      = omega,
      symbol     = "circle",
      smooth     = 0.3,
      symbolSize = 7,
      bind       = event_name,
      tooltip    = list(valueFormatter = htmlwidgets::JS(
        "function(value) {return parseFloat(value).toFixed(0) + '\U03A9';}"
      )),
      lineStyle  = list(
        width       = 2,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      ),
      endLabel = list(
        show       = TRUE,
        formatter  = "{a}",
        color      = "inherit",
        fontWeight = "bold",
        backgroundColor = "rgba(15,17,30,0.75)",
        borderRadius    = 15,
        padding         = 10
      )
    ) |>
    echarts4r::e_color(
      color = unname(col_palette$division$advancing[unique(df_results_contestant$division_adj)]),
      background = "#202946"
    ) |>
    echarts4r::e_x_axis(
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
          let current_date = new Date(params.value);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        }"
      ))),
      axisLine  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      axisTick  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      axisLabel = list(
        color = "rgba(165,148,249,0.5)", fontSize = 11, fontWeight = 300,
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
      axisLabel = list(color = "rgba(165,148,249,0.5)", fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      axisTick  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      splitLine = list(lineStyle = list(color = "rgba(99,102,241,0.1)", type = "dashed"))
    ) |>
    echarts4r::e_tooltip(
      trigger = "axis",
      backgroundColor = "rgba(15,17,30,0.92)",
      borderColor     = "rgba(99,102,241,0.25)",
      textStyle       = list(color = "#c7d2fe", fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px rgba(99,102,241,0.2);"
      ),
      borderRadius    = 15,
      padding         = 15,
      formatter = htmlwidgets::JS("
      function(params) {
        var date     = new Date(params[0].value[0]).toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        var event    = params[0].name;
        var division = params[0].seriesName;
        var score    = (parseFloat(params[0].value[1])).toFixed(0);
        var marker   = params[0].marker;
        var colour   = params[0].color;

        return '<div style=\"text-align: center; font-size: 1.4em; font-weight: bold; padding-bottom: 15px;\">' +
              event + '</div>' +
             '<hr style=\"margin: 4px 0; border: none; border-top: 1px solid #ccc;\" />' +
             '<div style=\"text-align: center; font-size: 1em;\">' + date + '</div><br>' +
             '<div style=\"display: flex; justify-content: space-between; align-items: center; margin-top: 4px;\">' +
             '<div style=\"font-size: 1.2em;\">' + marker + division + '</div>' +
             '<div style=\"font-size: 1.2em; font-weight: bold; color: ' + colour + ';\">' +
              score + '\U03A9' + '</div>' +
             '</div>';
      }
    ")
    ) |>
    echarts4r::e_grid(right = "7%", left = "3%", top = "15%") |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_title(
      text      = "Omega Points",
      subtext   = "reward your performance across all rounds - not just the final!",
      textAlign = "left",
      left      = "2%",
      textStyle = list(color = "#e2e8f0", fontWeight = 300, fontSize = 25),
      subtextStyle = list(color = "rgba(165,148,249,0.5)", fontSize = 12)
    ) |>
    echarts4r::e_toolbox(show = FALSE) |>
    get_data_zoom_date()
}



plot_nonomega_individual <- function(df_dancers, selected_contestant_id) {

  divisions_advancing     <- c("Newcomer", "Novice", "Intermediate", "Advanced", "All-Stars", "Champions")
  divisions_nonadvancing  <- c("Juniors", "Sophisticated", "Masters")
  df_results_contestant   <- get_df_results_contestant(df_dancers, selected_contestant_id) |>
    dplyr::mutate(division_adj = factor(division_adj, levels = divisions_advancing))

  df_results_contestant |>
    dplyr::mutate(p_final = ifelse(is.na(p_final), 0, p_final)) |>
    dplyr::group_by(division_adj) |>
    echarts4r::e_chart(x = event_date) |>
    echarts4r::e_line(
      serie      = p_final,
      symbol     = "circle",
      smooth     = 0.3,
      symbolSize = 7,
      bind       = event_name,
      tooltip    = list(valueFormatter = htmlwidgets::JS(
        "function(value) {return parseFloat(value).toFixed(0) + ' WSDC Points';}"
      )),
      lineStyle  = list(
        width       = 2,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      ),
      endLabel = list(
        show       = TRUE,
        formatter  = "{a}",
        color      = "inherit",
        fontWeight = "bold",
        backgroundColor = "rgba(15,17,30,0.75)",
        borderRadius    = 15,
        padding         = 10
      )
    ) |>
    echarts4r::e_color(
      color = unname(col_palette$division$advancing[unique(df_results_contestant$division_adj)]),
      background = "#202946"
    ) |>
    echarts4r::e_x_axis(
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
          let current_date = new Date(params.value);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        }"
      ))),
      axisLine  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      axisTick  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      axisLabel = list(
        color = "rgba(165,148,249,0.5)", fontSize = 11, fontWeight = 300,
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
      position  = "right",
      formatter = htmlwidgets::JS("function(value) {return value + ' WSDC Points';}"),
      axisLabel = list(color = "rgba(165,148,249,0.5)", fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      axisTick  = list(lineStyle = list(color = "rgba(99,102,241,0.25)")),
      splitLine = list(lineStyle = list(color = "rgba(99,102,241,0.1)", type = "dashed"))
    ) |>
    echarts4r::e_tooltip(
      trigger = "axis",
      backgroundColor = "rgba(15,17,30,0.92)",
      borderColor     = "rgba(99,102,241,0.25)",
      textStyle       = list(color = "#c7d2fe", fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px rgba(99,102,241,0.2);"
      ),
      borderRadius    = 15,
      padding         = 15,
      formatter = htmlwidgets::JS("
      function(params) {
        var date     = new Date(params[0].value[0]).toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        var event    = params[0].name;
        var division = params[0].seriesName;
        var score    = (parseFloat(params[0].value[1])).toFixed(0);
        var marker   = params[0].marker;
        var colour   = params[0].color;

        return '<div style=\"text-align: center; font-size: 1.4em; font-weight: bold; padding-bottom: 15px;\">' +
              event + '</div>' +
             '<hr style=\"margin: 4px 0; border: none; border-top: 1px solid #ccc;\" />' +
             '<div style=\"text-align: center; font-size: 1em;\">' + date + '</div><br>' +
             '<div style=\"display: flex; justify-content: space-between; align-items: center; margin-top: 4px;\">' +
             '<div style=\"font-size: 1.2em;\">' + marker + division + '</div>' +
             '<div style=\"font-size: 1.2em; font-weight: bold; color: ' + colour + ';\">' +
              score + ' WSDC Points' + '</div>' +
             '</div>';
      }
    ")
    ) |>
    echarts4r::e_grid(right = "7%", left = "3%", top = "15%") |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_title(
      text      = "WSDC Points",
      subtext   = "overlook the effort you put into non-final rounds.",
      textAlign = "right",
      right     = "-10%",
      textStyle = list(color = "#e2e8f0", fontWeight = 300, fontSize = 25),
      subtextStyle = list(color = "rgba(165,148,249,0.5)", fontSize = 12)
    ) |>
    echarts4r::e_toolbox(show = FALSE) |>
    get_data_zoom_date()
}


