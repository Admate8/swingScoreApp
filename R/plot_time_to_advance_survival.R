get_df_survival <- function(df_first_final) {

  df_survival_helper <- df_first_final |>
    dplyr::filter(
      role_type == "Dominant" &
        recent_year >= lubridate::year(Sys.Date()) - 3 &
        flag_division_gap != 1 &
        flag_division_order != 1
    ) |>
    # Filter dancers who compete in non-advancing divisions only
    dplyr::mutate(
      id = paste0(full_name, "_", wsdc_id),
      is_advancing = ifelse(
        is.na(novice) & is.na(intermediate) &
          is.na(advanced) & is.na(all_stars) & is.na(champions), 0, 1
      )
    ) |>
    dplyr::filter(is_advancing == 1) |>
    dplyr::distinct(
      id, role, recent_year,
      novice, intermediate, advanced, all_stars, champions
    ) |>
    # Find the time between divisions
    dplyr::mutate(
      analysis_month = lubridate::floor_date(Sys.Date(), unit = "month"),

      nov_to_inter = dplyr::case_when(
        !is.na(novice) & !is.na(intermediate) ~ lubridate::time_length(
          lubridate::interval(novice, intermediate), "months"
        ),
        !is.na(novice) & is.na(intermediate) ~ lubridate::time_length(
          lubridate::interval(novice, analysis_month), "months"
        ),
        TRUE ~ NA
      ),
      nov_to_inter_flag = ifelse(!is.na(novice) & !is.na(intermediate), 1, 0),

      inter_to_adv = dplyr::case_when(
        !is.na(intermediate) & !is.na(advanced) ~ lubridate::time_length(
          lubridate::interval(intermediate, advanced), "months"
        ),
        !is.na(intermediate) & is.na(advanced) ~ lubridate::time_length(
          lubridate::interval(intermediate, analysis_month), "months"
        ),
        TRUE ~ NA
      ),
      inter_to_adv_flag = ifelse(is.na(inter_to_adv), NA, ifelse(
        !is.na(intermediate) & !is.na(advanced), 1, 0
      )),

      adv_to_als = dplyr::case_when(
        !is.na(advanced) & !is.na(all_stars) ~ lubridate::time_length(
          lubridate::interval(advanced, all_stars), "months"
        ),
        !is.na(advanced) & is.na(all_stars) ~ lubridate::time_length(
          lubridate::interval(advanced, analysis_month), "months"
        ),
        TRUE ~ NA
      ),
      adv_to_als_flag = ifelse(is.na(adv_to_als), NA, ifelse(
        !is.na(advanced) & !is.na(all_stars), 1, 0
      )),

      als_to_champ = dplyr::case_when(
        !is.na(all_stars) & !is.na(champions) ~ lubridate::time_length(
          lubridate::interval(all_stars, champions), "months"
        ),
        !is.na(all_stars) & is.na(champions) ~ lubridate::time_length(
          lubridate::interval(all_stars, analysis_month), "months"
        ),
        TRUE ~ NA
      ),
      als_to_champ_flag = ifelse(is.na(als_to_champ), NA, ifelse(
        !is.na(all_stars) & !is.na(champions), 1, 0
      ))
    ) |>
    dplyr::select(
      id, role, recent_year,
      nov_to_inter, inter_to_adv, adv_to_als, als_to_champ,
      dplyr::contains("flag")
    ) |>
    tidyr::pivot_longer(-c("id", "role", "recent_year")) |>
    dplyr::filter(!is.na(value)) |>
    dplyr::mutate(
      advancement_flag = ifelse(grepl("flag", name), "Flag", NA),
      name = stringr::str_remove(name, "_flag"),
      name = dplyr::case_when(
        name == "nov_to_inter" ~ "Nov \U2192 Int",
        name == "inter_to_adv" ~ "Int \U2192 Adv",
        name == "adv_to_als"   ~ "Adv \U2192 Als",
        name == "als_to_champ" ~ "Als \U2192 Champ"
      )
    )


  df_survival_helper |>
    dplyr::filter(is.na(advancement_flag)) |>
    dplyr::select(-advancement_flag) |>
    dplyr::rename(months = value) |>
    dplyr::left_join(
      df_survival_helper |>
        dplyr::filter(advancement_flag == "Flag") |>
        dplyr::select(-advancement_flag) |>
        dplyr::rename(advancement_flag = value),
      by = dplyr::join_by(id, role, recent_year, name)
    ) |>
    dplyr::rename(progress = name) |>
    dplyr::mutate(
      progress = factor(progress, levels = c(
        "Nov \U2192 Int", "Int \U2192 Adv", "Adv \U2192 Als", "Als \U2192 Champ"
      )),
      role = factor(role, levels = c("Follower", "Leader"))
    )
}



