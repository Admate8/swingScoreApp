ui_individual_analysis_setup <- bslib::layout_columns(
  col_widths = c(5, 7),

  tags$div(
    class = "d-flex align-items-center justify-content-center h-100",
    tags$div(
      class = "w-100",
      shinyWidgets::pickerInput(
        inputId    = "select_dancer",
        label      = NULL,
        selected   = NULL,
        multiple   = FALSE,
        width      = "25rem",
        choices    = stats::setNames(
          df_dancers |>
            dplyr::distinct(contestant, wsdc_id, contestant_id) |>
            dplyr::mutate(contestant = stringr::str_to_title(contestant)) |>
            dplyr::arrange(contestant) |>
            dplyr::pull(contestant_id),
          df_dancers |>
            dplyr::distinct(contestant, wsdc_id, contestant_id) |>
            dplyr::mutate(contestant = stringr::str_to_title(contestant)) |>
            dplyr::arrange(contestant) |>
            dplyr::pull(contestant)
        ),
        choicesOpt = list(
          subtext = paste0(
            "(",
            df_dancers |>
              dplyr::distinct(contestant, wsdc_id) |>
              dplyr::mutate(contestant = stringr::str_to_title(contestant)) |>
              dplyr::arrange(contestant) |>
              dplyr::pull(wsdc_id),
            ")"
          )
        ),
        options = shinyWidgets::pickerOptions(
          size                = 3,
          liveSearch          = TRUE,
          liveSearchNormalize = TRUE,
          liveSearchStyle     = "contains",
          noneResultsText     = "No matches...",
          showSubtext         = TRUE,
          title               = "Select your name or WSDC ID..."
        )
      ) |> tags$div(style = "display: flex; justify-content: center; margin-top: 1rem;"),
      br(),
      bslib::layout_columns(
        col_widths = c(12, -1, 10, -1, -4, 4, -4),
        tags$div("FAQ", class = "faq-header"),
        bslib::accordion(
          open     = FALSE,
          multiple = FALSE,
          bslib::accordion_panel(
            title = "What is the Omega score?",
            lorem::ipsum(2)
          ),
          bslib::accordion_panel(
            title = "My competition is missing. Why?",
            lorem::ipsum(2)
          ),
          bslib::accordion_panel(
            title = "I can't see my name or WSDC ID. Why?",
            lorem::ipsum(1)
          ),
          bslib::accordion_panel(
            title = "My WSDC ID shows as NA. Why?",
            lorem::ipsum(2)
          ),
          bslib::accordion_panel(
            title = "My WSDC ID is negative. Why?",
            lorem::ipsum(2)
          )
        ),

        conditionalPanel(
          condition = "input.select_dancer != null && input.select_dancer != ''",
          actionButton(
            class   = "btn-glow",
            style   = "font-size:2em;font-weight:bold;",
            inputId = "button_dancer_selected",
            label   = "Show me!",
            onclick = "fullpage_api.moveTo(3, 0);"
          )
        )
      )
    )
  ),

  tags$div(
    class = "d-flex align-items-center h-100",
    tags$div(
      class = "glass-wrapper d-flex flex-column",
      style = "height: 80vh; width: 100%; min-width: 0;",
      tags$div("Available Events & Competitions", class = "glass-div-header"),
      br(),
      tags$div(
        class = "scrollable-table",
        style = "flex: 1 1 auto; min-width: 0; width: 100%; border-radius: 15px;",
        reactable::reactableOutput("table_event_details", width = "100%", height = "65vh") |> add_spinner()
      )
    )
  )
)
