library(tidyverse)
library(MASS)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/height_calc/")

point_height=read.csv("plt_db_height_wlidar.csv")
frac_cover=read.csv("frac_cover_poly_wlidar_c.csv")

# estimation of point height

ggplot(data=point_height,aes(x=canopy_height/100,y=meanheight*0.01))+geom_point()+ ylab("Field based mean height [m]") + xlab("Vegetation height [m]") + theme_bw(base_size = 17)

# estimation of cover fraction

frac_cover_c2=frac_cover[is.na(frac_cover$frac_class)==FALSE,]

ggplot(data=frac_cover_c2,aes(x=frac_cover_poly_wlidar,y=as.factor(frac_class)))+geom_point()+ xlab("Vegetation density above 2m [%]") + ylab("Woody cover fraction [%]") + theme_bw(base_size = 17)+
  scale_y_discrete(labels=c("1" = "0%", "2" = "1-10%",
                            "3" = "10-25%", "4" = "25-50%", "5"="50-100%"))

m=polr(as.factor(frac_class) ~ frac_cover_poly_wlidar, data = frac_cover, Hess=TRUE)
summary(m)