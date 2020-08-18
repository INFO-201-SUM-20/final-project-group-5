source('ui/map-ui.R')
source('ui/home-ui.R')
source('ui/market-ui.R')
source('ui/summary-ui.R')
source('ui/chart3-ui.R')

ui <- fluidPage(navbarPage(
    'USCV',
    tabPanel('Home', home),
    tabPanel('Interactive map', interactive_map),
    tabPanel('Markets', market_ui),
    tabPanel('Chart 3', chart3_ui),
    tabPanel('Summary', summary_ui)
    
  ),     
  includeCSS('www/style.css'),
  style = 'padding: 0px'
  )



