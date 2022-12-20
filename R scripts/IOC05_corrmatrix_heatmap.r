# Generate Correlation Matrix for the five IOC parameters

# Loading libraries
library(readxl)
library(ggplot2)
library(reshape2)
library(Hmisc)

# Loading excel sheet containing parameters
M <- read_excel("C:/ARKO/`PHD/IO Curve Project/IOC_parameters.xlsx")
M[, 6] <- NULL
M <- log(M) # Log transformation to make all parameters normally distributed

# Calculating Pearson's Correlation Coefficient on normalized parameters
Corr<- rcorr(as.matrix(M), type= "pearson")
cormat <- round (Corr[["r"]],2) # Precision upto 2 decimal places
cormat [lower.tri(cormat)] <- NA # Removing lower triangle
pmat <- round (Corr[["P"]],4) # Doing the above for p-values
pmat [lower.tri(cormat)] <- NA

# Removing correlation values for non-significant correlation 
cormat [1,2]<- 0
cormat [1,4]<- 0
cormat [3,5]<- 0

# Removing diagonals
cormat [1,1]<- NA
cormat [2,2]<- NA
cormat [3,3]<- NA
cormat [4,4]<- NA
cormat [5,5]<- NA

melted_cormat<-melt(cormat,na.rm = TRUE) #plots correlation between each variable in two columns and removes null values

# Plotting correaltion matrix
ggplot(melted_cormat, aes(x=Var1, y=Var2, fill=value))+ #x,y,fill obtained from melted_cormat
  geom_tile() +  #calls in plot style from ggplot2 library
  scale_fill_gradient2(low='blue', mid='white', high='red',
                       limit = c(-1,1), midpoint=0, name = 'Pearson\nCorrelation')+
  ggtitle("Correlation Matrix") + xlab("IOC Parameters") + ylab ("IOC Parameters")+
  theme_classic() 

View (melted_cormat) # View correlation values

# Saving Plot
ggsave ("C:/ARKO/`PHD/IO Curve Project/FINAL_IMAGES/fig_02b.jpeg",
        plot = last_plot(), dpi = 300)
# END ==========================================================================