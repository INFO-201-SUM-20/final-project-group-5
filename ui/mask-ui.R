mask_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),

  h2('Mask Usage in the United States'),
  
  p(),
  titlePanel ('Top Counties'),
  sidebarLayout(
  sidebarPanel('mask_bar_graph', 'Code', choices = union(c="COUNTYFP", unique(mask_data$COUNTYFP)))
  ),
  mainPanel(
  plotlyOutput("maskUse")  
  ))
