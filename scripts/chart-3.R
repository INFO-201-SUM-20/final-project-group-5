library(plotly)
library(dplyr)

render_chart3 <- function() {
  mask_data <- read.csv("data/mask-use-by-county.csv", stringsAsFactors = FALSE)
  codes <- c(06037, 
             17031, 
             48201, 
             04013, 
             06065, 
             06059, 
             48113, 
             36047)
  
  counties <- c('Los Angeles',
                'Cook',
                'Harris',
                'Maricopa',
                'Riverside',
                'Orange',
                'Dallas',
                'Kings')
  )

  top_5 <- data.frame(codes, counties)

  mask_data <- mask_data %>%
    filter(COUNTYFP %in% codes) %>%
    left_join(temp, by = c("COUNTYFP" = "codes"))

  mask_chart <- plot_ly(mask_data,
    x = ~counties, y = ~ALWAYS, type = "bar",
    marker = list(
      color = "rgba(17, 132, 255, 0.6)",
      line = list(
        color = "rgba(255, 180, 17, 1.0",
        width = 1
      )
    )
  ) %>%
    layout(
      barmode = "stack",
      title = "Mask Usages in Top 5 U.S Counties",
      xaxis = list(title = ""),
      yaxis = list(title = "")
    )

  return(mask_chart)
}
