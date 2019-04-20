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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$creationTimePlot <- renderPlot({
    
    # Import creation time distribution data contained in the RDS file.
    creation_time_dist <- read_rds("data/creation_time_dist.rds")

    # Draw the plot based on the imported RDS file. 
    # 
    # TODO: 
    # (1) Implement sidebar that allows users to adjust the range date displayed.
    # (2) Change y scale break formatting
    
    ggplot(data = creation_time_dist, aes(x = created_date, y = post_created)) +
      geom_line() +
      theme_minimal() +
      scale_y_continuous() +
      labs(x = NULL,
           y = "Number of Weibo Post Per Day",
           title = paste("Variations In Number of Weibo Posts"),
           subtitle = paste("Number of Weibo posts between", (creation_time_dist %>% arrange(created_date) %>% head(1) %>% select(created_date) %>% pull() %>% format(format = "%B %d, %Y")), "and", (creation_time_dist %>% arrange(desc(created_date)) %>% head(1) %>% select(created_date) %>% pull() %>% format(format = "%B %d, %Y")),"."),
           caption = "HKU WeiboScope Data: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship \non Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy.\nIEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28")
  })
  
})
