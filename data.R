library("dplyr")

timeseries <- read.csv("data/time_series_covid19_confirmed_US.csv",
  stringsAsFactors = F
)

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
