#----First determine number of lines in CSV-----
# testcon <- file("C:/Users/AliDesktop/Desktop/Bit Briefcase/Big Data/Kaggle/CTR/train.csv",open="r")
# readsizeof <- 20000
# nooflines <- 0
# ( while((linesread <- length(readLines(testcon,readsizeof))) > 0 ) 
#   nooflines <- nooflines+linesread )
# close(testcon)
# nooflines
# > nooflines
# total # of 40,428,968 rows in train.csv file size is 6163 MB
# ~=6560 rows per MB

#FUN to read clumps of sorted ascending in train.csv  by 'ID' 
read.clump <- function(file, lines, clump){
  if(clump > 1){
    header <- read.csv(file, nrows=0, header=TRUE)
    p = read.csv(file, skip = lines*(clump-1), 
                 nrows = lines, header=TRUE)
    
    names(p) = header
  } else {
    p = read.csv(file, skip = lines*(clump-1), nrows = lines)
  }
return(p)
}
#print(system.time(read.clump("C:/Users/AliDesktop/Desktop/Bit Briefcase/Big Data/Kaggle/CTR/
#train.csv",1000,10000)))
# user  system elapsed for 1,000 observations over 24 variables
# 114.21    0.73  115.7
#2GB memory for 1,000 observations per 10,000 rows, to calculate th system load and time

#4,000 is desired observations, 10,000 is every line to skip in the ascending CSV
#Decide to go with 6GB memory for 4,000 observaations per 10,000 rows to maximize sample
#CPU/memory buffer/system.time. Should take ~6 minutes of full load

CTRRAW<-read.clump("C:/Users/AliDesktop/Desktop/Bit Briefcase/Big Data/Kaggle/CTR/train.csv",100,10000)
#write.table(CTRRAW, file="CTRRAW.csv") #writes sampling to csv


