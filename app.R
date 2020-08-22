library("shiny")
library("leaflet")
library("dplyr")

source("myui.R")
source("myserver.R")
source("scripts/chart-1.R")

# Run shiny app
shinyApp(ui = ui, server = server)
