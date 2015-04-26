raw_data = LOAD 'home/zetsui/data/201201hourly.txt' USING Pigstorage(',');
weather_data = FOREACH raw_data GENERATE $1, $10;
ranked_data = RANK weather_data;
final_data = FILTER ranked_data by $0 IS NOT NULL;
STORE final_data INTO 'hbase:/weather'
		USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('info:date info:temp'); //map to $1 and $10 fields
// field 1 will be weather_data, 2 will be ranked, 3 will be tmperature. $1, $10, 
// $0 remember stand for columns you are looking up using PIG
