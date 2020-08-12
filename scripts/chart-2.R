library('dplyr')
library('ggplot2')
library('tidyr')
library('plotly')
library('gridExtra')

render_chart2 <- function(df){
  plot1 <- ggplotly(ggplot(df, ) +
    geom_line(aes(x = formatDate, y = new_cases), colour = '#f44336') +
    xlab('New Daily COVID-19 Cases'))
  

  plot2 <- ggplotly(ggplot(df, ) +
    geom_line(aes(x = formatDate, y = Close), colour="#f44336") + 
    xlab('US DOW JONES Performance'))

  
  plot3 <- ggplotly(ggplot(df, ) +
    geom_line(aes(x = formatDate, y = spyClose), colour="#f44336") +
    xlab('US S&P 500 Performance'))
  
  subplot(plot1, plot2, plot3, margin = 0.03, titleX = TRUE)
  
}
