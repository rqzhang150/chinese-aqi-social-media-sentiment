#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(mapview)
library(shiny)
library(tidyverse)
library(lubridate)
library(shinythemes)
library(markdown)
library(DT)
library(gridExtra)
library(googleLanguageR)
gl_auth("Transcription-675d1c2f9aef.json")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # theme = shinytheme("paper"),
  
  
  # https://live.staticflickr.com/7508/15769708856_3ecc0c9c43_k.jpg
  # https://live.staticflickr.com/733/23424745665_d054b3ca6d_h.jpg
  
  navbarPage(
    title = "Settling The Dust",
    tabPanel(
      title = "Pollution: A Legitimacy Issue",
      
      # Include the global CSS file for the formatting of the entire Shiny
      # application.
      
      includeCSS("www/style.css"),
      
      # Import the graphic title header for the first page.
      
      includeHTML("www/about_header.html"),
      
      # Source note for the picture used in the HTML file.
      
      tags$p(class = "source-note", style = "text-align: right;", "Tiananmen Square under Smog. By Lei Han on Flickr. Image licensed under CC BY-NC-ND 2.0."),
      
# SECTION 1: POLLUTION: A LEGITIMACY ISSUE ------------------------------
      
      # Write-up for the first section. Uses CSS class firstcharacter to drop
      # the first character and create better visual effects. Uses fluidRow, and
      # configure column so that the text area does not occupy the entire
      # screen, creating a visual effect closer to a newspaper website.

      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2("Pollution: A Legitimacy Issue"),
               tags$p(tags$span("T",class = "firstcharacter"), "hree hundred million. That is the number of Chinese people who had watched ", tags$i("Under the Done"),", a documentary on air pollution produced by a former investigative journalist. Despite the documentary, viewed by more than a quarter of China’s population, had been erased of all its traces on the Internet seven days after its release, it had seared one word into the collective consciousness of the Chinese populace."),
               tags$p(tags$b('"Smog."')),
               tags$p("Comprising industrial emissions and organic compounds, severe smog can dramatically hinder visibility, and the particulate matters (PM2.5) in the highly polluted air can penetrate even into the circulatory system."),
               tags$br()
               ),
        column(width = 3)
      ),

      # PM2.5 Over Time Graph
      
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
               tags$p(class = "source-note", "Map Data Source: Global Administrative Areas (2018). GADM database of Global Administrative Areas, version 3.6. [online] URL: www.gadm.org. Map represents de facto territory. This map does not reflect author's view on countries' sovereignty claims or territorial disputes.")
        ),
        
        column(width = 1)
      ),
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$br(),
               tags$p("This seemingly innocuous, mist-like weather phenomenon had since then become a visceral indicator of government’s failure to protect the environment. Fierce criticisms were hurled against the central government due to its weak measures in protecting the environment, and when air filtration devices were found in a photograph depicting a central government meeting, the anger turned to the political system - and the privilege that some enjoy - itself."),
               tags$p("Smog is no strange face in this region. While the documentary sparked a national outcry on air pollution and governmental inaction, the lengthy processes of awareness-building and consensus-reaching, which extend back to 2012, serve as essential foundations for those actions."),
               tags$p("Weibo (微博), a social media service resembling Twitter, had played an indispensable role in those processes. Effective censorship on social media sites like Weibo, back in 2012, was not in the realm of possibility due to technological limits. As a result, an active sphere of discussion emerged on the platform."),
               tags$br()),
        column(width = 3)
      ),
      
      
      sidebarLayout(
        position = "right",
        sidebarPanel(
          tags$h4("WeiboScope Open: An Overview"),
          helpText("Select the range of date in 2012 for displayed Weibo posts statistics."),
          dateRangeInput(inputId = "creationTimeDate",
                         label = "Range of Date",
                         start = "2012-01-01",
                         end = "2012-12-31",
                         min = "2012-01-01",
                         max = "2012-12-31",
                         startview = "year"),
          tags$p(tags$b("Number of Posts in the Dataset:")),
          
          # Hardcoded because it would be extremely computationally expensive to calculate on the fly.
          
          tags$p("226,841,122"),
          tags$p(tags$b("Dataset Size:")),
          tags$p("~45GB")
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
               tags$p("On Weibo, while the issue of air quality has not gained traction as it had in 2015, environmental protection and related topics have gained momentum. The following graph plots the frequency of keywords appearing in Weibo users with more than 1,000 subscribers. While the total number of posts are relatively small compared with the total number of posts, these users are generally more influential and would have larger impact on the public discourse."),
               tags$br()
        ),
        column(width = 3)
      ),
      
      
      sidebarLayout(
        position = "right",
        sidebarPanel(
          tags$h4("Environmental Issues Gaining Traction"),
          helpText("Select the range of date in 2012 for displayed statistics."),
          dateRangeInput(inputId = "keywordTime",
                         label = "Range of Date",
                         start = "2012-01-01",
                         end = "2012-12-31",
                         min = "2012-01-01",
                         max = "2012-12-31",
                         startview = "year"),
          helpText("Select the keyword you would like to see on the graph."),
          selectInput(inputId = "keywordSelected",
                      label = "Keywords:",
                      multiple = TRUE,
                      choices = c("环保 (Environmental Protection)" = "环保", 
                                  "环境保护 (Environmental Protection)" = "环境保护",
                                  "空气质量 (Air Quality)" = "空气质量", 
                                  "雾霾 (Smog)" = "雾霾", 
                                  "PM2.5" = "PM2.5", 
                                  "霾 (Smog)" = "霾", 
                                  "污染 (Pollution)" = "污染", 
                                  "口罩 (Facemask)" = "口罩"),
                      selected = "环保")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("keywordsFreqDist"),
          tags$p(class = "source-note", "Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28")
        )
      ),
      
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$br(),
               tags$p(tags$span("I",class = "firstcharacter"), "n this project, we return to 2012, and examine the general engagement with environmental issues, and whether the issue of air quality has gained salience in the national discourse in 2012, or was it an issue still unnoticed by the general population. Through geographical locator associated with Weibo posts and historical air quality data, we delve into how air quality in a city affects the sentiment expressed by its dwellers on social media. We would then cut into the issue of censorship, and examine the practice of cencorship's trend in this period."),
               tags$br()
               ),
        column(width = 3)
      )
    ),

