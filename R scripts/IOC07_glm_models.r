# Generate GLM using the z-score normalized values of IOC parameters to predict
# the actual value of 120% RMT MEP amplitude

# Loadig libraries
library (caret)
library(readxl)

# Read table contating z-score normalized parameters (except 120% RMT MEP)
M <- read_excel("C:/ARKO/`PHD/IO Curve Project/IOC_parameters_zscore.xlsx")

# GLM to predict 120% RMT MEP using all other IOC parameters
model <- lm(RMT_MEP~., data = M)
summary (model)
vif (model)

# Removing parameter with maximum VIF (S50) from the GLM
model2 <- lm(RMT_MEP~ MT + PS + MEP_max, data = M)
summary (model2)
vif (model2)

# END ==========================================================================