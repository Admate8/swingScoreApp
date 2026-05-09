ui_individual_analysis_setup <- bslib::layout_columns(
  col_widths = c(5, 7),

  tags$div(
    class = "d-flex align-items-center justify-content-center h-100",
    tags$div(
      class = "w-100",
      tags$div(
        style = "display: flex; justify-content: center; margin-top: 1rem;",
        uiOutput("pickerInput_dancer") |> add_spinner()
      ),
      br(),
      bslib::layout_columns(
        col_widths = c(12, -1, 10, -1, -4, 4, -4),
        tags$div("FAQ", class = "faq-header"),
        bslib::accordion(
          open     = FALSE,
          multiple = FALSE,
          bslib::accordion_panel(
            title = "What is the Omega score?",
            tags$div(
              style = "text-align: justify;padding:1rem;",
              tags$p(
                tags$span("The Omega Score", class = "glass-div-header", style = "font-size:1rem;text-align:left;"),
                " is a metric designed to capture your performance in all
                rounds of West Coast Swing competitions, not just in the final -
                regardless of event size,
                role, division, or the number of judges. It ranges from 0 to 100,
                making it easy to track your progression over time."
              ),
              tags$ul(
                tags$li(
                  "You'll score 0 if all judges give you a \"No\" in the prelims."
                ),
                tags$li(
                  "You'll score 100 if you win the competition and receive a \"Yes\" from every judge in all non-final rounds."
                )
              ),
              tags$p(
                "Omega rewards your effort in competitive settings by adding context
                to your raw results, helping you see progress even when you don't
                make the final - and giving you motivation to keep improving toward
                your next division."
              ),
              tags$p(
                "You can read more about how it's calculated, including detailed
                examples and a full technical walkthrough, on the ",
                tags$a(
                  "Swing Score website.",
                  href = "https://swing-score.netlify.app",
                  target = "_blank"
                )
              )
            )
          ),
          bslib::accordion_panel(
            title = "My competition is missing. Why?",
            tags$div(
              style = "text-align: justify;padding:1rem;",
              tags$p(
                "Not all competition results are publicly available. You can find
                all events and competitions used in this app in the table on the
                right-hand side. Currently, only events from ",
                tags$a(
                  "scoring.dance",
                  href = "https://scoring.dance/enCA/",
                  target = "_blank"
                ), "are included."
              ),
              tags$p(
                "This means that if you competed in an event that isn't published
                there - or whose results are unavailable, hidden, or incorrectly
                submitted - you won't see your Omega Score for those competitions."
              ),
              tags$p(
                "Because Omega is a comprehensive metric, it requires more information
                than just your \"Yes\"s, \"No\"s, and \"Alt\"s. As a result,
                your progression charts may be missing some past competitions."
              )
            )
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
            title = "My details or data seem incorrect. Why?",
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
