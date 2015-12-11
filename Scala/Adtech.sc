/*
#setwd("C:/Users/AliSamsung/Desktop/Bit Briefcase/Big Data/Kaggle/CTR")
setwd("H:/Ali/Bit Briefcase/Big Data/Kaggle/CTR")
#---------------------- Data preparation
*/

/*
# Click through rate is an important metric for evaluating performance
# in online advertising and marketing. The data is from the world's leading
# company specialized in cross device advertising.240  hours of click data
# is available.
# Column headers defined at https://www.kaggle.com/c/avazu-ctr-prediction/data

# Problem statement

# Predicting whether a mobile ad will be clicked. Historical data
# is provided. Metrics related to the app, site, device, time of activity
# is available. Using the data given, have to predict the variables which
# assist in the conversion of click.
*/


#----First determine number of lines in CSV-----
# testcon <- file("C:/Users/AliDesktop/Desktop/Bit Briefcase/Big Data/Kaggle/CTR/train.csv",open="r")
val readsizeof = 20000
val nooflines  = 0
/*( while((linesread <- length(readLines(testcon,readsizeof))) > 0 )
nooflines <- nooflines+linesread )
close(testcon)
 nooflines*/
/*# > nooflines
# total # of 40,428,968 rows in train.csv file size is 6163 MB
# ~=6560 rows per MB*/


/*
# Since it is the hourly click data, the dataset size is large. We must import  it
# by parts and taking a 10% sample out of it.
*/


ctr <- read.csv("train.csv", nrow = 1000000) # importing by parts
ctr_sample <- sample(nrow(ctr), nrow(ctr)*0.1)
ctr_1 <- ctr[ctr_sample,] # creating 10% sample
nrow(ctr_1)
rm(ctr)

ctr2 <-  read.csv("train.csv", header = TRUE,nrow = 1000000, skip = 1000000,
  col.names = c("id","click", "hour","C1", "banner_pos", "site_id"  , "site_domain",
    "site_category", "app_id" , "app_domain" ,"app_category", "device_id", "device_ip",
    "device_model","device_type","device_conn_type", "C14" , "C15", "C16", "C17", "C18",
    "C19", "C20" , "C21"))
ctr_sample <- sample(nrow(ctr2), nrow(ctr2)*0.1)
ctr_2 <- ctr2[ctr_sample,]
nrow(ctr_2)
rm(ctr2)

ctr3 <-  read.csv("train.csv", header = TRUE,nrow = 1000000, skip = 2000000,
  col.names = c("id","click", "hour","C1", "banner_pos", "site_id"  , "site_domain",
    "site_category", "app_id" , "app_domain" ,"app_category", "device_id", "device_ip",
    "device_model","device_type","device_conn_type", "C14" , "C15", "C16", "C17", "C18",
    "C19", "C20" , "C21"))
ctr_sample <- sample(nrow(ctr3), nrow(ctr3)*0.1)
ctr_3 <- ctr3[ctr_sample,]
nrow(ctr_3)
rm(ctr3)

ctr4 <-  read.csv("train.csv", header = TRUE,nrow = 1000000, skip = 3000000,
  col.names = c("id","click", "hour","C1", "banner_pos", "site_id"  , "site_domain",
    "site_category", "app_id" , "app_domain" ,"app_category", "device_id", "device_ip",
    "device_model","device_type","device_conn_type", "C14" , "C15", "C16", "C17", "C18",
    "C19", "C20" , "C21"))
ctr_sample <- sample(nrow(ctr4), nrow(ctr4)*0.1)
ctr_4 <- ctr4[ctr_sample,]
nrow(ctr_4)
rm(ctr4)

ctr5 <-  read.csv("train.csv", header = TRUE,nrow = 1000000, skip = 4000000,
  col.names = c("id","click", "hour","C1", "banner_pos", "site_id"  , "site_domain",
    "site_category", "app_id" , "app_domain" ,"app_category", "device_id", "device_ip",
    "device_model","device_type","device_conn_type", "C14" , "C15", "C16", "C17", "C18",
    "C19", "C20" , "C21"))
ctr_sample <- sample(nrow(ctr5), nrow(ctr5)*0.1)
ctr_5 <- ctr5[ctr_sample,]
nrow(ctr_5)
rm(ctr5)

