--This script generates the title and year for all movies produced before 1920
--The output is then ordered by the ascending order of the year.

--load the data from HDFS and define the schema
movies = LOAD '/data/movies.csv' USING PigStorage(',') AS (movieid:INT, title:CHARARRAY, year:INT);
--Other load data statements for the other two data sets for your reference
-- load the moviegenres data from HDFS and define the schema
--moviegenres = LOAD '/data/moviegenres.csv' USING PigStorage(',') AS (movieid:INT, genre:CHARARRAY);

-- load the ratings data from HDFS and define the schema. Note that TIMESTAMP left unconverted.
--ratings = LOAD '/data/ratings.csv' USING PigStorage(',') AS (userid:INT, movieid:INT, rating:DOUBLE, TIMESTAMP);


-- Read only the attributes we are interested in.
grpd = group movies by year;
cnt = foreach grpd generate $0 as year1,COUNT($1);

grpd2 = group movies by year;
cnt2 = foreach grpd2 generate $0 as year2,COUNT($1);

jnd = join cnt2 by year2-1, cnt by year1;
DESCRIBE jnd;

fltr = FILTER jnd BY $1 < $3;

rel = foreach fltr generate $0,$1,$3;
-- Send the output to the screen.
dump rel;
