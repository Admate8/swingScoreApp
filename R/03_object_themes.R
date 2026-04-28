
# 1. Reactable theme ------------------------------------------------------


custom_reactable_theme <- reactable::reactableTheme(
  color                = col_palette$global$tertiary,
  # highlightColor = "red",
  # Controled by: .rt-tr-highlight:hover .rt-tr-highlight-sticky:hover
  # class in the SCSS file
  backgroundColor      = "transparent",
  borderColor          = scales::alpha(col_palette$global$secondary, 0.25),
  cellPadding          = "0.65rem 1rem",

  tableStyle           = list(borderRadius = "1rem"),
  headerStyle          = list(
    color            = scales::alpha(col_palette$global$primary_light, 0.6),
    background       = col_palette$global$solid_bg,
    fontWeight       = 400,
    fontSize         = "0.7rem",
    letterSpacing    = "0.1em",
    textTransform    = "uppercase",
    borderBottomColor = scales::alpha(col_palette$global$secondary, 0.25)
  ),
  rowStyle             = list(borderBottomColor = scales::alpha(col_palette$global$secondary, 0.08)),
  # paginationStyle      = list(
  #   color       = "rgba(165, 148, 249, 0.5)",
  #   fontSize    = "0.78rem",
  #   borderColor = "rgba(99, 102, 241, 0.12)"
  # ),
  searchInputStyle     = list(
    background  = scales::alpha(col_palette$global$secondary, 0.07),
    border      = paste0("1px solid ", scales::alpha(col_palette$global$secondary, 0.2)),
    borderRadius = "0.6rem",
    color       = col_palette$global$tertiary,
    fontSize    = "0.85rem",
    width       = "100%"
  )
)



# 2. Echarts theme --------------------------------------------------------

get_data_zoom_date <- function(echart, date = TRUE) {

  if (date) {
    custom_formatter <- htmlwidgets::JS(
      "function(value, valueStr) {
          let current_date = new Date(valueStr);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'short'});
        }"
    )
  } else {
    custom_formatter <- htmlwidgets::JS("function(value, valueStr) { return value.toFixed(0); }")
  }

  echart |>
    echarts4r::e_datazoom(
      type            = "slider",
      bottom          = 20,
      height          = 20,
      borderColor     = scales::alpha(col_palette$global$secondary, 0.25),
      backgroundColor = scales::alpha(col_palette$global$secondary, 0.05),
      fillerColor     = scales::alpha(col_palette$global$secondary, 0.12),
      labelFormatter  = custom_formatter,
      handleStyle = list(
        color       = scales::alpha(col_palette$global$secondary, 0.5),
        borderColor = col_palette$global$secondary,
        borderWidth = 1,
        shadowColor = scales::alpha(col_palette$global$secondary, 0.4),
        shadowBlur  = 6,
        borderCap   = "round"
      ),
      moveHandleStyle = list(
        color       = scales::alpha(col_palette$global$secondary, 0.3),
        borderColor = scales::alpha(col_palette$global$secondary, 0.4)
      ),
      selectedDataBackground = list(
        lineStyle = list(color = col_palette$global$secondary, width = 1),
        areaStyle = list(color = scales::alpha(col_palette$global$secondary, 0.08))
      ),
      dataBackground = list(
        lineStyle = list(color = scales::alpha(col_palette$global$secondary, 0.2), width = 1),
        areaStyle = list(color = scales::alpha(col_palette$global$secondary, 0.04))
      ),
      emphasis = list(
        handleStyle     = list(borderColor = col_palette$global$tertiary, shadowBlur = 10),
        moveHandleStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5))
      ),
      textStyle = list(color = scales::alpha(col_palette$global$secondary, 0.5), fontSize = 10)
    )
}
