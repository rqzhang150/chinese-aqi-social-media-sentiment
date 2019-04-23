#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # theme = shinytheme("paper"),
  
  
  # https://live.staticflickr.com/7508/15769708856_3ecc0c9c43_k.jpg
  # https://live.staticflickr.com/733/23424745665_d054b3ca6d_h.jpg
  
  navbarPage(
    title = "Settling The Dust",
    tabPanel(
      title = "Environment and Political Legitimacy",
      includeHTML("www/about_header.html"),
      sidebarLayout(
        sidebarPanel(
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          imageOutput("censorshipTimeDist"),
          plotOutput("creationTimePlot")
        )
      )
    ),
    
    tabPanel(
      title = "Censorship"
    ),
    
    tabPanel(
      
      title = "About",
      fluidRow(
        # includeCSS("www/header.css"),
        # tags$div(class="landing-wrapper",
        #          tags$img(src="https://live.staticflickr.com/7508/15769708856_3ecc0c9c43_k.jpg"),
        #          tags$div(
        #            class="caption",
        #            tags$span(class="border", style="font-size: 45px; font-family: 'Lora', serif;", "SETTLING THE DUST"),
        #            tags$br(),
        #            tags$br(),
        #            tags$span(class="border", "Air Pollution & Public Opinion in China")
        #          ),
                includeMarkdown("about.md")
        )
    ),
    
    tabPanel(
      title = "Acknowledgement"
    )
  )
))
