---
title: "Drawing beautiful maps in R II"
author: "Mar Espadafor"
date: "17/11/2020"
output: beamer_presentation
---

```{r setup, include=FALSE}
#setwd("~/Desktop/Lab R-Geography")
library(tmap)
library(dplyr)
library(rgdal) #to import shapefiles
library(broom) #to convert shapefiles into the data frame structure we need
library(haven)
library(ggmap)
schools10<-read_dta("schools10.dta")
schools<-read_dta("schools.dta")
bets<-read_dta("bets.dta")
income<- read_dta("basedatos.dta")
betting<- read_dta("mc_income.dta")

register_google(key = "your key")
```

## COMMON TYPES OF SPATIAL DATA

- Point data
- Line data (multiple points connected)
- Polygon data (associated to area restricted within connected points)
- Raster data (aka grided), use with satellite

## Polygons 
Can be descibred by a collection of points.

- Census districts

- Wards: areas with roughly equal number of peoples (MCS)

Drawing polygons is tricky:

- Order matters

- Some areas may need more than one polygon (think of a city, with a lake in the middle)

## Drawing polygons (I)

- In ggplot2, polygons are drawn with geom_polygon(). Each row of your data is one point on the boundary and points are joined up in the order in which they appear in the data frame. You specify which variables describe position using the x and y aesthetics and which points belong to a single polygon using the group aesthetic.

## Drawing polygons (II)

- Remember the two tricky things about polygons? An area may be described by more than one polygon and order matters.  

- *Group* is an identifier for a single polygon, but a ward may be composed of more than one polygon, so you would see more than one value of group for such a ward.  

- *Order* describes the order in which the points should be drawn to create the correct shapes.

## INTRODUCING SP OBJECTS

So far we have been using dataframes, which is great because we know how to deal with them and visualize them.

However there is no easy way to keep coordinate reference system information within our data frames???

As soon as you have more than one coordinate references, this becomes a mess!

## INTRODUCING SP OBJECTS

-	Inefficient for complicated spatial objects

-	Hierarchical structure gets forced into a flat structure

Spatial objects for spatial data: sp package

-	Provides classes for storing different types of spatial data

-	Provides methods for spatial objects, for manipulation

Is useful for point line and polygon data!

New spatial packages expect data in a sp object, putting time to understand them now, will pay off in the future!

## Loading spatial object:

Going to GADM you can freely download any country map in a format of *SpatialPolygonsDataFrame*. Most of the countries has multiple levels. The free version includes some information such as population.

Here is a simple example:

```{r Example 1, echo=TRUE, message=FALSE, warning=FALSE}
download.file("http://biogeo.ucdavis.edu/data/gadm2.8/rds/FRA_adm1.rds",
              "FRA_adm1.rds", mode = "wb")
france_sp = readRDS("FRA_adm1.rds")

```

## Loading spatial object:
Exercise I:
Can you try loading a different country? Run lines 1-15 and try from lines 16-17

```{r Exercise 2, echo=TRUE, message=FALSE, warning=FALSE}
download.file("http://biogeo.ucdavis.edu/data/gadm2.8/rds/ITA_adm1.rds",
              "ITA_adm1.rds", mode = "wb")
italy_sp = readRDS("ITA_adm1.rds")

```

## Let's take a look at the spatial object we created:

We've loaded *france_sp* into our workspace. There are special version of functions that we can try out for these type of objects. Try the following:
Exercise II 

- Print france_sp

- Call summary on france_sp

- Call plot on france_sp

You can follow lines 21-28 in the exercises_polygons.R file.

## Our first SP map!
```{r map france, echo=TRUE, message=FALSE, warning=FALSE}
plot(france_sp)
```

## What's inside this spatial object? (II)

- Print() gives us as printed form of the object, too long and messy.

- Summary() provides a better description of the object, including its class (spatialpolygon), the coordinate reference system and other info.

- Plot() displays the contents, in the case drawing the map of France.

## What's inside this spatial object? (II)
Exercise III:

-	Call str() on countries_sp.  This won't be very helpful, except to convince you this is a complicated stucture!

-	Call str() on countries_sp, setting max.level to 2. What is at the highest level of this object? Can you see where things might be stored?

## More complications...

The structure of france_sp is different that a normal data frame. It looks like a list, but instead of elements being proceeded by $ in the output, they are proceeded by an @.

This is because sp classes are S4 objects!

## Walking the hierarchy
Try running the following code (lines 31-34)
```{r Example 2, echo=TRUE, message=FALSE, warning=FALSE}
#str(france_sp, max.level = 2)
```

Its a list of 22 polygons, any guessess what they might represent?

## Let's take a deeper look:

