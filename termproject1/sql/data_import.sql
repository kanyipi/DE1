-- please run Dump20211030.sql for to have an easy import

-- DROP SCHEMA IF EXISTS termproject;
CREATE SCHEMA termproject;

SHOW VARIABLES LIKE "secure_file_priv";

-- please put the cvs the data folder to the path of the secure in file

-- SET @infilePath='C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\' doesnt work
-- SET @endLine ='\r';
-- can not use these variables at loads so please
-- and replace all occurences of 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Coaches.csv'
-- to the output of the above command
-- and IF the loads don't at first try then 
-- replace all occurences of '\r' to either '\n', '\n\r', '\r\n' or what works on your system
-- to the output of the above command as I couldnt find a way to make LOAD DATA INFILE work with a variable


SHOW VARIABLES LIKE "local_infile";

-- IF off please run
-- SET GLOBAL local_infile = true;

USE termproject;

-- I found this data set https://github.com/carissaallen/NBA-Database here there are 7 tables of the 2017-18 NBA season
-- loading coach_stats table

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
POSeasG = nullIF(@v_POSeasG, ''),
POSeasW = nullIF(@v_POSeasW, ''),
POSeasL = nullIF(@v_POSeasL, ''),
POFranG = nullIF(@v_POFranG, ''),
POFranW = nullIF(@v_POFranW, ''),
POFranL = nullIF(@v_POFranL, ''),
POCareG = nullIF(@v_POCareG, ''),
POCareW = nullIF(@v_POCareW, ''),
POCareL = nullIF(@v_POCareL, '');

-- checking to see IF it worked

SELECT * FROM coach_stats;

-- loading coaches table

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

-- checking to see IF it worked

SELECT * FROM coaches;

-- loading player_stats table

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
PTS = nullIF(@v_PTS, ''),
PF = nullIF(@v_PF, ''),
BLK = nullIF(@v_BLK, ''),
TOV = nullIF(@v_TOV, ''),
STL = nullIF(@v_STL, '');

-- checking to see IF it worked

SELECT * FROM player_stats;

-- loading players table

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

-- checking to see IF it worked

SELECT * FROM players;

-- loading team_stats table

DROP TABLE IF EXISTS team_stats;

CREATE TABLE team_stats (
TeamID    VARCHAR(100)
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
,PRIMARY KEY(TeamID));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Team_Stats.csv'
INTO TABLE team_stats
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r' 
IGNORE 1 LINES 
(TeamID,Gms,MP,FG,FGA,FGP,ThreeP,ThreePA,ThreePP,TwoP,TwoPA,TwoPP,FT,FTA,FTP,ORB,DRB,TRB,AST,STL,BLK,TOV,PF,PTS);

-- I only could load TeamID as VARCHAR
-- Cant alter it same for teams
-- ALTER TABLE team_stats MODIFY TeamID INT;

-- checking to see IF it worked
SELECT * FROM team_stats;

-- loading teams table

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

-- checking to see IF it worked

SELECT * FROM teams;

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

SELECT * FROM top_scorers;
*/

-- stored proc to search for player/coach/team

DROP PROCEDURE IF EXISTS GetRecordsForSearch;

DELIMITER $$

CREATE PROCEDURE GetRecordsForSearch (
	IN  searchName VARCHAR(25),
    IN  searchTable VARCHAR(25)
)
BEGIN

	IF searchTable = 'coach' THEN 
		SELECT * FROM coaches WHERE Name LIKE CONCAT('%',searchName,'%');
    END IF;
    
    IF searchTable = 'player' THEN 
		SELECT * FROM players WHERE Name LIKE CONCAT('%',searchName,'%');
    END IF;
    
    IF searchTable = 'team' THEN 
		SELECT * FROM teams WHERE TeamName LIKE CONCAT('%',searchName,'%');
    END IF;
    
END$$
DELIMITER ;

-- example searches

CALL GetRecordsForSearch ('Alvin','coach');
CALL GetRecordsForSearch ('LeBron','player');
CALL GetRecordsForSearch ('Los Angeles','team');
