library(plotly)
library(dplyr)

render_chart3 <- function(mask_data) {
  codes <- c(
    34017,
    48201,
    04013,
    06065,
    06059
  )

  counties <- c(
    "Hudson",
    "Harris",
    "Maricopa",
    "Riverside",
    "Orange"
  )

  top <- data.frame(codes, counties)

  mask_data <- mask_data %>%
    filter(COUNTYFP %in% codes) %>%
    left_join(top, by = c("COUNTYFP" = "codes"))

  mask_chart <- plot_ly(mask_data,
    x = ~counties, y = ~ALWAYS, type = "bar",
    orientation = "v",
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
