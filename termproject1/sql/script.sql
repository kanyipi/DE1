drop schema if exists termproject;
create schema termproject;

SHOW VARIABLES LIKE "secure_file_priv";
-- please put the cvs in the path of the secure in file

SET GLOBAL local_infile = true;
SHOW VARIABLES LIKE "local_infile";

-- I found this data set https://github.com/carissaallen/NBA-Database here there are 7 tables of the 2017-18 NBA season
USE termproject;

DROP TABLE IF EXISTS coach_stats;

CREATE TABLE Coach_Stats (
CName      VARCHAR(100) NOT NULL
,Team     VARCHAR(10)
,SeasG    INT
,SeasW    INT
,SeasL    INT
,FranG    INT
,FranW    INT
,FranL    INT
,CareW    INT
,CareL    INT
,CareWP   FLOAT
,POSeasG  INT
,POSeasW  INT
,POSeasL  INT
,POFranG  INT
,POFranW  INT
,POFranL  INT
,POCareG  INT
,POCareW  INT
,POCareL  INT
,PRIMARY KEY(CName));

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\Coach_Stats.csv'
INTO TABLE coach_stats 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(CName,Team,SeasG,SeasW,SeasL,FranG,FranW,FranL,CareW,CareL,CareWP,POSeasG,POSeasW,POSeasL,POFranG,POFranW,POFranL,POCareG,POCareW,POCareL);


select ´ from coach_stats;