ctr6 <-  read.csv("train.csv", header = TRUE,nrow = 1000000, skip = 5000000,
  col.names = c("id","click", "hour","C1", "banner_pos", "site_id"  , "site_domain",
    "site_category", "app_id" , "app_domain" ,"app_category", "device_id", "device_ip",
    "device_model","device_type","device_conn_type", "C14" , "C15", "C16", "C17", "C18",
    "C19", "C20" , "C21"))
ctr_sample <- sample(nrow(ctr6), nrow(ctr6)*0.1)
ctr_6 <- ctr6[ctr_sample,]
nrow(ctr_6)
rm(ctr6)

ctr7 <-  read.csv("train.csv", header = TRUE,nrow = 1000000, skip = 6000000,
  col.names = c("id","click", "hour","C1", "banner_pos", "site_id"  , "site_domain",
    "site_category", "app_id" , "app_domain" ,"app_category", "device_id", "device_ip",
    "device_model","device_type","device_conn_type", "C14" , "C15", "C16", "C17", "C18",
    "C19", "C20" , "C21")  )
ctr_sample <- sample(nrow(ctr7), nrow(ctr7)*0.1)
ctr_7 <- ctr7[ctr_sample,]
nrow(ctr_7)
rm(ctr7)


# Merging all the parts together
ctr_set1 <- rbind(ctr_1, ctr_2, ctr_3, ctr_4, ctr_5, ctr_6, ctr_7)


# Checking the data size

#object_size attempts to take into account the size of the environments associated with an object.
# This is particularly important for closures and formulas, since otherwise you may not realise that
# you've accidentally captured a large object.

#Additionally, the env argument allows you to specify another environment at which to stop.
#This defaults to the environment from which object_size is called to prevent double-counting of
#objects created elsewhere.

  library(pryr)
object_size(ctr_set1)

# Verifying the data

nrow(ctr_set1)

# Column names of the dataset
colnames(ctr_set1)

# Sample dataset
  head(ctr_set1)

#Event rate: it is the no of 1's in the click = 16.6%
  table(ctr_set1$click)

# Summary of the dataset - this displays the class of each column, min, median, mean, max
# values in case of continuous variables and distribution in case of categorical variables

summary(ctr_set1)

# Variable click is the dependent variable here. Few columns needs to be treated before
# starting off with the analysis. Treatment includes changing it to suitable datatype and
# removing the null values.


# Changing the  datatypes. This is an important step for long term projects out of the scope of this # class as several supervised learning algorithms use factors for their input, ie one can build
# a decision tree classifier around CTR down the road.

  ctr_set1$id <- as.numeric(ctr_set1$id)
ctr_set1$hour <- as.factor(ctr_set1$hour)
ctr_set1$click <- as.factor(ctr_set1$click)
ctr_set1$C1 <- as.factor(ctr_set1$C1)
ctr_set1$C14 <- as.factor(ctr_set1$C14)
ctr_set1$C15 <- as.factor(ctr_set1$C15)
ctr_set1$C16 <- as.factor(ctr_set1$C16)
ctr_set1$C17 <- as.factor(ctr_set1$C17)
ctr_set1$C18 <- as.factor(ctr_set1$C18)
ctr_set1$C19 <- as.factor(ctr_set1$C19)
ctr_set1$C20 <- as.factor(ctr_set1$C20)
ctr_set1$C21 <- as.factor(ctr_set1$C21)
ctr_set1$banner_pos <- as.factor(ctr_set1$banner_pos)
ctr_set1$device_type <- as.factor(ctr_set1$device_type)
ctr_set1$device_conn_type <- as.factor(ctr_set1$device_conn_type)

# Replacing the null values with zero

ctr_set1[is.na(ctr_set1)] <- 0
write.csv(ctr_set1, file="ctr_set1.csv")


# Bivariate profiling
  attach(ctr_set1)

# Event is click.

# Click vs C1

table(C1, click)

plot(C1, click, xlab = "C1", ylab= "Clicks", main = "Click vs C1")

# From the plot, it is observed that the category 1005 has maximum population
# and 1002 has a better event rate comparing to the other categories.

# Click vs C15

table(C15, click)

plot(C15, click, xlab = "C15", ylab= "Clicks", main = "Click vs C15")

# Category C15=320 captures maximum touches to the respective page and category 300
# has maximum event rate.


# Click vs C16

table(C16, click)

plot(C16, click, xlab = "C16", ylab= "Clicks", main = "Click vs C16")

# Only the categories 36, 50, 90, 250 and 480 has considerable traffic and from the
# plot it is inferred the category 250 has higher event rate.

# Click vs C18

table(C18, click)

plot(C18, click, xlab = "C18", ylab= "Clicks", main = "Click vs C18")

