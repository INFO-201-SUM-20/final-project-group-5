library('plotly')

market_ui <- fluidPage(
  style = 'overflow-y: auto',
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  
  h2('US Markets during the COVID-19 Pandemic'),
  
  sidebarLayout(
    sidebarPanel(
           tags$div(class = 'market__div',
           h3('Side Panel for interactive'),
           radioButtons(
             'marketRadioInput',
             label = 'COVID chart',
             choices = list('Total cases' = 1, 'Total deaths' = 2, 'Daily cases' = 3),
             selected = 1
           )
          )),
    
    mainPanel(
           h3('Covid Graph'),
           plotlyOutput("covidPlot"),

           h3('DOW Jones Graph'),       
           plotlyOutput("marketPlot"),
           h3('S&P 500 Graph'),       
           plotlyOutput("spyGraph")
          
          )
    )
)