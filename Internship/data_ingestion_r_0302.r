
#getwd() 
#"C:/Users/AliDesktop/Desktop/Magic Briefcase/Internship"

#loading required packages to ingest data
#ingest split aggregate combine
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


#check total numbers of rows and no of variables in the ingested data
dim(mydata)

### [1] 2602496       9


#to get a summary stats of the ingested data
summary(mydata)
 
############# 

## TemperatureID          SensorID     OriginalReading    ReadingDate         GroupID    
## Min.   :1.089e+09   Min.   :23152   Min.   :-32.000   00:56.4:     31   Min.   : 811  
## 1st Qu.:1.137e+09   1st Qu.:23479   1st Qu.:-17.100   00:55.9:     28   1st Qu.:1911  
## Median :1.186e+09   Median :23816   Median :  3.200   00:56.2:     28   Median :2983  
## Mean   :1.186e+09   Mean   :25332   Mean   : -1.735   15:56.1:     28   Mean   :3666  
## 3rd Qu.:1.234e+09   3rd Qu.:24148   3rd Qu.:  5.100   30:56.3:     28   3rd Qu.:5634  
## Max.   :1.320e+09   Max.   :84192   Max.   : 28.200   45:55.7:     28   Max.   :8639  
##                                                       (Other):2602325                 
##                                                                                                 Notes        
## Type: RX Ambient,Make : (Ambient),Model: (Ambient),State: RI                                       :  91613  
##                                                                                                    :  42057  
## Type: RX Cooler,Make : Master-Bilt,Model: BGR-14R,State: RI Notes:  One clear door cooler back wall:  26149  
## Type: RX Ambient,Make : ,Model: ,State: RI                                                         :  20550  
## Type: RX Cooler,Make : haier,Model: n/a,State: RI                                                  :  17870  
## (Other)                                                                                            :2283164  
## NA's                                                                                               : 121093  
##
## 
## Make              Model          filename        
## Make_2 :1022544   Model_1 :814616   Length:2602496    
## Make_1 : 604678   Model_12:510929   Class :character  
## Make_4 : 193506   Model_2 :178601   Mode  :character  
## Make_10: 186090   Model_6 :131011                     
## Make_6 : 125305   Model_9 :121315                     
## Make_13: 103358   Model_22:116027                     
## (Other): 367015   (Other) :729997       
## 
##--------------
##################


#to get the column names of the data set 
colnames(mydata)

####[1] "TemperatureID"   "SensorID"        "OriginalReading" "ReadingDate"     "GroupID"         "Notes"          
####[7] "Make"            "Model"           "filename"  


######follow up #########

table(mydata$SensorID)

as.data.frame(table(mydata$SensorID))
####there are total 874 SensorIDs

as.data.frame(table(mydata$GroupID))
####there are total of 61 GroupIDs



#########installing the required package###################

install.packages("doBy")

## groupwise stats


library(doBy)

####getting the mean and std. deviation value for each sensor
summarydata<-summaryBy(OriginalReading ~ SensorID, data = mydata, FUN = function(x) { c(m = mean(x), s = sd(x)) } )
summarydata<-data.frame(summarydata)
colnames(summarydata)

#####calculating mean+3*s.d and mean-3*s.d for coming up with upper limit and lower limit
summarydata$upper_limit<-(summarydata$OriginalReading.m + 3 * summarydata$OriginalReading.s)

summarydata$lower_limit<-(summarydata$OriginalReading.m - 3 * summarydata$OriginalReading.s)

##merging the statistics (mean, s.d, uper limit and lower limit to the actual data set#####
alldata<-merge(x = mydata, y = summarydata, by = "SensorID", all.x = TRUE)

colnames(alldata)

alldata$classify <- ifelse((alldata$OriginalReading > alldata$upper_limit)|(alldata$OriginalReading < alldata$lower_limit) ,1,0)

#checks ...this is just to confirm if merge has happened correctly, no of observations with anamolies etc..

newdata <- alldata[which(alldata$classify==1),] 
nrow(newdata)
##[1] 21204
##there are total 21,204 observations in total with anamolies

dim(newdata)
##[1] 21204    14

write.csv(newdata, file = "C:\\data.csv")

####checks ends here

######getting the top 10 sensors with most number of anamolies (i.e readings which is deviation from what is normal)

require(doBy)
####summing and grouping
#######getting total no of anamolies for each sensor
aggdata<-summaryBy(classify~SensorID, data=alldata, FUN=sum)

#########sorting by top sensors with anamolies

aggdata <- aggdata[order(-aggdata$classify),] 

###listing the top 10 sensors with most anamolies
head(aggdata,10)

##   SensorID classify.sum
##   24176          256
##   82011          226
##   42607          138
##   23914          124
##   63840          123
##   63421          118
##   23361          115
##   24063          114
##   23511          111
##   23866          111

aggdata <- head(aggdata,10)

#####looking at the distribution of these top 10 sensors#####################

#getting subset of data which includes only the top 10 sensors
#perform SQL selects on dataframes

install.packages("sqldf")

library(sqldf)

df <- sqldf("SELECT OriginalReading, ReadingDate, GroupID, SensorID, classify FROM alldata JOIN aggdata USING(SensorID)")

###top sensor 10 with anamoly
df1<-alldata[which(alldata$SensorID==23866), ]
plot(df1$OriginalReading, main = "Sensor1 id:23866", xlab="observation#", ylab="Original_Reading")

###top sensor 9 with anamoly

df2<-alldata[which(alldata$SensorID==23511), ]
plot(df2$OriginalReading, main = "Sensor2 id:23511", xlab="observation#", ylab="Original_Reading")

###top sensor 8 with anamoly

df3<-alldata[which(alldata$SensorID==24063), ]
plot(df3$OriginalReading, main = "Sensor3 id:24063", xlab="observation#", ylab="Original_Reading")
###top sensor 7 with anamoly

df4<-alldata[which(alldata$SensorID==23361), ]
plot(df4$OriginalReading, main = "Sensor4 id:23361", xlab="observation#", ylab="Original_Reading")
###top sensor 6 with anamoly

df5<-alldata[which(alldata$SensorID==63421), ]
plot(df5$OriginalReading, main = "Sensor5 id:63421", xlab="observation#", ylab="Original_Reading")
###top sensor 5 with anamoly

df6<-alldata[which(alldata$SensorID==63840), ]
plot(df6$OriginalReading, main = "Sensor6 id:63840", xlab="observation#", ylab="Original_Reading")
###top sensor 4 with anamoly

df7<-alldata[which(alldata$SensorID==23914), ]
plot(df7$OriginalReading, main = "Sensor7 id:23914", xlab="observation#", ylab="Original_Reading")
###top sensor 3 with anamoly

df8<-alldata[which(alldata$SensorID==42607), ]
plot(df8$OriginalReading, main = "Sensor8 id:42607", xlab="observation#", ylab="Original_Reading")
###top sensor 2 with anamoly

df9<-alldata[which(alldata$SensorID==82011), ]
plot(df9$OriginalReading, main = "Sensor9 id:82011", xlab="observation#", ylab="Original_Reading")
###top sensor 1 with anamoly

df10<-alldata[which(alldata$SensorID==24176), ]
plot(df10$OriginalReading, main = "Sensor10 id:24176", xlab="observation#", ylab="Original_Reading")


