library(data.table)
library(sf)
library(tidyverse)
library(sp)
library(raster)
library(rgeos)
library(rgdal)
library(xlsx)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/novana/NOVANAAndP3_tozsofia/")
data<-as.data.frame(fread("NOVANAAndP3_tozsofia.tsv",encoding="UTF-8"))
biowide_dk = readOGR(dsn="biowide_zones.shp")

data=data[data$Yeare>2015,]

# prep. plot database

data_plot=data %>% 
  group_by(data$AktID,data$Yeare,data$Habitat,data$HabitatID,data$UTM_X_orig,data$UTM_Y_orig) %>%
  summarize(Count=n())

# make a shapefile

data_plot_forshp=data_plot

names(data_plot_forshp) <- c("AktID","Year","Habitat","HabitatID","UTM_X","UTM_Y","SpRichness")

coordinates(data_plot_forshp)=~UTM_X+UTM_Y
proj4string(data_plot_forshp)<- CRS("+proj=utm +zone=32 +ellps=intl +towgs84=-87,-98,-121,0,0,0,0 +units=m +no_defs ")
raster::shapefile(data_plot_forshp,"Novana_plots_utm",overwrite=TRUE)

# intersect with regions

data_plot_forshp_biow=raster::intersect(data_plot_forshp,biowide_dk)
names(data_plot_forshp_biow) <- c("AktID","Year","Habitat","HabitatID","SpRichness","Region")

data_plot_forshp_biow_df=data_plot_forshp_biow@data
raster::shapefile(data_plot_forshp_biow,"data_plot_forshp_biow_utm",overwrite=TRUE)

# add aggregated groups

data_plot_forshp_biow_df$HabGroup=NA

data_plot_forshp_biow_df$HabGroup[data_plot_forshp_biow_df$HabitatID == 1210 |data_plot_forshp_biow_df$HabitatID == 1220 |data_plot_forshp_biow_df$HabitatID == 1230 |
                                     data_plot_forshp_biow_df$HabitatID == 2110 |data_plot_forshp_biow_df$HabitatID == 2120 |data_plot_forshp_biow_df$HabitatID == 2130
                                   |data_plot_forshp_biow_df$HabitatID == 2140 | data_plot_forshp_biow_df$HabitatID == 2160 |data_plot_forshp_biow_df$HabitatID == 2170
                                   |data_plot_forshp_biow_df$HabitatID == 2190 |data_plot_forshp_biow_df$HabitatID == 2250 |data_plot_forshp_biow_df$HabitatID == 2310
                                   |data_plot_forshp_biow_df$HabitatID == 2330 | data_plot_forshp_biow_df$HabitatID == 4030 |data_plot_forshp_biow_df$HabitatID == 5130
                                   |data_plot_forshp_biow_df$HabitatID == 6120 |data_plot_forshp_biow_df$HabitatID == 6210 |data_plot_forshp_biow_df$HabitatID == 6230
                                   |data_plot_forshp_biow_df$HabitatID == 8220]="Nature dry"

data_plot_forshp_biow_df$HabGroup[data_plot_forshp_biow_df$HabitatID == 1310 |data_plot_forshp_biow_df$HabitatID == 1320 |data_plot_forshp_biow_df$HabitatID == 1330 |
                                    data_plot_forshp_biow_df$HabitatID == 1340 |data_plot_forshp_biow_df$HabitatID == 4010 |data_plot_forshp_biow_df$HabitatID == 6410
                                  |data_plot_forshp_biow_df$HabitatID == 7120 | data_plot_forshp_biow_df$HabitatID == 7140 |data_plot_forshp_biow_df$HabitatID == 7150
                                  |data_plot_forshp_biow_df$HabitatID == 7210 |data_plot_forshp_biow_df$HabitatID == 7220 |data_plot_forshp_biow_df$HabitatID == 7230]="Nature wet"

data_plot_forshp_biow_df$HabGroup[data_plot_forshp_biow_df$HabitatID == 9100 ]="Forest"

# for single year: how many plots per habitat per region

nofplots_perhabreg_yearly=data_plot_forshp_biow_df %>% 
  group_by(HabitatID,Habitat,Region, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

nofplots_perhab_yearly=data_plot_forshp_biow_df %>% 
  group_by(HabitatID,Habitat, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

write.xlsx(nofplots_perhabreg_yearly, file = "nofplots.xlsx",
           sheetName = "perhabperreg", append = FALSE,showNA=FALSE)

write.xlsx(nofplots_perhab_yearly, file = "nofplots.xlsx",
           sheetName = "perhab", append = TRUE,showNA=FALSE)

nofplots_perhabreg_yearly_agr=data_plot_forshp_biow_df %>% 
  group_by(HabGroup,Region, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

nofplots_perhab_yearly_agr=data_plot_forshp_biow_df %>% 
  group_by(HabGroup, Year) %>%
  summarize(Count=n()) %>%
  spread(Year, Count) %>% 
  ungroup()

write.xlsx(nofplots_perhabreg_yearly_agr, file = "nofplots_aggr.xlsx",
           sheetName = "perhabperreg_aggr", append = FALSE,showNA=FALSE)

write.xlsx(nofplots_perhab_yearly_agr, file = "nofplots_aggr.xlsx",
           sheetName = "perhab_aggr", append = TRUE,showNA=FALSE)

# spatial distribution

biowide_dk_sf=st_as_sf(biowide_dk)
data_plot_forshp_biow_sf=st_read("data_plot_forshp_biow_utm.shp")

ggplot()+geom_sf(data = biowide_dk_sf)+
  geom_sf(data = data_plot_forshp_biow_sf, aes(color = Habitat),size=2)+
  facet_wrap(facets = vars(Year))+
  theme_bw()

habitats=unique(data_plot_forshp_biow_sf$HabitatID)

for (i in habitats){
  
  print(i)
  
  #print(ggplot()+geom_sf(data = biowide_dk_sf)+
  #geom_sf(data = data_plot_forshp_biow_sf[data_plot_forshp_biow_sf$Habitat==i,], aes(color = Habitat),size=2)+
  #facet_wrap(facets = vars(Year))+
  #theme_bw())
  
  myplot=ggplot()+geom_sf(data = biowide_dk_sf)+
    geom_sf(data = data_plot_forshp_biow_sf[data_plot_forshp_biow_sf$HabitatID==i,], aes(color = Habitat),size=2)+
    facet_wrap(facets = vars(Year))+
    theme_bw()
  
  ggsave(paste(i,".png",sep=""),plot=myplot)
  
}

