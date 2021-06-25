# Drawing Maps in R
This is an introductory course on spatial data taught within the CLIC Training workshops (funded by the GEOSMITE PROJECT) at the European University Institute.

## Lab’s Goals

- Introduce researchers to basic GIS concepts and how to read traditional GIS shapefiles in R
- Introduce researchers to the map outlines available in the maps package
- Show how to convert those data into data frames that ggplot2 can deal with
- Use ggmap and ggplot2 to make some pretty maps
- Discuss some ggplot2 related issues about plotting 
- Using sp to plot maps with different projections
- Bonus: calculate distances and applications

Requirements: basic R knowledge (ggplot2 and tidyverse) or a lot of interest and willingness to learn!

# Instructions

BEFORE WE START—very important:
 
### 1. Update R

Make sure you have the last R version (4.03), you can update it by downloading this version here:  https://cran.r-project.org
 
### 2. Obtain your API key from Google

THIS IS ESSENTIAL: Before we can start geocoding, we need to obtain an API key from Google. Go to the registration page, and follow the instructions (select all mapping options). The geocoding API is a free service, but up to a limit. That's why you nevertheless need to associate a card with the account (sorry about that!): https://cloud.google.com/maps-platform/#get-started
 
### 3. Set your working directory

Assign a folder with all the materials and set your working directory to the folder there, use your google key and the packages that we are going to use. You can also follow lines 1-18 in "exercises_datapoints.R"
 
 
### 4. Download the materials. 

The materials for this course consist on data files, slides, a shape file (municipios_y_distritos_madrid), and the corresponding R code and exercises. The slides not only contain information, but also the solution to the examples and exercises for each part. TMake sure you download all of them! The course is divided in two parts:

- Part I consists of exercises with data points.
- Part II consists of exercises with polygons.


