library(tidyverse)

library(ggplot2)
library(gridExtra)
library(GGally)
library(corrplot)
library(ggpubr)

library(randomForest)
library(caret)
library(e1071)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/intermediate_results_2022May/")

height=read.csv("plt_db_height_wlidar.csv")
cover=read.csv("frac_cover_poly_wlidar_c.csv")
veg_db_wlidar=read.csv("plt_db_wlidar.csv")

##### height

# convert values

height$meanheight=height$meanheight*0.01
height$twi=height$twi/1000
height$vegetation_density=height$vegetation_density/10000
height$normalized_z_mean=height$normalized_z_mean/100
height$normalized_z_sd=height$normalized_z_sd/100
height$canopy_openness=height$canopy_openness/10000
height$heat_load_index=height$heat_load_index/10000
height$canopy_height=height$canopy_height/100

# lidar accuracy only can be reliabe above 1m

height_a1m=height[height$meanheight>1,]
height_a1m_sel=height_a1m[,c(4,6,7,8,9,10,11,12)]

height_a1m_sel %>%
  gather(-meanheight, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = meanheight)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5)+
  facet_wrap(~ var, scales = "free") +
  theme_bw()

ggsave(filename="height_vs_lidar_a1.png", plot=last_plot(),width = 8, height = 8)

##### ellenberg

veg_db_wlidar$twi=veg_db_wlidar$twi/1000
veg_db_wlidar$vegetation_density=veg_db_wlidar$vegetation_density/10000
veg_db_wlidar$normalized_z_sd=veg_db_wlidar$normalized_z_sd/100
veg_db_wlidar$canopy_openness=veg_db_wlidar$canopy_openness/10000
veg_db_wlidar$heat_load_index=veg_db_wlidar$heat_load_index/10000
veg_db_wlidar$canopy_height=veg_db_wlidar$canopy_height/100

veg_db_wlidar_sel=veg_db_wlidar[is.na(veg_db_wlidar$HabGroup)==FALSE,]
veg_db_wlidar_sel=veg_db_wlidar_sel[,c(7,8,9,10,11,12,13,14,16,17,18,19,20,21,22)]

veg_db_wlidar_sel_f=veg_db_wlidar_sel[veg_db_wlidar_sel$HabGroup=='Forest',]
veg_db_wlidar_sel_ndry=veg_db_wlidar_sel[veg_db_wlidar_sel$HabGroup=='Nature dry',]
veg_db_wlidar_sel_nwet=veg_db_wlidar_sel[veg_db_wlidar_sel$HabGroup=='Nature wet',]

# gam plot

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_L)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergL_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_F)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergF_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_R)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergR_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_N)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergN_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_S)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergS_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_T)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergT_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = Ellenberg_K)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="ellenbergK_vs_lidar.png", plot=last_plot(),width = 15, height = 10)

veg_db_wlidar_sel %>%
  gather(-SpRichness,-HabGroup,-Ellenberg_L,-Ellenberg_F,-Ellenberg_R,-Ellenberg_N,-Ellenberg_S,-Ellenberg_T,-Ellenberg_K, key = "var", value = "value") %>% 
  ggplot(aes(x = value, y = SpRichness)) +
  geom_point() +
  geom_smooth(se=TRUE)+
  stat_cor(method = "spearman",size=5,label.x.npc = "left", label.y.npc = "bottom",color="red")+
  facet_wrap(~ var+HabGroup, scales = "free") +
  theme_bw()

ggsave(filename="SpRichness_vs_lidar.png", plot=last_plot(),width = 15, height = 10)