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




print('Before server start')

server <- function(input, output){
  
  print('Inside server')
  

  
  # Functions for Mask Usage 
  output$maskUse <- renderPlotly( {
    
    
    # Sorts data depending on widget
    
    if (input$mask_bar_graph != "COUNTYFP") {
      mask_data <- mask_data %>% filter(COUNTYFP == input$mask_bar_graph)
    } else {
      mask_data <- 
        group_by(mask_data, ALWAYS)
    }
    
    # Formats and arranges data for plot
    
    mask_data <- mask_data%>% 
      summarize(count = n()) %>%
      filter(count > 1) %>%
      arrange(desc(count))
    
    # Names columns
    
    colnames(mask_data) <- c("COUNTYFP", "ALWAYS")
    
    # Sets up plot dimensions
    
    m = list(
      l = 100,
      r = 0,
      b = 300,
      t = 50,
      pad = 0
    )
    
    # Renders plot
    
    plot_ly(
      mask_data, 
      x = ~mask_data$COUNTYFP, 
      y = ~mask_data$ALWAYS, 
      type = 'bar', name = 'Country') %>%
      
      # Sets layout of plot
      
      layout(
        title="Mask Usage by County",
        yaxis = list(title = 'Usage Frequency'), 
        barmode = 'group',
        xaxis = list(categoryarray = count, categoryorder = "array", title = "US County"),
        autosize = F,
        height= 500,
        margin = m)
  } )
  
  
  # Function for market UI
  
  
  
  output$marketPlot <- renderPlotly({
    ggplotly(ggplot(df, ) +
               geom_line(aes(x = Date, y = dowClose, color = 'Dow Jones')) +
               xlab("US Market Performance") + 
               labs(color = 'Legend')
             
               )
  })
  
  output$spyGraph <- renderPlotly({
    ggplotly(ggplot(df) +
               geom_line(aes(x = Date, y = spyClose, color = 'S&P 500')) +
               xlab("S&P 500 Performance") +
               labs(color = 'Legend')
             
               )
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
               geom_line(aes(x = Date, y = df[[m_name]], color = m_label)) +
               xlab(m_label) +
               labs(color = 'Legend')
             
               )
  })
  
  output$combinedPlot <- renderPlotly({
    
    c_plot <- ggplot(df) + xlab('U.S COVID-19 and Market Data') + labs(color = 'Legend')

    
    vals <- input$joinedCheckboxInput
    
    if(1 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = total_cases, color = "#f44336"))
    }
    if(2 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = new_cases, color = 'Daily Cases'))
    }
    if(3 %in% vals){
      geom_line(aes(x = Date, y = total_deaths, colour = "black"))
    }
    if(4 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = new_deaths, color = "Daily Deaths"))
    }
    if(5 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = total_tests, color = "Total Tests"))
    }
    if(6 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = new_tests, color = "Daily Tests"))
    }
    if(7 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = dowClose, color = "Dow Jones"))
    }
    if(8 %in% vals){
      c_plot <- c_plot + geom_line(aes(x = Date, y = spyClose, color = "S&P 500")) 

    }
    
    c_plot <- c_plot + theme(    legend.position = c(0.95, 0.95),
                                 legend.justification = c("right", "top"),
                                 )
   
    return(ggplotly(c_plot))
   
  })
  
  
  output$combinedCovid <- renderPlotly({
    print(input$checkboxInput)
    vals <- input$checkboxInput
    
    p <- ggplot(df) +
           xlab('COVID-19 in the U.S') +
          labs(color = 'Legend')
    
    if(1 %in% vals){
      p <- p + geom_line(aes(x = Date, y = total_cases, color = 'Total Cases'))

    }
    if(2 %in% vals){
      p <- p + geom_line(aes(x = Date, y = new_cases, color = 'Daily Cases'))
    }
    if(3 %in% vals){
      p <- p + geom_line(aes(x = Date, y = total_deaths, color = 'Total Deaths'))
    }
    if(4 %in% vals){
      p <- p + geom_line(aes(x = Date, y = new_deaths, color = 'Daily Deaths'))
    }
    
    p <- p + theme(    legend.position = c(0.95, 0.95),
                                 legend.justification = c("right", "top"),
    )
    
    return(ggplotly(p))
  })
  
  output$combinedMarket <- renderPlotly({
    
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
               geom_line(aes(x = Date, y = dowClose, color = 'Dow Jones')) +
               geom_line(aes(x = Date, y = spyClose, color = 'S&P 500')) +
               theme(    legend.position = c(0.95, 0.95),
                         legend.justification = c("right", "top"),
               ) +
               xlab('Dow Jones & S&P 500 in the U.S') +
               labs(color = 'Legend')
             
             )
  })
  
  
  # Functions for Interactive map
  
  output$leafMap <- renderLeaflet({
    leaflet(states) %>%
      addProviderTiles("CartoDB.DarkMatter") %>%
      setView(-96, 37.8, 4, zoom = 6)
   })
  
  output$total_cases <- renderText({
    total_cases <- covid_data %>%
      slice(input$integer + 14) %>%
      pull(total_cases)
    
    return(comma(total_cases, digits = 0))
    
  })
  
  output$total_deaths <- renderText({
    total_deaths <- covid_data %>%
      slice(input$integer + 14) %>%
      pull(total_deaths)
    
      return(comma(total_deaths, digits = 0))
  })
  
  output$total_tests<- renderText({
    total_tests <- covid_data %>%
      slice(input$integer + 14) %>%
      pull(total_tests)
    
    return(comma(total_tests, digits = 0))
  })
  
  
  output$dow_close <- renderText({
    dow <- df %>%
      slice(input$integer  + 14) %>%
      pull(dowClose)
    
    return(comma(dow, digits = 2))
  })
  
  output$spy_close <- renderText({
    spy <- df %>%
      slice(input$integer + 14) %>%
      pull(spyClose)
    
    return(comma(spy, digits = 2))
  })

  
  
  
  output$mapDowPlot <- renderPlot({
    dow_data <- df %>%
      slice(1 : input$integer  + 14)
    
    ggplot(dow_data) +
               geom_line(aes(x = Date, y = dowClose), colour = "#ff7900", size = 1.15) +
               xlab("Dow Jones Performance") +
                ylab(NULL)
  }, height = 200)
  
  output$mapSpyPlot <- renderPlot({
    spy_data <- df %>%
      slice(1 : input$integer  + 14)
      
    ggplot(spy_data) +
      geom_line(aes(x = Date, y = spyClose), colour = "#0082e9", size = 1.5) +
      xlab("S&P 500 Performance") +
      ylab(NULL)
  }, height = 200)
  
  
  observe({
    
    names <- timeseries %>% colnames()
    name <- names[[12 + input$integer]]
    
    mapData <- timeseries %>%
      select(Province_State, Lat, Long_, !!as.name(name), Combined_Key) %>%
      filter(is.numeric(timeseries[[name]]) & timeseries[[name]] > 0)
    
    leafletProxy("leafMap") %>%
    clearShapes() %>%
     
      addCircles(
        data = mapData,
        lat = ~Lat,
        lng = ~Long_,
        radius = ~ sqrt(mapData[[name]]) * 200,
        popup = ~ paste(Combined_Key, "<br/>", "Total cases: ", 
                        comma(mapData[[name]], digits = 0)),
        color = "#4527a0", fillOpacity = 0.8,
        group = "cases",
        stroke = FALSE
      )
  })
}