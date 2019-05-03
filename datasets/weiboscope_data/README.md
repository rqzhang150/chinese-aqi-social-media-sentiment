# Setting up WeiboScope Open Dataset

Hong Kong University's WeiboScope Open Dataset contains more than 200 million Weibo posts and is larger than 45 Gigabytes. Therefore, it is unrealistic and would be a waste of space to upload these files to Github. The following document outlines the way this project sets up the WeiboScope Dataset.

## Download

You can download the WeiboScope Open Dataset from Hong Kong University's Website [here](https://hub.hku.hk/cris/dataset/dataset107483). Please make sure to cite the authors' paper. Its information is attached here:

King-wa Fu, CH Chan, Michael Chau. Assessing Censorship on Microblogs in China: Discriminatory Keyword Analysis and Impact Evaluation of the 'Real Name Registration' Policy. IEEE Internet Computing. 2013; 17(3): 42-50. http://doi.ieeecomputersociety.org/10.1109/MIC.2013.28

## Directory Structure

Simply extract the archives you've downloaded into this directory. Spark is set up in the project to read all the csv files in this directory. This should be what the directory looks like:

```
.
├── README.md - This README file.
├── .gitignore - Prevents the csv file from being pushed to Github.
├── week1.csv
├── week10.csv
├── week11.csv
├── week12.csv
├── week13.csv
├── week14.csv
├── week15.csv
├── week16.csv
├── week17.csv
├── week18.csv
├── week19.csv
├── week2.csv
├── week20.csv
├── week21.csv
├── week22.csv
├── week23.csv
├── week24.csv
├── week25.csv
├── week26.csv
├── week27.csv
├── week28.csv
├── week29.csv
├── week3.csv
├── week30.csv
├── week31.csv
├── week32.csv
├── week33.csv
├── week34.csv
├── week35.csv
├── week36.csv
├── week37.csv
├── week38.csv
├── week39.csv
├── week4.csv
├── week40.csv
├── week41.csv
├── week42.csv
├── week43.csv
├── week44.csv
├── week45.csv
├── week46.csv
├── week47.csv
├── week48.csv
├── week49.csv
├── week5.csv
├── week50.csv
├── week51.csv
├── week52.csv
├── week6.csv
├── week7.csv
├── week8.csv
└── week9.csv
```