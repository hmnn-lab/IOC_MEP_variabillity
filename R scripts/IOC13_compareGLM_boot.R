# The RMSE for predicting CV of 120% RMT MEP amplitude of the two GLMs compared
# using 10-fold cross validation (CV)

#Loading libraries and reading data set
library(readxl)
library(tidyverse)
library(caret)
library(ggplot2)
library(ggpubr)
library(car)
setwd("C:/ARKO/`PHD/IO Curve Project")
M <- read_excel("IOC_parameters_bootCVmean.xlsx")

# Setting seed and generating 5-fold cross validation training list
set.seed(130)
train_control <- trainControl(method = "cv",
                              number = 10,
                              savePredictions = TRUE)

# Linear Model (with all predictors)
# training the model by assigning CV_RMT_MEP column as the target variable, other CV values are predictors
lin1_model <- train(CV_RMT_MEP ~ CV_MT + CV_PS + CV_MEP_max + CV_Sfifty, data = M,
                   method = "lm",
                   trControl = train_control)
print (lin1_model)
lin1_pred <- lin1_model$pred
lin1_eachfold <- data.frame (lin1_model$resample) #RMSE of each fold
print (lin1_model$finalModel)

# Linear Model (with only CV_PS and CV_MEP_max as predictors)
lin2_model <- train(CV_RMT_MEP ~ CV_PS + CV_MEP_max, data = M,
                    method = "lm",
                    trControl = train_control)
print (lin2_model)
lin2_pred <- lin2_model$pred
lin2_eachfold <- data.frame (lin2_model$resample) # RMSE of each fold
print (lin2_model$finalModel)

# RMSE comparison and plotting
model_comp <- data.frame("GLM CV_all_pred" = c(lin1_model$resample$RMSE),
                         "GLM CV_PS_MEP_max" = c(lin2_model$resample$RMSE)
)
myplot <- boxplot(model_comp, data = model_comp, xlab = "Models",
                  ylab = "RMSE", main = "Comparing Linear Models",
                  col = 'white')
# Scattered points in plot
stripchart(model_comp,        # Data
           method = "jitter", # Random jitter
           pch = 19,          # Pch symbols
           col = 1,           # Color of the symbol
           vertical = TRUE,   # Vertical mode
           add = TRUE)        # Add it over

# Checking variance and performing t-test to compare mean RMSE
var.test(lin1_model$resample$RMSE, lin2_model$resample$RMSE, alternative = "two.sided")
print (t.test(lin1_model$resample$RMSE, lin2_model$resample$RMSE,
              alternative = "two.sided", var.equal = TRUE))

# END ==========================================================================
