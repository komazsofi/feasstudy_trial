library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/height_calc/")

# read polygon measurement data in

meas_poly_sf=st_read("Measured_polygons.shp")
meas_poly_sf_onlyfractcrone=meas_poly_sf[grep("(kronedække)", meas_poly_sf$Parametr), ]

# classes present
# "2: 1-10%"   "4: 25-50%"  "1: 0%"      "3: 10-25%"  "5: 50-100%" "1) 0%"      "5) 50-100%" "2) 1-10%"   "3) 10-25%"  "4) 25-50%"  "5) >50%"
# clear up and make 1-5 classes 1: 0%, 2: 1-10%, 3: 10 - 25%, 4: 25 - 50%, 5: 50 - 100 % 

meas_poly_sf_onlyfractcrone$frac_class<-NA
meas_poly_sf_onlyfractcrone$frac_class[meas_poly_sf_onlyfractcrone$KodeNavn == "1: 0%" | meas_poly_sf_onlyfractcrone$KodeNavn == "1) 0%" ]="1"
meas_poly_sf_onlyfractcrone$frac_class[meas_poly_sf_onlyfractcrone$KodeNavn == "2: 1-10%" | meas_poly_sf_onlyfractcrone$KodeNavn == "2) 1-10%" ]="2"
meas_poly_sf_onlyfractcrone$frac_class[meas_poly_sf_onlyfractcrone$KodeNavn == "3: 10-25%" | meas_poly_sf_onlyfractcrone$KodeNavn == "3) 10-25%" ]="3"
meas_poly_sf_onlyfractcrone$frac_class[meas_poly_sf_onlyfractcrone$KodeNavn == "4: 25-50%" | meas_poly_sf_onlyfractcrone$KodeNavn == "4) 25-50%" ]="4"
meas_poly_sf_onlyfractcrone$frac_class[meas_poly_sf_onlyfractcrone$KodeNavn == "5: 50-100%" | meas_poly_sf_onlyfractcrone$KodeNavn == "5) >50%" ]="5"

# write into a shapefile

st_write(meas_poly_sf_onlyfractcrone,"meas_poly_sf_onlyfractcrone.shp")