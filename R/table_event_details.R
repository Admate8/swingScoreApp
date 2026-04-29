get_df_event_details <- function(df_events, df_subevents, df_comps) {

  df_subevents  <- df_subevents |>
    dplyr::filter(!(division %in% c("Juniors Newcomer", "Masters Novice"))) |>
    dplyr::filter(retained_after_cleaning == 1)

  # 1. Find which divisions were present in each event
  df_events_divisions <- df_subevents |>
    dplyr::left_join(
      df_events |> dplyr::distinct(event_id, event_name, event_date, event_link),
      by = "event_id"
    ) |>
    dplyr::mutate(division = stringr::str_replace(division, "/.*", "")) |>
    dplyr::distinct(event_id, event_name, event_link, event_date, division) |>
    dplyr::arrange(dplyr::desc(event_date)) |>
    dplyr::mutate(present = 1) |>
    tidyr::pivot_wider(names_from = "division", values_from = "present") |>
    dplyr::select(
      event_id, event_name, event_link, event_date,
      Newcomer, Novice, Intermediate, Advanced, `All-Stars`, Champions,
      Juniors, Sophisticated, Masters
    )

  # 2. Compute total number of competitors per event
  df_comps_sizes <- df_comps |>
    dplyr::group_by(event_id) |>
    dplyr::summarise(all_competitors = sum(size), .groups = "drop") |>
    dplyr::mutate(
      comps_buckets = factor(
        dplyr::ntile(all_competitors, 3),
        labels = c("Small", "Medium", "Large")
      )
    )

  # 3. Combine into one data
  df_events_divisions |>
    dplyr::left_join(df_comps_sizes, by = "event_id") |>
    dplyr::relocate(comps_buckets, .after = event_date)
}

size_pill_colours <- list(
  Small  = list(bg = "rgba(16,185,129,0.12)",  text = "#6ee7b7", border = "rgba(16,185,129,0.3)"),
  Medium = list(bg = "rgba(234,179,8,0.12)",   text = "#fde047", border = "rgba(234,179,8,0.3)"),
  Large  = list(bg = "rgba(239,68,68,0.12)",   text = "#fca5a5", border = "rgba(239,68,68,0.3)")
)

size_pill <- function(label) {
  c <- size_pill_colours[[label]]
  if (is.null(c)) return(label)
  htmltools::tags$span(
    label,
    style = paste0(
      "display:inline-block; padding:0.2em 0.7em; border-radius:999px;",
      "font-size:0.75rem; font-weight:400; letter-spacing:0.03em;",
      "background:", c$bg, "; color:", c$text, "; border:1px solid ", c$border, ";"
    )
  )
}

get_df_event_details_subtable <- function(df_comps) {

  df_comps <- df_comps |>
    dplyr::filter(!(division %in% c("Juniors Newcomer", "Masters Novice")))

  df_comps |>
    dplyr::mutate(division = stringr::str_replace(division, "/.*", "")) |>
    dplyr::distinct(
      event_id, division, role, tier,
      n_prelim, n_quater, n_semi, n_final,
      J_prelim, J_quater, J_semi, J_final
    ) |>
    tidyr::pivot_longer(-c("event_id", "division", "role")) |>
    dplyr::mutate(name = dplyr::case_when(
      name == "tier"     ~ "Tier",
      name == "n_prelim" ~ "Dancers in Prelim",
      name == "n_quater" ~ "Dancers in Quater",
      name == "n_semi"   ~ "Dancers in Semi",
      name == "n_final"  ~ "Dancers in Final",
      name == "J_prelim" ~ "Judges* in Prelim",
      name == "J_quater" ~ "Judges* in Quater",
      name == "J_semi"   ~ "Judges* in Semi",
      name == "J_final"  ~ "Judges* in Final"
    )) |>
    dplyr::mutate(
      role      = ifelse(role == "Leader", "l", "f"),
      division  = stringr::str_to_snake(division),
      col_names = paste(role, division, sep = "_")
    ) |>
    dplyr::select(-division, -role) |>
    tidyr::pivot_wider(names_from = "col_names", values_from = "value") |>
    # Remove rows where all divisions were empty (e.g. Quater round)
    dplyr::mutate(flag_empty = dplyr::if_all(-(1:2), is.na) * 1) |>
    dplyr::filter(flag_empty == 0) |>
    dplyr::select(-flag_empty) |>
    # Establish correct column order
    dplyr::select(
      event_id, name,
      dplyr::contains("newcomer"),  dplyr::contains("novice"),
      dplyr::contains("inter"),     dplyr::contains("adv"),
      dplyr::contains("all_stars"), dplyr::contains("champ"),
      dplyr::contains("junior"),    dplyr::contains("soph"),
      dplyr::contains("mast")
    ) |>
    # Add an empty column to better align with the parent table
    dplyr::mutate(col_empty = NA) |>
    dplyr::relocate(col_empty, .after = name)
}


