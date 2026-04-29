get_df_time_to_progress <- function(df_first_final) {

  df_time_to_progress <- df_first_final |>
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
      nov_to_inter = ifelse(
        !is.na(novice) & !is.na(intermediate),
        lubridate::time_length(
          lubridate::interval(novice, intermediate), "months"
        ), NA
      ),

      inter_to_adv = ifelse(
        !is.na(intermediate) & !is.na(advanced),
        lubridate::time_length(
          lubridate::interval(intermediate, advanced), "months"
        ), NA
      ),

      adv_to_als = ifelse(
        !is.na(advanced) & !is.na(all_stars),
        lubridate::time_length(
          lubridate::interval(advanced, all_stars), "months"
        ), NA
      ),

      als_to_champ = ifelse(
        !is.na(all_stars) & !is.na(champions),
        lubridate::time_length(
          lubridate::interval(all_stars, champions), "months"
        ), NA
      )
    ) |>
    # Remove dancers stuck in Novice
    dplyr::filter(!is.na(nov_to_inter)) |>
    dplyr::select(
      id, role, recent_year,
      nov_to_inter, inter_to_adv, adv_to_als, als_to_champ
    ) |>
    # Reshape to long
    tidyr::pivot_longer(
      c("nov_to_inter", "inter_to_adv", "adv_to_als", "als_to_champ"),
      names_to = "progress", values_to = "months"
    ) |>
    dplyr::mutate(progress = dplyr::case_when(
      progress == "nov_to_inter" ~ "Nov \U2192 Int",
      progress == "inter_to_adv" ~ "Int \U2192 Adv",
      progress == "adv_to_als"   ~ "Adv \U2192 Als",
      progress == "als_to_champ" ~ "Als \U2192 Champ"
    ))

  df_time_to_progress_med_wide <- df_time_to_progress |>
    dplyr::group_by(progress, role) |>
    dplyr::summarise(median = median(months, na.rm = TRUE), .groups = "drop") |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_med")) |>
    tidyr::pivot_wider(names_from = "role", values_from = "median")

  df_time_to_progress_wide <- df_time_to_progress |>
    dplyr::filter(!is.na(months)) |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_val")) |>
    tidyr::pivot_wider(names_from = "role", values_from = "months")

  list(
    "df_time_to_progress"          = df_time_to_progress,
    "df_time_to_progress_med_wide" = df_time_to_progress_med_wide,
    "df_time_to_progress_wide"     = df_time_to_progress_wide
  )
}


plot_time_to_progress <- function(df_first_final) {

  df <- get_df_time_to_progress(df_first_final)

  df_time_to_progress          <- df$df_time_to_progress
  df_time_to_progress_med_wide <- df$df_time_to_progress_med_wide
  df_time_to_progress_wide     <- df$df_time_to_progress_wide

  df_time_to_progress_wide |>
    dplyr::mutate(progress = factor(progress, levels = c(
      "Als \U2192 Champ", "Adv \U2192 Als", "Int \U2192 Adv", "Nov \U2192 Int"
    ))) |>
    dplyr::arrange(progress) |>
    echarts4r::e_chart(x = progress) |>
    echarts4r::e_scatter(
      serie = f_val, name = "Followers", symbol_size = 7,
      color = scales::alpha(col_palette$roles$follower, 0.2)
    ) |>
    echarts4r::e_scatter(
      serie = l_val, name = "Leaders", symbol_size = 7, symbol = "triangle",
      color = scales::alpha(col_palette$roles$leader, 0.2)
    ) |>
    echarts4r::e_jitter() |>
    echarts4r::e_data(df_time_to_progress_med_wide) |>
    echarts4r::e_line(
      serie = f_med, name = "Followers", symbol = "circle",
      color = col_palette$roles$follower, symbolSize = 10,
      lineStyle = list(width = 0),
      label = list(
        show = TRUE, color = "inherit", fontWeight = "bolder", fontSize = 15,
        formatter = htmlwidgets::JS(paste0("
        function(params) {
        ", js_convert_to_year_months, "
          return formatMonths(parseFloat(params.value[0]));
        }
      "))
      )
    ) |>
    echarts4r::e_line(
      serie = l_med, name = "Leaders", symbol = "triangle",
      color = col_palette$roles$leader, symbolSize = 10,
      lineStyle = list(width = 0),
      label = list(
        show = TRUE, color = "inherit", position = "bottom",
        fontWeight = "bolder", fontSize = 15,
        formatter = htmlwidgets::JS(paste0("
        function(params) {
        ", js_convert_to_year_months, "
          return formatMonths(parseFloat(params.value[0]));
        }
      "))
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
    get_data_zoom_date(date = FALSE, start = 0, end = 33) |>
    echarts4r::e_toolbox(show = FALSE) |>
    get_echart_legend() |>
    echarts4r::e_grid(left = "7%", right = "5%", bottom = "15%", top = "5%")
}
