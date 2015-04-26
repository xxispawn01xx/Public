##
## Step 1: Gather Data
##
credit <- read.csv("credit.csv")

##
## Step 2: Prepare data
##
table(credit$checking_balance)

# Set random seed
set.seed(1234)

# Randomize credit order
credit_rand <- credit[order(runif(length(credit[,1]))),]

# Split data for train/test
credit_train <- credit_rand[1:900,]
credit_test <- credit_rand[901:1000,]

##
## Step 3: Train
##
# Use C50 library install.packages("C50")
library(C50)

credit_model <- C5.0(credit_train[-17], credit_train$default)

##
## Step 4: Evaluate Performance
##

credit_pred <- predict(credit_model, credit_test)

library(gmodels)
CrossTable(credit_test$default, credit_pred, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual Default", "Predicted Default"))

##
## Step 5: Improve Performance (Boosting)
##

# Boosting
credit_boost10 <- C5.0(credit_train[-17], credit_train$default, trials = 10)
credit_boost_pred10 <- predict(credit_boost10, credit_test)
CrossTable(credit_test$default, credit_boost_pred10, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual Default", "Predicted Default"))

# Error Cost Matrix
error_cost <- matrix(c(0,1,4,0), nrow=2)
credit_cost <- C5.0(credit_train[-17], credit_train$default, costs = error_cost)
credit_cost_pred <- predict(credit_cost, credit_test)
CrossTable(credit_test$default, credit_cost_pred, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual Default", "Predicted Default"))
