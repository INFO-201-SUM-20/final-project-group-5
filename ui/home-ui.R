home <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  tags$div(
    class = "container",

    h2("Introduction"),
    img(
      src = "https://meldfinancial.com/wp-content/uploads/covid-update.jpg",
      desc = "Img",
      class = "home__img"
    ),
    p("COVID-19 has altered the world immeasurably. Schools and many workforces 
    have been shift to become digitized and travel has been restricted. Mask use
    has been mandated by the government in many areas in the United States. With 
    no end in sight of coronavirus cases dissipating, our group stems to give a 
    visual presentation of COVID-19 incidence rates, as well as explore the 
    correlation between COVID-19 and population densities, the U.S markets, 
    and the percentage of mask usage by the top counties in the country."),
    p(),



    h2("Our Team"),
    tags$div(
      class = "row",


      tags$div(
        class = "col-xs-4 col-sm-offset-2",

        tags$div(
          class = "home__team-div",
          tags$img(class = "home__team-img", src = "cam2.jpg", desc = "Profile Image"),
          tags$p(class = "home__team-name", "Camden Foucht")
        )
      ),


      tags$div(
        class = "col-xs-4",

        tags$div(
          class = "home__team-div",
          tags$img(class = "home__team-img", src = "Judy.jpg", desc = "Profile Image"),

          tags$p(class = "home__team-name", "Judy Nguyen")
        )
      )
    ),






    h2("Summary"),
    p("The datasets we analyzed were taken from John Hopkins and Yahoo Finance. 
  After combining these datasets, our data had 154 observations
and 40 columns. The coronavirus has reached 5,044,864 cases and 162,938 deaths 
since it's inception in the United States. The worst day of COVID-19 had 4928 
deaths 
    in a single day. The most cases in a single day was 76,930 cases. Since the 
    first COVID-19 case in the U.S, the DOW JONES index has reached a low of 18,591.93 
    and a high of 29,551.42. The S&P 500 has 
    reached a high of 3,386.15 and a low of 2,237.40. The highest positive rate 
    in a single day was 0.211 and the lowest tests per cases in a single day 
    had reached 4.734."),
    p(),
    h2("Questions"),
    tags$ul(
      tags$li(class = "home__li", "Where is coronavirus most prominent in the United States"),
      tags$li(class = "home__li", "Has coronavirus cases had an impact on the U.S stock market?"),
      tags$li(class = "home__li", "Has coronavirus deaths had an impact on the U.S stock market?"),
      tags$li(class = "home__li", "What was the worst day of COVID-19?"),
      tags$li(class = "home__li", "How often are top U.S counties using masks?"),
    )
  )
)
