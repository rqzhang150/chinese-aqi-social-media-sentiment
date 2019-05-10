# This file utilizes Spark, Sparklyr, and GeoSpark to read and process datasets,
# combine them into intermediate results and export them into RDS format files
# for other helper files to process.

# Libraries --------------------------------------------------------------------

library(sf)
library(tidyverse)
library(gt)
library(sparklyr)
library(tictoc)
library(lubridate)
library(mapview)

# Installed through devtools::install_github("harryprince/geospark"). You would
# also need to install Geospark directly on the Spark instance you have.

library(geospark)
library(stringr)
library(gganimate)
library(janitor)
library(googleLanguageR)
gl_auth("weibo_air_quality/Transcription-675d1c2f9aef.json")

# Spark Setup ------------------------------------------------------------------

# Set environment variable for JDK 1.8 in order to point sparklyr package to the
# correct directory.

Sys.setenv(JAVA_HOME = "/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home")

# Configuring Sparklyr settings.

conf <- list()

# Usually I would set the local cores to 8 and unset executor cores so that
# Spark utilizes the best options possible on the setup. However, there **might** be
# an issue with the thread-safety of Geospark. Thus, I leave the options to only
# assign one core to an executor here for debugging purposes.

conf$`sparklyr.cores.local` <- 8
# conf$spark.executor.cores <- 1
conf$`sparklyr.shell.driver-memory` <- "10G"
conf$spark.memory.fraction <- 0.9

# Switching the default serializer to Kryo Serializer and register it to
# Geospark. Kyro Serializer allows for more efficient serializing.

conf$spark.serializer <- "org.apache.spark.serializer.KryoSerializer"
conf$spark.kryo.registrator <- "org.datasyslab.geospark.serde.GeoSparkKryoRegistrator"
conf$spark.kryoserializer.buffer.max <- "1G"
conf$spark.driver.maxResultSize <- "3G"

# Connect to local Spark instance.

sc <- spark_connect(
  master = "local",
  config = conf
)

# GeoSpark registration.

register_gis(sc)



# WeiboScope Load ------------------------------------------------------

# Time the loading time for the csv files.

tic("weiboscope_load_full")

# Read all WeiboScope csv files to WEIBOSCOPE_ALL variable through spark. The
# reason that we use Spark is that the files are too big to be stored in memory.
# Thus, we need a distributional computation platfrom to properly produce
# analysis on tis dataset. We process the dataset using spark, and generate
# dataframes that contains manageable metadata, and visualize it using ggplot.

WEIBOSCOPE_ALL <- spark_read_csv(sc,
  name = "weiboscope",

  # Weiboscope data is stored under datasets/weiboscope_data in .csv formats.
  # Using wildcard, we read in all the data in that directory. Because
  # Weiboscope data already contains timestamp of the posts, we do not worry
  # about the filename.

  path = "datasets/weiboscope_data/*.csv",

  # Specifying the column types manually without letting Spark infering the
  # column types. The following column types are not specified under R coltypes,
  # but instead uses Spark SQL format.

  infer_schema = FALSE,
  columns = list(
    mid = "character",
    retweeted_status_mid = "character",
    uid = "character",
    retweeted_uid = "character",
    source = "character",
    image = "integer",
    text = "character",
    geo = "character",
    created_at = "timestamp",
    deleted_last_seen = "timestamp",
    permission_denied = "boolean"
  )
)
toc()

# It would usually takes ~20 minutes for Sparklyr to read in all the csv files.
# We need something more efficient to store this dataset. Thus, after running
# this for the first time, we store the intermediate dataset into a parquet file
# - a file format designed for Spark and is much more efficient in terms of
# storage usage and reading speed.

spark_write_parquet(WEIBOSCOPE_ALL, "spark_parquets/weiboscope_all_before_partition.parquet")

# Usually would run this, read the parquet files directly.

