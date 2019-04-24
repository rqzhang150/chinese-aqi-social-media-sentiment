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
      title = "Pollution: A Legitimacy Issue",
      includeHTML("www/about_header.html"),
      includeCSS("www/style.css"),
      
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$p(tags$span("S",class = "firstcharacter"), "ome random text.")),
        column(width = 3)
      ),
      
      fluidRow(
        column(width = 3,
               sliderInput(
                 inputId = "pm25_year",
                 label = "year",
                 min = 1998,
                 max = 2016,
                 step = 1,
                 value = 2012,
                 animate = TRUE,
                 ticks = FALSE,
                 sep = ""
               )),
        column(width = 9,
               imageOutput("pm25map"))
      ),
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut maximus sem eget quam porttitor lacinia. Phasellus libero nulla, egestas id ullamcorper elementum, rhoncus ut nibh. Phasellus fermentum sollicitudin finibus. Pellentesque quis hendrerit dui, a congue nisl. Integer sodales eget massa at eleifend. Morbi posuere arcu libero, sit amet molestie ipsum pellentesque vitae. Etiam blandit lacus vitae leo ultricies, eget efficitur odio vehicula. Quisque ullamcorper urna et imperdiet convallis. Nulla a lorem iaculis, blandit magna a, cursus ante. Duis fringilla justo at bibendum porta.")),
        column(width = 3)
      ),
      
      # fluidRow(
      #   column(width = 2),
      #   column(width = 8,
      #          imageOutput("censorshipTimeDist")),
      #   column(width = 2)
      # ),
      
      
      sidebarLayout(
        sidebarPanel(
          dateRangeInput(inputId = "creationTimeDate",
                         label = "Date",
                         start = "2012-01-01",
                         end = "2012-12-31",
                         min = "2012-01-01",
                         max = "2012-12-31",
                         startview = "year")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
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
