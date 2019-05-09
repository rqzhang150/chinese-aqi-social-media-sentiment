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

shenzhen_sentiment <- read_rds("sentiment_analysis/shenzhen_sentiment.rds")

guangzhou_sentiment %>% 
  filter(!is.na(sentiment)) %>% 
  mutate(created_date = as_date(created_at)) %>% 
  group_by(created_date) %>% 
  summarize(avg_sentiment = mean(sentiment)) %>% 
  ggplot(aes(x = created_date, y = avg_sentiment)) +
  geom_line() 

shenzhen_plot <- shenzhen_sentiment %>% 
  filter(!is.na(sentiment)) %>% 
  mutate(created_date = as_date(created_at)) %>% 
  group_by(created_date) %>% 
  summarize(avg_sentiment = mean(sentiment)) %>% 
  ggplot(aes(x = created_date, y = avg_sentiment)) +
  geom_line()
