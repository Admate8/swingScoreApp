col_palette <- list(
  global = list(
    primary        = "#9333EA",

    primary_light  = "#a594f9", # rbg(165, 148, 249) Used for axis labels, subtitles
    secondary      = "#6366f1", # rbg(99, 102, 241)  Used for axis, custom icons, zoom elements, borders
    tertiary       = "#c7d2fe", # rgb(199, 210, 254) Used for icon accents and tooltip text
    tooltip_bg     = "#0f111e", # rgb(15, 17, 30)    Used for tooltip/label backgrounds
    solid_bg       = "#202946", # Used for table columns or visible background

    font_primary   = "#e2e8f0",
    font_secondary = "#ADADAD",

    body_col       = "#F1F5F9",
    body_col_sec   = "#CBD5E1"
  ),
  divisions = list(
    Newcomer      = "#86efac",
    Novice        = "#6ee7b7",
    Intermediate  = "#c4b5fd",
    Advanced      = "#7dd3fc",
    `All-Stars`   = "#fde047",
    Champions     = "#fca5a5",
    Juniors       = "#70e5ff",
    Sophisticated = "#ffae00",
    Masters       = "#8f5aff"
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
  secondary                   = col_palette$global$secondary,
  body_color                  = col_palette$global$body_col,
  body_color_secondary        = col_palette$global$body_col_sec,
  accordion_icon_active_color = col_palette$global$body_col,
  base_font                   = "Inter",
  heading_font                = "Poppins",
  accordion_border_radius     = "0.75rem"
) |>
  bslib::bs_add_rules(sass::sass_file("inst/app/www/custom_styles.scss"))
