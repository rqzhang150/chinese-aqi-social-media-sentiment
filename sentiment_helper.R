# The sentiment helper takes on the posts in selected city exported from Spark,
# and analyzes their sentiment through Google API. It then plots simultaneously
# the air quality index as well as the average sentiment for these cities across
# 2012.


# Loading Library --------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(janitor)
library(stringr)
library(googleLanguageR)
library(gridExtra)
gl_auth("weibo_air_quality/Transcription-675d1c2f9aef.json")



# Sentiment Analysis ------------------------------------------------------------

# Import the RDS dataframe produced by Spark in the pipeline helper that
# contains Weibo posts for the selected cities.
select_city_posts_df <- read_rds("sentiment_analysis/select_city_posts_df.rds")

# Google Natural Language API has a quota for the amount of strings to be
# processed each minute. There are over 400 thousand Weibo posts that we are
# hoping to analyze. Therefore, we split them into small dataframes to make
# running the sentiment analysis function more managable.

shenzhen <- select_city_posts_df %>%
  filter(NAME_2 == "Shenzhen")

beijing <- select_city_posts_df %>%
  filter(NAME_2 == "Beijing")

guangzhou <- select_city_posts_df %>%
  filter(NAME_2 == "Guangzhou")

shanghai <- select_city_posts_df %>%
  filter(NAME_2 == "Shanghai")

# Using Google Natural Language API, we evaluate the sentiment for the Weibo
# posts for each city, and store them into RDS files.

shenzhen_sentiment <- shenzhen %>%
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(shenzhen_sentiment, "sentiment_analysis/shenzhen_sentiment.rds")

shanghai_sentiment <- shanghai_partition_1 %>%
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(shanghai_sentiment, "sentiment_analysis/shanghai_sentiment.rds")

guangzhou_sentiment <- guangzhou %>%
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(guangzhou_sentiment, "sentiment_analysis/guangzhou_sentiment.rds")

beijing_sentiment <- beijing %>%
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(beijing_sentiment, "sentiment_analysis/beijing_sentiment.rds")

# Load intermediate results.

shenzhen_sentiment <- read_rds("sentiment_analysis/shenzhen_sentiment.rds")
guangzhou_sentiment <- read_rds("sentiment_analysis/guangzhou_sentiment.rds")
shanghai_sentiment <- read_rds("sentiment_analysis/shanghai_sentiment.rds")
beijing_sentiment <- read_rds("sentiment_analysis/beijing_sentiment.rds")

#' Takes Weibo sentiment data, calculate daily average sentiment for each city,
#' and generate ggplot with best fitting line of the sentiment
#'
#' @param df Dataframe with annotated sentiment score for each row
#' @return A ggplot object.

generate_sentiment_plot <- function(df) {
  df %>%
    filter(!is.na(sentiment)) %>%
    mutate(created_date = as_date(created_at)) %>%
    group_by(created_date) %>%
    summarize(avg_sentiment = mean(sentiment)) %>%
    ggplot(aes(x = created_date, y = avg_sentiment)) +
    geom_jitter(alpha = 0.1) +
    geom_smooth(size = 0.5, se = TRUE) +

    # Neutral sentiment is represented by the score 0, we would like to
    # emphasize this divide as a reference line.

    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +

    # We are not including a title and subtitle as we are combining this plot
    # with the air quality plot later.

    labs(
      x = NULL,
      caption = "Sentiment evaluated through Google Natural Language API.\nPositive/Negative values represent strength of positive/negative sentiment."
    ) +
    scale_y_continuous(
      name = "Sentiment Score",
      limits = c(-1, 1),
      breaks = seq(-1, 1, by = 1)
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(
        family = "Georgia",
        size = 20
      ),
      plot.subtitle = element_text(size = 12)
    )
}

# Data Import: Air Quality Index ---------------------------------------------

# Read in Air Quality Index data for each selected city using US Mission to
# China's hourly air quality data, and calculate the daily average air quality.

guangzhou_aqi <- read_csv("datasets/us_mission_air_quality/Guangzhou_2012_HourlyPM25_created20140423.csv",
  skip = 2,
  col_types = cols(
    Site = col_character(),
    Parameter = col_character(),
    `Date (LST)` = col_datetime(format = ""),
    Year = col_double(),
    Month = col_double(),
    Day = col_double(),
    Hour = col_double(),
    Value = col_double(),
    Unit = col_character(),
    Duration = col_character(),
    `QC Name` = col_character()
  )
) %>%
  clean_names() %>%

  # Quality Assurance column: We are only taking the values that are deemed
  # valid. Also, there theoretically cannot be density that is lower than 0.

  filter(
    qc_name == "Valid",
    value > 0
  ) %>%
  mutate(date = as_date(date_lst))