Let's take another look at the 10th element in the Polygons slot of france_sp. Run this code from the previous exercise
```{r Example 3, echo=TRUE, message=FALSE, warning=FALSE}
tenth <- france_sp@polygons[[10]]
str(tenth, max.level = 2)
```

## Accessing data in sp objects:
Exercise 5 (lines39-49)
Instead of $ or [[]] subsetting on a *spatialdataframe* pull columns directly from the data frame (lines40-45)

-	Call head() and str() (one at a time) on the data slot of france_sp.  Verify that this object is just a regular data frame.

-	Pull out the name column of france_sp using $.

-	Pull out the subregion column of france_sp using [[.

## Tmap package works with sp objects


- qtm(): function for quick thematic maps

- qlot(): similar to ggplot

- Important: tmap doesn't use non-stantdard evaluation, so variables *need* to be surrounded by quotes!!

## Merging data 
Every spatial object has a coordinate reference system (CRS) associated with it


- proj4string() function returns the CRS

- spTransform() in the rgdal helps us to do so.

```{r Example 4, echo=TRUE, message=FALSE, warning=FALSE}
library(sp)
library(raster)
# Use spTransform on first_object:
#spTransform(first_object, proj4string(second_object))
# Check
#head(coordinates(first_object))
```

## Let's download an sp file
Follow lines 51-58
```{r Example 5, echo=TRUE, message=FALSE, warning=FALSE}
temp <- tempfile(fileext = ".zip")
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2013_01M_SH.zip", temp)
unzip(temp)
```

## Let's download an sp file
Follow lines 51-58
```{r Example 6, echo=TRUE, message=FALSE, warning=FALSE}
#load the data and filter 
EU_NUTS = readOGR(dsn = "./NUTS_2013_01M_SH/data", layer = "NUTS_RG_01M_2013")
#Explore the spatialdataframe:
summary(EU_NUTS)
# plot EU_NUTS
plot(EU_NUTS)
```
## Let's try to color the map. 
Using data from euroestats at NUTS-2. The problem is that we need to first subset our EU_NUTS data and keep only NUTS-2
```{r Example 7, echo=TRUE, message=FALSE, warning=FALSE}

#Subset our map
eu_nuts2 <- subset(EU_NUTS, STAT_LEVL_ == 2) # set NUTS level
```

We know that NUTS2 id is "NUTS_ID" for "eu_nuts"" and region for the income dataset 
How would you merge it?

## Mergin solutions
```{r Example 8, echo=TRUE, message=FALSE, warning=FALSE}
nuts_merge<- merge(eu_nuts2, income, by.x="NUTS_ID", by.y="region")
```

Now is time to choose a variable, and map the color to it, try to do it in lines 80-82 
## Color solution
```{r Example 9, echo=TRUE, message=FALSE, warning=FALSE}
# Choose a variable  with col mapped to it
tm_shape(nuts_merge) +
  tm_fill(col = "GDPpc2017") 
```

## Example using madrid data

Load the shape file, do you remember how to do it? HINT: read***
Run lines 89-112, it's just some recoding.
- Lines 89-109 creates a list with the municipality names
- Line 111 creates a new SDF subsetting it to only the municipalities listed as "madrid_city"
- Plot Madrid city map!
```{r no run, message=FALSE, warning=FALSE, include=FALSE}

#lets try going back to Madrid
# Since the data is not very good lets move on to Madrid again:
sf_madrid <- readOGR("municipios_y_distritos_madrid.shp")
sf_madrid$municipio_
#We want to keep only municipios in Madrid city
madrid_city<- c( "Madrid-Retiro",                               
                 "Madrid-Salamanca",                            
                 "Madrid-Centro",                               
                 "Madrid-Arganzuela",                           
                 "Madrid-Chamart\303\255n",                     
                 "Madrid-Tetu\303\241n",                        
                 "Madrid-Chamber\303\255",                      
                 "Madrid-Fuencarral-El Pardo",                  
                 "Madrid-Moncloa-Aravaca",                      
                 "Madrid-Latina",                               
                 "Madrid-Carabanchel",                          
                 "Madrid-Usera",                                
                 "Madrid-Puente de Vallecas",                   
                 "Madrid-San Blas-Canillejas",                
                 "Madrid-Barajas",                              
                 "Madrid-Moratalaz",                            
                 "Madrid-Ciudad Lineal",                        
                 "Madrid-Hortaleza",                            
                 "Madrid-Villaverde",                           
                 "Madrid-Villa de Vallecas",                    
                 "Madrid-Vic\303\241lvaro")     

madrid_city_map <- sf_madrid[sf_madrid$municipio_ %in% madrid_city, ]
```

## Plotting 
```{r Example 10, echo=TRUE, message=FALSE, warning=FALSE}
plot(madrid_city_map)
```

## Mapping numbers to color:

-	Ggplot2 map to a continuous gradient of color
-	Continuous map: control mapping by transforming the scale (e.g. log)
-	 Tmap map to a discrete set of colors
-	Discrete map: control mapping by binning the variable

## Colouring by income

- Rune lines 118-142, here we are just loading the data and generating a new variable ID that will match our original shapefile
- The following lines (145-146) check for duplicates;
```{r no2, message=FALSE, warning=FALSE, include=FALSE}

betting$municipality<-case_when(
  betting$distrito==1  ~ "Madrid-Arganzuela",
  betting$distrito==2  ~ "Madrid-Barajas",
  betting$distrito==3  ~ "Madrid-Carabanchel",
  betting$distrito==4  ~ "Madrid-Centro",
  betting$distrito==5  ~ "Madrid-Chamart\303\255n",
  betting$distrito==6  ~ "Madrid-Chamber\303\255",
  betting$distrito==7  ~ "Madrid-Ciudad Lineal",
  betting$distrito==8  ~ "Madrid-Fuencarral-El Pardo",
  betting$distrito==9  ~ "Madrid-Hortaleza",
  betting$distrito==10  ~ "Madrid-Latina",
  betting$distrito==11  ~ "Madrid-Moncloa-Aravaca",
  betting$distrito==12  ~ "Madrid-Moratalaz",
  betting$distrito==13  ~ "Madrid-Puente de Vallecas",
  betting$distrito==14  ~ "Madrid-Retiro",
  betting$distrito==15  ~ "Madrid-Salamanca",
  betting$distrito==16  ~ "Madrid-San Blas-Canillejas",
  betting$distrito==17  ~ "Madrid-Tetu\303\241n",
  betting$distrito==18  ~ "Madrid-Usera",
  betting$distrito==19  ~ "Madrid-Vic\303\241lvaro",
  betting$distrito==20  ~ "Madrid-Villa de Vallecas",
  betting$distrito==21  ~ "Madrid-Villaverde")
```
## Load back new data from betting project:

```{r Example 11, echo=TRUE, message=FALSE, warning=FALSE}
any(duplicated(betting$municipality))
any(duplicated(madrid_city_map$municipio_))
```

Now, try merging it yourself using the previous example.
## Try merging: solution
```{r Example 12, echo=TRUE, message=FALSE, warning=FALSE}
madrid_merge<- merge(madrid_city_map, betting, by.x="municipio_", by.y="municipality")
```

## Fast map:
```{r Example 13, echo=TRUE, message=FALSE, warning=FALSE}

spplot(madrid_merge, "renta", main = "Income")

```

## Using tm_shape
```{r Example 14, echo=TRUE, message=FALSE, warning=FALSE}
# Plot from last exercise
tm_shape(madrid_merge) +
tm_fill(col = "renta", palette = "Greens")
# Save a static version "population.png"
#tmap_save(filename = "madrid_income.png")
````
You can see that there are many other functions in tmap such as tm_bordes, tm_bubles and many more (see lines 173-184)

## Traditional ShapeFiles: 

Now that we are more or less proficient, let's take a look at how to handle traditional shape files. Lines 188 to 199 do the following:
```{r Example 15, echo=TRUE, message=FALSE, warning=FALSE}
#Converting it to df:
madrid_df <- tidy(sf_madrid)
# Recover row name
temp_df <- data.frame(sf_madrid$municipio_)
#creating numeric id
temp_df$id <- as.character(seq(0,nrow(temp_df)-1))
#joinning two datas
madrid_df2 <- left_join(madrid_df, temp_df, by="id")
```

Can you try filtering our new df file by taking out only districts in Madrid City? (line 201)

## MERGIN

For mergin the data set where we have our income data we need to:

1. We have filtered our madrid_df so that only contains Madrid City districts (line 201)

2. Rename one of our variables so that the same variable is in both dataframes (line 204)

3. Then do a lef_join by using that variable (207-208)

## Solution to mergin:
```{r Example 16, echo=TRUE, message=FALSE, warning=FALSE}

#madrid_df3<- madrid_df2 %>% filter(sf_madrid.municipio_==madrid_city)

#madrid_df3$municipio_<-madrid_df3$sf_madrid.municipio_

# madrid_city_map2 <- madrid_df3%>%
#  left_join(betting, by = "municipio_")
```

## Now we are ready to plot our first map!
```{r Example 17, echo=TRUE, message=FALSE, warning=FALSE}
#madrid_city_map2%>%
  #you should be using the following aesthetics for any plot you make:
#  ggplot(aes(x=long, y = lat, group = group))+
 # geom_polygon()
```
![s](map_feo.jpeg)
## Doing some twicks

Try the following (lines 216-234)

- Fill the amp with "renta" variable
- Load the viridis palette
- Choose a different theme
- Choose viridis scale and add a legend title


## LAST MAP

![m](map3.jpeg)