WEIBOSCOPE_ALL <- spark_read_parquet(sc, name = "weiboscope", path = "spark_parquets/weiboscope_all.parquet/")



# RDS: Weibo Posting Time Distribution ------------------------------------------

# Using all WeiboScope data in Spark environment, we hope to calculate how many
# posts are posted everyday in 2012.

tic("creation_time_dist")
creation_time_dist <- WEIBOSCOPE_ALL %>%

  # Due to Spark SQL settings, we imported created_at variable as a timestamp.
  # Because of Spark SQL grammar constraint, we cannot use as_date() in
  # Lubridate. We instead use to_date function provided in Spark's HIVE
  # functions. By using this, we obtain the date portion of created_at varibale.

  mutate(created_date = to_date(created_at)) %>%
  group_by(created_date) %>%

  # Calculate how many posts are created in each day.

  summarize(post_created = n()) %>%

  # Function specific to Spark. Use collect() to calculate the result and put
  # the result into R workspace.

  collect()
toc()

# This takes a lot of computational power and time to calculate. Thus, we save
# our result into an RDS file for our Shiny app to use.

write_rds(creation_time_dist, "weibo_air_quality/data/creation_time_dist.rds")


# Geo Boundary Loading --------------------------------------------------

# We use GADM Global Topolotical dataset to plot out the provincial level map of
# China. However, due to the size of the map (~10M), plotting the original
# simple feature would take too much time. Therefore, we simplify the map while
# preserving its topology using st_simplify.

CHN_simplified <- read_rds("datasets/gadm36_rds/gadm36_CHN_1_sf.rds") %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.01)

# We load the city level administrative map of China.

CHN_2 <- read_rds("datasets/gadm36_rds/gadm36_CHN_2_sf.rds")

# This reduced the size of the map, and makes it more mamagable to print. To
# check whether it's feasible to print, we manually examine the size of the
# simplified map.

object.size(CHN_simplified)

# We print out China's map for testing.

mapview(CHN_simplified)

mapview(year_total_geo,
  zcol = "total_posts",
  layer.name = "Number of Posts",

  # We view the map in an external browser.

  viewer.suppress = TRUE
)



# RDS: Weibo Geographical Distribution -------------------------------------

# WeiboScope Open's Geographical data is coded as character in the format of
# "POINT(0 0)". We would like to import this into our Spark environment for
# calculation. However, we cannot use sf to directly calculate due to the memory
# constraint. To achieve this, we use Geospark package to complete the
# calculation directly in Spark.

WEIBOSCOPE_GEO_WKT <- WEIBOSCOPE_ALL %>%

  # In the Weiboscope Data, because the longitude and latitude is coded as
  # string character, we need to extract them into separate variables in order
  # to manipulate the data. Spark does not support stringr functions, therefore,
  # we are using regex expressions (Java format, since Spark is based on Java)
  # to extract them.

  mutate(
    longitude = regexp_extract(geo, "[(](.*?)\\\\s"),
    latitude = regexp_extract(geo, "\\\\s(.*?)[)]")
  ) %>%

  # We filter out the geo data that is NA. And remove rows that contains
  # erroneous data. We also remove obviously unrealisitc points.

  filter(
    !is.na(geo),

    # There are some instances where the geo column contains information
    # that is not geo information at all. We filter for the rows that
    # confrom to the format.

    str_detect(geo, "POINT"),

    # This is obviously impossible

    geo != "POINT(0 0)",

    # There are some data points in the WeiboScope data that is outside of
    # possible bounds, causing runtime errors in Spark. We filter out those
    # data.

    between(longitude, 0, 180),
    between(latitude, -90, 90)
  ) %>%

  # Within Spark, we use GeoSpark function st_geomfromwkt to transform character
  # string contained in geo to a Simple Feature object within Spark supported by
  # Geospark. We store the result of this transformation into variable
  # weibo_geo_wkt.

  mutate(weibo_geo_wkt = st_geomfromwkt(geo)) %>%
  filter(!is.na(weibo_geo_wkt))

