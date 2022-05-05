library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/height_calc/")

# read data in

meas_points_sf=st_read("Measured_points.shp")
meas_points_sf_onlyh=meas_points_sf[grep("Vegetationshøjde", meas_points_sf$Parametr), ]
meas_points_sf_onlyh_c=meas_points_sf_onlyh[meas_points_sf_onlyh$ProgNavn=="Overvågning af lysåbne naturtyper (2011-2016)",]

# group it by id and year calculate mean height

meanheight_meas_plot=meas_points_sf_onlyh_c %>% 
  group_by(meas_points_sf_onlyh_c$AktID,meas_points_sf_onlyh_c$Yeare) %>%
  summarize(mean_height=mean(meas_points_sf_onlyh_c$Valuee))