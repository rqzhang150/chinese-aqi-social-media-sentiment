# Libraries ------------------------------------------------------------------
# We load all the necessary packages for the Shiny application here. We also
# authenticate the Google Language API's JSON key, which is included in the
# uploaded package but not pushed to Github for obvious reason.

library(mapview)
library(shiny)
library(markdown)
library(lubridate)
library(shinythemes)
library(markdown)
library(tidyverse)
library(DT)
library(gridExtra)
library(cowplot)
library(googleLanguageR)
gl_auth("Transcription-675d1c2f9aef.json")

# Loading Pre-Calculated RDS Files ------------------------------------------
# Here, we load all the necessary RDS files. They are precalculated and
# exported, and could save loading time.

# SECTION 1: POLLUTION A LEGITIMACY ISSUE
creation_time_dist <- read_rds("data/creation_time_dist.rds")

# SECTION 2: WOES OF DEVELOPMENT
china_gdp <- read_rds("data/china_gdp.rds")
development_indicators <- read_rds("data/development_indicators.rds")
keywords_freq_dist <- read_rds("data/keywords_freq_dist.rds")

# SECTION 3: BAD AIR BAD DAY?
provDist <- read_rds("data/year_total_geo.rds") %>% 
  select(Name = NAME_1, `Name in Chinese` = NL_NAME_1, `Number of Posts` = total_posts, geometry)
guangzhou_plot <- read_rds("data/guangzhou_sentiment_aqi_plot.rds")
shanghai_plot <- read_rds("data/shanghai_sentiment_aqi_plot.rds")
beijing_plot <- read_rds("data/beijing_sentiment_aqi_plot.rds")

# SECTION 4: PERMISSION DENIED
permission_denied_all <- read_rds("data/permission_denied_all.rds")

