summary_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  tags$div(
    class = 'container',

    h2('Summary'),
    
    p('The datasets we analyzed were taken from John Hopkins and Yahoo Finance. 
        After combining these datasets, our data had 154 observations
      and 40 columns. The coronavirus has reached 5,044,864 cases and 162,938 deaths 
      since it\'s inception in the United States. The worst day of COVID-19 had 4928 
      deaths  in a single day. The most cases in a single day was 76,930 cases. Since the 
        first COVID-19 case in the U.S, the DOW JONES index has reached a low of 18,591.93 
        and a high of 29,551.42. The S&P 500 has 
        reached a high of 3,386.15 and a low of 2,237.40. The highest positive rate 
        in a single day was 0.211 and the lowest tests per cases in a single day 
        had reached 4.734.')

    )
  )
