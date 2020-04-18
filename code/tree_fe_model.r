# Basic Information -------------------------------------------------------
# --
# Topic: tree_FE_model
# Date: 2019-09-26
# Modification:
# --

# Setting Path ------------------------------------------------------------
setwd("C:/users/a2279/Desktop/?????j?ƾ?/final")
getwd()

# Code -----------------------------------------------------------------
# Package
library(dplyr)
library(ggplot2)
library(readr)
library(caret)
library(dummies)
library(xgboost)

# read data ==========================================================================
# raw data
data<-read.csv("train_test_boxcox_trans11_mean35_importance44_order6_comd4.csv",header=TRUE)
y<-read.csv("train_y.csv",header=TRUE)
colnames(data)
data<-data[,-c(124,125,130,131,118,119,136,137,140,141,144,145,99,100,108,109,110,111,4,58,64,67,70,74,80)]
train<-data[1:100000,]
test<-data[100001:250000,]
levels(y[["Y1"]])<-c(0,1)
y[["Y1"]]<-as.vector(y[["Y1"]])
data["RFM_M_LEVEL/AGE"]<-data["RFM_M_LEVEL"]/data["AGE"]
data["APC_1ST_YEARDIF/REBUY_TIMES_CNT"]=data["APC_1ST_YEARDIF"]/data["REBUY_TIMES_CNT"]
data["RFM_M_LEVEL/AGE"]=data["RFM_M_LEVEL"]/data["AGE"]
data["LIFE_INSD_CNT/LIFE_CNT"]=data["LIFE_INSD_CNT"]/data["LIFE_CNT"]
data["AGE*BMI"]=data["AGE"]/data["BMI"]

# model ==============================================================================
# preprocess
dtrain <- xgb.DMatrix(data=as.matrix(train),
                      label = y[["Y1"]])
dtest <- xgb.DMatrix(data = as.matrix(test))

# parameter fix
param_fix <- list(
  booster = "gbtree", 
  objective = 'binary:logistic',
  eval_metric = 'auc',
  gamma = 0
)

# parameter tune ========================================================================
tunegrid <- expand.grid(
  eta = c(0.05),
  max_depth = c(5),
  colsample_bytree = c(1),
  min_child_weight = c(0.71,0.72,0.73),
  subsample = c(1),
  scale_pos_weight = c(1)
)
param_tune <- sapply(tunegrid[1:5,], list)
paramlist <- c(param_fix, param_tune)

# cv model 
xgb_cv <- function(paramlist){
  xgb_cv <- xgb.cv(data = dtrain,
                   params = paramlist, 
                   nfold = 5, 
                   nrounds = 2000,
                   early_stopping_rounds = 10)
  #best nround
  best_nrounds = xgb_cv$best_iteration
  
  cv_auc <- xgb_cv$evaluation_log[xgb_cv$best_iteration,4] %>% list()
  
  return(c(paramlist[-c(1:4)], best_nrounds = best_nrounds, cv_auc))
}

# tune result
tune_result <- data.frame()
for (i in 1:nrow(tunegrid)) {
  param_tune <- sapply(tunegrid[i, ], list)
  paramlist <- c(param_fix, param_tune)
  tmp <- xgb_cv(paramlist)
  tune_result <- tune_result %>% 
    rbind(., do.call(cbind, tmp))
}

tune_result %>% View()

# final model ==============================================================
best_tune <- tune_result %>% arrange(., -test_auc_mean)
best_paramlist <- c(param_fix, sapply(best_tune[1, -c(6, 7, 8)], list))

xgb <- xgb.train(data = dtrain,
                 params = best_paramlist,
                 nrounds = best_tune[1, 7])
xgb

# variable importane
importance <- xgb.importance(model = xgb)
select_feature <- importance$Feature



# predict
predict <- predict(xgb, dtest)
ggplot(predict %>% as.data.frame(), aes(x= predict)) +
  geom_density()

raw_test<-read.csv("C:/users/a2279/Desktop/?????j?ƾ?/submit_test.csv",header=TRUE)
output <- data.frame(CUS_ID = raw_test$CUS_ID,
                     Ypred = predict)

# wrtie csv
write.csv(output, 'predict/submit_test_10_01_fe.csv', row.names = F)

# load/save workspace
save.image('model/tree_fe_model.Rdata')
load('model/tree_fe_model.Rdata')
