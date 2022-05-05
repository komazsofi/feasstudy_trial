library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)
library(data.table)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/height_calc/")

# read point measurement data in

meas_points_sf=st_read("Measured_points.shp")
meas_points_sf_onlyh=meas_points_sf[grep("Vegetationshøjde", meas_points_sf$Parametr), ]
meas_points_sf_onlyh_c=meas_points_sf_onlyh[meas_points_sf_onlyh$ProgNavn=="Overvågning af lysåbne naturtyper (2011-2016)",]

meas_points_sf_onlyh_c_coord=st_coordinates(meas_points_sf_onlyh_c)
meas_points_sf_onlyh_c_wcood=cbind(meas_points_sf_onlyh_c,meas_points_sf_onlyh_c_coord)

meas_points_sf_onlyh_c_df=as.data.frame(meas_points_sf_onlyh_c_wcood)
meas_points_sf_onlyh_c_df$meanheight=ave(meas_points_sf_onlyh_c_df$Valuee,meas_points_sf_onlyh_c_df$AktID)

# group it by id and year calculate mean height

meanheight_meas_plot=meas_points_sf_onlyh_c_df %>% 
  group_by(meas_points_sf_onlyh_c_df$AktID,meas_points_sf_onlyh_c_df$meanheight,meas_points_sf_onlyh_c_df$X,meas_points_sf_onlyh_c_df$Y) %>%
  summarize(Count=n())

names(meanheight_meas_plot)<-c("AktID","meanheight","X","Y","Count")

# export
write.csv(meanheight_meas_plot,"meanheight_plot.csv")

# read polygon measurement data in

meas_poly_sf=st_read("Measured_polygons.shp")
