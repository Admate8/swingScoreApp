col_palette <- list(
  global = list(
    primary        = "#9333EA",
    body_col       = "#F1F5F9",
    body_col_sec   = "#CBD5E1",
    bg_primary     = "#2C2C2C",
    bg_secondary   = "#474747"
  ),
  divisions = list(
    advancing = list(
      Newcomer     = "#A8DADC",
      Novice       = "#5FBCBF",
      Intermediate = "#FFC1CC",
      Advanced     = "#FF5C7A",
      `All-Stars`  = "#B39CD0",
      Champions    = "#8059B1"
    ),
    nonadvancing = list(
      jun = "#BC4749",
      sop = "#BC4749",
      mas = "#873132"
    )
  ),
  roles = list(
    leader   = "#2176AE",
    follower = "#F98948"
  ),
  accents = list(
    acc1_dark  = "#8f5aff",
    acc1_light = "#a07aff",
    acc2_dark  = "#c967ff",
    acc2_light = "#dc91ff",
    acc3_dark  = "#00d4ff",
    acc3_light = "#70e5ff",
    acc4_dark  = "#ffae00",
    acc4_light = "#ffc95b",
    acc5_dark  = "#6effa8",
    acc5_light = "#b1ffd6"
  )
)

app_theme <- bslib::bs_theme(
  primary                     = col_palette$global$primary,
  body_color                  = col_palette$global$body_col,
  body_color_secondary        = col_palette$global$body_col_sec,
  accordion_icon_active_color = col_palette$global$body_col,
  base_font                   = "Inter",
  heading_font                = "Poppins",
  accordion_border_radius     = "0.75rem"
) |>
  bslib::bs_add_rules(sass::sass_file("inst/app/www/custom_styles.scss"))