beijing_aqi <- read_csv("datasets/us_mission_air_quality/Beijing_2012_HourlyPM2.5_created20140325.csv",
  skip = 2,
  col_types = cols(
    Site = col_character(),
    Parameter = col_character(),
    `Date (LST)` = col_datetime(format = ""),
    Year = col_double(),
    Month = col_double(),
    Day = col_double(),
    Hour = col_double(),
    Value = col_double(),
    Unit = col_character(),
    Duration = col_character(),
    `QC Name` = col_character()
  )
) %>%
  clean_names() %>%

  # Quality Assurance column: We are only taking the values that are deemed
  # valid. Also, there theoretically cannot be density that is lower than 0.

  filter(
    qc_name == "Valid",
    value > 0
  ) %>%
  mutate(date = as_date(date_lst))

shanghai_aqi <- read_csv("datasets/us_mission_air_quality/Shanghai_2012_HourlyPM25_created20140423.csv",
  skip = 2,
  col_types = cols(
    Site = col_character(),
    Parameter = col_character(),
    `Date (LST)` = col_datetime(format = ""),
    Year = col_double(),
    Month = col_double(),
    Day = col_double(),
    Hour = col_double(),
    Value = col_double(),
    Unit = col_character(),
    Duration = col_character(),
    `QC Name` = col_character()
  )
) %>%
  clean_names() %>%

  # Quality Assurance column: We are only taking the values that are deemed
  # valid. Also, there theoretically cannot be density that is lower than 0.

  filter(
    qc_name == "Valid",
    value > 0
  ) %>%
  mutate(date = as_date(date_lst))

#' Generate ggplot with the best fitting line of AQI data in specific city.
#'
#' @param df A U.S. Mission to China formatted dataframe containing PM2.5
#'   concentration data
#' @param city_name Name of the city, used to generate title for the plot.
#' @return A ggplot object.

generate_aqi_plot <- function(df, city_name) {
  df %>%
    ggplot(aes(x = date, y = value)) +

    # Because the AQI dataset is calculated hourly, there is going to be a lot
    # of points. Thus, we set the alpha value for each point to a low value to
    # ensure legibility.

    geom_jitter(alpha = 0.05) +

    # Allows the function to choose the most appropriate method of regression.

    geom_smooth() +
    theme_minimal() +
    labs(
      title = paste0("Density of PM2.5 and Average Weibo Sentiment in ", city_name, ", 2012"),
      x = NULL,
      y = "Density (µg/m³)"
    ) +
    theme(
      plot.title = element_text(
        family = "Georgia",
        size = 15
      ),
      plot.subtitle = element_text(size = 12)
    )
}

# Plot Combination -----------------------------------------------------------
# In this section, we combine the Air Quality and the Sentiment plots in one
# single plot, and then stores them into an RDS file for display in the Shiny
# application.

guangzhou_plot <- cowplot::plot_grid(
  generate_aqi_plot(guangzhou_aqi, city_name = "Guangzhou"),
  generate_sentiment_plot(guangzhou_sentiment, city_name = "Guangzhou"),
  nrow = 2,
  rel_heights = c(0.6, 0.4),
  align = "v"
)

write_rds(guangzhou_plot, "weibo_air_quality/data/guangzhou_sentiment_aqi_plot.rds")

shanghai_plot <- cowplot::plot_grid(
  generate_aqi_plot(shanghai_aqi, city_name = "Shanghai"),
  generate_sentiment_plot(shanghai_sentiment, city_name = "Shanghai"),
  nrow = 2,
  rel_heights = c(0.6, 0.4),
  align = "v"
)

write_rds(shanghai_plot, "weibo_air_quality/data/shanghai_sentiment_aqi_plot.rds")

beijing_plot <- cowplot::plot_grid(
  generate_aqi_plot(beijing_aqi, city_name = "Beijing"),
  generate_sentiment_plot(beijing_sentiment, city_name = "Shanghai"),
  nrow = 2,
  rel_heights = c(0.6, 0.4),
  align = "v"
)

write_rds(beijing_plot, "weibo_air_quality/data/beijing_sentiment_aqi_plot.rds")
