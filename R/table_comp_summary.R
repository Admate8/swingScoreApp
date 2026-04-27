get_df_dancers_summary <- function(df) {

  divisions_advancing <- c("Newcomer", "Novice", "Intermediate", "Advanced", "All-Stars", "Champions")

  non_active_dancers_count <- df |>
    dplyr::filter(recent_year < lubridate::year(Sys.Date()) - 3) |>
    dplyr::distinct(wsdc_id, full_name) |>
    nrow()

  active_dancers_count <- df |>
    dplyr::filter(recent_year >= lubridate::year(Sys.Date()) - 3) |>
    dplyr::distinct(wsdc_id, full_name) |>
    nrow()

  perc_active_dancers <- active_dancers_count / (active_dancers_count + non_active_dancers_count)

  df_all_dancers <- df |>
    dplyr::distinct(wsdc_id, full_name, role, division = dom_role_highest) |>
    # Remove non-advancing divisions
    dplyr::filter(!is.na(division)) |>
    dplyr::count(division, role, name = "count") |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_count")) |>
    tidyr::pivot_wider(names_from = "role", values_from = "count") |>
    dplyr::mutate(
      f_perc = f_count / sum(f_count),
      l_perc = l_count / sum(l_count)
    ) |>
    dplyr::mutate(division = factor(division, levels = divisions_advancing)) |>
    dplyr::arrange(division)
  df_all_dancers <- df_all_dancers |>
    rbind(data.frame(
      division = "Total",
      f_count  = sum(df_all_dancers$f_count),
      l_count  = sum(df_all_dancers$l_count),
      f_perc   = NA, l_perc = NA
    ))


  df_active_dancers <- df |>
    # filter for active competitors only
    dplyr::filter(recent_year >= lubridate::year(Sys.Date()) - 3) |>
    dplyr::distinct(wsdc_id, full_name, role, division = dom_role_highest) |>
    # Remove non-advancing divisions
    dplyr::filter(!is.na(division)) |>
    dplyr::count(division, role, name = "count") |>
    dplyr::mutate(role = paste0(tolower(substr(role, 1, 1)), "_count")) |>
    tidyr::pivot_wider(names_from = "role", values_from = "count") |>
    dplyr::mutate(
      f_perc = f_count / sum(f_count),
      l_perc = l_count / sum(l_count)
    ) |>
    dplyr::mutate(division = factor(division, levels = divisions_advancing)) |>
    dplyr::arrange(division)
  df_active_dancers <- df_active_dancers |>
    rbind(data.frame(
      division = "Total",
      f_count  = sum(df_active_dancers$f_count),
      l_count  = sum(df_active_dancers$l_count),
      f_perc   = NA, l_perc = NA
    ))

  list(
    "perc_active_dancers" = perc_active_dancers,
    "df_all_dancers"      = df_all_dancers,
    "df_active_dancers"   = df_active_dancers
  )
}



plot_active_dancers_prop <- function(df) {

  perc_active_dancers <- get_df_dancers_summary(df)$perc_active_dancers

  echarts4r::e_charts() |>
    echarts4r::e_gauge(
      value       = perc_active_dancers,
      name        = "ACTIVE COMPETITORS",
      radius      = "100%",
      startAngle  = 180,
      endAngle    = 0,
      center      = list('50%', '70%'),
      min         = 0,
      max         = 100,
      splitNumber = 5,
      axisLine    = list(
        lineStyle = list(
          width = 30,
          color = list(
            list(perc_active_dancers, col_palette$global$primary_light),
            list(1, "rgba(99,102,241,0.1)")
          )
        ),
        roundCap = TRUE
      ),
      axisLabel = list(show = FALSE),
      pointer   = list(show = FALSE),
      axisTick  = list(show = FALSE),
      splitLine = list(show = FALSE),
      title = list(
        offsetCenter = list(0, "-10%"),
        fontSize     = 11,
        fontWeight   = 300,
        letterSpacing = "0.08em",
        color        = scales::alpha(col_palette$global$primary_light, 0.55)
      ),
      detail = list(
        offsetCenter   = list(0, "-38%"),
        fontSize       = 35,
        fontWeight     = 200,
        color          = col_palette$global$tertiary,
        valueAnimation = TRUE,
        rich           = list(
          unit = list(
            fontSize  = 14,
            color     = scales::alpha(col_palette$global$primary_light, 0.5),
            fontWeight = 300,
            padding   = list(0, 0, 4, 2)
          )
        ),
        formatter      = htmlwidgets::JS(
          "function(value) {return (100 * parseFloat(value)).toFixed(0) + '%';}"
        )
      )
    ) |>
    echarts4r::e_grid(left = "0%", right = "0%", top = "0%", bottom = "0%")
}



