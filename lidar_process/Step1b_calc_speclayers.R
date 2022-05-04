library(raster)
library(rgdal)

workingdir="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/lidar/dhm2015_processed/"
setwd(workingdir)

height=raster("canopy_height_corr.tif")
density=raster("vegetation_density_corr.tif")

height_class_b1=reclassify(height, c(c(-Inf,1,1,1,3,0,3,5,0,5,Inf,0)))
height_class=reclassify(height, c(c(-Inf,1,1,1,3,2,3,5,3,5,25,4,25,Inf,5)))

writeRaster(height_class_bush,"height_classes.tif",overwrite=TRUE)

density_masked_b1 <- mask(density, height_class_b1,maskvalue=0)
writeRaster(density_masked_b1,"density_masked_b1.tif",overwrite=TRUE)

density_masked_a1 <- mask(density, height_class_b1,maskvalue=1)
writeRaster(density_masked_a1,"density_masked_a1.tif",overwrite=TRUE)

