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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$creationTimePlot <- renderPlot({
    
    # Import creation time distribution data contained in the RDS file.
    creation_time_dist <- read_rds("data/creation_time_dist.rds")

    # Draw the plot based on the imported RDS file. 
    # 
    # TODO: Implement sidebar that
    # allows users to adjust the range date displayed.
    ggplot(data = creation_time_dist, aes(x = created_date, y = post_created)) +
      geom_line()
    
  })
  
})
