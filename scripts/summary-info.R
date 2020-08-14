library("dplyr")


get_summary_info <- function(covid_df, dow_df, spy_df) {
  df <- covid_df %>%
    inner_join(dow_df, by = "formatDate") %>%
    inner_join(spy_df, by = "formatDate")

  res <- list()

  res$numColumns <- ncol(df)

  res$numRows <- nrow(df)

  res$most_deaths_in_a_day <- df %>%
    filter(new_deaths == max(new_deaths, na.rm = TRUE)) %>%
    pull(new_deaths)


  res$most_cases_in_a_day <- df %>%
    filter(new_cases == max(new_cases, na.rm = TRUE)) %>%
    pull(new_cases)

  res$most_tests_in_a_day <- df %>%
    filter(new_tests == max(new_tests, na.rm = TRUE)) %>%
    pull(new_tests)

  res$highest_positive_rate <- df %>%
    filter(positive_rate == max(positive_rate, na.rm = TRUE)) %>%
    pull(positive_rate)

  res$lowest_tests_per_case <- df %>%
    filter(tests_per_case == min(tests_per_case, na.rm = TRUE)) %>%
    pull(tests_per_case)

  res$highest_dow_jones <- df %>%
    filter(dowClose == max(dowClose)) %>%
    pull(dowClose)

  res$highest_spy <- df %>%
    filter(spyClose == max(spyClose)) %>%
    pull(spyClose)

  res$lowest_dow_jones <- df %>%
    filter(dowClose == min(dowClose)) %>%
    pull(dowClose)

  res$lowest_spy <- df %>%
    filter(spyClose == min(spyClose)) %>%
    pull(spyClose)

  res$total_cases <- df %>%
    slice_tail() %>%
    pull(total_cases)

  res$total_deaths <- df %>%
    slice_tail() %>%
    pull(total_deaths)

  return(res)
}
