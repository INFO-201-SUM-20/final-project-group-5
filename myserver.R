library('dplyr')
library("formattable")

print('b4 data')

timeseries <- read.csv("data/time_series_covid19_confirmed_US.csv",
                       stringsAsFactors = F)

states <- geojsonio::geojson_read("data/us-states.json", what = "sp")

dow_data <- read.csv("data/dow-jones-data.csv", stringsAsFactors = F)
spy_data <- read.csv("data/S&P 500.csv", stringsAsFactors = F)
owid_covid_data <- read.csv("data/owid-covid-data.csv", stringsAsFactors = F)
mask_data <- read.csv("data/mask-use-by-county.csv", stringsAsFactors = F)

covid_data <- owid_covid_data %>%
  filter(location == "United States") %>%
  mutate(Month = as.numeric(substr(date, 6, 7))) %>%
  mutate(Date = as.Date(date))

dow_data <- dow_data %>%
  mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
  mutate(dowClose = Close) %>%
  select(Date, dowClose)

spy_data <- spy_data %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(spyClose = Close) %>%
  select(Date, spyClose)

df <- covid_data %>%
  inner_join(dow_data, by = "Date") %>%
  inner_join(spy_data, by = "Date")

cov_data <- timeseries %>%
  select(Province_State, Lat, Long_, X8.5.20, Combined_Key) %>%
  filter(X8.5.20 > 100 & is.numeric(X8.5.20))





print('b4 server')

server <- function(input, output){
  print('in server')
  

  
  # Function for market UI
  
  output$marketPlot <- renderPlotly({
    ggplotly(ggplot(df, ) +
               geom_line(aes(x = Date, y = dowClose), colour = "#ff7900") +
               xlab("US Market Performance"))
  })
  
  output$spyGraph <- renderPlotly({
    ggplotly(ggplot(df) +
               geom_line(aes(x = Date, y = spyClose), colour = "#0082e9") +
               xlab("S&P 500 Performance"))
  })
  
  output$covidPlot <- renderPlotly({
    
    val <- input$marketRadioInput
    
    if(val == 1){
      m_name <- 'total_cases'
      m_label <- 'Total COVID Cases'
    }else if(val == 2){
      m_name = 'new_cases'
      m_label <- 'New Daily COVID-19 Cases'
      
    }else{
      m_name = 'total_deaths'
      m_label <- 'Total COVID-19 Deaths'
      
    }
    
    ggplotly(ggplot(df) +
               geom_line(aes(x = Date, y = df[[m_name]]), colour = "#f44336") +
               xlab(m_label))
  })
  
  
  
  
  
  # Functions for Interactive map
  
  output$leafMap <- renderLeaflet({
    leaflet(states) %>%
      addProviderTiles("CartoDB.DarkMatter") %>%
      setView(-96, 37.8, 4, zoom = 6)
   })
  
  output$total_cases <- renderText({
    total_cases <- covid_data %>%
      slice(input$integer) %>%
      pull(total_cases)
    
    return(paste0('Total cases: ', comma(total_cases, digits = 0)))
    
  })
  
  output$total_deaths <- renderText({
    total_deaths <- covid_data %>%
      slice(input$integer) %>%
      pull(total_deaths)
    
      return(paste0('Total deaths: ', comma(total_deaths, digits = 0)))
  })
  
  output$total_tests<- renderText({
    total_tests <- covid_data %>%
      slice(input$integer) %>%
      pull(total_tests)
    
    return(paste0('Total tests: ', comma(total_tests, digits = 0)))
  })
  
  
  output$dow_close <- renderText({
    dow <- df %>%
      slice(input$integer) %>%
      pull(dowClose)
    
    return(paste0('Dow Jones: ', comma(dow, digits = 2)))
  })
  
  output$spy_close <- renderText({
    spy <- df %>%
      slice(input$integer) %>%
      pull(spyClose)
    
    return(paste0('S&P 500: ', comma(spy, digits = 2)))
  })

  observe({
    
    names <- timeseries %>% colnames()
    name <- names[[12 + input$integer]]
    
    leafletProxy("leafMap") %>%
    clearShapes() %>%
     
      addCircles(
        data = cov_data,
        lat = ~Lat,
        lng = ~Long_,
        radius = ~ timeseries[[name]],
        popup = ~ paste(Combined_Key, "<br/>", "Total cases: ", 
                        comma(timeseries[[name]], digits = 0)),
        color = "#a94442", fillOpacity = 0.9,
        group = "cases",
        stroke = FALSE
      )
  })
  
}