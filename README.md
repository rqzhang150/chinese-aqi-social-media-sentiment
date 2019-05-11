# Settling the Dust: Air Pollution & Public Opinion in China, 2012

Click [here](https://ruoqi-zhang.shinyapps.io/weibo_air_quality/) for the web application demonstrating the result of this project.

Air pollution and environmental protections are salient topics in China at least since 2013. This project examines the situation in 2012. Using Weiboscope data, we analyze the popularity of environment-related subjects, and explore whether air pollution issues have gained similar prominence as they do today.

If you'd like to chat about the project, you can contact me at `ruoqizhang [at] college.harvard.edu`.

## Getting Started

To run this project, other than the packages listed in the helper files, you would also need to install `Apache Spark` and `Geospark` on your environment. They enable us to do data processing on large datasets like Weiboscope Open Dataset.

Due to the size of the dataset, SDEI PM2.5 and Weiboscope are not included in the repository. For how the two datasets are set up in this project, read this project's README files for [SDEI PM2.5 Dataset](datasets/sdei-pm25/README.md), and [Weiboscope Open Dataset](datasets/weiboscope_data/README.md). For intermediary results, I recommend that you save them in parquet format.

## Acknowledgements

This project makes use of datasets generously released by researchers and developers of R packages, without which this Shiny application, in itself a testament of the vibrancy of R developer community, would not be possible. I would like to extend my thanks to the following scholars, researchers, and teams whose datasets form an essential part of this application.

### Weiboscope Open Data at Hong Kong University

King-wa Fu, CH Chan, and Michael Chau's amazing Weiboscope Open Dataset provides an interesting glimpse into the dynamic of Chinese Internet and civil society at that time prior to intensified repressions in recent years. With millions rows of records totaling over 45 Gigabyte, he Weiboscope Open Dataset, which encompasses Weibo posts and their matadata in 2012 for Weibo users with a subscriber base larger than 1,000 people, is unparalleled in its detailed recording of information and its special attention on the issue of censorship. 

Due to online censorship, Chinese Internet users are unable to access many sites that do not conform to government censorship requests or otherwise deemed sensitive. Those sites include widely used services including Twitter, Google, Facebook, Instagram, and Snapchat. Partially as a result of Chinese Internet users' limited access to foreign services, Weibo boasts a Monthly Active User based over 400 million and is widely regarded as one of the important barometer of China's public sentiment on social issues.

The team published its 2012 dataset that contains over 200 million Weibo posts that fit the previous criteria. In the dataset, each week's data is published separately.

Collected information include user's hashed id (`uid`), the platform used to publish the post (`source`),  whether the post contains image(s) (`image`), original text of the post (`text`), geospatial coordinate of the post (`geo`), and time of creation of the post (`created_at`).

Additionally, as Weibo is required to conform with government's censorship requirements in sensitive issues. This dataset also tracks whether the post is deleted. Weibo displays posts that are censored in different ways: either saying that it's deleted (`deleted_last_seen`) or the user does not have permission to view the post (`permission_denied`).

To access their dataset, please visit <https://hub.hku.hk/cris/dataset/dataset107483>.

Citation: King-wa Fu, CH Chan, and Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. <http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28>.

### U.S. Mission to China Air Quality Data

Citation: U.S. Department of State. 2019. U.S. Department of State Air Quality Monitoring Program. <http://www.stateair.net/web/historical/1/1.html>.

### NASA Socioeconomic Data and Applications Center (SEDAC)

NASA's Moderate Resolution Imaging Spectroradiometer (MODIS), Multi-angle Imaging SpectroRadiometer (MISR), and the Sea-Viewing Wide Field-of-View Sensor (SeaWiFS) observations are used by the researchers to estimate the concentration of fine particulae matters that is smaller than 2.5 milimeter. Such satellite data is not subject to human manipulation and is generally more accurate. 

This project utilizes Global Annual PM2.5 Grids from MODIS, MISR and SeaWiFS Aerosol Optical Depth (AOD) with GWR, v1 (1998–2016) derived from the previous observations. Ranging from 1998 to 2016, the data, provided in GeoTiff format, present a coherent outlook into the trend of air pollution in China.

Citation: van Donkelaar, A., R. V. Martin, M. Brauer, N. C. Hsu, R. A. Kahn, R. C. Levy, A. Lyapustin, A. M. Sayer, and D. M. Winker. 2016. Global Estimates of Fine Particulate Matter Using a Combined Geophysical-Statistical Method with Information from Satellites. Environmental Science & Technology 50 (7): 3762-3772. <https://doi.org/10.1021/acs.est.5b05833>.

### Global Administrative Areas Dataset

This project makes use of Global Administrative Areas (GADM) Dataset to assist in plotting out the boundaries between administrative entities and to categorize the longitude-latitude Weibo geo-location data into specific administrative areas. GADM dataset represents countries' actural control over territory. **The territory presented in the GADM dataset does not reflect the author's view on countries' sovereignty claims or territorial disputes.**

Citation: Global Administrative Areas (2018). GADM database of Global Administrative Areas, version 3.6. [online] URL: <https://www.gadm.org>.

### World Development Indicators, World Bank Group

This project makes use of World Bank Group's World Development Indicator to explore China's economic growth and continued urbanization process.

Citation: World Bank Development Indicators by the World Bank Group. Data licensed under CC BY 4.0.
