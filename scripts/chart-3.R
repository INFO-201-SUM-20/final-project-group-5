library(plotly)
library(dplyr)

mask_data <- read.csv('data/mask-use-by-county.csv')

#Create a new Dataset that contains top 10 counties
render_chart3 <- function(mask_by_countries) {
  mask_by_countries <- filter(mask_data,
                              %in% c('Los Angeles',
                                     'Cook',
                                     'Harris',
                                     'Maricopa',
                                     'San Diego',
                                     'Orange',
                                     'Miami-Dade',
                                     'Dallas',
                                     'King',
                                     'Queens'))
  
  
  
  BuildChart <- function(mask_by_countries, county){
    
    #y, x, and x1 values
    x.counties <- c ('Los Angeles',
                     'Cook',
                     'Harris',
                     'Maricopa',
                     'Riverside',
                     'Orange',
                     'Miami-Dade',
                     'Dallas',
                     'Kings',
                     'Queens'))

x1.codes <- c(06037, 
              17031, 
              48201, 
              04013, 
              06065, 
              06059, 
              12086, 
              48113, 
              36047, 
              36081)

y.freq <- c(0.786, 
            0.722, 
            0.736, 
            0.734, 
            0.803, 
            0.754, 
            0.756, 
            0.757, 
            0.732,
            0.751)


#make chart using plotly
mask_chart <- plot_ly(mask_data, x = ~county, y = ~percentage(), type = 'bar', 
                      orientation = 'h',
                      marker = list(color = 'rgba(17, 132, 255, 0.6)',
                                    line = list(color = 'rgba(255, 180, 17, 1.0',
                                                width = 1))) %>%
  
  layout(barmode = 'stack',
         title = "Mask Usages in Top 10 U.S Counties",
         xaxis = list(title = ""),
         yaxis = list(title = ""))
return(mask_chart)
  }
}
