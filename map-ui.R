interactive_map <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  leafletOutput("leafMap", width = '100%', height = '100vh'),
  p(),
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
                width = 330, height = "auto",
                
                h2("COVID Tracker"),
                
                h3(
                  textOutput(
                    outputId = 'total_cases'
                  )),
                
                h3(
                  textOutput(
                    outputId = 'total_deaths'
                  )),
                
                h3(textOutput(
                  outputId = 'total_tests'
                )),
                h3(textOutput(
                  outputId = 'dow_close'
                )),
                h3(textOutput(
                  outputId = 'spy_close'
                )),
                tags$br(),
                sliderInput("integer", "Days since first COVID-19 Case:",
                            min = 0, 
                            max = 200,
                            value = 0
                )
  )
)