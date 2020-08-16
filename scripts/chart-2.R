library("dplyr")
library("ggplot2")
library("tidyr")
library("plotly")
library("gridExtra")

render_chart2 <- function(df) {
  plot1 <- ggplotly(ggplot(df) +
    geom_line(aes(x = Date, y = new_cases), colour = "#f44336") +
    xlab("New Daily COVID-19 Cases"))

  plot2 <- ggplotly(ggplot(df, ) +
    geom_line(aes(x = Date, y = dowClose), colour = "#ff7900") +
    xlab("US DOW JONES Performance"))


  plot3 <- ggplotly(ggplot(df, ) +
    geom_line(aes(x = Date, y = spyClose), colour = "#0082e9") +
    xlab("US S&P 500 Performance"))

  subplot(plot1, plot2, plot3, margin = 0.05, titleX = TRUE, nrows = 3)
}
