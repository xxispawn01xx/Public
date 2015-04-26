wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors=FALSE)

# Get rid of ID column
wbcd <- wbcd[-1]

table(wbcd$diagnosis)

# Write diagnosis values as factors and re-label
wbcd$diagnosis <- factor(wbcd$diagnosis, levels=c("B", "M"), labels=c("Benign", "Malignant"))

# Show percentage
round(prop.table(table(wbcd$diagnosis)) * 100, digits=1)

# Normalize data function
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Normalize each feature
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))

# Split data into train and test datasets
wbcd_train <- wbcd_n[1:469,]
wbcd_test <- wbcd_n[470:569,]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

# Load class library for KNN clasification
library(class)

# Train on data
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Evaluate model

# Load gmodels for CrossTable
library(gmodels)

CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)


# Attempt to improve performance

# Try z-score standardization
wbcd_z <- as.data.frame(scale(wbcd[-1]))
summary(wbcd_z$area_mean)

# Split data into train and test datasets
wbcd_train <- wbcd_z[1:469,]
wbcd_test <- wbcd_z[470:569,]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

# Train
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Evaluate
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)







