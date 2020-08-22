interactive_map <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  leafletOutput("leafMap", width = "100%", height = "100vh"),
  p(),
  absolutePanel(
    id = "controls", class = "panel panel-default", fixed = TRUE,
    draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
    width = 330, height = "auto",

    h2("COVID Tracker"),

    tags$div(
      class = "panel-row-wrapper",
      p(
        class = "map__panel-p",
        "Total Cases: ",
        tags$span(
          class = "map_panel-num",
          textOutput(
            outputId = "total_cases"
          )
        )
      )
    ),
    tags$div(
      class = "panel-row-wrapper",
      tags$p(
        class = "map__panel-p",
        "Total Deaths: ",
        tags$span(
          class = "map_panel-num",
          textOutput(
            outputId = "total_deaths"
          )
        )
      )
    ),
    tags$div(
      class = "panel-row-wrapper",
      tags$p(
        class = "map__panel-p",
        "Total Tests: ",
        tags$span(
          class = "map_panel-num",

          textOutput(
            outputId = "total_tests"
          )
        )
      )
    ),
    tags$div(
      class = "panel-row-wrapper",
      tags$p(
        class = "map__panel-p",
        "Dow Close: ",
        tags$span(
          class = "map_panel-num",

          textOutput(
            outputId = "dow_close"
          )
        )
      )
    ),
    tags$div(
      class = "panel-row-wrapper",
      tags$p(
        class = "map__panel-p",
        "S&P 500 Close: ",
        tags$span(
          class = "map_panel-num",

          textOutput(
            outputId = "spy_close"
          )
        )
      )
    ),
    tags$br(),
    sliderInput("integer", "Days since first COVID-19 Case:",
      min = 1,
      max = 130,
      value = 1
    ),
    tags$br(),

    plotOutput("mapDowPlot"),

    plotOutput("mapSpyPlot")
  ),
)
