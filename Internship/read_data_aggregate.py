import pandas as pd
import csv
import os
import numpy as np
from ggplot import *

### Define relative path to read file
base_path = 'Jan Fridge Data/'
files = os.listdir("Jan Fridge Data")
all_files = [base_path + f for f in files]

df = pd.concat((pd.read_csv(f) for f in all_files))

df.SensorID.value_counts()
df.GroupID.value_counts()

# summary - mean and sd
grp = df.groupby(['SensorID'])['OriginalReading']
summarydata = grp.agg({'m' : 'mean', 's':'std'})

# nothing relevant
summarydata = summarydata.reset_index() # need to remove the index for plotting with python's ggplot
ggplot(summarydata, aes("SensorID", "m")) + geom_point()

### Create new colums with aggregation - potentially useless
grp = df.groupby(['SensorID'])['OriginalReading']
df.ix[:, 'm'] = grp.transform(np.mean)
df.ix[:, 's'] = grp.transform(np.std)

# keep complete date rows
df = df[df.ReadingDate.apply(len) == 23]

df['Datetime'] = pd.to_datetime(df.ReadingDate.values)
df = df.set_index(pd.DatetimeIndex(df['Datetime']))
df['date'] = df["Datetime"].map(lambda t: t.date()).unique()

DT[, min_date:=max(date) - (3600 * 24 * 7)]
DT = DT[date >= min_date]

# remove cases where the date is not complete
# table(nchar(unique(DT$date))) the problem is there are incomplete dates
DT = DT[nchars_date > 10]
DT[, date:=as.POSIXct(date, origin='1970-01-01')]

save(DT, file='data/cleaned_data.RData')










