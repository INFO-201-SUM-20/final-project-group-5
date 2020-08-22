library("plotly")

market_ui <- fluidPage(
  style = "overflow-y: auto",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),

  h2("Taking different looks at COVID-19 with US Markets"),


  tags$div(
    class = "market",
    fluidRow(
      column(
        3,
        tags$div(
          class = "market__div",
          checkboxGroupInput(
            "checkboxInput",
            label = "COVID vs US Market options",
            choices = list("Total Cases" = 1, "New Cases" = 2, "Total Deaths" = 3, "Total Tests" = 4),
            selected = c(2, 3)
          )
        )
      ),

      column(
        9,
        h3("COVID vs US Market"),
        fluidRow(
          column(
            6,
            plotlyOutput("combinedCovid", height = 600),
          ),
          column(
            6,
            plotlyOutput("combinedMarket", height = 600),
          )
        )
      ),
      column(
        3,
        tags$div(
          class = "market__div",
          checkboxGroupInput(
            "joinedCheckboxInput",
            label = "COVID & US Market Joined Options",
            choices = list("Total Cases" = 1, "New Cases" = 2, "Total Deaths" = 3, "New Deaths" = 4, "Total Tests" = 5, "New Tests" = 6, "Dow Jones" = 7, "S&P 500" = 8),
            selected = c(2, 4, 7, 8)
          ),
        )
      ),
      column(
        9,
        h3("COVID & US Market Joined"),
        plotlyOutput("combinedPlot", height = 600),
      ),
      column(
        3,
        tags$div(
          class = "market__div",
          radioButtons(
            "marketRadioInput",
            label = "COVID in the U.S Options",
            choices = list("Total cases" = 1, "Total deaths" = 2, "Daily cases" = 3),
            selected = 1
          )
        )
      ),
      column(
        9,

        h3("Covid in the U.S"),
        plotlyOutput("covidPlot", height = 600),

        h3("DOW Jones"),
        plotlyOutput("marketPlot", height = 600),
        h3("S&P 500"),
        plotlyOutput("spyGraph", height = 600)
      )
    )
  )
)
