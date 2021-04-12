#Set working directory
setwd("~/Desktop/Lab R-Geography ")
#Set your API key
register_google(key= "YOURKEY")

##################################
## WARNING:  Remove # to install:
# install.packages("ggmap")
#install.packages("ggplot2")
#install.packages("tidyverse")
#install.packages("haven")
#install.packages("tmaptools")
##################################

library(ggmap) #geocode and grab maps
library(ggplot2) # nice graphs :)
library(tidyverse) #manage our data
library(haven) #read and write .dta
library(tmaptools) # Open Street Maps tools

##################################
#EXERCISE I: Geolocate Madrid ####
##################################
madrid<-___("____")
# Get map at zoom level 5: fmap and plot it
mmap<- ___(__, zoom=___ , scale = 1)
ggmap(___)
#get a map at zoom level 12 and plot it
fmap12<-___(____)
___(___)

#BONUS: shorter way around it:
madrid_map<-___(____(_____),zoom= 12, scale=1)

##################################
# EXERCISE II: Geolocate schools # 
##################################

#load the data:
schools10<-read_dta("schools10.dta")
# The variable adress2 has the location of each school
#wrong way
schools10_f<- geocode(schools10$address2)
schools10$fake<-geocode(schools10$address2)
# the way
schools10_locations<- ___geocode(schools10, address2)

#################################################
#EXERCISE III: Layer schools into Madrid's map ##
#################################################
___(madrid_map)+
  geom_point(aes(__,__), data=_________)

# Look at the warning message: what do you think it happened?

# Redo the map so that all schools are mapped in!!
madrid_map<-get_map(geocode("Madrid"),zoom= 11, scale=1)
ggmap(madrid_map)+
  geom_point(aes(lon,lat), data=schools10_locations)

##################################
# EXCERCISE IIIb
##################################
#The default Google map downloaded by get_map() is useful when you need major roads, 
#basic terrain, and places of interest, but visually it can be a little busy. 
#You want your map to add to your data, not distract from it, so it can be useful to have other "quieter" options.
# Take a look at: http://maps.stamen.com/#toner/12/37.7706/-122.3782

# Change the type of map:
madrid_map<-get_map(geocode("Madrid"),zoom= 12, scale=1, ____ = "_____")
ggmap(madrid_map)+
  geom_point(aes(lon,lat), data=schools10_locations)

# EXERCISE IV: Layer two different type of point data:
# Now lets geolocate two different type of things: schools and betting houses

# Load "schools.dta" and "bets.dta"

schools<-read_dta("schools.dta")
bets<-read_dta("bets.dta")

# Let's plot again schools, now all of them:
____(_____)+
____(_(__,__), __=__)+
____(_(__,__), __=__)+
  
# How can we differenciate them? Use the argument color
  ____(_____)+
  ____(_(__,__), __=__, ___=___)+
  ____(_(__,__), __=__, ___=___)+

# How can we see if they differ by type of school?
ggmap(madrid_map)+
  geom_point(aes(lon,lat), data=schools, color="blue")+
  facet_wrap(~____)+
  geom_point(aes(lon,lat), data=apuestas, color="red")

####################################################################
#EXTRA BONUS: alternative way of geolocating using tmaptools
library(tmaptools)
streets <- "Adramuttiou, Thessaloniki, Greece"
#inspect streets
streets_tmaptools <- geocode_OSM(paste("street ", streets),
                                 details = TRUE, as.data.frame = TRUE)
head(streets_tmaptools)
####################################################################

