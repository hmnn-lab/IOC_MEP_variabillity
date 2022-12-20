# Generating Correlation circle using Parameters obtained from IOC

# Loading Libraries
library(readxl)
library(FactoMineR)
library(ggplot2)

# Read file containing IOC parameters 
M <- read_excel("C:/ARKO/`PHD/IO Curve Project/IOC_parameters.xlsx")
M[, 6] <- NULL

# Constructing PCA correlation circle
res.pca = PCA(M, scale.unit=TRUE, graph=T)

# Saving Plot
ggsave ("C:/ARKO/`PHD/IO Curve Project/FINAL_IMAGES/fig_02a.jpeg",
        plot = last_plot(), dpi = 300)

# END ==========================================================================