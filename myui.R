source('ui/map-ui.R')
source('ui/home-ui.R')
source('ui/market-ui.R')
source('ui/summary-ui.R')
source('ui/chart3-ui.R')
source('scripts/chart-3.R')

mask_data <- read.csv("data/mask-use-by-county.csv", stringsAsFactors = F)
render_chart3(mask_data)

ui <- fluidPage(navbarPage(
    'USCV',
    tabPanel('Home', home),
    tabPanel('Interactive map', interactive_map),
    tabPanel('Markets', market_ui),
    tabPanel('Mask Usage', chart3_ui),
      sidebarLayout(
      sidebarPanel(
      radioButtons('Code', 'Code', choices = unique(mask_data$COUNTYFP))),
    mainPanel()),
    tabPanel('Summary', summary_ui)
    
  ),     
  includeCSS('www/style.css'),
  style = 'padding: 0px'
  )



