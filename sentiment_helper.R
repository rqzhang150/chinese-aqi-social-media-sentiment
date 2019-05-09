library(tidyverse)
library(lubridate)
library(janitor)
library(stringr)
library(googleLanguageR)
gl_auth("weibo_air_quality/Transcription-675d1c2f9aef.json")

select_city_posts_df <- read_rds("sentiment_analysis/select_city_posts_df.rds")

shenzhen <- select_city_posts_df %>% 
  filter(NAME_2 == "Shenzhen")

beijing <- select_city_posts_df %>% 
  filter(NAME_2 == "Beijing")

guangzhou <- select_city_posts_df %>% 
  filter(NAME_2 == "Guangzhou")

shanghai <- select_city_posts_df %>% 
  filter(NAME_2 == "Shanghai")

shenzhen_sentiment <- shenzhen %>% 
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(shenzhen_sentiment, "sentiment_analysis/shenzhen_sentiment.rds")

shanghai_sentiment <- shanghai %>% 
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(shanghai_sentiment, "sentiment_analysis/shanghai_sentiment.rds")

guangzhou_sentiment <- guangzhou %>% 
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(guangzhou_sentiment, "sentiment_analysis/guangzhou_sentiment.rds")

beijing_sentiment <- beijing %>% 
  mutate(sentiment = gl_nlp(text, nlp_type = "analyzeSentiment")$documentSentiment$score)

write_rds(beijing_sentiment, "sentiment_analysis/beijing_sentiment.rds")

# ------

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
  filter(qc_name == "Valid") %>% 
  mutate(date = as_date(date_lst)) %>% 
  group_by(date) %>% 
  summarize(avg_aqi = mean(value))

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
  filter(qc_name == "Valid") %>% 
  mutate(date = as_date(date_lst)) %>% 
  group_by(date) %>% 
  summarize(avg_aqi = mean(value))


beijing_aqi %>% 
  ggplot(aes(x = date, y = avg_aqi)) +
    geom_line()

# ------

shenzhen_sentiment <- read_rds("sentiment_analysis/shenzhen_sentiment.rds")
guangzhou_sentiment <- read_rds("sentiment_analysis/guangzhou_sentiment.rds")


guangzhou_sentiment %>% 
  filter(!is.na(sentiment)) %>% 
  mutate(created_date = as_date(created_at)) %>% 
  group_by(created_date) %>% 
  summarize(avg_sentiment = mean(sentiment)) %>% 
  ggplot(aes(x = created_date, y = avg_sentiment)) +
  geom_line() +
  scale_y_continuous(name = "Sentiment Score",
                     limits = c(-1, 1),
                     breaks = seq(-1, 1, by = 0.5)) +
  theme_minimal()
  

shenzhen_plot <- shenzhen_sentiment %>% 
  filter(!is.na(sentiment)) %>% 
  mutate(created_date = as_date(created_at)) %>% 
  group_by(created_date) %>% 
  summarize(avg_sentiment = mean(sentiment)) %>% 
  ggplot(aes(x = created_date, y = avg_sentiment)) +
  geom_line()
