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
               tags$br(),

               tags$p(tags$span("T",class = "firstcharacter"), "hree hundred million. That is the number of Chinese people who had watched ", tags$i("Under the Done"),", a documentary on air pollution produced by a former investigative journalist. Despite the documentary, viewed by more than a quarter of China’s population, had been erased of all its traces on the Internet seven days after its release, it had seared one word into the collective consciousness of the Chinese populace."),
               tags$p(tags$b('"Smog."')),
               tags$p("Comprising industrial emissions and organic compounds, severe smog can dramatically hinder visibility, and the particulate matters (PM2.5) in the highly polluted air can penetrate even into the circulatory system."),
               tags$br()
               ),
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
               tags$br(),
               tags$p("This seemingly innocuous, mist-like weather phenomenon had since then become a visceral indicator of government’s failure to protect the environment. Fierce criticisms were hurled against the central government due to its weak measures in protecting the environment, and when air filtration devices were found in a photograph on a central government meeting, the anger turned to the political system itself."),
               tags$p("Smog is no strange face in this region. While the documentary sparked a national outcry on air pollution and governmental inaction, the lengthy processes of awareness-building and consensus-reaching, which extend back to 2012, serve as essential foundations for those actions."),
               tags$p("Weibo, a social media service resembling Twitter, had played an indispensable role in those processes. Effective censorship on social media sites like Weibo, back in 2012, was not in the realm of possibility due to technological limits. As a result, an active sphere of discussion emerged on the platform."),
               tags$br()),
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
