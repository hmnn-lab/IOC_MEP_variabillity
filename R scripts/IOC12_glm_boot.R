# Generate GLM using the bootstrapped CV values of IOC parameters to predict
# the CV value of 120% RMT MEP amplitude

# Loading libraries
library (caret)
library(readxl)

# Read data set
M <- read_excel("C:/ARKO/`PHD/IO Curve Project/IOC_parameters_bootCVmean.xlsx")

# Generate GLM
model <- lm(CV_RMT_MEP ~ CV_MT + CV_PS + CV_MEP_max + CV_Sfifty, data = M)
summary (model)
vif (model)

# Remove maximum VIF parameter (CV of S50)
model2 <- lm(CV_RMT_MEP~ CV_MT + CV_PS + CV_MEP_max, data = M)
summary (model2)
vif (model2)

# Remove non-significant parameter (CV of MT, p> 0.05)
model3 <- lm(CV_RMT_MEP~ CV_PS + CV_MEP_max, data = M)
summary (model3)
vif (model3)

# END ==========================================================================