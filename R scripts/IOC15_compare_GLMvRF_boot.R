# Compare RMSE for predicting the bootstrapped CV values of 120% RMT MEP between
# GLM vs Random Forest Model 

#Loading libraries and reading data set
library(readxl)
library(tidyverse)
library(caret)
library(e1071)
library(randomForest)
library(ggplot2)
library(dplyr)
library (tcltk)
setwd("C:/ARKO/`PHD/IO Curve Project")
M <- read_excel("IOC_parameters_bootCV.xlsx")
head (M)

set.seed(100)

# Track progress
pb <- tkProgressBar(title = 'Computing...', min=0, max = 1000, width = 200)

# Calculate for 1000 iterations to remove bias
for (j in 1:1000) {

# Progress bar
Sys.sleep(0.001)
setTkProgressBar (pb, j, label = paste(round(j/1000*100,1), '% done'))

# Create testing folds for 10-fold CV
testing_folds <- createFolds(M$CV_RMT_MEP, k = 10, list = TRUE, returnTrain = FALSE)

# Initialize vectors for training and testing RMSE data storage
i = 1
rftrain <- vector(mode = "numeric", 10)
rftest <- vector(mode = "numeric", 10)
lintrain <- vector(mode = "numeric", 10)
lintest <- vector(mode = "numeric", 10)

# Running loop for each fold of CV
for (i in 1:10) {

# Define training and testing data set
training_dataset  <- M[-matrix(unlist(testing_folds[i])), ]
testing_dataset <- M[matrix(unlist(testing_folds[i])), ]

# RF model
rf <- randomForest(CV_RMT_MEP~.,data = training_dataset,
                   mtry = 2
)

# Predicting both training and testing data set
pred_train <- predict(rf, training_dataset)
pred_test <- predict(rf, testing_dataset)

# Computing model performance metrics
testing_performance <- data.frame( R2 = R2(pred_test, testing_dataset $ CV_RMT_MEP),
                                   RMSE = RMSE(pred_test, testing_dataset $ CV_RMT_MEP
                                   ))
training_performance <- data.frame( R2 = R2(pred_train, training_dataset $ CV_RMT_MEP),
                                    RMSE = RMSE(pred_train, training_dataset $ CV_RMT_MEP
                                    ))
rftrain [i] <- training_performance$RMSE
rftest [i] <- testing_performance$RMSE

# GLM
glm <- lm (CV_RMT_MEP~., data = training_dataset)

# Predicting both training and testing data set
pred_train <- predict(glm, training_dataset)
pred_test <- predict(glm, testing_dataset)

# Computing model performance metrics
testing_performance <- data.frame( R2 = R2(pred_test, testing_dataset $ CV_RMT_MEP),
                                   RMSE = RMSE(pred_test, testing_dataset $ CV_RMT_MEP
                                   ))
training_performance <- data.frame( R2 = R2(pred_train, training_dataset $ CV_RMT_MEP),
                                    RMSE = RMSE(pred_train, training_dataset $ CV_RMT_MEP
                                    ))
lintrain [i] <- training_performance$RMSE
lintest [i] <- testing_performance$RMSE
}

# Making dataframe
df <- data.frame(
  Model = c (rep("GLM", 20), rep("RF", 20)), 
  RMSE = c(lintrain, lintest, rftrain, rftest),
  Group = c(rep("Training", 10),rep("Testing", 10), 
            rep("Training", 10),rep("Testing", 10))
  )

# Appending values across iterations
if(j == 1){
  
  df_total = df
  
} else {
  
  df_total = rbind (df_total, df)
  
}
} # Ending 1000 iterations
close (pb) # Close popup window

# Boxplot
p <- df %>%
  drop_na()%>%
  ggplot(aes(x=Model,
             y=RMSE,
             fill=Group))+
  geom_boxplot(width =0.60) + theme(panel.background = element_rect(fill = 'white', colour = 'black'))


p + scale_fill_manual(values=c("white",
                               "#999999",
                               "white",
                               "#999999")) + theme(text = element_text(size = 20))

# Taking subsets of df_total for statistic testing
df_rmse <- NULL
df_tvtglm <- NULL
df_tvtrf <- NULL

df_rmse$GLM <- select(filter(df_total, Model == 'GLM', Group == 'Testing'), c("Model", "RMSE", "Group"))
df_rmse$RF <- select(filter(df_total, Model == 'RF', Group == 'Testing'), c("Model", "RMSE", "Group"))

df_tvtglm$train <- select(filter(df_total, Model == 'GLM', Group == 'Training'), c("Model", "RMSE", "Group"))
df_tvtglm$test <- select(filter(df_total, Model == 'GLM', Group == 'Testing'), c("Model", "RMSE", "Group"))

df_tvtrf$train <- select(filter(df_total, Model == 'RF', Group == 'Training'), c("Model", "RMSE", "Group"))
df_tvtrf$test <- select(filter(df_total, Model == 'RF', Group == 'Testing'), c("Model", "RMSE", "Group"))

# Variance test and t-tests

# GLM test vs train RMSE
var.test(df_tvtglm[["test"]][["RMSE"]], df_tvtglm[["train"]][["RMSE"]], alternative = "two.sided")
print (t.test(df_tvtglm[["test"]][["RMSE"]], df_tvtglm[["train"]][["RMSE"]],
              alternative = "two.sided", var.equal = FALSE))
print (sd(df_tvtglm[["test"]][["RMSE"]]))
print (sd(df_tvtglm[["train"]][["RMSE"]]))

# RF model test vs train RMSE
var.test(df_tvtrf[["test"]][["RMSE"]], df_tvtrf[["train"]][["RMSE"]], alternative = "two.sided")
print (t.test(df_tvtrf[["test"]][["RMSE"]], df_tvtrf[["train"]][["RMSE"]],
              alternative = "two.sided", var.equal = FALSE))
print (sd(df_tvtrf[["test"]][["RMSE"]]))
print (sd(df_tvtrf[["train"]][["RMSE"]]))

# GLM test vs RF model test RMSE
var.test(df_rmse[["GLM"]][["RMSE"]], df_rmse[["RF"]][["RMSE"]], alternative = "two.sided")
print (t.test(df_rmse[["GLM"]][["RMSE"]], df_rmse[["RF"]][["RMSE"]],
              alternative = "two.sided", var.equal = FALSE))
print (sd(df_rmse[["GLM"]][["RMSE"]]))
print (sd(df_rmse[["RF"]][["RMSE"]]))


# Saving Plot
ggsave ("C:/ARKO/`PHD/IO Curve Project/FINAL_IMAGES/fig_05.jpeg",
        plot = last_plot(), dpi = 300)

# END ==========================================================================
