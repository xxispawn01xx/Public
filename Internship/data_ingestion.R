rm(list = ls(all = TRUE)); gc()

source('R_libraries.R')
library(plyr)
library(dplyr)

first_time = FALSE

if(first_time){
  # function for data ingestion. this will load all the csvs into R as one data set
  file_names = list.files(path="Jan Fridge Data",pattern="csv",full.names=TRUE)
  mydata = ldply(file_names,function(filename) {
    dum = read.csv(filename)
    dum$filename=filename
    return(dum)
  })
  save(mydata, file='data/all_files.RData')
}

load('data/all_files.RData')
DT <- as.data.table(mydata)

# take a look
DT[, .N, SensorID]
DT[, .N, GroupID]

# summary - mean and sd
summarydata = DT[, .(m = mean(OriginalReading), 
                     s = sd(OriginalReading)), by=SensorID]

# nothing relevant
ggplot(summarydata, aes(SensorID, m)) + geom_point()

### Create new colums with aggregation - potentially useless
DT[, m := mean(OriginalReading), by=SensorID]
DT[, s := sd(OriginalReading), by=SensorID]

# parse dates
DT[, date:=as.character(ReadingDate)]
DT[, nchars_date:=nchar(date)] # count amount of characters in dates.

# remove cases where the date is not complete
# table(nchar(unique(DT$date))) the problem is there are incomplete dates
DT = DT[nchars_date > 10]
DT[, date:=as.POSIXct(date, origin='1970-01-01')]

save(DT, file='data/cleaned_data.RData')







