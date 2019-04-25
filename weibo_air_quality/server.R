#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(markdown)
library(lubridate)
library(shinythemes)
library(markdown)

china_gdp <- read_rds("data/china_gdp.rds")
development_indicators <- read_rds("data/development_indicators.rds")

shinyServer(function(input, output) {
  
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
    # 
    # TODO: 
    # (1) Implement sidebar that allows users to adjust the range date displayed.
    # (2) Change y scale break formatting
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
             subtitle = paste("Per day. Available data between", (creation_time_dist %>% arrange(created_date) %>% head(1) %>% select(created_date) %>% pull() %>% format(format = "%B %d, %Y")), "and", (creation_time_dist %>% arrange(desc(created_date)) %>% head(1) %>% select(created_date) %>% pull() %>% format(format = "%B %d, %Y")),".")
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
      filter(series_name == "Urban population (% of total)") %>% 
      mutate(value = as.numeric(value)) %>% 
      ggplot(aes(x = year, y = value)) +
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
      scale_y_continuous(name = "Urban population (% of total)",
                         limits = c(0, 100),
                         breaks = seq(0, 100, by = 10),
                         labels = paste0(seq(0, 100, by = 10),"%")) +
      scale_x_continuous(breaks = seq(1960, 2017, by = 5))
  })
  
  
})
