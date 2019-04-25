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
               tags$h2("Pollution: A Legitimacy Issue"),

               tags$p(tags$span("T",class = "firstcharacter"), "hree hundred million. That is the number of Chinese people who had watched ", tags$i("Under the Done"),", a documentary on air pollution produced by a former investigative journalist. Despite the documentary, viewed by more than a quarter of China’s population, had been erased of all its traces on the Internet seven days after its release, it had seared one word into the collective consciousness of the Chinese populace."),
               tags$p(tags$b('"Smog."')),
               tags$p("Comprising industrial emissions and organic compounds, severe smog can dramatically hinder visibility, and the particulate matters (PM2.5) in the highly polluted air can penetrate even into the circulatory system."),
               tags$br()
               ),
        column(width = 3)
      ),
      
      fluidRow(
        column(width = 1),
        sidebarPanel(width = 3,
               tags$h4("A Troubling Trend: Air Pollution in China Across the Years"),
               helpText("Drag to view the air pollution (PM2.5) map in a specific year."),
               sliderInput(
                 inputId = "pm25_year",
                 label = "Year of Map",
                 min = 1998,
                 max = 2016,
                 step = 1,
                 value = 2012,
                 animate = TRUE,
                 ticks = FALSE,
                 sep = ""
               )
               ),
        column(width = 7,
               imageOutput("pm25map"),
               tags$p(class = "source-note", "Pollution Data Source: van Donkelaar, A., R. V. Martin, M. Brauer, N. C. Hsu, R. A. Kahn, R. C. Levy, A. Lyapustin, A. M. Sayer, and D. M. Winker. 2016. Global Estimates of Fine Particulate Matter Using a Combined Geophysical-Statistical Method with Information from Satellites. Environmental Science & Technology 50 (7): 3762-3772. https://doi.org/10.1021/acs.est.5b05833."),
               tags$p(class = "source-note", "Map Data Source: Global Administrative Areas (2018). GADM database of Global Administrative Areas, version 3.6. [online] URL: www.gadm.org. Map represents de facto territory. This map does not reflect this project's view on countries' sovereignty claims or territorial disputes.")
        ),
        
        column(width = 1)
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
      
      
      sidebarLayout(
        position = "right",
        sidebarPanel(
          helpText("Select the range of date in 2012 for displayed Weibo posts statistics."),
          dateRangeInput(inputId = "creationTimeDate",
                         label = "Range of Date",
                         start = "2012-01-01",
                         end = "2012-12-31",
                         min = "2012-01-01",
                         max = "2012-12-31",
                         startview = "year")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("creationTimePlot"),
          tags$p(class = "source-note", "Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28")
        )
      ),
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$br(),
               tags$p(tags$span("I",class = "firstcharacter"), "n this project, we return to 2012, and examine how online discussions in Weibo engages with environmental damages and air pollutions. Through geographical locator associated with Weibo posts and historical air quality data, we delve into how air quality in a city affects the sentiment expressed by its dwellers on social media. We would then cut into the issue of censorship, and examine the practice of cencorship's trend in this period."),
               tags$br()
               ),
        column(width = 3)
      )
    ),
    
    tabPanel(
      title = "Woes of Development",
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2("Woes of Development")
        ),
        column(width = 3)
      )
      
    ),
    
    tabPanel(
      title = "Bad Air, Bad Day?",
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2("Bad Air, Bad Day?")
        ),
        column(width = 3)
      )
      
    ),
    
    
    tabPanel(
      title = '"Permission Denied"',
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2('"Permission Denied"')
        ),
        column(width = 3)
      ),
      
      
      fluidRow(
        column(width = 2),
        column(width = 8,
               imageOutput("censorshipTimeDist"),
               tags$p(class = "source-note", "Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28")
        ),
        column(width = 2)
      )
      
    ),
    
    tabPanel(
      title = "About",
      fluidPage(
        column(width = 3),
        column(width = 6,
               includeMarkdown("acknowledgement.md"),
               includeMarkdown("about.md")
        ),
        column(width = 3)
      )
    )
  )
))
