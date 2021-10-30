USE termproject;

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

-- some sanity checks

SELECT * FROM coach_stats;

SELECT COUNT(distinct Name) FROM coach_stats;
SELECT COUNT(Name) FROM coach_stats;
-- its ok that the name is the key for coach_stats as it is unique

SELECT * FROM coaches;

SELECT COUNT(distinct Name) FROM coaches;
SELECT COUNT(Name) FROM coaches;
-- its ok that the name is the key for coaches as it is unique

SELECT * FROM player_stats;

SELECT COUNT(distinct Player) FROM player_stats;
SELECT COUNT(Player) FROM player_stats;
-- its not ok that the Player is the key for player_stats as it is not unique

SELECT Player, COUNT(*) FROM player_stats group by Player having COUNT(*) > 1;

-- after checking the players on https://www.basketball-reference.com/
-- there are no players with the same name just that some players changed teams and then they have multiple rows

SELECT * FROM players;

SELECT COUNT(distinct Name) FROM players;
SELECT COUNT(Name) FROM players;
-- its ok that the name is the key for players as it is unique

SELECT * FROM team_stats;

SELECT COUNT(distinct TeamID) FROM team_stats;
SELECT COUNT(TeamID) FROM team_stats;
-- its ok that the TeamID is the key for team_stats as it is unique

SELECT * FROM teams;

SELECT COUNT(distinct TeamID) FROM teams;
SELECT COUNT(TeamID) FROM teams;
-- its ok that the TeamID is the key for teams as it is unique

-- datawarehouse

DROP PROCEDURE IF EXISTS CreateTeamCoachPlayerMap;

DELIMITER //

CREATE PROCEDURE CreateTeamCoachPlayerMap()
BEGIN

	DROP TABLE IF EXISTS full_stats_table;

	CREATE TABLE full_stats_table AS
	SELECT 
		player_stats.Player AS PlayerName,
        player_stats.FG AS PlayerFieldGoals,
        player_stats.PTS AS PlayerPoints,
        player_stats.eFGP AS EffectiveFieldGoalPercentage,
        players.Pos AS PlayerPosition,
        players.Age AS PlayerAge,
        teams.TeamID AS TeamRank,
        teams.TeamName AS TeamName,
        team_stats.FG AS TeamFieldGoals,
        team_stats.PTS AS TeamPoints,
        coaches.Name AS CoachName,
        coach_stats.SeasW AS CoachSeasonWin,
        coach_stats.SeasL AS CoachSeasonLose
	FROM
		player_stats
	INNER JOIN
		players ON player_stats.Player=players.Name
    INNER JOIN
		teams ON player_stats.Tm=teams.TeamAbbr
	INNER JOIN
		team_stats USING (TeamID)
    INNER JOIN
		coaches USING (TeamID)
    INNER JOIN
		coach_stats ON coaches.Name=coach_stats.Name;
        
END //
DELIMITER ;

CALL CreateTeamCoachPlayerMap();

SELECT * FROM full_stats_table;

-- stored proc search

DROP PROCEDURE IF EXISTS GetRecordsFROMALayerSearch;

DELIMITER $$

CREATE PROCEDURE GetRecordsFROMALayerSearch (
	IN  searchName VARCHAR(25),
    IN  searchCategory VARCHAR(25)
)
BEGIN

	IF searchCategory = 'coach' THEN 
		SELECT * FROM full_stats_table where CoachName Like CONCAT('%',searchName,'%');
    END IF;
    
    IF searchCategory = 'player' THEN 
		SELECT * FROM full_stats_table where PlayerName Like CONCAT('%',searchName,'%');
    END IF;
    
    IF searchCategory = 'team' THEN 
		SELECT * FROM full_stats_table where TeamName Like CONCAT('%',searchName,'%');
    END IF;
    
END$$
DELIMITER ;

-- example searches

CALL GetRecordsFROMALayerSearch ('Alvin','coach'); -- use case: shows every player a coach coached
CALL GetRecordsFROMALayerSearch ('Boban Marjanovic','player'); -- use case: shows every team a player played for
CALL GetRecordsFROMALayerSearch ('Los Angeles Lakers','team'); -- use case: shows every player for a team

-- trigger if there is a new player in players log it and update the analytical layer

