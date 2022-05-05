library(rgdal)
library(raster)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/novana/NOVANAAndP3_tozsofia/")

# Load list of EcoDes-DK15 descriptors
raster_list <- shell("dir /b /s O:\\Nat_Sustain-proj\\_user\\ZsofiaKoma_au700510\\FeasStudy\\processing\\lidar\\dhm2015\\*.vrt",
                     intern = T) 
raster_list <- gsub("\\\\", "/", raster_list)

lidar_metrics=stack(raster_list)

# read in the plot database

plot_db=read.csv("plot_db_welberg.csv")
plot_db_2016=plot_db[plot_db$Year==2016,]

# make a shapefile

data_plot_forshp=plot_db_2016

coordinates(data_plot_forshp)=~UTM_X+UTM_Y
proj4string(data_plot_forshp)<- CRS("+proj=utm +zone=32 +ellps=intl +towgs84=-87,-98,-121,0,0,0,0 +units=m +no_defs ")

# intersect

metrics <- extract(lidar_metrics,data_plot_forshp)

plt_db_wlidar=cbind(data_plot_forshp@data,metrics)

write.csv(metrics,"onlymetrics.csv")
write.csv(plt_db_wlidar,"plt_db_wlidar.csv")