plot_median_difference <- function(df_first_final) {

  df_time_to_progress <- get_df_time_to_progress(df_first_final)$df_time_to_progress
  df_survival         <- get_df_survival(df_first_final)

  df_time_to_progress_medians <- df_time_to_progress |>
    dplyr::group_by(progress) |>
    dplyr::summarise(
      median_standard = median(months, na.rm = TRUE), .groups = "drop"
    )

  df_survival_medians <- df_survival |>
    dplyr::group_by(progress) |>
    dplyr::group_modify(~ {
      fit <- survival::survfit(
        survival::Surv(months, advancement_flag) ~ 1, data = .x
      )
      tibble::tibble(median_survival = summary(fit)$table["median"])
    })

  df_medians_difference <- dplyr::left_join(
    df_time_to_progress_medians,
    df_survival_medians,
    by = "progress"
  ) |>
    dplyr::mutate(
      bar_diff = ifelse(
        is.na(median_survival), NA,
        median_survival - median_standard
      ) - 3,
      progress = factor(progress, levels = c(
        "Als \U2192 Champ", "Adv \U2192 Als", "Int \U2192 Adv", "Nov \U2192 Int"
      )),
      median_survival_for_arrow = median_survival - 2
    ) |>
    dplyr::arrange(progress)


  df_medians_difference |>
    echarts4r::e_chart(x = progress) |>
    echarts4r::e_bar(
      serie = median_standard, stack = "bar", barWidth = "3%",
      tooltip = list(show = FALSE), color = "transparent"
    ) |>
    echarts4r::e_bar(
      serie = bar_diff, stack = "bar", barWidth = "3%",
      tooltip = list(show = FALSE), color = "rgba(99,102,241,0.2)"
    ) |>
    echarts4r::e_scatter(
      serie = median_survival_for_arrow, symbol = "arrow", color = "rgba(99,102,241,0.2)",
      symbolSize = c(10, 15), itemStyle = list(opacity = 1),
      symbolRotate = -90,
      tooltip = list(show = FALSE)
    ) |>
    echarts4r::e_scatter(
      serie = median_standard,
      symbol_size = 30,
      color       = col_palette$global$primary_light,
      itemStyle   = list(
        opacity     = 1,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      )
    ) |>
    echarts4r::e_scatter(
      serie = median_survival,
      symbol_size = 30,
      color       = col_palette$global$primary,
      itemStyle   = list(
        opacity     = 1,
        shadowBlur  = 10,
        shadowColor = col_palette$global$font_primary
      )
    ) |>
    echarts4r::e_x_axis(
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisLabel = list(align = "left", margin = 80, color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      name         = "Months",
      nameLocation = "middle",
      axisLabel = list(color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300),
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed"))
    ) |>
    echarts4r::e_flip_coords() |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_tooltip(
      trigger     = "axis",
      backgroundColor = scales::alpha(col_palette$global$tooltip_bg, 0.92),
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      textStyle       = list(color = col_palette$global$tertiary, fontSize = 12, fontWeight = 300),
      extraCssText    = paste0(
        "backdrop-filter:blur(10px);",
        "box-shadow:0 0 20px ", scales::alpha(col_palette$global$secondary, 0.2), ";"
      ),
      borderRadius    = 15,
      padding         = 15,
      axisPointer = list(
        type = "shadow",
        shadowStyle = list(color = "rgba(99,102,241,0.1)"
        )),
      formatter = htmlwidgets::JS(paste0(
        "function(params) {", js_convert_to_year_months, "

          let before = formatMonths(params[0].value[0]);
          let after  = formatMonths(params[1].value[0]);

          lowerMap = {
            'Nov \U2192 Int': 'Novice',
            'Int \U2192 Adv': 'Intermediate',
            'Adv \U2192 Als': 'Advanced',
            'Als \U2192 Champ': 'All-Stars'
          };
          div_lower = lowerMap[params[0].name];
          upperMap = {
            'Nov \U2192 Int': 'Intermediate',
            'Int \U2192 Adv': 'Advanced',
            'Adv \U2192 Als': 'All-Stars',
            'Als \U2192 Champ': 'Champions'
          };
          div_upper = upperMap[params[0].name];

          let beforeCol = params[0].color;
          let afterCol  = params[1].color;

          return '<div style=\"text-align:center;\">' +
          'Among dancers who reached <b>' +  div_upper + '</b>,<br> half took ' +
          '<span style=\"font-weight:bold;color:' + beforeCol + ';\">' +
          before + '</span> to get there.<br><br>' +
          'But if we account for those still in <b>' + div_lower + '</b>,<br>' +
          'this increases to ' +
          '<span style=\"font-weight:bold;color:' + afterCol + '\">' +
          after + '</span>.</div>';
        }"
      ))
    ) |>
    echarts4r::e_grid(left = "7%", right = "5%", bottom = "5%", top = "5%")
}


