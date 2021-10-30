# Term Project 1 Documentation
Peter Kaiser Termproject 1 using NBA 17-18 dataset.
## Operational Layer
Finding the data set was the hardest pard of the project and I don't think it is the perfect dataset.
I found a dataset about 17-18 NBA season at [git-repo-url]. It's from  [basketball-reference]. 
I did not use the top scorers table.
There are 6 tables which I used players, playe_stats, coaches, coach_stats, teams, team_stats,
The ER diagram is: 
<p align="center">
  <img src="https://github.com/kanyipi/DE1/blob/main/termproject1/er_diagram2.PNG" />
</p>

These are the total stats for the 17-18 season.
The 3 main tables are the stats for players, coaches, and teams. 

For team and player stats this is the glossary: 

* TeamId -- Rank at the end of the season
* G -- Games
* MP -- Minutes Played
* FG -- Field Goals
* FGA -- Field Goal Attempts
* FGP -- Field Goal Percentage
* ThreeP -- 3-Point Field Goals
* ThreePA -- 3-Point Field Goal Attempts
* ThreePP -- 3-Point Field Goal Percentage
* TwoP -- 2-Point Field Goals
* TwoPA -- 2-point Field Goal Attempts
* TwoPP -- 2-Point Field Goal Percentage
* eFGP -- Effective Field Goal Percentage
* FT -- Free Throws
* FTA -- Free Throw Attempts
* FTP -- Free Throw Percentage
* ORB -- Offensive Rebounds
* DRB -- Defensive Rebounds
* TRB -- Total Rebounds
* AST -- Assists
* STL -- Steals
* BLK -- Blocks
* TOV -- Turnovers
* PF -- Personal Fouls
* PTS -- Points

For coaches it's:
* Name -- Name
* Team -- Team Name Short
* Seas -- Season Metric
* G -- Games
* W -- Win
* L -- Lose
* WP -- Win Percentage
* Fran -- Franchise Metric
* Care -- Career Metric
* PO -- Play Off Metric

## Analytics Plan

I would have some questions about the validity of the dataset, that is for example if we calculate the fieldgoals of all its players we get the fieldgoals of the team.

My other questions would be:

* Do Players average eFGP affect the teams rank?
* Does the winner of the season have the oldest players?
* Check the metric from the two Los Angeles based teams?

For these questions I think I would need 
Player, FG, PTS, eFGP from player_stats
Pos, Age from players
TeamID, TeamName from teams
FG, PTS from team_stats
Name from coaches
SeasW, SeasL from coach_stats

## Analytical layer and ETL

The analytical layer is created by inner joining the tables and selecting the needed columns. The ETL is called on every insertion of the players table and updates everyday for a week. 
<p align="center">
  <img src="https://github.com/kanyipi/DE1/blob/main/termproject1/analytic_layer.PNG" />
</p>

## Project
* Dump20211030.sql is the file for easy load
* data_import.sql is the file for the hard load
* datawarehouse has everything else with comments implicating what each part does



[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [basketball-reference]: <https://www.basketball-reference.com>
   [git-repo-url]: <https://github.com/carissaallen/NBA-Database>
   
