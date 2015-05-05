##
## Step 1 - Collect Data
##
concrete <- read.csv("concrete.csv")
str(concrete)

##
## Step 2 - Prepare Data
##

# Normalize function
normalize <- function(x) {
        return ((x - min(x)) / (max(x) - min(x)))
}

concrete_norm <- as.data.frame(lapply(concrete, normalize))
summary(concrete_norm$strength)

concrete_train <- concrete_norm[1:773, ]
concrete_test <- concrete_norm[774:1030, ]

##
## Step 3 - Train Data
##

# Use install.packages("neuralnet")

library(neuralnet)

concrete_model <- neuralnet(strength ~ cement + slag + ash + water + superplastic + coarseagg + fineagg + age, data = concrete_train)
plot(concrete_model)

##
## Step 4 - Performance
##

# Compute returns $neurons for each layer in the network
# and $net.results as the predicted output layer
model_results <- compute(concrete_model, concrete_test[1:8])

predicted_strength <- model_results$net.result

# Get correlation between prediction and actual
cor(predicted_strength, concrete_test$strength)

##
## Step 5 - Improve Performance
##

# Use multiple hidden layers
concrete_model2 <- neuralnet(strength ~ cement + slag + ash + water + superplastic + coarseagg + fineagg + age, data = concrete_train, hidden = 5)

plot(concrete_model2)
model_results2 <- compute(concrete_model2, concrete_test[1:8])
predicted_strength2 <- model_results2$net.result
cor(predicted_strength2, concrete_test$strength)
