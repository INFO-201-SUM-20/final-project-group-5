library('dplyr')
library('ggplot2')
library('leaflet')
library('shiny')
library('geojsonio')



render_leaf_plot <- function(df){
  
  csv <- read.csv('data/time_series_covid19_confirmed_US.csv', stringsAsFactors =
                    FALSE)
  
  covid_data <- df %>%
    select(Province_State, Lat, Long_, X8.5.20, Combined_Key) %>%
    filter(X8.5.20 > 100)
  
  
  
  states <- geojsonio::geojson_read("data/us-states.json", what = "sp")
  m <- leaflet(states) %>%
    setView(-96, 37.8, 4) %>%
    addTiles("MapBox", options = providerTileOptions(
      id = "mapbox.light",
      group = 'stateTiles',
      accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
  
  bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
  pal <- colorBin("YlOrRd", domain = states$density, bins = bins)
  
  labels <- sprintf(
    "<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
    states$name, states$density
  ) %>% lapply(htmltools::HTML)
  
  create_color <- function(color){
    if(color == "red"){
      return('red')
    }else{
      return('blue')
    }
  }
  
  m <- m %>% addPolygons(
    fillColor = ~color,
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.5)


  
  m %>% addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                  position = "bottomright")
  m <- m %>%
    addCircles(
      data = covid_data,
      lat = ~Lat,
      lng = ~Long_,
      radius = ~X8.5.20,
      popup =  ~paste(Combined_Key, '<br/>', 'Total cases: ', X8.5.20),
      color = '#000', fillOpacity = 0.9,
      group = 'cases'
    ) %>%
    addLayersControl(
      baseGroups = c('stateTiles'),
      overlayGroups = c("cases"),
      options = layersControlOptions(collapsed = FALSE)
    )
  
  
  m <- m %>% addLegend('bottomright', colors = c('red', 'blue'), labels= c('Democratic', 'Republican'))
  
  
  

    return(m)
}


#label = labels,
#labelOptions = labelOptions(
#  style = list("font-weight" = "normal", padding = "3px 8px"),
 # textsize = "15px",
#  direction = "auto"))


#leaf_plot <- leaflet(data = covid_data) %>%
#  addProviderTiles('CartoDB.Positron') %>%
 # setView(lng = -122.3321, lat = 47.6062, zoom = 5) %>%
 # addCircles(
  #  lat = ~Lat,
 #   lng = ~Long_,
  #  radius = ~X8.5.20,
  #  popup =  ~paste(Combined_Key, '<br/>', 'Total cases: ', X8.5.20),
  #  color = 'pink', fillOpacity = 0.7
 # ) %>%
  
 # addLayersControl(overlayGroups = c("Red","Blue") , baseGroups = c("background 1","background 2"),
   #                options = layersControlOptions(collapsed = FALSE))

#highlight = highlightOptions(
 # weight = 5,
 # color = "#666",
 # dashArray = "",
  #fillOpacity = 0.4,
 # bringToFront = TRUE))