# Category C18 =2 has a conversion rate of 46% which is higher than all the other
# categories.


# Click vs Device type

table(device_type, click)

plot(device_type, click, xlab = "Device type", ylab= "Clicks", main = "Click vs Device type")

# device_type = 1 captures maximum traffic.

# Click vs Banner POS

table(banner_pos, click)

plot(banner_pos, click, xlab = "Banner POS", ylab= "Clicks", main = "Click vs Banner POS")

# Almost all the traffic to the advertisement page comes via the banner_pos 0 and 1 with both
# of them having almost equal conversion rate.


# Segmenting train and test dataset.

  sample_2 <- sample(nrow(ctr_set1), nrow(ctr_set1)*0.7)
train <- ctr_set1[-sample_2, ]

#Dataset on which to build model
  test <- ctr_set1[-sample_2, ]


# Analysis methodology

# Using ANOVA, finding out the significant variables and building the model using
#logistic regression

# Anova

anova_1 <- aov(as.numeric(click) ~ C1+C15+C16+C18+banner_pos+device_conn_type+
  device_type+site_category+app_category, data = train)

summary(anova_1)


#C1, C15, C16, C18, banner_pos, device_conn_type, site_category, app_category came out
#to be significant. Hence we can proceed with logistic regression having the above as
#independent varaibles.


# Logistic regression

log_1 <- glm(click ~ C1+C15+C16+C18+banner_pos+device_conn_type+site_category+app_category,
  data = train, family = binomial)
summary(log_1)

# Only the variables C15, C18, banner_pos,device_conn_type,site_category came out to be
# significant in the first trial of logistic regression. Iterating the same process with
# significant idvs.

log_2 <- glm(click ~ C15+C18+banner_pos+device_conn_type+site_category, data = train,
  family = binomial)
summary(log_2)

# Prediction- . Test$scr is the predicted variable of click. We use .16 as the cutoff,
# as >.16 implies a click will be made.the scale is given on the scale of the response
# variable of the glm object

test$scr <- predict(log_2, test, type = "response")

a <- data.frame(test$click, test$scr)

#rounding up the predicted probability (cutoff=0.16)
test$round <- ifelse((test$scr > 0.16), 1, 0)

test$tpr <- ifelse(test$round == 1 , (ifelse( (test$round == test$click), 1, 0)), 0)

#calculating false positive rate
test$fpr <- ifelse(test$round ==1 , ifelse( (test$round != test$click), 1, 0), 0)

#calculating true negative rate i.e correctly identified 0's
test$tnr <-  ifelse(test$round ==0 , ifelse( (test$round == test$click), 1, 0), 0)

#True-positives
TP <- sum(test$tpr)

#True-negatives
TN <- sum(test$tnr)

#Calculating accuracy
  acc <- (TP + TN) /nrow(test)
acc

# Accuracy of 66% implies it is a good model

#plotting roc curve

library(pROC)
roc_1 <- roc (click ~ scr, data = test)
roc_1

plot(roc_1)

#Specificity is the % of false positives and sensitivity the % true positive
#The plot shows a straight line as no predicted values and our test as the curved line
# We can now set the specificity of our own test. Considering the low cost of mobile advertising
# This can be relatively high around .7.

  #----OUTCOME-----
# The objective of the project was to build a predictive model which helps to predict
# whether a mobile ad will be clicked and accordingly target those who have a high porobability
# to click. Targetting the people who have a higher frequency to click will obviously help to
# increase the overall clickthrough rate and hence conversion. It will also help to increase
# efficiency since we will be paying for clicks which has a higher conversion chance. This will
# thus help to improve performance in online advertising and marketing. The dataset includes 36
# hours of click data containing metrics related to the app, site, device, time of activity etc.
#
# The model is built on 80% train dataset and validated against the 20% test dataset.
# This is a good learning exercise on the side of predictive modeling and has real world
# applications. Models can be built on similar lines to predict frauds, chances of default on
# insurance premium, credit going bad, customer churn, propensity to buy etc. Predictive modeling
# helps to target more relevant customers and improve efficiency.
  ```

```{r}
#########################----DECISION TREES----######################################
  ##
## Step 1: Gather Data
  ##
credit <- read.csv("C://Users//AliDesktop//Desktop//Magic Briefcase//Coursera//Other Repo//MLWRRscripts//5 - Decision Trees and Rules//credit.csv")

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

# > levels(credit_train$default)
# [1] "no"  "yes"
```

