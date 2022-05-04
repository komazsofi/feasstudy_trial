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
ArtsEllenberg = read.csv2(file = "Floraliste.csv")

data=data[data$Yeare>2015,]

# prep. plot database

data_plot=data %>% 
  group_by(data$AktID,data$Yeare,data$Habitat,data$HabitatID,data$UTM_X_orig,data$UTM_Y_orig) %>%
  summarize(Count=n())

names(data_plot) <- c("AktID","Year","Habitat","HabitatID","UTM_X","UTM_Y","SpRichness")

# calculate Ellenberg values

ellenberg_df <- data.frame(matrix(ncol = 8, nrow = 0))
x <- c("AktID","Year","Habitat","HabitatID","UTM_X","UTM_Y","SpRichness","Ellenberg_L","Ellenberg_F","Ellenberg_R","Ellenberg_N","Ellenberg_S","Ellenberg_T","Ellenberg_K","Artsscore")

colnames(ellenberg_df) <- x

for (i in 1:length(data_plot$AktID)){
  print(i)
  
  plot_sel=filter(data,AktID==data_plot$AktID[i],Yeare==data_plot$Year[i])
  ellenberg_sel=filter(ArtsEllenberg,LATINSK.NAVN %in% plot_sel$LatArt)
  
  ellenberg_sel[ellenberg_sel=="x"]<-0
  ellenberg_sel[ellenberg_sel=="NA"]<-NA
  ellenberg_sel_m=ellenberg_sel[c(12,13,14,15,16,17,18,20,21,22,23)]
  #ellenberg_sel_m2=as.data.frame(sapply(ellenberg_sel_m, as.numeric))
  ellenberg_sel_m2=as.data.frame(lapply(ellenberg_sel_m, function(x) as.numeric(as.character(x))))
  
  ellenberg_sel_means=ellenberg_sel_m2 %>% summarise_at(vars(c(1:11)),mean, na.rm =TRUE)
  
  newline <- data.frame(t(c(AktID=data_plot$AktID[i],Year=data_plot$Year[i],Habitat=data_plot$Habitat[i],HabitatID=data_plot$HabitatID[i],UTM_X=data_plot$UTM_X[i],UTM_Y=data_plot$UTM_Y[i],SpRichness=data_plot$SpRichness[i],
                            Ellenberg_L=ellenberg_sel_means$Lys...Ellenbeg.L,
                            Ellenberg_F=ellenberg_sel_means$Fugtighed...Ellenberg.F,
                            Ellenberg_R=ellenberg_sel_means$Allkalinitet..reaktion..pH.....Ellenberg.R,
                            Ellenberg_N=ellenberg_sel_means$Næringstof...Ellenberg.N,
                            Ellenberg_S=ellenberg_sel_means$Salt...Ellenberg.S,
                            Ellenberg_T=ellenberg_sel_means$Temperature...Ellenberg.T,
                            Ellenberg_K=ellenberg_sel_means$Kontanilitet...Ellenberg.K,
                            Artsscore=ellenberg_sel_means$Arts.score)))
  
  ellenberg_df <- rbind(ellenberg_df, newline)
  
}

write.csv(ellenberg_df,"plot_db_welberg.csv")
