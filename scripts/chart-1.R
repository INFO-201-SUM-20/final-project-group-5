library("dplyr")
library("ggplot2")
library("leaflet")
library("shiny")
library("geojsonio")
library("formattable")

render_leaf_plot <- function(df, name) {
  

  covid_data <- df %>%
    select(Province_State, Lat, Long_, X8.5.20, Combined_Key) %>%
    filter(X8.5.20 > 100 & is.numeric(X8.5.20))

  states <- geojsonio::geojson_read("data/us-states.json", what = "sp")
  m <- leaflet(states) %>%
    setView(-96, 37.8, 4) %>%
    addTiles() %>%
    addTiles("MapBox", options = providerTileOptions(
      id = "mapbox.light",
      group = "stateTiles",
      accessToken = Sys.getenv("MAPBOX_ACCESS_TOKEN")
    ))

  bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
  pal <- colorBin("Blues", domain = states$density, bins = bins)

  m <- m %>% addPolygons(
    fillColor = ~ pal(density),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.9)

  m <- m %>%
    addCircles(
      data = covid_data,
      lat = ~Lat,
      lng = ~Long_,
      radius = ~ df[[name]],
      popup = ~ paste(Combined_Key, "<br/>", "Total cases: ", 
                      comma(X8.5.20, digits = 0)),
      color = "#a94442", fillOpacity = 0.9,
      group = "cases",
      stroke = FALSE
    ) %>%
    addLayersControl(
      overlayGroups = c("cases"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>%
    addLegend(
      pal = pal, values = ~density, opacity = 0.7,
      position = "bottomright", title = "People per mile squared"
    )

  return(m)
}
