#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(mapview)
library(shiny)
library(markdown)
library(lubridate)
library(shinythemes)
library(markdown)
library(tidyverse)
library(DT)
library(googleLanguageR)
gl_auth("Transcription-675d1c2f9aef.json")


china_gdp <- read_rds("data/china_gdp.rds")
development_indicators <- read_rds("data/development_indicators.rds")
provDist <- read_rds("data/year_total_geo.rds")
keywords_freq_dist <- read_rds("data/keywords_freq_dist.rds")
permission_denied_all <- read_rds("data/permission_denied_all.rds")
guangzhou_plot <- read_rds("data/guangzhou_sentiment_aqi_plot.rds")

shinyServer(function(input, output) {
  
  output$guangzhouAqiSentiment <- renderPlot(
    guangzhou_plot
  )
  
  observe({   
    if(input$shuffle > 0) {
      output$censoredExamples <- renderDT(
        sample_n(permission_denied_all, 1) %>% 
          dplyr::select(text) %>% 
          pull() %>% 
          gl_translate(target = "en") %>% 
          mutate(`Original Text` = text,
                 `Translated Text (Google)` = translatedText) %>% 
          dplyr::select(`Original Text`, `Translated Text (Google)`)
      )
    }
  })

  output$keywordsFreqDist <- renderPlot(
    keywords_freq_dist %>% 
      filter(between(created_date, input$keywordTime[1], input$keywordTime[2]),
             filter_keyword %in% input$keywordSelected) %>% 
      mutate(filter_keyword = factor(filter_keyword,
                                     levels = c("环保", "环境保护", "空气质量", "雾霾", "PM2.5", "霾", "污染", "口罩"),
                                     labels = c("环保 (Environmental Protection)", "环境保护 (Environmental Protection)",
                                                "空气质量 (Air Quality)", "雾霾 (Smog)", "PM2.5", "霾 (Smog)", 
                                                "污染 (Pollution)", "口罩 (Facemask)"))) %>%
      ggplot(aes(x = created_date, y = post_created, color = filter_keyword)) +
        geom_line() +
        theme_minimal() +
        theme(plot.title = element_text(family = "Georgia",
                                        size = 20),
              plot.subtitle = element_text(size = 15),
              legend.text = element_text(family="STKaiti"),
              legend.position = "bottom") +
        labs(x = NULL,
             y = "Number of Posts",
             title = "Number of Weibo Posts That Mention Certain Keywords",
             caption = "Source: WeiboScope Open Data/Hong Kong University",
             color = "Keywords")
  )
  
  output$privincialDistribution <- renderMapview(
    mapview(provDist, zcol = "total_posts",
            layer.name = "Number of Posts")
  )
  
  output$pm25map <- renderImage({
    list(src = paste0("pm25_graphs/pm25_", input$pm25_year, ".png"),
         contentType = "image/png")},
  deleteFile = FALSE)
  
  output$censorshipTimeDist <- renderImage({
    list(src = "www/censorship_dist_plot.gif",
         contentType = "image/gif")},
    deleteFile = FALSE
  )
   
  output$creationTimePlot <- renderPlot({
    
    # Import creation time distribution data contained in the RDS file.
    creation_time_dist <- read_rds("data/creation_time_dist.rds")

    # Draw the plot based on the imported RDS file. 
    creation_time_dist %>% 
      filter(created_date >= input$creationTimeDate[1] &
               created_date <= input$creationTimeDate[2]) %>% 
      ggplot(aes(x = created_date, y = post_created)) +
        geom_line() +
        theme_minimal() +
        theme(plot.title = element_text(family = "Georgia",
                                      size = 20),
              plot.subtitle = element_text(size = 15)) +
        scale_y_continuous() +
        labs(x = NULL,
             y = "Number of Weibo Post Per Day",
             title = paste("Weibo Posts Created by Users with Subscription Base Larger Than 1,000"),
             subtitle = paste("Per day. Available data between", (creation_time_dist %>% arrange(created_date) %>% head(1) %>% dplyr::select(created_date) %>% pull() %>% format(format = "%B %d, %Y")), "and", (creation_time_dist %>% arrange(desc(created_date)) %>% head(1) %>% dplyr::select(created_date) %>% pull() %>% format(format = "%B %d, %Y")),".")
             )
  })
  
  output$gdpPlot <- renderPlot({
    china_gdp %>% 
      filter(between(year, input$gdp_year[1], input$gdp_year[2])) %>% 
      ggplot(aes(x = year, y = gdp)) +
      geom_line() +
      geom_point(size = 0.5) +
      theme_minimal() +
      theme(plot.title = element_text(family = "Georgia",
                                      size = 20),
            plot.subtitle = element_text(size = 15)) +
      labs(title = "China's Post-Reform Economy: Rapid Development",
           subtitle = "China's GDP (in current USD) from 1960 to 2017",
           x = NULL) +
      scale_y_continuous(name = "GDP (in trillion dollar)",
                         breaks = seq(0, 14e12, by = 2e12),
                         labels = paste0("$",seq(0, 14, by = 2),"tn")) +
      scale_x_continuous(breaks = seq(input$gdp_year[1], input$gdp_year[2], by = 5))
  })
  
  output$urbanizationPlot <- renderPlot({
    development_indicators %>% 
      filter(between(year, input$urbanization_year[1], input$urbanization_year[2])) %>% 
      filter(series_name %in% c("Urban population (% of total)") ) %>% 
      mutate(value = as.numeric(value)) %>% 
      ggplot(aes(x = year, y = value, color = series_name)) +
      geom_line() +
      geom_point(size = 0.5) +
      theme_minimal() +
      theme(plot.title = element_text(family = "Georgia",
                                      size = 20),
            plot.subtitle = element_text(size = 15)) +
      labs(title = "Into an Urban Society",
           subtitle = "China became predominantly urban in 2011.",
           x = NULL) +
      geom_hline(yintercept = 50, linetype="dashed", color = "red") +
      scale_y_continuous(name = "% of Total Population",
                         limits = c(0, 100),
                         breaks = seq(0, 100, by = 10),
                         labels = paste0(seq(0, 100, by = 10),"%")) +
      scale_x_continuous(breaks = seq(1960, 2017, by = 5))
  })
  
  
})
