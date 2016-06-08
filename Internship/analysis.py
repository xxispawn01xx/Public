import matplotlib
import matplotlib.pyplot as plt

import pandas as pd
from pandas.tseries.offsets import *
import csv
import os
import numpy as np
from ggplot import *

### Define relative path to read file
base_path = 'Jan Fridge Data/'
files = os.listdir("Jan Fridge Data")
all_files = [base_path + f for f in files]

df = pd.concat((pd.read_csv(f) for f in all_files))

# keep complete date rows
df = df[df.ReadingDate.apply(len) > 15]

df['Datetime'] = pd.to_datetime(df.ReadingDate, unit='s')

grp_time = df.groupby(['SensorID', 'GroupID'])['Datetime']
df['max_by_sensor_group_id'] = grp_time.transform(max)
df['min_date'] = df.max_by_sensor_group_id - Week()

### keep last week data
df = df[df.Datetime >= df.min_date]
# df = df.set_index(pd.DatetimeIndex(df['Datetime']))
df.index = pd.to_datetime(df.Datetime)

### example of one group
x = df[df.GroupID == 1170]

ggplot(x, aes("Datetime", "OriginalReading", group="SensorID")) + \
   geom_line() + \
   facet_wrap("SensorID", scales= 'free') + theme_bw()

### outlier detection

# Create a list with sensors to try
sensors_to_try = list(df.ix[df.GroupID == 1170].SensorID.unique())

## Change the sensors id from groupID 1170
sensor_id = sensors_to_try[1]
sensor_ts = df.ix[df.SensorID == sensor_id, 'OriginalReading']

# As the timestamp is the index, you can just use plot(). A pandas wrapper to matplotlib
sensor_ts.plot()
plt.show() # then this is needed so the plot works.
# Con ggplot
ggplot(sensor_ts.reset_index(), aes('index', 'OriginalReading')) + geom_line()


### STL decomposition
import statsmodels.api as sm
from statsmodels.nonparametric.smoothers_lowess import lowess

# df = df.set_index(pd.DatetimeIndex(df['Datetime']))

# Shows a similar plot to R's stats::stl function
# The filter is not quite the same so it needs some extra work
ts = df.ix[df.SensorID == sensor_id, ['OriginalReading'] ]
ts.OriginalReading.interpolate(inplace=True)
x_stl = sm.tsa.seasonal_decompose(ts.OriginalReading.values, freq=95)
x_stl.plot()
plt.show()

# Apply loess filter to get the trend
trend_loess = lowess(ts.OriginalReading.values, ts.index, frac=0.2)[:,1]
pd.DataFrame(trend_loess).plot()
plt.show()

x_ts = ts.OriginalReading.values
seasonal = x_stl.seasonal # the seasonality is fine
x_ts -= seasonal # remove seasonality
residuals -= trend_loess # remove trend, similar to x_stl.resid but complete


### make a function out of it
# interesting to try things out: http://stackoverflow.com/questions/28536191/how-to-filter-smooth-with-scipy-numpy

ts = df.ix[df.SensorID == sensor_id, ['OriginalReading'] ]

def stl_loess(ts, loess_frac=0.2):
	ts.OriginalReading.interpolate(inplace=True) # if there are NAs
	x_stl = sm.tsa.seasonal_decompose(ts.OriginalReading.values, freq=95)

	# Apply loess filter to get the trend
	trend_loess = lowess(ts.OriginalReading.values, ts.index, frac=loess_frac)[:,1]
	x_ts = ts.OriginalReading.values
	seasonal = x_stl.seasonal # the seasonality is fine
	x_ts -= seasonal # remove seasonality
	remainder = x_ts - trend_loess # remove trend, similar to x_stl.resid but complete

	return remainder


### Find outliers in remainder
# far outliers
def find_outliers(remainder, th=3):
	q1 = np.percentile(remainder, 25)
	q3 = np.percentile(remainder, 75)
	iqr = q3 - q1
	return ( remainder < (q1 - (th * iqr) ) ) | (  remainder > (q3 + (th * iqr) ) )


# outliers
remainder = stl_loess(ts)
ts['outlier'] = np.where(find_outliers(remainder) == True, 1, 0)
ts

ggplot(ts.reset_index(), aes(x='Datetime', y='OriginalReading', color='outlier')) + geom_line() + facet_wrap('outlier')

ggplot(ts.reset_index(), aes(x='Datetime', y='OriginalReading', color='outlier', group='outlier')) + geom_jitter()