table_dancers_summary <- function(df) {

  custom_background <- list(
    color            = scales::alpha(col_palette$global$primary_light, 0.6),
    background       = col_palette$global$solid_bg,
    fontWeight       = 400,
    fontSize         = "0.7rem",
    letterSpacing    = "0.1em",
    textTransform    = "uppercase",
    borderBottomColor = scales::alpha(col_palette$global$secondary, 0.25)
  )

  df |>
    reactable::reactable(
      compact = TRUE,
      outlined = TRUE,
      theme   = custom_reactable_theme,
      style   = list(fontSize = "0.7em"),
      columnGroups = list(
        reactable::colGroup(
          name = "",
          columns = "division",
          headerStyle = custom_background
        ),
        reactable::colGroup(
          name = "Followers",
          columns = c("f_count", "f_perc"),
          headerStyle = custom_background
        ),
        reactable::colGroup(
          name = "Leaders",
          columns = c("l_count", "l_perc"),
          headerStyle = list(
            color            = scales::alpha(col_palette$global$primary_light, 0.6),
            background       = col_palette$global$solid_bg,
            fontWeight       = 400,
            fontSize         = "0.7rem",
            letterSpacing    = "0.1em",
            textTransform    = "uppercase",
            borderBottomColor = scales::alpha(col_palette$global$secondary, 0.25)
          )
        )
      ),
      columns = list(
        division = reactable::colDef(
          name   = "Division",
          style  = list(background = col_palette$global$solid_bg),
          cell   = function(value, index) {
            is_last <- index == nrow(df)

            if (is_last) {
              tags$div(style = custom_background, value)
            } else {
              value
            }
          }
        ),
        f_count = reactable::colDef(name = "Competitors", format = reactable::colFormat(separators = TRUE)),
        l_count = reactable::colDef(name = "Competitors", format = reactable::colFormat(separators = TRUE)),
        f_perc = reactable::colDef(
          name = "% of Total",
          align = "left",
          cell = reactablefmtr::data_bars(
            data = df,
            fill_color = c(
              "transparent",
              col_palette$roles$follower
            ),
            background    = "transparent",
            bar_height    = 7,
            number_fmt    = scales::percent,
            text_position = "outside-end",
            fill_gradient = TRUE,
            max_value     = 1,
            icon          = "fas fa-circle",
            icon_color    = col_palette$roles$follower,
            icon_size     = 12,
            text_color    = col_palette$roles$follower,
            text_size     = 12,
            round_edges   = TRUE
          )
        ),
        l_perc = reactable::colDef(
          name = "% of Total",
          align = "left",
          cell = reactablefmtr::data_bars(
            data = df,
            fill_color = c(
              "transparent",
              col_palette$roles$leader
            ),
            background    = "transparent",
            bar_height    = 7,
            number_fmt    = scales::percent,
            text_position = "outside-end",
            fill_gradient = TRUE,
            max_value     = 1,
            icon          = "fas fa-circle",
            icon_color    = col_palette$roles$leader,
            icon_size     = 12,
            text_color    = col_palette$roles$leader,
            text_size     = 12,
            round_edges   = TRUE
          )
        )
      )
    )
}
