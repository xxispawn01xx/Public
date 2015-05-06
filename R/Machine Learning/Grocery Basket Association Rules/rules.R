##
## Step 1 - Gather Data
##

# install.packages("arules")
# To read in sparse matrix data
library(arules)
groceries <- read.transactions("groceries.csv", sep = ",")

##
## Step 2 - Explore/Prepare Data
##

summary(groceries)

# inspect from arules
inspect(groceries[1:5])

# itemFrequency for first three items (columns)
itemFrequency(groceries[, 1:3])

# Plot with min 10% frequency
itemFrequencyPlot(groceries, support = 0.1)

# Plot top N items
itemFrequencyPlot(groceries, topN = 20)

# Visualize entire matrix
# all columns for first 5 transactions
image(groceries[1:5])

# Or sample random 100 transactions
image(sample(groceries, 100))

##
## Step 3 - Train
##

# Produces no results since default support is 0.1
# Which produces 0.1 * 9835 = 983 items needed for a rule
apriori(groceries)

# Change to deal with items purchased 2 times a day
# or about 60 times. 60/9835 = 0.006100661

groceryrules <- apriori(groceries, parameter = list(support = 0.006100661, confidence = 0.25, minlen = 2))

##
## Step 4 - Evaluate Performance
##
summary(groceryrules)

# Check specific rules
inspect(groceryrules[1:3])

##
## Step 5 - Improve Performance
##

inspect(sort(groceryrules, by = "lift")[1:5])

# Subsets of association rules
berryrules <- subset(groceryrules, items %in% "berries")

# Write rules to file
write(groceryrules, file = "groceryrules.csv", sep = ",", quote = TRUE, row.names = FALSE)

# Or convert to a data frame
groceryrules_df <- as(groceryrules, "data.frame")