CREATE TABLE log_new_players (logMessage varchar(100) NOT NULL);

DELIMITER $$

CREATE TRIGGER after_new_palyer_insert
AFTER INSERT
ON players FOR EACH ROW
BEGIN
	
	-- log the new player inserted
    	INSERT INTO log_new_players SELECT CONCAT('new player: ', NEW.Name);

	-- archive the order and assosiated table entries to product_sales
  	INSERT INTO full_stats_table
    SELECT
		player_stats.Player AS PlayerName,
        player_stats.FG AS PlayerFieldGoals,
        player_stats.PTS AS PlayerPoints,
        player_stats.eFGP AS EffectiveFieldGoalPercentage,
        players.Pos AS PlayerPosition,
        players.Age AS PlayerAge,
        teams.TeamID AS TeamRank,
        teams.TeamName AS TeamName,
        team_stats.FG AS TeamFieldGoals,
        team_stats.PTS AS TeamPoints,
        coaches.Name AS CoachName,
        coach_stats.SeasW AS CoachSeasonWin,
        coach_stats.SeasL AS CoachSeasonLose
	FROM
		player_stats
	INNER JOIN
		players ON player_stats.Player=players.Name
    INNER JOIN
		teams ON player_stats.Tm=teams.TeamAbbr
	INNER JOIN
		team_stats USING (TeamID)
    INNER JOIN
		coaches USING (TeamID)
    INNER JOIN
		coach_stats ON coaches.Name=coach_stats.Name
	WHERE player_stats.Player = NEW.Name;
        
END $$

DELIMITER ;

-- test here I learned that if the trigger is bad the insert doesn't insert

INSERT INTO players VALUES('Peter Kaiser','tenis',23);
SELECT * FROM log_new_players;

-- to drop
-- DROP TRIGGER IF EXISTS after_new_palyer_insert; 

-- event to create the analytical layer everyday for 1 week

SHOW VARIABLES LIKE "event_scheduler";

DELIMITER $$

CREATE EVENT CreateFullStatsTableEvent
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 7 DAY
DO
	BEGIN
		INSERT INTO log_new_players SELECT CONCAT('event:',NOW());
    		CALL CreateTeamCoachPlayerMap();
	END$$
DELIMITER ;

SHOW EVENTS;

SELECT * FROM log_new_players;

-- to drop it
-- DROP EVENT IF EXISTS CreateFullStatsTableEvent;

-- data marts

DROP VIEW IF EXISTS field_goals;

-- calculate the fieldgoals of all its players we get the fieldgoals of the team

CREATE VIEW field_goals AS
SELECT TeamName, SumFromPlayers-TeamFieldGoals AS FieldGoalDifference FROM (SELECT sum(PlayerFieldGoals) as 'SumFromPlayers', TeamName, TeamFieldGoals FROM full_stats_table GROUP BY TeamName ) AS A;

SELECT * FROM field_goals;

-- there are 3 teams with buig differences so there are some problems with the dataset

DROP VIEW IF EXISTS efgp_rank;

-- Do Players average eFGP affect the teams rank?

CREATE VIEW efgp_rank AS
SELECT avg(EffectiveFieldGoalPercentage) as 'AvgEFGP', TeamName, TeamRank FROM full_stats_table GROUP BY TeamName;

SELECT * FROM efgp_rank;

-- there is no relationship as avg(EffectiveFieldGoalPercentage) is a dumb thing to calculate as for example if a player plays 1 game and has 999 avg then it will inflate the avg greatly

DROP VIEW IF EXISTS avgage_rank;

-- Does the winner of the season have the oldest players?

CREATE VIEW avgage_rank AS
SELECT avg(PlayerAge) as 'AvgAge', TeamName, TeamRank FROM full_stats_table GROUP BY TeamName;

 SELECT * FROM avgage_rank;

-- this avg is still bad as for example if an old player plays 1 game it counts the same as if some 20 year old plays 20 games,
-- maybe a better metric would be avg based on games played for that team this season

DROP VIEW IF EXISTS clippers_lakers;

-- Check the metric from the two Los Angeles based teams?

CREATE VIEW clippers_lakers AS
SELECT * FROM full_stats_table WHERE TeamName LIKE "Los Angeles%";

SELECT * FROM clippers_lakers;