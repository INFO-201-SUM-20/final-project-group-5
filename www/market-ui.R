market_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  h2('US Markets during the COVID-19 Pandemic'),

  p(),
  
  plotlyOutput("marketPlot")


)