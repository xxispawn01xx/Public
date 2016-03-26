rm(list = ls(all = TRUE)); gc()

source('R_libraries.R')
load('data/cleaned_data.RData')


head(DT) #count
DT[, .N, SensorID]
DT[, .N, GroupID]

# Compute minimum date we will consider - 7 days going back should be more than enough, selecting
#maximum date - 7 days
DT[, min_date:=max(date) - (3600 * 24 * 7)]
DT = DT[date >= min_date] #WHERE in SQL

gc() # garbage collection after removing part of the data

## Plotting first one sensor to see how the series look like
# dt = DT[SensorID == 23216]
# max_date = max(dt$date)
# min_date = max_date - 3600 * 24 * 7
# 
# dt = dt[date > min_date]
# 
# plot(dt$date, dt$OriginalReading, type='l')
# 
# ggplot(DT[GroupID == 1170], aes(date, OriginalReading, color=SensorID, group=SensorID)) +
#   geom_line() +
#   facet_wrap(~SensorID, scales= 'free')


pdf('time_serie_plots.pdf', width = 12, 8)
for(g in unique(DT$GroupID)){
  p = ggplot(DT[GroupID == g], aes(date, OriginalReading, color=SensorID, group=SensorID)) +
    geom_line() +
    facet_wrap(~SensorID, scales= 'free') + 
    theme_few() +
    labs(title=sprintf('GroupID %s', g))
  print(p)
}
dev.off()

#DT data object for ggplot, #AESthetic
p = ggplot(DT[GroupID == DT$GroupID[1]], aes(date, OriginalReading, color=SensorID, group=SensorID)) +
  geom_line() +
  facet_wrap(~SensorID, scales= 'free') + #scale each plot by SensorID individually
  theme_few() +
  labs(title=sprintf('GroupID %s', g))
p


# DT[SensorID == 23194, .(as.IDate(date))][, .N, V1]


sensors_to_try = DT[GroupID == 1170, .N, SensorID]$SensorID

## Change the sensors id from groupID 1170
sensor_id = sensors_to_try[6] #Good 23194 has a spike, but doesn't have spike 23174
sensor_ts = DT[SensorID == sensor_id, c('date', 'OriginalReading'), with=F]
#head(sensor_ts)
#str(sensor_ts) date  :POSIXct
#library(zoo) for irregular time series
xts = ts(zoo(sensor_ts$OriginalReading, order.by = sensor_ts$date), frequency=95)
#get as zoo time series, then cast as ts for other packages
#~95 observations in day

###Analysis
#help(stl)
#Loess
x_stl = stl(xts, s.window = 95)
plot(x_stl)
remainder = x_stl$time.series[, 'remainder']

# far outliers #proportion of distribution, more robust
outlier_condition = ( remainder < (quantile(remainder, 0.25)[[1]] - (3 * IQR(remainder))) ) | (  remainder > quantile(remainder, 0.75)[[1]] + (3 * IQR(remainder)) )

# outliers
outlier_condition = ( remainder < (quantile(remainder, 0.25)[[1]] - (1.5 * IQR(remainder))) ) | (  remainder > quantile(remainder, 0.75)[[1]] + (1.5 * IQR(remainder)) )
outlier_condition = ifelse(outlier_condition, 'outlier', 'normal')

table(outlier_condition)

df = data.frame(date=sensor_ts$date, remainder=as.numeric(remainder), 
                outlier_condition = as.character(outlier_condition))

ggplot(df, aes(date, remainder, color=outlier_condition)) +
         geom_point() +
  theme_bw()


mean()

sd(x_stl$time.series[, 'remainder'])

plot(x_stl)

ts(data=sensor_ts$OriginalReading, start=sensor_ts[[1]][[1]], end==sensor_ts[[1]][[nrow(sensor_ts)]])





