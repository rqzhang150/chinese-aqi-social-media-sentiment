# This files helps create the graphs for social and economic metrics on the
# second page of the Shiny application

library(janitor)
library(tidyverse)

# Read Data ---------------------------------------------------------------

# Read in the development indicators data and clean the variable names with
# janitor.

development_indicators <- read_csv("datasets/World_Development_Indicators/development_metrics.csv") %>% 
  clean_names()

# Read in the World Bank Chinese GDP data series.

china_gdp <- read_csv("datasets/World_Development_Indicators/gdp_dollar.csv",
                      skip = 3) %>% 
  clean_names()

# RDS for China's GDP Graph -----------------------------------------------

china_gdp %>% 
  filter(country_name == "China") %>% 
  
  # Drop those columns as they do not contain anything.
  
  select(-x2018, -x64) %>% 
  
  # Create a row for each data point as opposed to a row for multiple data.
  
  gather(key = "year", "value" = gdp, x1960:x2017) %>% 
  
  # Convert year from character type to integer type.
  
  mutate(year = as.integer(str_remove(year, "x")))

write_rds(china_gdp, "weibo_air_quality/data/china_gdp.rds")

# RDS for Other Indicators ------------------------------------------------


# The following list stores the indicators that I am interested in.

selected_indicators <- c("GDP (current US$)", "Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population)", 
                         "Urban population (% of total)", "Individuals using the Internet (% of population)", 
                         "School enrollment, primary (% gross)", "School enrollment, secondary (% gross)")

# Cleaning the data.

cleaned_indicators <- development_indicators %>% 
  
  # We only want the indicators that we are interested in.
  
  filter(series_name %in% selected_indicators) %>% 
  
  # Create one row for each data entry, instead of one row for a series of data
  # across time.
  
  gather(key = "year", value = "value", x1960_yr1960:x2017_yr2017) %>% 
  
  # Drop the country_code and country_name and series_code as they are
  # unnecessary. Drop the 2018 column as it does not contain any data.
  
  dplyr::select(-country_name, -country_code, -x2018_yr2018, -series_code) %>% 
  
  # Extract numeric year from the "year" string.
  
  mutate(year = map_chr(str_split(year, pattern = "_"), c(1)),
         year = as.integer(str_remove(year, "x")))

write_rds(cleaned_indicators, "weibo_air_quality/data/development_indicators.rds")

# Graphic Generation --------------------------------------------------
# I test out the graphic generation codes for the server here.

china_gdp %>% 
  ggplot(aes(x = year, y = gdp)) +
  geom_line() +
  geom_point(size = 0.5) +
  theme_minimal() +
  labs(title = "China's Post-Reform Economy: Rapid Development",
       subtitle = "China's GDP (in current USD) from 1960 to 2017",
       x = NULL) +
  scale_y_continuous(name = "GDP (in trillion dollar)",
                     breaks = seq(0, 14e12, by = 2e12),
                     labels = paste0("$",seq(0, 14, by = 2),"tn")) +
  scale_x_continuous(breaks = seq(1960, 2017, by = 5))

cleaned_indicators %>% 
  filter(series_name == "Urban population (% of total)") %>% 
  mutate(value = as.numeric(value)) %>% 
  ggplot(aes(x = year, y = value)) +
  geom_line() +
  geom_point(size = 0.5) +
  theme_minimal() +
  labs(title = "Into an Urban Society",
       subtitle = "China became predominantly urban in 2011",
       x = NULL) +
  geom_hline(yintercept = 50, linetype="dashed", color = "red") +
  scale_y_continuous(name = "Urban population (% of total)",
                     limits = c(0, 100),
                     breaks = seq(0, 100, by = 10),
                     labels = paste0(seq(0, 100, by = 10),"%")) +
  scale_x_continuous(breaks = seq(1960, 2017, by = 5))
