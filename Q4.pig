--This script generates the title and year for all movies produced before 1920
--The output is then ordered by the ascending order of the year.

--load the data from HDFS and define the schema
movies = LOAD '/data/movies.csv' USING PigStorage(',') AS (movieid:INT, title:CHARARRAY, year:INT);
--Other load data statements for the other two data sets for your reference
-- load the moviegenres data from HDFS and define the schema
--moviegenres = LOAD '/data/moviegenres.csv' USING PigStorage(',') AS (movieid:INT, genre:CHARARRAY);

-- load the ratings data from HDFS and define the schema. Note that TIMESTAMP left unconverted.
ratings = LOAD '/data/ratings.csv' USING PigStorage(',') AS (userid:INT, movieid:INT, rating:DOUBLE, TIMESTAMP);

--Group ratings by movieid
grpd = group ratings by movieid;

--Count number of ratings per each movie
cnt = foreach grpd generate $0,COUNT($1) as num_ratings;

jnd = Join cnt by $0, movies by movieid;

rel = foreach jnd generate title, num_ratings;

srtd = order rel by num_ratings desc;

Top10 = limit srtd 10;

dump Top10;