# MAIN SERVER LOGIC
shinyServer(function(input, output) {

  # SECTION 1: POLLUTION A LEGITIMACY ISSUE ------------------------------------
  # This puts the pre-generated png files describing the pollution intensity in
  # China through time and feed it into the UI. Plot is generated in
  # pollution_map_helper.R

  output$pm25map <- renderImage({
    list(
      src = paste0("pm25_graphs/pm25_", input$pm25_year, ".png"),
      contentType = "image/png"
    )
  },
  deleteFile = FALSE
  )

  # This describes the Weiboscope dataset that we are using. Plotting out the
  # number of posts each day throughout 2012 and allows users to specify the
  # range of date they would like to see.

  output$creationTimePlot <- renderPlot({
    # Draw the plot based on the imported RDS file.
    creation_time_dist %>%
      filter(created_date >= input$creationTimeDate[1] &
        created_date <= input$creationTimeDate[2]) %>%
      ggplot(aes(x = created_date, y = post_created)) +
      geom_line() +
      theme_minimal() +
      theme(
        plot.title = element_text(
          family = "Georgia",
          size = 20
        ),
        plot.subtitle = element_text(size = 15)
      ) +
      scale_y_continuous() +
      labs(
        x = NULL,
        y = "Number of Weibo Post Per Day",
        title = paste("Weibo Posts Created by Users with Subscription Base Larger Than 1,000"),
        subtitle = paste("Per day. Available data between", (creation_time_dist %>% arrange(created_date) %>% head(1) %>% dplyr::select(created_date) %>% pull() %>% format(format = "%B %d, %Y")), "and", (creation_time_dist %>% arrange(desc(created_date)) %>% head(1) %>% dplyr::select(created_date) %>% pull() %>% format(format = "%B %d, %Y")), ".")
      )
  })


  # This utilizes the keyword RDS generated in the pipeline_helper.R, and
  # creates a plot in which users can select the keyword they would like to
  # explore, as well as the time range they'd like to look into.

  output$keywordsFreqDist <- renderPlot(
    keywords_freq_dist %>%
      filter(
        between(created_date, input$keywordTime[1], input$keywordTime[2]),
        filter_keyword %in% input$keywordSelected
      ) %>%
      mutate(filter_keyword = factor(filter_keyword,
        levels = c("环保", "环境保护", "空气质量", "雾霾", "PM2.5", "霾", "污染", "口罩"),
        labels = c(
          "环保 (Environmental Protection)", "环境保护 (Environmental Protection)",
          "空气质量 (Air Quality)", "雾霾 (Smog)", "PM2.5", "霾 (Smog)",
          "污染 (Pollution)", "口罩 (Facemask)"
        )
      )) %>%
      ggplot(aes(x = created_date, y = post_created, color = filter_keyword)) +
      geom_line() +
      theme_minimal() +
      theme(
        plot.title = element_text(
          family = "Georgia",
          size = 20
        ),
        plot.subtitle = element_text(size = 15),
        legend.text = element_text(family = "STKaiti"),
        legend.position = "bottom"
      ) +
      labs(
        x = NULL,
        y = "Number of Posts",
        title = "Number of Weibo Posts That Mention Certain Keywords",
        caption = "Source: WeiboScope Open Data/Hong Kong University",
        color = "Keywords"
      )
  )

  # SECTION 2: WOES OF DEVELOPMENT ---------------------------------------------

  # This plot takes on the World Bank World Development Indicators dataset and
  # plots out China's GDP thorugh time, and allows users to specify the range of
  # date they would like to see.

  output$gdpPlot <- renderPlot({
    china_gdp %>%
      
      # Allows the users to select the time range they would like to view.
      
      filter(between(year, input$gdp_year[1], input$gdp_year[2])) %>%
      ggplot(aes(x = year, y = gdp)) +
      geom_line() +
      geom_point(size = 0.5) +
      theme_minimal() +
      theme(
        plot.title = element_text(
          family = "Georgia",
          size = 20
        ),
        plot.subtitle = element_text(size = 15)
      ) +
      labs(
        title = "China's Post-Reform Economy: Rapid Development",
        subtitle = "China's GDP (in current USD) from 1960 to 2017",
        x = NULL
      ) +
      scale_y_continuous(
        name = "GDP (in trillion dollar)",
        breaks = seq(0, 14e12, by = 2e12),
        labels = paste0("$", seq(0, 14, by = 2), "tn")
      ) +
      scale_x_continuous(breaks = seq(input$gdp_year[1], input$gdp_year[2], by = 5))
  })

  # This plot takes on the urbanization rate dataset provided by the World Bank,
  # and allows users to select the range of time they would like to see.

  output$urbanizationPlot <- renderPlot({
    development_indicators %>%
      
      # Allows the users to select the time range they would like to view.
      
      filter(between(year, input$urbanization_year[1], input$urbanization_year[2])) %>%
      filter(series_name == c("Urban population (% of total)")) %>%
      
      # Value is recorded as character type, coerce them into numeric.
      
      mutate(value = as.numeric(value)) %>%
      ggplot(aes(x = year, y = value)) +
      geom_line() +
      geom_point(size = 0.5) +
      theme_minimal() +
      theme(
        plot.title = element_text(
          family = "Georgia",
          size = 20
        ),
        plot.subtitle = element_text(size = 15)
      ) +
      labs(
        title = "Into an Urban Society",
        subtitle = "China became predominantly urban in 2011.",
        x = NULL
      ) +
      
      # Add an intercept at 50% to indicate an urban society.
      
      geom_hline(yintercept = 50, linetype = "dashed", color = "red") +
      scale_y_continuous(
        name = "% of Total Population",
        limits = c(0, 100),
        breaks = seq(0, 100, by = 10),
        labels = paste0(seq(0, 100, by = 10), "%")
      ) +
      scale_x_continuous(breaks = seq(1960, 2017, by = 5))
  })

  # SECTION 3: BAD AIR BAD DAY -------------------------------------------------
  # This section take the RDS plots generated in the sentiment_helper.R and
  # prepares them for the UI to invoke.

  output$privincialDistribution <- renderMapview(
    mapview(provDist,
      zcol = "Number of Posts",
      layer.name = "Number of Posts"
    )
  )

  output$beijingAqiSentiment <- renderPlot(
    beijing_plot
  )

  output$shanghaiAqiSentiment <- renderPlot(
    shanghai_plot
  )

  output$guangzhouAqiSentiment <- renderPlot(
    guangzhou_plot
  )

  # SECTION 4: PERMISSION DENIED -----------------------------------------------
  # This implements the Shuffle button that allows the user to see a random
  # censored post after clicking the button.

  observe({
    if (input$shuffle > 0) {
      output$censoredExamples <- renderDT(
        sample_n(permission_denied_all, 1) %>%
          dplyr::select(text) %>%
          pull() %>%

          # Using Google Translate API, we translate the original text into
          # English.

          gl_translate(target = "en") %>%
          mutate(
            `Original Text` = text,
            `Translated Text (Google Translate)` = translatedText
          ) %>%
          dplyr::select(`Original Text`, `Translated Text (Google Translate)`)
      )
    }
  })

  # This renders the pre-generated gganimate file by the censorship_dist_helper.R

  output$censorshipTimeDist <- renderImage({
    list(
      src = "www/censorship_dist_plot.gif",
      contentType = "image/gif"
    )
  },

  # We do not want to delete the file after display.
  deleteFile = FALSE
  )
})
