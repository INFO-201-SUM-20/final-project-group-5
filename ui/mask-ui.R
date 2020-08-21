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
               choices = list('Greene,AR' = 05055, 'Maricopa,AZ' = 04013,
                              'Kit Carson,CO' = 08043,
                              'Hardee,FL' = 12049,
                              'Honolulu,HI' = 15003,'Cook,IL' = 17031,
                              'Graham,KS' = 20065, 'Hudson,NJ' = 34017,
                              'Queens,NY' = 36081, 'King,WA' = 53033))),
  mainPanel(
    plotlyOutput("maskUse")  
  ) 
  ))
