mask_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),

  h2('Mask Usage in the United States'),
  
  p(),
  titlePanel ('Top Counties'),
  sidebarLayout(
  sidebarPanel('mask_bar_graph', 'Code', 
               radioButtons(
                 "maskRadioInput",
                 label="County Picker",
               choices = list('Greene' = 05055, 'Santa Cruz' = 04923))),
  mainPanel(
    plotlyOutput("maskUse")  
  )
  ))