# Registering the table in the Spark workplace and give it a name.

sdf_register(WEIBOSCOPE_GEO_WKT, name = "WEIBOSCOPE_GEO_WKT")

# Write the intermediate result to parquet format.

spark_write_parquet(WEIBOSCOPE_GEO_WKT, "spark_parquets/weiboscope_geo_before_partition.parquet")

# Now, because the previous steps involve filtering a significant chunk of data.
# The original partition assigned by Spark is no longer optimal for future
# operations. We would like to optimize this operations. Therefore, we first get
# the number of partitions of the original Spark table. Then, comparing the rows
# of the WEIBOSCOPE_ALL dataframe and geo filtered dataframe, we proportionally
# reduce the number of partitions, which gives us a resulting partition of 35.

sdf_num_partitions(WEIBOSCOPE_ALL)
sdf_num_partitions(WEIBOSCOPE_GEO_WKT)
sdf_nrow(WEIBOSCOPE_ALL)
sdf_nrow(WEIBOSCOPE_GEO_WKT)
WEIBOSCOPE_GEO_WKT <- sdf_repartition(WEIBOSCOPE_GEO_WKT, partitions = 35)

# Write the intermediate result to parquet format.

spark_write_parquet(WEIBOSCOPE_GEO_WKT, "spark_parquets/weiboscope_geo_after_partition.parquet")

# Then, we need to transform the simplified Chinese map into a format that is
# compatible to GeoSpark. To achieve this, we first convert it into a dataframe,
# and transform its geometry into character strings. We then remove its geometry
# column that contains value incompatible with Spark.

WEIBOSCOPE_GEO_WKT <- spark_read_parquet(sc, name = "weiboscope_geo_wkt", path = "spark_parquets/weiboscope_geo_after_partition.parquet/")

CHN_GeoSpark_Map_df <- as_data_frame(CHN_simplified) %>%
  mutate(
    chn_map_geom = st_as_text(geometry),
    geometry = NULL
  )

# CHN_GeoSpark_Map_df <- as_data_frame(CHN_simplified) %>%
#   mutate(chn_map_geom = st_as_text(geometry),
#          geometry = NULL)

# Put the Chinese Map into Spark storage.

CHN_GeoSpark_Map_spark <- copy_to(sc, CHN_GeoSpark_Map_df)

# Within Spark's storage, we transform the the character that contains the
# geographical boundary of China's administrative regions into Simple Feature
# objects that can be processed in GeoSpark.

CHN_GeoSpark_Map <- mutate(CHN_GeoSpark_Map_spark, chn_geo_wkt = st_geomfromwkt(chn_map_geom))

# sdf_register(CHN_GeoSpark_Map, name = "CHN_GeoSpark_Map")

CHN_GeoSpark_Map


# We then use Geospark's st_join function to calculate their intersections. We
# want to find out the number of posts in each province in each month.
# Therefore, we specify join condition as contain, and let Spark calculate which
# administrative zone a specific geotagged post is in.

# We store this as an intermediate result, not collecting this into R workspace
# for further data wrangling and analysis.

geo_distribution <- st_join(CHN_GeoSpark_Map,
  WEIBOSCOPE_GEO_WKT,

  # We use an sql operation provided by GeoSpark here. By using
  # st_contains, we are joining the rows in which the Weibo
  # posts location is located within a Chinese province.
  join = sql("st_contains(chn_geo_wkt, weibo_geo_wkt)")
)

# Registering the Spark table with a name in the Spark workspace.

sdf_register(geo_distribution, name = "geo_distribution")

# Write the intermediate results to parquet files.

spark_write_parquet(geo_distribution, path = "spark_parquets/geo_distribution.parquet")

# In this step, we hope to calculate the volume of Weibo posts in different
# provinces across 2012.

