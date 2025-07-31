col_pal <- list(
  global = list(
    primary = "#9333EA",
    body_col  = "#F1F5F9",
    body_col_sec = "#CBD5E1"
  )
)

app_theme <- bslib::bs_theme(
  primary = col_pal$global$primary,
  body_color = col_pal$global$body_col,
  body_color_secondary = col_pal$global$body_col_sec,
  accordion_icon_active_color = col_pal$global$body_col,
  base_font = "Inter",
  heading_font = "Poppins",
  accordion_border_radius = "0.75rem"
) |>
  bslib::bs_add_rules(sass::sass_file("inst/app/www/custom_styles.scss"))
