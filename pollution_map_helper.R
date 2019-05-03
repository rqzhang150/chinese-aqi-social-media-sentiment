# This file creates the PM 2.5 Concentration Map from 1998-2016 on the first
# page of the Shiny App. Using satellite-derived air pollutant data, we plot out
# the average concerntration of air pollutant in China across time.

library(sf)
library(raster)
library(rasterVis)
library(rgdal)
library(maps)
library(mapdata)
library(maptools)
library(mapview)
library(tidyverse)

# Import provincial level map of China provided by the GADM3.6 dataset. GADM
# dataset contains very detailed topology for China's coastline, and it takes a
# lot of time and computational power to plot that out. Therefore, we use sf's
# simplify function to simplify its topology.

CHN_simplified <- read_rds("datasets/gadm36_rds/gadm36_CHN_1_sf.rds") %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.01)

# The air pollution dataset is stored in GEOTiff format. We read in each GEOTiff
# file into a variable.

pm25_1998 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-geotiff/gwr_pm25_1998.tif")
pm25_1999 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1999-geotiff/gwr_pm25_1999.tif")
pm25_2000 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2000-geotiff/gwr_pm25_2000.tif")
pm25_2001 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2001-geotiff/gwr_pm25_2001.tif")
pm25_2002 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2002-geotiff/gwr_pm25_2002.tif")
pm25_2003 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2003-geotiff/gwr_pm25_2003.tif")
pm25_2004 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2004-geotiff/gwr_pm25_2004.tif")
pm25_2005 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2005-geotiff/gwr_pm25_2005.tif")
pm25_2006 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2006-geotiff/gwr_pm25_2006.tif")
pm25_2007 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2007-geotiff/gwr_pm25_2007.tif")
pm25_2008 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2008-geotiff/gwr_pm25_2008.tif")
pm25_2009 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2009-geotiff/gwr_pm25_2009.tif")
pm25_2010 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2010-geotiff/gwr_pm25_2010.tif")
pm25_2011 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2011-geotiff/gwr_pm25_2011.tif")
pm25_2012 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2012-geotiff/gwr_pm25_2012.tif")
pm25_2013 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2013-geotiff/gwr_pm25_2013.tif")
pm25_2014 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2014-geotiff/gwr_pm25_2014.tif")
pm25_2015 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2015-geotiff/gwr_pm25_2015.tif")
pm25_2016 <- raster("datasets/sdei-pm25/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2016-geotiff/gwr_pm25_2016.tif")

# Create a list that contains the name for the previous variables to feed to the
# for loop later.

pm25_list <- c("pm25_1998", "pm25_1999", "pm25_2000", "pm25_2001", "pm25_2002", "pm25_2003", "pm25_2004", "pm25_2005", "pm25_2006", "pm25_2007", "pm25_2008", "pm25_2009", "pm25_2010", "pm25_2011", "pm25_2012", "pm25_2013", "pm25_2014", "pm25_2015", "pm25_2016")

# Brew color for the concentration of PM2.5.

colr <- colorRampPalette(rev(brewer.pal(11, "RdYlBu")))

# Formatting parameters for the graph generation. We set the top, left, and
# right padding to zero.

padding <- list(
  layout.heights = list(top.padding = 0),
  layout.widths = list(
    left.padding = 0,
    right.padding = 0
  )
)

# For each year's raster data, we generate one PM2.5 map.

for (year in pm25_list) {

  # Setting up parameters for storing the graph into png format.

  png(
    filename = paste0("weibo_air_quality/pm25_graphs/", year, ".png"),
    width = 3000,
    height = 1000,
    res = 300
  )

  plot <- levelplot(
    
    # This is the raster variable we are processing. We are iterating over the
    # list that stores the name for the raster data. But the lists are stored as
    # character type. Therefore, we need to convert them into name, and evaluate
    # it, so that R will use those to point to the data.
    
    eval(as.name(year)),
    
    # Generate Title
    
    main = paste("Air Pollution (PM2.5) Concentration in China,", str_split(year, pattern = "_")[[1]][2]),
    
    # The raster file contains data for the entire world, we specify a Latitude
    # and Longitude range to zoom into China.
    
    xlim = c(70, 140),
    ylim = c(10, 60),
    
    # We disable the labels for axis.
    
    xlab = NULL,
    ylab = NULL,
    
    # We do not want the color intensity to be that large, therefore, we set the
    # transparency to 0.8.
    
    alpha.regions = 0.8,
    
    # Resolution in the original dataset is extremely high, we approximate it a
    # little bit.
    
    maxpixels = 2e6,
    margin = FALSE,
    
    # Legend for the color.
    
    colorkey = list(
      title = "mg / cubic m"
    ),
    
    # Supress axis labels.
    
    scales = list(draw = FALSE),
    
    # Generate color ramp using the previously generated colors.
    
    col.regions = colr,
    
    # Breaks for the color ramp.
    
    at = seq(0, 110, by = 10),
    
    # Use the pre-set parameters to specify the paddings.
    
    par.settings = padding
  ) +
    
    # Add an overlay China map layer.
    
    layer(
      sp.polygons(as_Spatial(CHN_simplified))
    )

  print(plot)
  
  # Generate the png file.

  dev.off()
}