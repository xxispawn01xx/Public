
#1
#a
ca_pa <- read.csv("http://people.csail.mit.edu/sylvain/houseprices2011.csv")  
# Loading the file into R
#b
dim(ca_pa)  # display the dimension of the dataframe (nrow, ncol)
#c
colSums(apply(ca_pa,c(1,2),is.na)) # this apply function checks for null values in the 
#given dataframe and replaces null with 1. 
#ThecolSums displays how many null values are there in each column.
# a vector giving the subscripts which the function will be applied over. E.g., 
# for a matrix 1 indicates rows, 2 indicates columns, c(1, 2) indicates rows and columns. 
# Where X has named dimnames, it can be a character vector selecting dimension names.
x <- nrow(ca_pa)
#d
ca_pa <- na.omit(ca_pa) 
# eliminates the null records from the dataset
#e
row_omit <- x - nrow(ca_pa) 
# no of rows eliminated 
print(row_omit)
#670
#f

#******
#2) 

#a) 
# Attach is a function that allows one to search variable in R shell path
#attach(ca_pa)
plot(Built_2005_or_later, Median_house_value, main= "Overall", xlab = "Built_2005_or_later", ylab = "Median_house_value")

#b)
ca <- subset(ca_pa, ca_pa$STATEFP == 6)  
#Filtering out the data for California 
pa <- subset(ca_pa, ca_pa$STATEFP == 42) 
#Filtering out the data for Pennsylvania 
plot(ca$Built_2005_or_later, ca$Median_house_value, main= "California", xlab = "Built_2005_or_later", ylab = "Median_house_value")
plot(pa$Built_2005_or_later, pa$Median_house_value, main= "Pennsylvania", xlab = "Built_2005_or_later", ylab = "Median_house_value")


#3)
#a) 

ca_pa$vacancy_rate <- ca_pa$Vacant_units/ca_pa$Total_units 
# Create new column vacancy rate 
summary(ca_pa$vacancy_rate) 
# function summary gives the min max, mean and median of the particular column. 
#to visualize before allocating computing resources to plot
#b) 
plot(ca_pa$vacancy_rate, ca_pa$Median_house_value, main= "Overall", xlab = "vacancy_rate", ylab = "Median_house_value")

#c) 
ca <- subset(ca_pa, ca_pa$STATEFP == 6)
pa <- subset(ca_pa, ca_pa$STATEFP == 42)
plot(pa$vacancy_rate, pa$Median_house_value, main= "California", xlab = "vacancy_rate", ylab = "Median_house_value")
plot(ca$vacancy_rate, ca$Median_house_value, main= "Pennsylvania", xlab = "vacancy_rate", ylab = "Median_house_value")

#is there a difference between ca and pa vacancy rate plots?

#4)
#a) 
acca <- c()
for (tract in 1:nrow(ca_pa)) {
  if (ca_pa$STATEFP[tract] == 6) {
    if (ca_pa$COUNTYFP[tract] == 1) { #county embeded in state
      acca <- c(acca, tract)
    }
  }
}       
# this code extracts the row names of the data where state = 6 AND county = 1 which is #Alameda County, in CA state
accamhv <- c()
for (tract in acca) {
  accamhv <- c(accamhv, ca_pa[tract,10])
}                                  
#extracts the median house value for the county Alameda
#median(accamhv) median of the median house value column

#b)
bracket_code = median((subset(ca_pa, (ca_pa$STATEFP == 6 & ca_pa$COUNTYFP == 1)))[,10])
#subset of ca_pa where StateFP equivalent to 6 &&  County =1,

#c)
ala <- subset(ca_pa, (ca_pa$STATEFP == 6 & ca_pa$COUNTYFP == 1))  
#create subsets for counties
santa <- subset(ca_pa, (ca_pa$STATEFP == 6 & ca_pa$COUNTYFP == 85))
allegh <- subset(ca_pa, (ca_pa$STATEFP == 42 & ca_pa$COUNTYFP == 3))

mean(ala$Built_2005_or_later)
mean(santa$Built_2005_or_later)
mean(allegh$Built_2005_or_later)

#d)
cor(ca_pa$Median_house_value, ca_pa$Built_2005_or_later) # Calculating correlation between #median house value and percent of houses built on or after 2005.
cor(ca$Median_house_value, ca$Built_2005_or_later)
cor(pa$Median_house_value, pa$Built_2005_or_later)
cor(ala$Median_house_value, ala$Built_2005_or_later)
cor(santa$Median_house_value, santa$Built_2005_or_later)
cor(allegh$Median_house_value, allegh$Built_2005_or_later)


#e)
plot(ala$Median_household_income, ala$Median_house_value, main= "Alameda", ylab = "Median_house_value", xlab = "Median_household_income")
plot(santa$Median_household_income, santa$Median_house_value, main= "Santa Clara", ylab = "Median_house_value", xlab = "Median_household_income")
plot(allegh$Median_household_income, allegh$Median_house_value, main= "Allegheny", ylab = "Median_house_value", xlab = "Median_household_income")