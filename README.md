# Air Quality and Social Media Sentiment in China

![Smog in Beijing, China](https://live.staticflickr.com/733/23424745665_d054b3ca6d_h.jpg)
Smog in Beijing, China. By *Lei Han* on [Flickr](https://www.flickr.com/photos/sunsetnoir/23424745665/in/photostream/). Licensed under [CC BY-NC-ND 2.0](https://creativecommons.org/licenses/by-nc-nd/2.0/).

## Description

Exploratory data analysis between Air Quality-related data and social media (Weibo) sentiment data in 2012. Final project for Harvard College GOV 1005: Data

## Getting Started

The repository comprises two components: a data processing component and a Shiny webapp to demonstrate the findings of the data analysis. The diretory tree is listed below: 

```
.
├── README.md
├── data_processing.Rmd
├── datasets
│   ├── exploratory_analysis.Rmd
│   ├── World_Development_Indicators
│   ├── gadm36_CHN_shp
│   ├── gadm36_rds
│   │   └── gadm36_CHN_1_sf.rds
│   ├── sdei-pm25
│   └── weiboscope_data
│       ├── week1.csv
│       ├── ....csv
│       └── week52.csv
├── final-project-critique
│   ├── critique.Rmd
│   └── critique.html
└── weibo_air_quality
    ├── about.md
    ├── acknowledgement.md
    ├── data
    │   ├── china_gdp.rds
    │   ├── creation_time_dist.rds
    │   ├── development_indicators.rds
    │   ├── keywords_freq_dist.rds
    │   ├── permission_denied_all.rds
    │   └── permission_denied_dist.rds
    ├── pm25_graphs
    ├── server.R
    ├── ui.R
    └── www
        ├── about_header.html
        ├── bgimg.jpg
        ├── censorship_dist_plot.gif
        ├── demo.html
        └── style.css
```

## Datasets

### Open WeiboScope

Weibo (微博), widely dubbed as China's version of Twitter, is a social networking platform provided by Sina, now a subsidiary of Alibaba Group, one of the largest Internet firms in mainland China. 

Due to online censorship, Chinese Internet users are unable to access many sites that do not conform to government censorship requests or otherwise deemed sensitive. Those sites include widely used services including Twitter, Google, Facebook, Instagram, and Snapchat. Partially as a result of Chinese Internet users' limited access to foreign services, Weibo boasts a Monthly Active User based over 400 million and is widely regarded as one of the important barometer of China's public sentiment on social issues.

The most important dataset in this project is the Open WeiboScope dataset published by a team at Hong Kong University led by King-wa Fu. The project scraped Weibo posts and their matadata published by users with more than 1,000 followers since January 2011. 

The research team published its 2012 dataset that contains over 200 million Weibo posts that fit the previous criteria. In the dataset, each week's data is published separately. In this step of the project, we examin the WeiboScope data in Week 1, 2012.

Metadata includes such as user's anonymous id (`uid`), the platform used to publish the post (`source`),  whether the post contains image(s) (`image`), original text of the post (`text`), geospatial coordinate of the post (`geo`), and time of creation of the post (`created_at`).

Additionally, as Weibo is required to conform with government's censorship requirements in sensitive issues. This dataset also tracks whether the post is deleted. Weibo displays posts that are censored in different ways: either saying that it's deleted (`deleted_last_seen`) or the user does not have permission to view the post (`permission_denied`).

**Open WeiboScope**
King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28

### Air Quality (PM2.5)

**Global Annual PM2.5 Grids from MODIS, MISR and SeaWiFS Aerosol Optical Depth (AOD) with GWR, v1 (1998–2016)**
van Donkelaar, A., R. V. Martin, M. Brauer, N. C. Hsu, R. A. Kahn, R. C. Levy, A. Lyapustin, A. M. Sayer, and D. M. Winker. 2016. Global Estimates of Fine Particulate Matter Using a Combined Geophysical-Statistical Method with Information from Satellites. Environmental Science & Technology 50 (7): 3762-3772. https://doi.org/10.1021/acs.est.5b05833.

### U.S. Mission to China Air Quality Data

**U.S. Mission to China Air Quality Historical Data**
U.S. Department of State. 2019. U.S. Department of State Air Quality Monitoring Program. http://www.stateair.net/web/historical/1/1.html
