source("ui/map-ui.R")
source("ui/home-ui.R")
source("ui/market-ui.R")
source("ui/summary-ui.R")
source("ui/mask-ui.R")
source("scripts/chart-3.R")


ui <- fluidPage(navbarPage(
  "US Stocks & COVID",
  tabPanel("Home", home),
  tabPanel("Interactive Map", interactive_map),
  tabPanel("Markets", market_ui),
  tabPanel("Mask Usage", mask_ui),
  tabPanel("Summary", summary_ui)
),
includeCSS("www/style.css"),
style = "padding: 0px"
)
