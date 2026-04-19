
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
