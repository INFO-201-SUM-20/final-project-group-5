library('dplyr')
library('ggplot2')
library('leaflet')
library('shiny')

csv <- read.csv('data/time_series_covid19_confirmed_US.csv', stringsAsFactors =
                     FALSE)

render_leaf_plot <- function(df){
  covid_data <- df %>%
    select(Province_State, Lat, Long_, X8.5.20, Combined_Key) %>%
    filter(X8.5.20 > 100)

  leaf_plot <- leaflet(data = covid_data) %>%
    addProviderTiles('CartoDB.Positron') %>%
    setView(lng = -122.3321, lat = 47.6062, zoom = 5) %>%
    addCircles(
      lat = ~Lat,
      lng = ~Long_,
      radius = ~X8.5.20,
      popup =  ~paste(Combined_Key, '<br/>', 'Total cases: ', X8.5.20),
      color = 'pink', fillOpacity = 0.7
    ) %>%

    addLayersControl(overlayGroups = c("Red","Blue") , baseGroups = c("background 1","background 2"),
                     options = layersControlOptions(collapsed = FALSE))

    return(leaf_plot)
}
