##
## Step 1 - Gather Data
##
letters <- read.csv("letterdata.csv")

##
## Step 2 - Prepare Data
##

# Data has mostly been prepared so
# split into train and test data
letters_train <- letters[1:16000, ]
letters_test  <- letters[16001:20000, ]

##
## Step 3 - Train
##

# SVM packages
# 1. e1071 - Award winning from Vienna University (C++)
# 2. klaR - SVMlight algrorithm
# 3. kernlab - Native R implementation good for starting out

# install.packages("kernlab")
library(kernlab)

letter_classifier <- ksvm(letter ~., data = letters_train, kernel = "vanilladot")

##
## Step 4 - Evaluate Performance
##

letter_predictions <- predict(letter_classifier, letters_test)

# Show predictions of letters
head(letter_predictions)

agreement <- letter_predictions == letters_test$letter

table(agreement)

prop.table(table(agreement))

##
## Step 5 - Improve Performance
##

letter_classifier_rbf <- ksvm(letter ~., data = letters_train, kernel = "rbfdot")
letter_predictions_rbf <- predict(letter_classifier_rbf, letters_test)

agreement_rbf <- letter_predictions_rbf == letters_test$letter
table(agreement_rbf)
prop.table(table(agreement_rbf))
