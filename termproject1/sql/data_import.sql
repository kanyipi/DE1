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
Name      VARCHAR(100) NOT NULL
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
,PRIMARY KEY(Name));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Coach_Stats.csv'
INTO TABLE coach_stats 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(Name,Team,SeasG,SeasW,SeasL,FranG,FranW,FranL,CareW,CareL,CareWP,@v_POSeasG,@v_POSeasW,@v_POSeasL,@v_POFranG,@v_POFranW,@v_POFranL,@v_POCareG,@v_POCareW,@v_POCareL)
SET
POSeasG = nullif(@v_POSeasG, ''),
POSeasW = nullif(@v_POSeasW, ''),
POSeasL = nullif(@v_POSeasL, ''),
POFranG = nullif(@v_POFranG, ''),
POFranW = nullif(@v_POFranW, ''),
POFranL = nullif(@v_POFranL, ''),
POCareG = nullif(@v_POCareG, ''),
POCareW = nullif(@v_POCareW, ''),
POCareL = nullif(@v_POCareL, '');

select * from coach_stats;

DROP TABLE IF EXISTS coaches;

CREATE TABLE coaches (
Name      VARCHAR(100)
,TeamID   INT REFERENCES Teams(TeamID)
,PRIMARY KEY(Name, TeamID));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Coaches.csv'
INTO TABLE coaches
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(Name,TeamID);

select * from coaches;

DROP TABLE IF EXISTS player_stats;

CREATE TABLE player_stats (
Player    VARCHAR(100) NOT NULL
,Tm       VARCHAR(10) NOT NULL
,Gms      INT
,Gstart   INT
,MP       INT
,FG       INT
,FGA      INT
,FGP      FLOAT
,ThreeP   INT
,ThreePA  INT
,ThreePP  FLOAT
,TwoP     INT
,TwoPA    FLOAT
,TwoPP    FLOAT
,eFGP     FLOAT
,FT       INT
,FTA      FLOAT
,FTP      FLOAT
,ORB      INT
,DRB      INT
,TRB      INT
,AST      INT
,STL      INT
,BLK      INT
,TOV      INT
,PF       INT
,PTS      INT
,PRIMARY KEY(Player, Tm));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Player_Stats.csv'
INTO TABLE player_stats
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(Player,Tm,Gms,Gstart,MP,FG,FGA,FGP,ThreeP,ThreePA,ThreePP,TwoP,TwoPA,TwoPP,eFGP,FT,FTA,FTP,ORB,DRB,TRB,AST,@v_STL,@v_BLK,@v_TOV,@v_PF,@v_PTS)
SET
PTS = nullif(@v_PTS, ''),
PF = nullif(@v_PF, ''),
BLK = nullif(@v_BLK, ''),
TOV = nullif(@v_TOV, ''),
STL = nullif(@v_STL, '');

select * from player_stats;

DROP TABLE IF EXISTS players;

CREATE TABLE players (
Name      VARCHAR(100)
,Pos      VARCHAR(10)
,Age      INT
,PRIMARY KEY(Name));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Players.csv'
INTO TABLE players
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(Name,Pos,Age);

select * from players;

DROP TABLE IF EXISTS team_stats;

CREATE TABLE team_stats (
TeamId    VARCHAR(100)
,Gms	  INT
,MP       INT
,FG       INT
,FGA      INT
,FGP      FLOAT
,ThreeP   INT
,ThreePA  INT
,ThreePP  FLOAT
,TwoP     INT
,TwoPA    INT
,TwoPP    FLOAT
,FT       INT
,FTA      INT
,FTP      FLOAT
,ORB      INT
,DRB      INT
,TRB      INT
,AST      INT
,STL      INT
,BLK      INT
,TOV      INT
,PF       INT
,PTS      INT
,PRIMARY KEY(TeamId));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Team_Stats.csv'
INTO TABLE team_stats
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(TeamID,Gms,MP,FG,FGA,FGP,ThreeP,ThreePA,ThreePP,TwoP,TwoPA,TwoPP,FT,FTA,FTP,ORB,DRB,TRB,AST,STL,BLK,TOV,PF,PTS);

select * from team_stats;

DROP TABLE IF EXISTS teams;

CREATE TABLE teams (
TeamID       VARCHAR(100)
,TeamName    VARCHAR(100) NOT NULL
,TeamAbbr    VARCHAR(10)
,Location    VARCHAR(100)
,PRIMARY KEY(TeamID));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teams.csv'
INTO TABLE teams
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(TeamID,TeamName,TeamAbbr,Location);

select * from teams;

/* This table is not important (and I couldnt read it in:))
DROP TABLE IF EXISTS top_scorers;

CREATE TABLE top_scorers (
Points        INT NOT NULL
,Name         VARCHAR(100) NOT NULL
,Year         INT
,TeamName     VARCHAR(100)
,OppTeamName  VARCHAR(100)
,TeamScore    INT
,OppTeamScore INT
,MinsPlayed   INT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Top_Scorers.csv'
INTO TABLE top_scorers
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(Points,Name,Year,TeamName,OppTeamName,TeamScore,OppTeamScore,MinsPlayed);

select * from top_scorers;
*/