plot_time_to_advance_survival <- function(df_first_final) {

  df_survival <- get_df_survival(df_first_final)

  model_survival <- survival::survfit(
    survival::Surv(months, advancement_flag) ~ progress,
    data = df_survival
  )
  df_survival_model_results <- summary(model_survival) |>
    with(data.frame(
      time   = time,
      surv   = 1 - surv,
      #lower  = 1 - lower,
      #upper  = 1 - upper,
      strata = strata
    )) |>
    dplyr::mutate(strata = gsub("progress=", "", strata)) |>
    tidyr::pivot_wider(names_from = "strata", values_from = "surv") |>
    janitor::clean_names()


  df_survival_model_results |>
    echarts4r::e_charts(x = time) |>
    echarts4r::e_line(
      serie = nov_int, symbol = "circle", step = "end", symbolSize = 3,
      name = "Novice to Intermediate",
      lineStyle = list(width = 0.5, type = "dashed"), connectNulls = TRUE,
      color = col_palette$divisions$Novice
    ) |>
    echarts4r::e_line(
      serie = int_adv, symbol = "circle", step = "end", symbolSize = 3,
      name = "Intermediate to Advanced",
      lineStyle = list(width = 0.5, type = "dashed"), connectNulls = TRUE,
      color = col_palette$divisions$Intermediate
    ) |>
    echarts4r::e_line(
      serie = adv_als, symbol = "circle", step = "end", symbolSize = 3,
      name = "Advanced to All-Stars",
      lineStyle = list(width = 0.5, type = "dashed"), connectNulls = TRUE,
      color = col_palette$divisions$Advanced
    ) |>
    echarts4r::e_line(
      serie = als_champ, symbol = "circle", step = "end", symbolSize = 3,
      name = "All-Stars to Champions",
      lineStyle = list(width = 0.5, type = "dashed"), connectNulls = TRUE,
      color = col_palette$divisions$`All-Stars`
    ) |>
    echarts4r::e_x_axis(
      name = "Months",  nameLocation = "middle",
      axisLine  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      axisTick  = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.25))),
      splitLine = list(lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.1), type = "dashed")),
      axisLabel = list(align = "left", color = scales::alpha(col_palette$global$primary_light, 0.5), fontSize = 11, fontWeight = 300)
    ) |>
    echarts4r::e_y_axis(
      min = 0, max = 1, name = "Progression Probability",
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
    get_echart_legend() |>
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
      formatter = htmlwidgets::JS(paste0(
        'function(params) {
        ', js_convert_to_year_months, '
          let month = String(params[0].value[0]);
          let result = "";
          params.forEach(function(p) {
            if (p.value[1] !== null) {
              let pct = (p.value[1] * 100).toFixed(0);
              let parts = p.seriesName.split(" to ");
              let lower = parts[0];
              let upper = parts[1];
              result += "<span style=\'color:" + p.color + "\'><b>" + pct + "%" + "</b></span> of people who reached<b> " + lower + "</b><br>progress to <b>" + upper + "</b> within " + formatMonths(month) + ".<br/><br/>";
            }
          });
          return result;
        }'
      ))
    ) |>
    get_data_zoom_date(date = FALSE) |>
    echarts4r::e_toolbox(show = FALSE) |>
    echarts4r::e_grid(left = "5%", right = "5%", bottom = "17%", top = "10%")
}
