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
            tags$div(
              style = "text-align: justify;padding:1rem;",
              tags$p(
                "There are at least two possible reasons for this. Either you didn't
                compete in any of the available events or competitions (see the
                table on the right), or you did compete but your data was entered
                or processed incorrectly. If you can find your results for a specific
                event on scoring.dance but not here, ",
                tags$a(
                  "get in touch.",
                  href = "mailto:omega.dancing.score@gmail.com",
                  target = "_blank"
                )
              )
            )
          ),
          bslib::accordion_panel(
            title = "My WSDC ID shows as NA. Why?",
            tags$div(
              style = "text-align: justify;padding:1rem;",
              tags$p(
                "You're assigned a unique WSDC ID once you earn at least one WSDC
                point (typically by placing in the final, depending on the
                competition size). If you haven't reached that milestone yet,
                your WSDC ID will appear as NA - but don't worry. Your progress
                still matters, and your Omega Score will reflect it."
              ),
              tags$p(
                "Another possible issue is incorrect data on ",
                tags$a(
                  "scoring.dance.",
                  href = "https://scoring.dance/enCA/",
                  target = "_blank"
                ), ".
                If your name or WSDC ID was submitted incorrectly, it may not
                match the official WSDC records. In such cases, a misspelled name
                might be treated as a different competitor altogether. If you think
                this might apply to you, ",
                tags$a(
                  "get in touch.",
                  href = "mailto:omega.dancing.score@gmail.com",
                  target = "_blank"
                )
              )
            )
          ),
          bslib::accordion_panel(
            title = "My details or data seem incorrect. Why?",
            tags$div(
              style = "text-align: justify;padding:1rem;",
              tags$p(
                "There are at least two reasons why this might happen."
              ),
              tags$p(
                "First, your data for a particular event or competition on ",
                tags$a(
                  "scoring.dance",
                  href = "https://scoring.dance/enCA/",
                  target = "_blank"
                ),
                " may have been entered incorrectly. The app tries to fix minor
                issues - such as small spelling mistakes in names, missing WSDC IDs,
                surname changes, or typos in IDs - but it's not possible to catch
                everything. The WSDC system itself focuses on results that
                award points, so non-scoring entries may be less consistent.
                In some cases, the same person might even appear with multiple
                WSDC IDs, which ideally shouldn't happen unless two dancers share
                the exact same name."
              ),
              tags$p(
                "Second, the issue may come from the data processing side.
                When names are very similar, our correction methods might accidentally
                merge two different dancers into one. Unfortunately, there's no
                reliable way to detect this automatically unless it's reported.
                This is further complicated by inconsistencies in scoring.dance data."
              ),
              tags$p(
                "In short, mistakes can and do happen - but they can be fixed.
                If you think this applies to you, ",
                tags$a(
                  "get in touch.",
                  href = "mailto:omega.dancing.score@gmail.com",
                  target = "_blank"
                )
              )
            )
          )
        ),

        conditionalPanel(
          condition = "input.select_dancer != null && input.select_dancer != ''",
          actionButton(
            class   = "btn-glow",
            style   = "font-size:1.5em;font-weight:bold;",
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
