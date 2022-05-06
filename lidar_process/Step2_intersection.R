library(rgdal)
library(raster)
library(ggplot2)

#setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/novana/NOVANAAndP3_tozsofia/")
setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/height_calc/")

# Load list of EcoDes-DK15 descriptors
raster_list <- shell("dir /b /s O:\\Nat_Sustain-proj\\_user\\ZsofiaKoma_au700510\\FeasStudy\\processing\\lidar\\dhm2015\\*.vrt",
                     intern = T) 
raster_list <- gsub("\\\\", "/", raster_list)

lidar_metrics=stack(raster_list)

# read in the plot database

#plot_db=read.csv("plot_db_welberg.csv")
#plot_db_2016=plot_db[plot_db$Year==2016,]

plot_db=read.csv("meanheight_plot.csv")

# make a shapefile

data_plot_forshp=plot_db

coordinates(data_plot_forshp)=~X+Y
proj4string(data_plot_forshp)<- CRS("+proj=utm +zone=32 +ellps=intl +towgs84=-87,-98,-121,0,0,0,0 +units=m +no_defs ")

# intersect

metrics <- extract(lidar_metrics,data_plot_forshp)
plt_db_wlidar=cbind(data_plot_forshp@data,metrics)
write.csv(plt_db_wlidar,"plt_db_height_wlidar.csv")
