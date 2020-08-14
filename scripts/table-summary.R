
library("dplyr")
library("tidyr")

get_summary_info_table <- function(covid_df, dow_df, spy_df) {
  df <- covid_data %>%
    inner_join(dow_df, by = "formatDate") %>%
    inner_join(spy_df, by = "formatDate")

  summary_data <- df %>%
    mutate(Year = as.numeric(substr(date, 1, 4))) %>%
    mutate(Month = as.numeric(substr(date, 6, 7))) %>%
    group_by(Year, Month) %>%
    summarize(
      total_cases = sum(new_cases, na.rm = TRUE),
      total_deaths = sum(new_deaths, na.rm = TRUE),
      DOW_average = mean(dowClose),
      SPY_average = mean(spyClose),
      new_tests = sum(new_tests, na.rm = TRUE),
      positive_rate = mean(positive_rate, na.rm = TRUE),
      tests_per_case = mean(tests_per_case, na.rm = TRUE),
      .groups = "keep"
    )

  return(summary_data)
}
