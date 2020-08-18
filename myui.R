source('map-ui.R')
source('home-ui.R')
source('market-ui.R')

ui <- fluidPage(navbarPage(
    'USCV',
    tabPanel('Home', home),
    tabPanel('Interactive map', interactive_map),
    tabPanel('Markets', market_ui),
    includeCSS('www/style.css')
  ))