monthly_distribution <- st_join(CHN_GeoSpark_Map,
  WEIBOSCOPE_GEO_WKT,
  join = sql("st_contains(chn_geo_wkt, weibo_geo_wkt)")
) %>%
  mutate(created_month = month(to_date(created_at))) %>%
  group_by(NAME_1, created_month) %>%
  summarise(cnt = n()) %>%
  collect()

year_total_geo <- monthly_distribution %>%
  group_by(NAME_1) %>%
  summarize(total_posts = sum(cnt)) %>%
  full_join(CHN_simplified) %>%
  st_as_sf()

write_rds(year_total_geo, "weibo_air_quality/data/year_total_geo.rds")

year_total_geo <- read_rds("weibo_air_quality/data/year_total_geo.rds")

# Select City Posts Filtering ---------------------------------------------

CHN_Select_City_Simplified <- read_rds("datasets/gadm36_rds/gadm36_CHN_2_sf.rds") %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.01) %>%
  dplyr::filter(NAME_2 %in% c("Beijing", "Guangzhou", "Shenzhen", "Shanghai"))

CHN_Select_City_Simplified <- as_data_frame(CHN_Select_City_Simplified) %>%
  mutate(
    chn_map_geom = st_as_text(geometry),
    geometry = NULL
  )

CHN_Select_City_Simplified_spark <- copy_to(sc, CHN_Select_City_Simplified)

CHN_Select_City_Simplified <- mutate(CHN_Select_City_Simplified_spark, chn_geo_wkt = st_geomfromwkt(chn_map_geom))

select_city_posts <- st_join(CHN_Select_City_Simplified,
  WEIBOSCOPE_GEO_WKT,

  # We use an sql operation provided by GeoSpark here. By using
  # st_contains, we are joining the rows in which the Weibo
  # posts location is located within a Chinese province.
  join = sql("st_contains(chn_geo_wkt, weibo_geo_wkt)")
)

sdf_register(select_city_posts, name = "select_city_posts")

spark_write_parquet(select_city_posts, path = "spark_parquets/select_city_posts.parquet")

# RDS: Posts in Shenzhen, Guangzhou, Shanghai, Beijing ---------------------------------

select_city_posts <- spark_read_parquet(sc, "spark_parquets/select_city_posts.parquet/")

select_city_posts_df <- select_city_posts %>%
  dplyr::select(-chn_geo_wkt, -weibo_geo_wkt, -chn_map_geom) %>%
  collect()

write_rds(select_city_posts_df, "sentiment_analysis/select_city_posts_df.rds")

# RDS: Censored Posts ------------------------------------------------------------------

permission_denied_dist <- WEIBOSCOPE_ALL %>% 
  filter(!is.na(permission_denied)) %>% 
  mutate(created_date = to_date(created_at)) %>% 
  group_by(created_date) %>% 
  summarize(deleted_count = n()) %>% 
  collect()

write_rds(permission_denied_dist, "weibo_air_quality/data/permission_denied_dist.rds")

permission_denied_all <- WEIBOSCOPE_ALL %>% 
  filter(!is.na(permission_denied)) %>% 
  collect()

write_rds(permission_denied_all, "weibo_air_quality/data/permission_denied_all.rds")

# RDS: Keyword Distribution ----------------------------------------------------------

keywords <- c("环保", "环境保护", "空气质量", "雾霾", "PM2.5", "霾", "污染", "口罩")

frequency <- tibble(filter_keyword = character(),
                    created_date = date(),
                    post_created = integer())

for (keyword in keywords) {
  WEIBOSCOPE_ALL %>% 
    filter(str_detect(text, keyword)) %>% 
    mutate(created_date = to_date(created_at),
           filter_keyword = keyword) %>% 
    group_by(filter_keyword, created_date) %>% 
    summarize(post_created = n()) %>% 
    collect() %>% 
    bind_rows(frequency) -> frequency
}

write_rds(frequency, "weibo_air_quality/data/keywords_freq_dist.rds")