table_event_details <- function(df_events, df_subevents, df_comps) {

  df_events_table        <- get_df_event_details(df_events, df_subevents, df_comps)
  df_events_subtable     <- get_df_event_details_subtable(df_comps)
  divisions_advancing    <- c("Newcomer", "Novice", "Intermediate", "Advanced", "All-Stars", "Champions")
  divisions_nonadvancing <- c("Juniors", "Sophisticated", "Masters")

  df_events_table |>
    reactable::reactable(

      # 1. General table settings
      compact    = TRUE,
      highlight  = TRUE,
      pagination = FALSE,
      bordered   = TRUE,
      sortable   = FALSE,
      searchable = TRUE,
      theme      = custom_reactable_theme,
      style      = list(fontSize = "0.7em"),

      # 2. Specific column settings
      columns    = c(

        # 2.1. Cols to hide from the table
        stats::setNames(
          lapply(
            c("event_id", "event_link", "all_competitors"),
            function(x) {reactable::colDef(show = FALSE)}
          ),
          c("event_id", "event_link", "all_competitors")
        ),

        # 2.2. Cols with divisions
        stats::setNames(
          lapply(
            c(divisions_advancing, divisions_nonadvancing),
            function(x) {
              reactable::colDef(
                cell  = function(value) {
                  if (!is.na(value) && value == 1) {
                    htmltools::HTML(paste0(
                      '<svg width="1.1em" height="1.1em" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="8" r="7" fill="', scales::alpha(col_palette$global$secondary, 0.2), '" stroke="', scales::alpha(col_palette$global$secondary, 0.5), '" stroke-width="0.8"/>
                      <polyline points="4.5,8.5 7,11 11.5,5.5" stroke="', col_palette$global$secondary, '" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>'
                    ))
                  } else {
                    ""
                  }
                },
                align = "center",
                width = 114,
                html = TRUE
              )
            }
          ),
          c(divisions_advancing, divisions_nonadvancing)
        ),

        # 2.3. Cols with custom settings
        list(
          event_name = reactable::colDef(
            sticky = "left",
            name   = "Event Name",
            html   = TRUE,
            width  = 200,
            style  = list(background = col_palette$global$solid_bg),
            headerStyle = list(textAlign = "center"),
            cell   = function(value, index) {sprintf(
              '<a
            href="%s" target="_blank"
            style="color:%s; text-decoration:none; font-weight:bold;"
           >%s</a>',
              df_events_table$event_link[index], col_palette$global$tertiary, value
            )}
          ),
          event_date = reactable::colDef(
            sticky = "left",
            name   = "Event Date",
            width  = 100,
            align  = "center",
            style  = list(background = col_palette$global$solid_bg),
            cell   = function(value) {format(as.Date(value), "%d %b %Y")},
            headerStyle = list(textAlign = "center")
          ),
          comps_buckets = reactable::colDef(
            html  = TRUE,
            align = "center",
            width = 100,
            name  = 'Comp Size',
            cell =  function(v) size_pill(v)
          )
        )
      ),

      # 3. Sub-tables
      details = reactable::colDef(
        width  = 45,
        sticky = "left",
        style  = list(background = col_palette$global$solid_bg),

        details = function(index) {

          df_nested <- df_events_subtable |>
            dplyr::filter(event_id == df_events_table$event_id[index])

          tbl <- df_nested |>
            reactable::reactable(
              compact    = TRUE,
              highlight  = FALSE,
              pagination = FALSE,
              bordered   = FALSE,
              sortable   = FALSE,
              theme      = custom_reactable_theme,

              columns = c(
                list(
                  event_id  = reactable::colDef(show = FALSE),
                  name      = reactable::colDef(
                    name   = "Details",
                    width  = 344,
                    align  = "right",
                    sticky = "left",
                    style  = list(background = col_palette$global$solid_bg)
                  ),
                  col_empty = reactable::colDef(name = " ", width = 100),
                  # Move the last column here because it's 1px narrower
                  l_masters = reactable::colDef(name = "L", width = 56, align = "center")
                ),
                stats::setNames(
                  lapply(
                    paste0("f_", stringr::str_to_snake(
                      c(divisions_advancing, divisions_nonadvancing))),
                    function(x) {
                      reactable::colDef(name = "F", width = 57, align = "center")
                    }
                  ),
                  paste0("f_", stringr::str_to_snake(
                    c(divisions_advancing, divisions_nonadvancing)))
                ),
                stats::setNames(
                  lapply(
                    paste0("l_", stringr::str_to_snake(
                      c(divisions_advancing, divisions_nonadvancing))),
                    function(x) {reactable::colDef(name = "L", width = 57, align = "center")}
                  ),
                  paste0("l_", stringr::str_to_snake(
                    c(divisions_advancing, divisions_nonadvancing)))
                )
              )
            )
          htmltools::tagList(
            # This CSS ensures the first column is sticky in the nested table
            htmltools::tags$style(htmltools::HTML("
            /* Make the detail row the scroll container */
            .rt-tr-details .rt-table-wrap {
              overflow-x: auto !important;
              overflow-y: visible !important;
            }

            /* The detail row itself must NOT clip overflow */
            .rt-tr-details,
            .rt-tr-details > div,
            .rt-tr-details .rt-table {
              overflow: visible !important;
            }

            /* Sticky cells in the nested table only */
            .rt-tr-details .rt-td-sticky-left,
            .rt-tr-details .rt-th-sticky-left {
              position: sticky !important;
              left: 0 !important;
              z-index: 4 !important;
            }
          ")),
            htmltools::div(
              style = list(`font-size` = "0.7rem", `font-style` = "italic"),
              tbl,
              htmltools::div(
                style = list(margin = "0px 0px 0px 50px"),
                "*excluding the Chiefjudge"
              )
            )
          )
        }
      ),
      onClick  = "expand",
      rowStyle = list(cursor = "pointer")

    )
}