# SECTION 2: WOES OF DEVELOPMENT ------------------------------------
    
    tabPanel(
      title = "Woes of Development",
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2("Woes of Development"),
               tags$p(tags$span("R",class = "firstcharacter"), "eform efforts across 1980s and 90s were of significant importance to the economic development of Chinese economy. While the transformation to a market economy was not without painful episodes and is still ongoing until today, China has gone through a period of rapid development since then, accompanied by a series of social and cultural transformations."),
               tags$p("The following plot demonstrate China's Gross Domestic Product since 1960 to 2017. Since 1960, China's GDP has grew by two degrees of magnitude and become the second largest economic entity in the world. After a series of structural economic reforms undertaken by the country's leadership in 1990s, Chinese economy had took off, and thus dramatically raised the standard of living for average Chinese people.")
        ),
        column(width = 3)
      ),
    
      fluidRow(
        column(width = 1),
        column(width = 10,
               sidebarLayout(
                 position = "left",
                 sidebarPanel(
                   tags$h4("Growing the Economy"),
                   helpText("Select timespan to view annual GDP data in that period."),
                   sliderInput(
                     inputId = "gdp_year",
                     label = "Year",
                     value = c(1960, 2017),
                     min = 1960,
                     max = 2017,
                     step = 1,
                     sep = ""
                   )
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                   plotOutput("gdpPlot"),
                   tags$p(class = "source-note", "Data Source: World Bank Development Indicators: GDP (current US$) by the World Bank Group. Data licensed under CC BY 4.0.")
                 )
               )
        ),
        column(width = 1)
      ),
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$p(tags$span("I",class = "firstcharacter"), 'n spite of economic growth dubbed by some as "miracle", China has only recently become a country with more than half of its population residing in urban areas. Such transformation also dramatically altered China\'s social dynamic, ushering in a increasingly large group of urban middle class, and also led to a variety of social problems. Coupled with the spread of mobile devices and the increasing use of Internet among Chinese citizens, a new sphere for civil society and dissents have arisen out of the social media that have since become the new ground for people to voice their grievances and opinions.')
        ),
        column(width = 3)
      ),
      
      fluidRow(
        column(width = 1),
        column(width = 10,
               tags$br(),
               sidebarLayout(
                 position = "right",
                 sidebarPanel(
                   tags$h4("Urbanizing China"),
                   helpText("Select timespan to view urbanization data in that period."),
                   sliderInput(
                     inputId = "urbanization_year",
                     label = "Year",
                     value = c(1960, 2017),
                     min = 1960,
                     max = 2017,
                     step = 1,
                     sep = ""
                   )
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                   plotOutput("urbanizationPlot"),
                   tags$p(class = "source-note", "Data Source: World Bank Development Indicators: Urban population (% of total) by the World Bank Group. Data licensed under CC BY 4.0.")
                 )
               ),
        column(width = 1)
      )
    ),
    
    fluidRow(
      column(width = 3),
      column(width = 6,
             tags$p('Weibo was one of such example. In spite of government\'s demand for censorship, the technological capabilities were unable to satisfactorily fulfill such requirement, thus leaving precious room for the development of civil society organizations and coalitions. Internet and social media has become a form through which citizens access informed opinions by public intellectuals, who are often more sympathetic towards liberal causes. '),
             tags$p("In this repressed but vibrant sphere of public discussion, air pollution and environmental protection grew as increasingly saliant topics, culminating ultimately in public controversies that would threaten the central government's legitimacy.")
      ),
      column(width = 3)
    )
    ),

