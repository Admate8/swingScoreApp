
get_df_dancer_results <- function(df, role, dom_role = TRUE, advancing_divs = TRUE) {

  if (dom_role) {
    role_selected <- role
  } else {
    role_selected <- ifelse(role == "Leader", "Follower", "Leader")
  }

  if (advancing_divs) {
    divis <- c("Newcomer", "Novice", "Intermediate", "Advanced", "All-Stars", "Champions")
  } else {
    divis <- c("Juniors", "Sophisticated", "Masters")
  }


  df |>
    dplyr::filter(role == role_selected & division_adj %in% divis) |>
    dplyr::mutate(division_adj = factor(division_adj, levels = divis)) |>
    dplyr::arrange(event_date, division_adj)
}


plot_omega_individual <- function(df, role, dom_role = TRUE, advancing_divs = TRUE) {

  df_results_contestant <- get_df_dancer_results(df, role, dom_role, advancing_divs)


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
        backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.75),
        borderRadius    = 15,
        padding         = 10
      )
    ) |>
    echarts4r::e_color(
      color = unname(col_palette$divisions[as.character(sort(unique(df_results_contestant$division_adj)))]),
      background = col_palette$global$solid_bg
    ) |>
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
      trigger = "axis",
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
          var base     = params[0] || params[1]; // fallback if first is missing
          var date     = base && base.value ? new Date(base.value[0]).toLocaleDateString('en-GB', {year: 'numeric', month: 'long'}) : '';
          var event    = base ? base.name : '';
          var division = base ? base.seriesName : '';
          var marker   = base ? base.marker : '';
          var colour   = base ? base.color : '';

          var score1 = (params[0] && params[0].value && params[0].value[1] != null)
            ? parseFloat(params[0].value[1]).toFixed(0)
            : null;

          var score2 = (params[1] && params[1].value && params[1].value[1] != null)
            ? parseFloat(params[1].value[1]).toFixed(0)
            : null;

          var content =
            '<div style=\"text-align: center; font-size: 1.4em; font-weight: bold; padding-bottom: 15px;\">' +
              event + '</div>' +
            '<hr style=\"margin: 4px 0; border: none; border-top: 1px solid #ccc;\" />' +
            '<div style=\"text-align: center; font-size: 1em;\">' + date + '</div><br>';

          // First line (only if score1 exists)
          if (score1 !== null) {
            content +=
              '<div style=\"display: flex; justify-content: space-between; align-items: center; margin-top: 4px;\">' +
                '<div style=\"font-size: 1.2em;\">' + marker + division + '</div>' +
                '<div style=\"font-size: 1.2em; font-weight: bold; color: ' + colour + ';\">' +
                  score1 + '\u03A9' +
                '</div>' +
              '</div>';
          }

          // Second line (only if score2 exists)
          if (score2 !== null) {
            var marker2   = params[1] ? params[1].marker : '';
            var division2 = params[1] ? params[1].seriesName : '';
            var colour2   = params[1] ? params[1].color : colour;

            content +=
              '<div style=\"display: flex; justify-content: space-between; align-items: center; margin-top: 4px;\">' +
                '<div style=\"font-size: 1.2em;\">' + marker2 + division2 + '</div>' +
                '<div style=\"font-size: 1.2em; font-weight: bold; color: ' + colour2 + ';\">' +
                  score2 + '\u03A9' +
                '</div>' +
              '</div>';
          }

          return content;
        }
      ")
    ) |>
    echarts4r::e_grid(right = "7%", left = "5%", top = "15%", bottom = "7%") |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_title(
      text      = "Omega Score",
      subtext   = "rewards your performance across all rounds - not just the final!",
      textAlign = "left",
      left      = "5%",
      textStyle = list(color = col_palette$global$font_primary, fontWeight = 300, fontSize = 25),
      subtextStyle = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 12)
    ) |>
    echarts4r::e_toolbox(show = FALSE)
    #get_data_zoom_date()
}



plot_nonomega_individual <- function(df, role, dom_role = TRUE, advancing_divs = TRUE) {

  df_results_contestant <- get_df_dancer_results(df, role, dom_role, advancing_divs)

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
        backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.75),
        borderRadius    = 15,
        padding         = 10
      )
    ) |>
    echarts4r::e_color(
      color = unname(col_palette$divisions[as.character(sort(unique(df_results_contestant$division_adj)))]),
      background = col_palette$global$solid_bg
    ) |>
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
      position  = "right",
      formatter = htmlwidgets::JS("function(value) {return value + ' WSDC Points';}"),
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_tooltip(
      trigger = "axis",
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
          var base     = params[0] || params[1]; // fallback if first missing
          var date     = base && base.value ? new Date(base.value[0]).toLocaleDateString('en-GB', {year: 'numeric', month: 'long'}) : '';
          var event    = base ? base.name : '';
          var division = base ? base.seriesName : '';
          var marker   = base ? base.marker : '';
          var colour   = base ? base.color : '';

          var score1 = (params[0] && params[0].value && params[0].value[1] != null)
            ? parseFloat(params[0].value[1]).toFixed(0)
            : null;

          var score2 = (params[1] && params[1].value && params[1].value[1] != null)
            ? parseFloat(params[1].value[1]).toFixed(0)
            : null;

          var content =
            '<div style=\"text-align: center; font-size: 1.4em; font-weight: bold; padding-bottom: 15px;\">' +
              event + '</div>' +
            '<hr style=\"margin: 4px 0; border: none; border-top: 1px solid #ccc;\" />' +
            '<div style=\"text-align: center; font-size: 1em;\">' + date + '</div><br>';

          // First line
          if (score1 !== null) {
            content +=
              '<div style=\"display: flex; justify-content: space-between; align-items: center; margin-top: 4px;\">' +
                '<div style=\"font-size: 1.2em;\">' + marker + division + '</div>' +
                '<div style=\"font-size: 1.2em; font-weight: bold; color: ' + colour + ';\">' +
                  score1 + ' WSDC Points' +
                '</div>' +
              '</div>';
          }

          // Second line
          if (score2 !== null) {
            var marker2   = params[1] ? params[1].marker : '';
            var division2 = params[1] ? params[1].seriesName : '';
            var colour2   = params[1] ? params[1].color : colour;

            content +=
              '<div style=\"display: flex; justify-content: space-between; align-items: center; margin-top: 4px;\">' +
                '<div style=\"font-size: 1.2em;\">' + marker2 + division2 + '</div>' +
                '<div style=\"font-size: 1.2em; font-weight: bold; color: ' + colour2 + ';\">' +
                  score2 + ' WSDC Points' +
                '</div>' +
              '</div>';
          }

          return content;
        }
    ")
    ) |>
    echarts4r::e_grid(right = "10%", left = "5%", top = "15%", bottom = "7%") |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_title(
      text      = "WSDC Points",
      subtext   = "overlook the effort you put into non-final rounds.",
      textAlign = "right",
      right     = "-10%",
      textStyle = list(color = col_palette$global$font_primary, fontWeight = 300, fontSize = 25),
      subtextStyle = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 12)
    ) |>
    echarts4r::e_toolbox(show = FALSE)
    #get_data_zoom_date()
}



# ~-----


