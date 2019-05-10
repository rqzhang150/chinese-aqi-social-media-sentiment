library(tidyverse)
library(stringr)
library(gganimate)
library(lubridate)

permission_denied_dist <- read_rds("weibo_air_quality/data/permission_denied_dist.rds")

censorship_dist_plot <- permission_denied_dist %>% 
  ggplot(aes(x = created_date, y = deleted_count)) +
  geom_line(color = "#d11141") +
  transition_reveal(created_date) +
  theme_minimal() +
  labs(title = "Tightening the Grip",
       subtitle = "Number of recorded censorship on the rise in 2012.",
       x = NULL,
       y = "Number of Monitored Censored Posts",
       caption = "Source: Open WeiboScope/Hong Kong University") +
  theme(panel.grid.minor = element_blank()) + 
  theme(plot.title = element_text(family = "Georgia",
                                  size = 20),
        plot.subtitle = element_text(size = 15))

animate(censorship_dist_plot, 
        nframes = 365,
        fps = 30,
        duration = 8,
        end_pause = 150,
        width = 1000,
        height = 500)

anim_save("weibo_air_quality/censorship_dist_plot.gif", animation = censorship_dist_plot,
          nframes = 365,
          fps = 30,
          duration = 10,
          end_pause = 150,
          width = 800,
          height = 400)