# SECTION 3: BAD AIR, BAD DAY? -----------------------------------------

    tabPanel(
      title = "Bad Air, Bad Day?",
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2("Bad Air, Bad Day?"),
               tags$p(tags$span("T",class = "firstcharacter"), "his is a map of the number of Weibo posts in different provinces through 2012. In this page, we will zoom into 4 cities - Beijing (北京), Shanghai (上海), Guangzhou (广州), and Shenzhen (深圳) - putting their reaction to air pollution, or smog, under scrutiny. In four cities with the largest amount of geotagged Weibo posts, do people mention air pollution more explicitly? Do the average sentiment score of their Weibo posts decrease in days of heavy smog?")
        ),
        column(width = 3)
      ),
      
      fluidRow(
        column(width = 2),
        column(width = 8,
               tags$h3("Geotagged Weibo Posts Mostly in Coastal Areas"),
               mapviewOutput("privincialDistribution"),
               tags$p(class = "source-note", "Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28"),
               tags$br()
        ),
        column(width = 2)
      ),
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$p("In the next section, we would zoom into Beijing, Shanghai, and Guangzhou. Using the air quality data from U.S. Mission to China in 2012, we plot out the fluctuation of Weibo sentiment through 2012, and the fluctuation of the density of PM2.5 through 2012.")
        ),
        column(width = 3)
      ),
      
      navlistPanel(
        "Select City",
        tabPanel("Beijing",
                 tags$h3("Shanghai"),
                 # plotOutput("shanghaiAqiSentiment"),
                 tags$p(class = "source-note", "Weibo Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28"),
                 tags$p(class = "source-note", "Air Quality Data Source: U.S. Mission to China/United States Department of State.")
        ),
        tabPanel("Shanghai",
                 tags$h3("Shanghai"),
                 plotOutput("shanghaiAqiSentiment"),
                 tags$p(class = "source-note", "Weibo Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28"),
                 tags$p(class = "source-note", "Air Quality Data Source: U.S. Mission to China/United States Department of State.")
        ),
        tabPanel("Guangzhou",
                 tags$h3("Guangzhou"),
                 plotOutput("guangzhouAqiSentiment"),
                 tags$p(class = "source-note", "Weibo Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28"),
                 tags$p(class = "source-note", "Air Quality Data Source: U.S. Mission to China/United States Department of State.")
                 ),
        widths = c(3, 9)
      )
      
    ),
    
# SECTION 4: "PERMISSION DENIED" -------------------------------------
    
    tabPanel(
      title = '"Permission Denied"',
      
      fluidRow(
        column(width = 3),
        column(width = 6,
               tags$h2('"Permission Denied"'),
               tags$p(tags$span("T",class = "firstcharacter"), "here are a variety of issues that have gave rise to contentious online debate on the Chinese Internet during 2012. In this page, we set aside our analysis on environmental awareness and air quality, and look into the issues that were censored on Weibo back in 2012. In the following component, you would be able to sample from over eighty thousand censored post collected by Weiboscope team. The original posts would be displayed, along with a Google translated version of these posts.")
        ),
        column(width = 3)
      ),
      
      fluidRow(
        column(width = 1),
        column(width = 10,
               tags$br(),
               sidebarLayout(
                 position = "right",
                 sidebarPanel(
                   tags$h4("What Gets Censored?"),
                   helpText("Click the button to view more censored posts (Translated with Google Translate)"),
                   actionButton("shuffle", "Shuffle!")
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                   DTOutput('censoredExamples'),
                   tags$p(class = "source-note", "Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28")
                 )
               ),
               column(width = 1)
        )
      ),

      fluidRow(
        column(width = 2),
        column(width = 8,
               tags$p("In the aftermath of multiple public opinion incidents in China, the government began increasing their grip on content moderation on Chinese Internet. They began mandating social media platforms to register the real name and phone number of the users on their platforms, and started a series of movement targeting 'rumors' on the Internet. The following animation shows the trend of increasing amount censorship recorded in the Weiboscope dataset."),
               imageOutput("censorshipTimeDist"),
               tags$p(class = "source-note", "Data Source: King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28")
        ),
        column(width = 2)
      )
    ),
    
# SECTION 5: ABOUT --------------------------------------------------

    tabPanel(
      title = "About",
      fluidPage(
        column(width = 3),
        column(width = 6,
               includeMarkdown("www/acknowledgement.md")
        ),
        column(width = 3)
      )
    )
  )
))
