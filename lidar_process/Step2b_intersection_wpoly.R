library(sf)
library(stars)
library(ggplot2)
library(dplyr)
library(raster)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/height_calc/")

# Load list of EcoDes-DK15 descriptors
#raster_list <- shell("dir /b /s O:\\Nat_Sustain-proj\\_user\\ZsofiaKoma_au700510\\FeasStudy\\processing\\lidar\\dhm2015\\*.vrt",
#intern = T) 
#raster_list <- gsub("\\\\", "/", raster_list)

#lidar_metrics=stack(raster_list)

density=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/lidar/dhm2015_processed/density_masked_a2.tif")
crs(density)<-crs("+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

# Field data polygons

frac_cover_poly=st_read("meas_poly_sf_onlyfractcrone.shp")

# extract mean density value for polygons

frac_cover_poly_wlidar=extract(density, frac_cover_poly, fun = mean)
frac_cover_poly_wlidar_c=cbind(frac_cover_poly,frac_cover_poly_wlidar)
write.csv(frac_cover_poly_wlidar_c,"frac_cover_poly_wlidar_c.csv")

