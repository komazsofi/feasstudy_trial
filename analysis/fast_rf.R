library(randomForest)
library(caret)
library(e1071)
library(usdm)
library(ggplot2)

intersected=read.csv("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/FeasStudy/processing/field/novana/NOVANAAndP3_tozsofia/plt_db_wlidar.csv")

# sort into habitat groups

naturedry=intersected[intersected$HabGroup=="Nature dry",]
naturedry_omit <- na.omit(naturedry[,c(8,17:22)])

vif_naturedry=vifcor(naturedry_omit[,c(17:22)], th=0.6, method='spearman')

naturedry_omit_sel=naturedry_omit[,c(19,22,23,28,29,31,34,38,40,41,13)]

# RF
set.seed(1234)

#natdry

trControl <- trainControl(method = "cv",
                          number = 10,
                          search = "grid")

rf_natdry <- train(Ellenberg_L ~ .,
                   data = naturedry_omit,
                   method = "rf",
                   trControl = trControl,
                   importance=T)

print(rf_natdry)
saveRDS(rf_natdry, file = "rf_natdry.rds")
rf_natdry_varimp=varImp(rf_natdry,scale = FALSE)
plot(rf_natdry_varimp,top=5)

# forest

natureforest=intersected[intersected$HabGroup=="Forest",]
natureforest_omit <- na.omit(natureforest[,c(8,17:22)])

vif_naturedry=vifcor(naturedry_omit[,c(17:22)], th=0.6, method='spearman')

# RF
set.seed(1234)

trControl <- trainControl(method = "cv",
                          number = 10,
                          search = "grid")

rf_natforest <- train(Ellenberg_L ~ .,
                   data = natureforest_omit,
                   method = "rf",
                   trControl = trControl,
                   importance=T)

print(rf_natforest)
saveRDS(rf_natforest, file = "rf_natforest.rds")
rf_natforest_varimp=varImp(rf_natforest,scale = FALSE)
plot(rf_natforest_varimp,top=5)
