--LOAD files into relations. This is how you comment btw
month1 = LOAD 'hdfs:/data/big/201201hourly.txt USING PigStorage(',');
month2 = LOAD 'hdfs:/data/big/201202hourly.txt USING PigStorage(',');
month3 = LOAD 'hdfs:/data/big/201203hourly.txt USING PigStorage(',');
month4 = LOAD 'hdfs:/data/big/201204hourly.txt USING PigStorage(',');
month5 = LOAD 'hdfs:/data/big/201205hourly.txt USING PigStorage(',');
month6 = LOAD 'hdfs:/data/big/201206hourly.txt USING PigStorage(',');

--COMBINE relations
months = UNION month1, month2, month3, month4, month5, month6;
--columns need to line up for UNION to work; combines all loads into one relation

/* Splitting relations
SPLIT months INTO
	splitMonth1 IF SUBSTRING(date, 4, 6) == '01',
	splitMonth1 IF SUBSTRING(date, 4, 6) == '02',
	splitMonth1 IF SUBSTRING(date, 4, 6) == '03',
	splitRest IF (SUBSTRING(date, 4, 6) == '04' OR SUBSTRING(date, 4, 6) == '04');
*/


/*Joining relations
stations = LOAD 'hdfs:/data/big/stations.txt' USING PigStorage() AS  (id:int, name:chararray)

JOIN months by wban, stations by id;
--A UNION is piling rows on top of each other, bringing them together horizontally, a join is by column, like a table
*/

--Filter out unwanted data 
clearWeather = FILTER months BY skyCondition == 'CLR';

--Transform and shape relation
shapedWeather = FOR EACH clearWeather GENERATE date, SUBSTRING(data, 0, 4) as year, SUBSTRING(date, 4, 6) as month, SUBSTRING(data, 6, 8) as day, skyCondition, dryTemp;

--Group relation specifying number of reducers
groupedByMonthDay = GROUP shapedWeather BY month, day PARALLEL 10

--Aggregated Relation
aggedResults = FOREACH groupedByMonthDay GENERATE group as MonthDay, AVG(shapedWeather.dryTemp), MIN(shapedWeather.dryTemp), MAX(shapedWeather.dryTemp), COUNT(shapedWeather.dryTemp) PARALLEL 10;

--Sort relation
sortedResults = SORT aggedResults BY $1 DESC;

--Store results in HDFS 
STORE sortedResults INTO 'hdfs:/data/big/pigresults' USING PigStorage(':');
