#getwd() 
#"C:/Users/AliDesktop/Desktop/Magic Briefcase/Internship"
# file_names <- dir("C:/Users/AliDesktop/Desktop/Magic Briefcase/Internship/Jan Fridge Data")
# your_data_frame <- do.call(rbind,lapply(file_names,read.csv))

load_data <- function(path) { 
  files <- dir(path, pattern = '\\.csv', full.names = TRUE)
  tables <- lapply(files, read.csv)
  do.call(rbind, tables)
}

raw_data <- load_data("C:/Users/AliDesktop/Desktop/Magic Briefcase/Internship/Jan Fridge Data")

ts_explore <- ts(ReadingDate, frequency=24, start=c(1946,1))