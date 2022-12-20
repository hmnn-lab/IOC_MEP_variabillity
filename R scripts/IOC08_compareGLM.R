# The RMSE of the two GLMs compared using 5-fold cross validation (CV)

#Loading libraries and reading IOC parameter table
library(readxl)
library(tidyverse)
library(caret)
library(ggplot2)
library(ggpubr)
setwd("C:/ARKO/`PHD/IO Curve Project")
M <- read_excel("IOC_parameters.xlsx")
head (M)
M[, 6] <- NULL

# Setting seed and generating 5 fold cross validation training list
set.seed(125)
train_control <- trainControl(method = "cv",
                              number = 5,
                              savePredictions = TRUE)

# Linear Model (with all predictors) training the model by assigning RMT_MEP column as the target variable, others are predictors
lin1_model <- train(RMT_MEP ~., data = M,
                   method = "lm",
                   trControl = train_control)
print (lin1_model)
lin1_pred <- lin1_model$pred
lin1_eachfold <- data.frame (lin1_model$resample) #RMSE of each fold
print (lin1_model$finalModel)

# Linear Model (with only MT, PS and MEP max as predictors)

lin2_model <- train(RMT_MEP ~ MT + PS + MEP_max, data = M,
                   method = "lm",
                   trControl = train_control)
print (lin2_model)
lin2_pred <- lin2_model$pred
lin2_eachfold <- data.frame (lin2_model$resample) #RMSE of each fold
print (lin2_model$finalModel)

# RMSE comparison between two GLMs and plotting
model_comp <- data.frame("GLM all pred" = c(lin1_model$resample$RMSE),
                         "GLM PS_MT_MEPmax" = c(lin2_model$resample$RMSE)
                         )
myplot <- boxplot(model_comp, data = model_comp, xlab = "Models",
                  ylab = "RMSE", main = "Comparing Linear Models",
                  col = 'white')

# Plot scattered points representing RMSE of each fold of cross-validation
stripchart(model_comp,        # Data
           method = "jitter", # Random jitter of points
           pch = 19,          # Pch symbols
           col = 1,           # Color of the symbol
           vertical = TRUE,   # Vertical mode
           add = TRUE)        # Add it over

# Testing for equal variance 
var.test(lin1_eachfold$RMSE, lin2_eachfold$RMSE, alternative = "two.sided")

# Two sample independent t test for equal variance
print (t.test(lin1_eachfold$RMSE, lin2_eachfold$RMSE,
              alternative = "two.sided", var.equal = TRUE))

# END ========================================================================== 
