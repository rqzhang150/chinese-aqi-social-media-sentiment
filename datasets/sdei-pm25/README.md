# Setting up SDEI Global Annual PM2.5 Dataset

SDEI Global Annual PM2.5 Dataset contains the satellite-derived average PM2.5 concentration from 1998 to 2016. Each year's data is stored in GEOTiff format in high resolution. Therefore, it's unrealistic and unnecssary to upload this to Github. The following document outlines how the dataset is set up in this project's context.

## Download

You can download the SDEI Global Annual PM2.5 Dataset [here](https://sedac.ciesin.columbia.edu/data/set/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod/data-download). Please make sure to cite the authors' paper. Its information is attached here:

van Donkelaar, A., R. V. Martin, M. Brauer, N. C. Hsu, R. A. Kahn, R. C. Levy, A. Lyapustin, A. M. Sayer, and D. M. Winker. 2016. Global Estimates of Fine Particulate Matter Using a Combined Geophysical-Statistical Method with Information from Satellites. Environmental Science & Technology 50 (7): 3762-3772. <https://doi.org/10.1021/acs.est.5b05833>.

## Directory Structure

Simply extract the archives you've downloaded into this directory. This should be what the directory looks like:

```
.
├── README.md - This README file.
├── .gitignore - Prevents the csv file from being pushed to Github.
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-geotiff
│   ├── gwr_pm25_1998.tfw
│   ├── gwr_pm25_1998.tif
│   ├── gwr_pm25_1998.tif.aux.xml
│   ├── gwr_pm25_1998.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1999-geotiff
│   ├── gwr_pm25_1999.tfw
│   ├── gwr_pm25_1999.tif
│   ├── gwr_pm25_1999.tif.aux.xml
│   ├── gwr_pm25_1999.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1999-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2000-geotiff
│   ├── gwr_pm25_2000.tfw
│   ├── gwr_pm25_2000.tif
│   ├── gwr_pm25_2000.tif.aux.xml
│   ├── gwr_pm25_2000.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2000-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2001-geotiff
│   ├── gwr_pm25_2001.tfw
│   ├── gwr_pm25_2001.tif
│   ├── gwr_pm25_2001.tif.aux.xml
│   ├── gwr_pm25_2001.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2001-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2002-geotiff
│   ├── gwr_pm25_2002.tfw
│   ├── gwr_pm25_2002.tif
│   ├── gwr_pm25_2002.tif.aux.xml
│   ├── gwr_pm25_2002.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2002-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2003-geotiff
│   ├── gwr_pm25_2003.tfw
│   ├── gwr_pm25_2003.tif
│   ├── gwr_pm25_2003.tif.aux.xml
│   ├── gwr_pm25_2003.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2003-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2004-geotiff
│   ├── gwr_pm25_2004.tfw
│   ├── gwr_pm25_2004.tif
│   ├── gwr_pm25_2004.tif.aux.xml
│   ├── gwr_pm25_2004.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2004-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2005-geotiff
│   ├── gwr_pm25_2005.tfw
│   ├── gwr_pm25_2005.tif
│   ├── gwr_pm25_2005.tif.aux.xml
│   ├── gwr_pm25_2005.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2005-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2006-geotiff
│   ├── gwr_pm25_2006.tfw
│   ├── gwr_pm25_2006.tif
│   ├── gwr_pm25_2006.tif.aux.xml
│   ├── gwr_pm25_2006.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2006-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2007-geotiff
│   ├── gwr_pm25_2007.tfw
│   ├── gwr_pm25_2007.tif
│   ├── gwr_pm25_2007.tif.aux.xml
│   ├── gwr_pm25_2007.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2007-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2008-geotiff
│   ├── gwr_pm25_2008.tfw
│   ├── gwr_pm25_2008.tif
│   ├── gwr_pm25_2008.tif.aux.xml
│   ├── gwr_pm25_2008.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2008-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2009-geotiff
│   ├── gwr_pm25_2009.tfw
│   ├── gwr_pm25_2009.tif
│   ├── gwr_pm25_2009.tif.aux.xml
│   ├── gwr_pm25_2009.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2009-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2010-geotiff
│   ├── gwr_pm25_2010.tfw
│   ├── gwr_pm25_2010.tif
│   ├── gwr_pm25_2010.tif.aux.xml
│   ├── gwr_pm25_2010.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2010-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2011-geotiff
│   ├── gwr_pm25_2011.tfw
│   ├── gwr_pm25_2011.tif
│   ├── gwr_pm25_2011.tif.aux.xml
│   ├── gwr_pm25_2011.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2011-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2012-geotiff
│   ├── gwr_pm25_2012.tfw
│   ├── gwr_pm25_2012.tif
│   ├── gwr_pm25_2012.tif.aux.xml
│   ├── gwr_pm25_2012.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2012-geotiff\ (2).zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2013-geotiff
│   ├── gwr_pm25_2013.tfw
│   ├── gwr_pm25_2013.tif
│   ├── gwr_pm25_2013.tif.aux.xml
│   ├── gwr_pm25_2013.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2013-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2014-geotiff
│   ├── gwr_pm25_2014.tfw
│   ├── gwr_pm25_2014.tif
│   ├── gwr_pm25_2014.tif.aux.xml
│   ├── gwr_pm25_2014.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2014-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2015-geotiff
│   ├── gwr_pm25_2015.tfw
│   ├── gwr_pm25_2015.tif
│   ├── gwr_pm25_2015.tif.aux.xml
│   ├── gwr_pm25_2015.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2015-geotiff.zip
├── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2016-geotiff
│   ├── gwr_pm25_2016.tfw
│   ├── gwr_pm25_2016.tif
│   ├── gwr_pm25_2016.tif.aux.xml
│   ├── gwr_pm25_2016.tif.ovr
│   └── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-1998-2016-documentation.pdf
└── sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod-2016-geotiff.zip
```