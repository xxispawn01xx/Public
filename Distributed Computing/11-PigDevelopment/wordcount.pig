--Register custom .jar containing UDF
REGISTER /home/zetsui/NuggetFiles/11-PigDevelopment/PigUDFS.jar;
--use define operator here if you want to call this all over your script, almost like a variable 

--Load HDFS data into relation
book = LOAD 'hdfs:/data/small/war_and_peace.txt' USING PigStorage() AS (lines:charray);

--Break up lines into words
words = FOREACH book GENERATE FLATTEN(TOKENIZE(lines)) as word;

--Call custom UDF to send all words to lowercase
wordsLower = FOREACH words GENERATE hadoopnugs.pig.udfs.toLower(word);

--Group words
wordsGrouped = GROUP wordsLower by $0;

--Aggregate words for count
wordsAggregated = FOREACH wordsGrouped GENERATE group as word, COUNT(wordsLower) as wordCount;

--Sort aggregated words
wordsSorted = ORDER wordsAggregated BY wordCount desc;

--Store sorted results into HDFS
STORE wordsSorted INTO 'hdfs:/data/small/pigresults2';
