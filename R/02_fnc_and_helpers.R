label_button_indivdual_analysis <- HTML('
  See my WCS competition<br>progression analysis <br>
  <svg width="3em" height="3em" viewBox="0 0 18 18" fill="none" style="vertical-align:middle; margin-left:8px;">
    <circle cx="9" cy="9" r="7.5" stroke="rgba(99,102,241,0.5)" stroke-width="0.8"/>
    <polyline points="2.5,13 6,8.5 9,10.5 13.5,5"
      stroke="#c7d2fe" stroke-width="1.3"
      stroke-linecap="round" stroke-linejoin="round" fill="none"/>
    <polyline points="11.5,5 13.5,5 13.5,7"
      stroke="#c7d2fe" stroke-width="1.3"
      stroke-linecap="round" stroke-linejoin="round" fill="none"/>
    <circle cx="6"    cy="8.5"  r="1.1" fill="rgba(99,102,241,0.7)" stroke="#c7d2fe" stroke-width="0.6"/>
    <circle cx="9"    cy="10.5" r="1.1" fill="rgba(99,102,241,0.7)" stroke="#c7d2fe" stroke-width="0.6"/>
    <circle cx="13.5" cy="5"    r="1.1" fill="#a5b4fc"              stroke="#c7d2fe" stroke-width="0.6"/>
  </svg>
')

label_button_group_analysis <- HTML('
  See the wider WCS<br>competitive scene analysis<br>
  <svg width="3em" height="3em" viewBox="0 0 18 18" fill="none" style="vertical-align:middle; margin-left:8px;">
    <circle cx="9" cy="9" r="7.5" stroke="rgba(99,102,241,0.5)" stroke-width="0.8"/>
    <circle cx="9" cy="9" r="2"   fill="rgba(99,102,241,0.6)"  stroke="#c7d2fe" stroke-width="0.7"/>
    <circle cx="9"    cy="3"  r="1.4" fill="rgba(99,102,241,0.5)" stroke="#c7d2fe" stroke-width="0.6"/>
    <circle cx="14.2" cy="12" r="1.4" fill="rgba(99,102,241,0.5)" stroke="#c7d2fe" stroke-width="0.6"/>
    <circle cx="3.8"  cy="12" r="1.4" fill="rgba(99,102,241,0.5)" stroke="#c7d2fe" stroke-width="0.6"/>
    <line x1="9"    y1="7"    x2="9"    y2="4.4"  stroke="#c7d2fe" stroke-width="0.7" stroke-dasharray="1.2 1"/>
    <line x1="10.7" y1="10.1" x2="13.1" y2="11.3" stroke="#c7d2fe" stroke-width="0.7" stroke-dasharray="1.2 1"/>
    <line x1="7.3"  y1="10.1" x2="4.9"  y2="11.3" stroke="#c7d2fe" stroke-width="0.7" stroke-dasharray="1.2 1"/>
  </svg>
')

add_spinner <- function(ui_element) {
  ui_element |>
    shinycssloaders::withSpinner(color = col_palette$global$primary, size = 1.5, type = 6)
}

#' Shade Hex Colour
#'
#' @param hex_color String: hex colour.
#' @param factor Shading factor: negative/positive values will darken/lighten the colour, respectively.
#'
#' @return Shaded hex colour.
get_hex_colour_shade <- function(hex_color, factor = 0.2) {
  if (factor == 0) hex_color
  else {
    rgb_values <- grDevices::col2rgb(hex_color) / 255
    rgb_values <- rgb_values + (1 - rgb_values) * factor
    rgb_values <- base::pmin(base::pmax(rgb_values, 0), 1)
    grDevices::rgb(rgb_values[1], rgb_values[2], rgb_values[3])
  }
}

