---
title: "Drawing beautiful maps in R"
author: "Mar Espadafor"
date: "17/11/2020"
output: beamer_presentation
---

```{r setup, include=FALSE}
#setwd("~/Desktop/Lab R-Geography")
library(tidyverse)
library(ggplot2)
library(ggmap)
library(sp)
library(haven)
library(tmaptools)
schools10<-read_dta("schools10.dta")
schools<-read_dta("schools.dta")
bets<-read_dta("bets.dta")
register_google(key = "AIzaSyAblmReH4FA5fZW50f5l6-HndvsNAL4_nM")
```

## Before we start (I)

- Make sure you have the last R version (4.03), you can update it by downloading this version here:


 https://cran.r-project.org


- Before we can start geocoding, we need to obtain an API key from Google. Go to the registration page, and follow the instructions (select all mapping options). The geocoding API is a free service, but up to a limit. That's why you nevertheless need to associate a card with the account (sorry about that!).


https://cloud.google.com/maps-platform/#get-started

## Before we start (II)

- Now, set your working directory to the folder where all the materials, use your google key and the packages that we are going to use. You can also follow lines 1-18 in "exercises_datapoints.R"

- Read about different coordinate systems, map projections and transformations: 

http://resources.esri.com/help/9.3/arcgisengine/dotnet/89b720a5-7339-44b0-8b58-0f5bf2843393.htm


## Intro: Types of spatial data in a nutshell:
Using coordinates (longitude and latitude) we can create the following types of data:

![s](spatial_data_types.jpg)

##Intro: Feature types and their representations

![s](Feature-types-and-their-representations-in-two-spatial-data-models.png)

##Intro: Differences between vector and raster model:
![s](vector_vs_raster.jpg)


