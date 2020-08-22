library("dplyr")
library("scales")
library("kableExtra")

source("scripts/table-summary.R")
source("data.R")

server <- function(input, output) {

  # Renders table on summary page
  output$summaryTable <- function() {
    kable(get_summary_info_table(df), col.names = c(
      "Year",
      "Month",
      "Total Cases",
      "Total Deaths",
      "DOW Average",
      "S&P Average",
      "New Tests",
      "Positive Rate",
      "Tests Per Case"
    )) %>%
      kable_styling("striped", full_width = T)
  }


  # Mask Bar Graph
  output$maskUse <- renderPlotly({

    # Sorts data depending on widget
    if (input$maskRadioInput == "COUNTYFP") {
      mask_data <- mask_data %>% filter(COUNTYFP == mask_bar_graph)
    } else {
      mask_data <-
        group_by(mask_data, ALWAYS)
    }

    # Formats and arranges data for plot

    mask_data <- mask_data %>%
      summarize(count = n()) %>%
      filter(count > 1) %>%
      arrange(desc(count))

    # Names columns

    colnames(mask_data) <- c("COUNTYFP", "ALWAYS", "Sometimes")

    # Sets up plot dimensions

    m <- list(
      l = 100,
      r = 0,
      b = 300,
      t = 50,
      pad = 0
    )

    # Renders plot

    mask_plot <- plot_ly(
      mask_data,
      x = ~ mask_data$COUNTYFP,
      y = ~ mask_data$ALWAYS,
      type = "bar", name = "Country"
    ) %>%
      layout(
        title = "Mask Usage by County",
        yaxis = list(title = "Usage Frequency"),
        barmode = "group",
        xaxis = list(
          categoryarray = count,
          categoryorder = "array",
          title = "US County"
        ),
        autosize = F,
        height = 500,
        margin = m
      )

    return(mask_plot)
  })


  # Function for market UI
  
  # Renders a dow jones line graph
  output$marketPlot <- renderPlotly({
    ggplotly(ggplot(df, ) +
      geom_line(aes(x = Date, y = dowClose, color = "Dow Jones")) +
      xlab("US Market Performance") +
      labs(color = "Legend"))
  })

  # Renders a s&p 500 line graph
  output$spyGraph <- renderPlotly({
    ggplotly(ggplot(df) +
      geom_line(aes(x = Date, y = spyClose, color = "S&P 500")) +
      xlab("S&P 500 Performance") +
      labs(color = "Legend"))
  })

  # Renders a covid plot
  output$covidPlot <- renderPlotly({
    val <- input$marketRadioInput

    if (val == 1) {
      m_name <- "total_cases"
      m_label <- "Total COVID Cases"
    } else if (val == 2) {
      m_name <- "new_cases"
      m_label <- "New Daily COVID-19 Cases"
    } else {
      m_name <- "total_deaths"
      m_label <- "Total COVID-19 Deaths"
    }

    ggplotly(ggplot(df) +
      geom_line(aes(x = Date, y = df[[m_name]], color = m_label)) +
      xlab(m_label) +
      labs(color = "Legend"))
  })

  # Renders a plot combining market & covid data
  output$combinedPlot <- renderPlotly({
    c_plot <- ggplot(df) +
      xlab("U.S COVID-19 and Market Data") +
      labs(color = "Legend") +
      ylab("Number")


    vals <- input$joinedCheckboxInput

    if (1 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = total_cases,
        color = "#f44336"
      ))
    }
    if (2 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = new_cases,
        color = "Daily Cases"
      ))
    }
    if (3 %in% vals) {
      geom_line(aes(
        x = Date,
        y = total_deaths,
        colour = "black"
      ))
    }
    if (4 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = new_deaths,
        color = "Daily Deaths"
      ))
    }
    if (5 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = total_tests,
        color = "Total Tests"
      ))
    }
    if (6 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = new_tests,
        color = "Daily Tests"
      ))
    }
    if (7 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = dowClose,
        color = "Dow Jones"
      ))
    }
    if (8 %in% vals) {
      c_plot <- c_plot + geom_line(aes(
        x = Date,
        y = spyClose,
        color = "S&P 500"
      ))
    }

    c_plot <- c_plot + theme(
      legend.position = c(0.95, 0.95),
      legend.justification = c("right", "top"),
    )

    return(ggplotly(c_plot))
  })

  # Renders a line graph of covid data
  output$combinedCovid <- renderPlotly({
    print(input$checkboxInput)
    vals <- input$checkboxInput

    p <- ggplot(df) +
      xlab("COVID-19 in the U.S") +
      labs(color = "Legend") +
      ylab("Count")

    if (1 %in% vals) {
      p <- p + geom_line(aes(
        x = Date,
        y = total_cases,
        color = "Total Cases"
      ))
    }
    if (2 %in% vals) {
      p <- p + geom_line(aes(
        x = Date,
        y = new_cases,
        color = "Daily Cases"
      ))
    }
    if (3 %in% vals) {
      p <- p + geom_line(aes(
        x = Date,
        y = total_deaths,
        color = "Total Deaths"
      ))
    }
    if (4 %in% vals) {
      p <- p + geom_line(aes(
        x = Date,
        y = new_deaths,
        color = "Daily Deaths"
      ))
    }

    p <- p + theme(
      legend.position = c(0.95, 0.95),
      legend.justification = c("right", "top"),
    )

    return(ggplotly(p))
  })

  # Renders plot of Dow jones and S&P 500
  output$combinedMarket <- renderPlotly({
    val <- input$marketRadioInput

    if (val == 1) {
      m_name <- "total_cases"
      m_label <- "Total COVID Cases"
    } else if (val == 2) {
      m_name <- "new_cases"
      m_label <- "New Daily COVID-19 Cases"
    } else {
      m_name <- "total_deaths"
      m_label <- "Total COVID-19 Deaths"
    }

    ggplotly(ggplot(df) +
      geom_line(aes(x = Date, y = dowClose, color = "Dow Jones")) +
      geom_line(aes(x = Date, y = spyClose, color = "S&P 500")) +
      theme(
        legend.position = c(0.95, 0.95),
        legend.justification = c("right", "top"),
      ) +
      xlab("Dow Jones & S&P 500 in the U.S") +
      labs(color = "Legend") +
      ylab("Stock Price"))
  })


  # Functions for Interactive map

  output$leafMap <- renderLeaflet({
    leaflet(states) %>%
      addProviderTiles("CartoDB.DarkMatter") %>%
      setView(-96, 37.8, 4, zoom = 6)
  })

  # Total cases
  output$total_cases <- renderText({
    total_cases <- covid_data %>%
      slice(input$integer + 22) %>%
      pull(total_cases)

    return(paste0(comma(total_cases, digits = 0)))
  })

  # Total Deaths
  output$total_deaths <- renderText({
    total_deaths <- covid_data %>%
      slice(input$integer + 22) %>%
      pull(total_deaths)

    return(paste0(comma(total_deaths, digits = 0)))
  })

  # Total tests
  output$total_tests <- renderText({
    total_tests <- covid_data %>%
      slice(input$integer + 22) %>%
      pull(total_tests)

    return(paste0(comma(total_tests, digits = 0)))
  })

  # Dow Jones closing number
  output$dow_close <- renderText({
    dow <- df %>%
      slice(input$integer + 22) %>%
      pull(dowClose)
    return(paste0(comma(dow, digits = 2)))
  })

  # S&P 500 closing number
  output$spy_close <- renderText({
    spy <- df %>%
      slice(input$integer + 22) %>%
      pull(spyClose)

    return(paste0(comma(spy, digits = 2)))
  })



  # Renders a small line graph on Dow Jones closing quotes
  output$mapDowPlot <- renderPlot({
      dow_data <- df %>%
        slice(1:input$integer + 22)

      ggplot(dow_data) +
        geom_line(aes(x = Date, y = dowClose),
          colour = "#ff7900", size = 1.15
        ) +
        xlab("Dow Jones Performance") +
        ylab(NULL)
    },
    height = 200
  )

  # Renders a small line graph on S&P 500 closing quotes
  output$mapSpyPlot <- renderPlot({
      spy_data <- df %>%
        slice(1:input$integer + 22)

      ggplot(spy_data) +
        geom_line(aes(x = Date, y = spyClose), colour = "#0082e9", size = 1.5) +
        xlab("S&P 500 Performance") +
        ylab(NULL)
    },
    height = 200
  )


  # Updates coronavirus cases on the map without rerendering entire map
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
        radius = ~ sqrt(mapData[[name]]) * 300,
        popup = ~ paste(
          Combined_Key, "<br/>", "Total cases: ",
          comma(mapData[[name]], digits = 0)
        ),
        color = "#4527a0", fillOpacity = 0.8,
        group = "cases",
        stroke = FALSE
      )
  })
}
