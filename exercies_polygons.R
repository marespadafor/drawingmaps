rm(list = ls())
setwd("~/Desktop/Lab R-Geography ")
#library(sf)
library(tmap)
library(dplyr)
library(rgdal) #to import shapefiles
library(broom) #to convert shapefiles into the data frame structure we need
library(haven)
library(ggmap)

#EXAMPLE I: Downloading a file
download.file("http://biogeo.ucdavis.edu/data/gadm2.8/rds/ITA_adm1.rds",
              "ITA_adm1.rds", mode = "wb")
italy_sp = readRDS("ITA_adm1.rds")

#EXERCISE I: Try downloading another country of your choice
download.file("http://biogeo.ucdavis.edu/data/gadm2.8/rds/FRA_adm1.rds",
              "FRA_adm1.rds", mode = "wb")
france_sp = readRDS("FRA_adm1.rds")
#EXERCISE II
# Print france_sp
__(___)
# Call summary() on france_sp
___(___)
#check the structure of the data
___@___
# Call plot() on france_sp
plot(____)
# Call str on france_sp
str(france_sp)
#EXERCISE IV
#Try running the following code
str(france_sp, max.level = 2)
str(france_sp@polygons, max.level=2)

# Taking a deeper look:
tenth <- france_sp@polygons[[10]]
str(tenth, max.level = 2)
#EXERCISE V
# Call head() and str() on the data slot of countries_spdf
head(france_sp@data)
str(france_sp@data)

# Pull out the name column using $
france_sp$NAME_1
# Pull out the subregion column using [[
france_sp[["NAME_1"]]
# Subsetting
france_centre<- france_sp$NAME_1 == "_____"

##########################################################
# Let's work with tmap:
library(tmap)

#Let's download  the sp file
temp <- tempfile(fileext = ".zip")
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2013_01M_SH.zip", temp)
unzip(temp)

#load the data and filter 
EU_NUTS = readOGR(dsn = "./NUTS_2013_01M_SH/data", layer = "NUTS_RG_01M_2013")

#Explore the spatialdataframe:
summary(EU_NUTS)
# plot EU_NUTS
plot(EU_NUTS)

#Subset our map
eu_nuts2 <- subset(EU_NUTS, STAT_LEVL_ == 2) # set NUTS level
eu_nuts2

# inomce is a dataframe that contains income data NUTS-2
income<- read_dta("basedatos.dta")
income$region

#Merge eurost to EU_NUTS
nuts_merge<- merge(eu_nuts2, income, by.x="NUTS_ID", by.y="region")
#Call Summary
summary(nuts_merge)
# Choose a variable  with col mapped to it
tm_shape(nuts_merge) +
  tm_fill(col = "GDPpc2017") 

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

#Now we have our sp of Madrid city only
madrid_city_map
plot(madrid_city_map)

# Load back new data from betting project:
betting<- read_dta("mc_income.dta")
betting$distrito

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

# Check for duplicates 
any(duplicated(betting$municipality))
any(duplicated(madrid_city_map$municipio_))

# Mergin the two datasets:
madrid_merge<- merge(____, ____, by.x="_____", by.y="______")

# fast way:
spplot(madrid_merge, "renta")
spplot(madrid_merge, "renta", main = "Income")

#THIS DOESNT WORK
#ggmap(madrid_map) +
#  geom_sf(data = madrid_merge ,aes(fill=renta), inherit.aes = FALSE) #error


library(sp)
library(tmap)

# Plot from last exercise
tm_shape(madrid_merge) +
  tm_fill(col = "renta")
# Save a static version "population.png"
tmap_save(filename = "madrid_income.png")


# Add style argument to the tm_fill() call
tm_shape(france_sp) +
  tm_fill(col = "", style="") +
  # Add a tm_borders() layer 
  tm_borders(col="")
# New plot, with tm_bubbles() instead of tm_fill()
tm_shape(countries_spdf) +
  tm_bubbles(size = "population", style="quantile") +
  # Add a tm_borders() layer 
  tm_borders(col="burlywood4")
# Save a static version "population.png"
tmap_save(filename = ".png")




