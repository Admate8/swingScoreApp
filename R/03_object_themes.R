
# 1. Reactable theme ------------------------------------------------------


custom_reactable_theme <- reactable::reactableTheme(
  color                = "#c7d2fe",
  # highlightColor = "red",
  # Controled by: .rt-tr-highlight:hover .rt-tr-highlight-sticky:hover
  # class in the SCSS file
  backgroundColor      = "transparent",
  borderColor          = "rgba(99, 102, 241, 0.25)",
  cellPadding          = "0.65rem 1rem",

  tableStyle           = list(borderRadius = "1rem"),
  headerStyle          = list(
    color            = "rgba(165, 148, 249, 0.6)",
    background       = "#202946",
    fontWeight       = 400,
    fontSize         = "0.7rem",
    letterSpacing    = "0.1em",
    textTransform    = "uppercase",
    borderBottomColor = "rgba(99, 102, 241, 0.25)"
  ),
  rowStyle             = list(borderBottomColor = "rgba(99, 102, 241, 0.08)"),
  paginationStyle      = list(
    color       = "rgba(165, 148, 249, 0.5)",
    fontSize    = "0.78rem",
    borderColor = "rgba(99, 102, 241, 0.12)"
  ),
  searchInputStyle     = list(
    background  = "rgba(99, 102, 241, 0.07)",
    border      = "1px solid rgba(99, 102, 241, 0.2)",
    borderRadius = "0.6rem",
    color       = "#c7d2fe",
    fontSize    = "0.85rem",
    width       = "100%"
  )
)



# 2. Echarts theme --------------------------------------------------------

get_data_zoom_date <- function(echart) {
  echart |>
    echarts4r::e_datazoom(
      type            = "slider",
      bottom          = 20,
      height          = 20,
      borderColor     = "rgba(99,102,241,0.25)",
      backgroundColor = "rgba(99,102,241,0.05)",
      fillerColor     = "rgba(99,102,241,0.12)",
      labelFormatter  = htmlwidgets::JS(
        "function(value, valueStr) {
          let current_date = new Date(valueStr);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'short'});
        }"
      ),
      handleStyle = list(
        color       = "rgba(99,102,241,0.5)",
        borderColor = "#a5b4fc",
        borderWidth = 1,
        shadowColor = "rgba(165,180,252,0.4)",
        shadowBlur  = 6,
        borderCap   = "round"
      ),
      moveHandleStyle = list(
        color       = "rgba(99,102,241,0.3)",
        borderColor = "rgba(165,180,252,0.4)"
      ),
      selectedDataBackground = list(
        lineStyle = list(color = "#a5b4fc", width = 1),
        areaStyle = list(color = "rgba(165,180,252,0.08)")
      ),
      dataBackground = list(
        lineStyle = list(color = "rgba(99,102,241,0.2)", width = 1),
        areaStyle = list(color = "rgba(99,102,241,0.04)")
      ),
      emphasis = list(
        handleStyle     = list(borderColor = "#c7d2fe", shadowBlur = 10),
        moveHandleStyle = list(color = "rgba(99,102,241,0.5)")
      ),
      textStyle = list(color = "rgba(165,148,249,0.5)", fontSize = 10)
    )
}
