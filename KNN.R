###########################################################################
## This code is to explore the cereals data set using different visualizations (EDA)
## Akhil Koppera 
## Created: September 10 2019
###########################################################################   



rm(list = ls())

setwd("/Users/Akhil/Desktop/Data")

#install.packages("mclust")
#install.packages("ElemStatLearn")
#install.packages("ggplot2")
#install.packages("reshape2")


library(ElemStatLearn)
library(mclust)
library(ggplot2)
library(reshape2)
library(MASS)
library(imputeTS)
library(dplyr)
library(dlookr)

#######################################################################
#### converting the data into a data frame#############################
#######################################################################

zip.test
zip_train<-as.data.frame(zip.train)
zip_test<-as.data.frame(zip.test)
zip_train_2_3 <- subset(zip_train,zip_train$V1==2|zip_train$V1==3)
zip_test_2_3<- subset(zip_test,zip_test$V1==2|zip_test$V1==3)

#######################################################################
##### fitting linear model using test data#############################
#######################################################################

model<-lm(V1~., data=zip_train_2_3)
summary(model)

##########################################################################
###finding the predictions using the model formed from the train data#####
##########################################################################

train_predictions<-round(predict(model,zip_train_2_3))
test_predictions<-round(predict(model,zip_test_2_3))

#########################################################################
###### fnding the errors of linear model for both test and train#########
#########################################################################

lm_train_errror<-classError(train_predictions,zip_train_2_3$V1)$errorRate
lm_test_error<-classError(test_predictions,zip_test_2_3$V1)$errorRate

#########################################################################
################## KNN model creation  ##################################
#########################################################################
# create a loop to look at kNN for different values of k
k_vals <- c(1, 3, 5, 7, 9, 11,13,15)

knn_error_df <-data.frame(k=numeric(),knn_train_error=numeric(),knn_test_error=numeric(),lm_tr_er=numeric(),lm_te_er=numeric())
require(class)
for (i in 1:8){
  
  # select "k"
  kk <- k_vals[i]
  fit <- knn(zip_train_2_3, zip_train_2_3, zip_train_2_3$V1, k = kk)
  test<- knn(zip_train_2_3, zip_test_2_3, zip_train_2_3$V1, k = kk)

  fit
  test
  
  ###################################################################
  # finding knn error for both train and test data ##################
  ###################################################################
  knn_er_train<-classError(fit,zip_train_2_3$V1)$errorRate
  knn_er_test<-classError(test,zip_test_2_3$V1)$errorRate
  knn_error_df[nrow(knn_error_df)+1,]<-c(kk,knn_er_train,knn_er_test,lm_train_errror,lm_test_error)

}
error_plot<-melt(knn_error_df,id="k")
ggplot(data=error_plot,aes(x=k,y=value,colour=variable))+geom_line()+geom_point()
       

       