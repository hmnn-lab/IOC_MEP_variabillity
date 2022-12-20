# Plotting correlation heat map and dendrogram along with correlation matrix of bootstrapped CV values

#Loading libraries and reading data set
library(readxl)
library(tidyverse)
library(caret)
library(PerformanceAnalytics)
library(Hmisc)
library(gplots)
setwd("C:/ARKO/`PHD/IO Curve Project")
M <- read_excel("IOC_parameters_bootCVmean.xlsx")
head (M)

# Removing CV and Mean of S50 parameter
M[, 5] <- NULL
M[, 9] <- NULL

# Generating correlation plot of all bootstrapped variables
Corr <- rcorr(as.matrix(M), type= "pearson") # p value and Pearson's values
cormat <- round (Corr[["r"]],2)
chart.Correlation(M, histogram=TRUE, pch=19)

# Generating correlation heat map and dendrogram
col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap.2(x = cormat, col = col, symm = TRUE, trace = "none", Colv = NULL,
          density.info=c("none"), keysize = 1,  key.title = "Pearson rho")
# END ==========================================================================