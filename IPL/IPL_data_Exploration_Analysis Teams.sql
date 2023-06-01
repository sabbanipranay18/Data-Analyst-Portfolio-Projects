### TOP-5 HIGHEST TEAM SCORE IN IPL HISTORY
SELECT (a.date) as Date, concat( a.team1, " 'VS' ", a.team2) as Teams, (b.battingteam) as Highest_Score_Batting_Team, sum(b.total_run) as Team_Runs, CONCAT(a.winningteam, "  'By'  ", a.margin, " " ,a.WonBy) as Team_Won_By
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE a.WonBy != "NoResults" AND  a.WonBy != "SuperOver" AND a.method != "D/L"
GROUP BY a.date, b.id, b.innings, a.team1, a.team2, b.battingteam, a.winningteam, a.WonBy, a.margin
ORDER BY Team_Runs DESC
LIMIT 5;


### TOP-3 HIGHEST TEAM SCORE of EACH SEASON WISE
SELECT subquery.season, subquery.Date, subquery.Teams, subquery.Highest_Score_Batting_Team, subquery.Team_Runs, subquery.Team_Won_By from
	(SELECT a.season, (a.date) as Date, concat( a.team1, " 'VS' ", a.team2) as Teams, (b.battingteam) as Highest_Score_Batting_Team, 
    sum(b.total_run) as Team_Runs, CONCAT(a.winningteam, "  'By'  ", a.margin, " " ,a.WonBy) as Team_Won_By,
    row_number() over (PARTITION BY a.season ORDER BY sum(b.total_run) DESC) as row_num
	FROM ipl_matches a
	JOIN ipl_balltoball b
	ON a.id = b.id
	WHERE a.WonBy != "NoResults" AND  a.WonBy != "SuperOver" AND a.method != "D/L"
	GROUP BY a.season, a.date, b.id, b.innings, a.team1, a.team2, b.battingteam, a.winningteam, a.WonBy, a.margin
	ORDER BY a.season DESC, Team_Runs DESC) as subquery
WHERE row_num <= 3;




### TOP-5 LOWEST TEAM SCORE IN IPL HISTORY
SELECT (a.date) as Date, concat( a.team1, " 'VS' ", a.team2) as Teams, (b.battingteam) as Lowest_Score_Batting_Team, 
sum(b.total_run) as Team_Runs, CONCAT(a.winningteam, "  'By'  ", a.margin, " " ,a.WonBy) as Team_Won_By
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE a.WonBy != "NoResults" AND  a.WonBy != "SuperOver" AND a.method != "D/L"
GROUP BY a.date, b.id, b.innings, a.team1, a.team2, b.battingteam, a.winningteam, a.WonBy, a.margin
ORDER BY Team_Runs ASC
LIMIT 5;


### TOP-3 LOWEST TEAM SCORE of EACH SEASON WISE
SELECT subquery.season, subquery.Date, subquery.Teams, subquery.Lowest_Score_Batting_Team, subquery.Team_Runs, subquery.Team_Won_By from
	(SELECT a.season, (a.date) as Date, concat( a.team1, " 'VS' ", a.team2) as Teams, (b.battingteam) as Lowest_Score_Batting_Team, 
    sum(b.total_run) as Team_Runs, CONCAT(a.winningteam, "  'By'  ", a.margin, " " ,a.WonBy) as Team_Won_By,
    row_number() over (PARTITION BY a.season ORDER BY sum(b.total_run) ASC) as row_num
	FROM ipl_matches a
	JOIN ipl_balltoball b
	ON a.id = b.id
	WHERE a.WonBy != "NoResults" AND  a.WonBy != "SuperOver" AND a.method != "D/L"
	GROUP BY a.season, a.date, b.id, b.innings, a.team1, a.team2, b.battingteam, a.winningteam, a.WonBy, a.margin
	ORDER BY a.season DESC, Team_Runs ASC) as subquery
WHERE row_num <= 3;




### Highest Fours By Teams ###
SELECT BattingTeam, count(total_run) 4s
FROM ipl_balltoball 
WHERE batsman_run = 4
GROUP BY BattingTeam
ORDER BY 4s DESC;


### Highest Fours By Teams by one Inning ###
SELECT a.season, b.BattingTeam, count(b.total_run) 4s
FROM ipl_matches a 
JOIN ipl_balltoball b
ON a.id = b.id 
WHERE batsman_run = 4
GROUP BY a.season, b.BattingTeam, b.id
ORDER BY 4s DESC;


### Highest Fours By Teams by each season ###
SELECT subquery.season, subquery.BattingTeam, subquery.Fours
FROM
(SELECT a.season, b.BattingTeam, count(b.total_run) Fours, row_number() over (partition by a.season order by count(b.total_run) DESC)as row_num
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE batsman_run = 6
GROUP BY b.BattingTeam, a.season) as subquery
WHERE row_num <=3
ORDER BY season DESC, Fours DESC;





### Highest Sixes By Teams ###
SELECT BattingTeam, count(total_run) 6s
FROM ipl_balltoball 
WHERE batsman_run = 6
GROUP BY BattingTeam
ORDER BY 6s DESC;


### Highest Sixes By Teams by one Inning ###
SELECT a.season, b.BattingTeam, count(b.total_run) 6s
FROM ipl_matches a 
JOIN ipl_balltoball b
ON a.id = b.id 
WHERE batsman_run = 6
GROUP BY a.season, b.BattingTeam, b.id
ORDER BY 6s DESC;


### Highest Sixes By Teams by each season ###
SELECT subquery.season, subquery.BattingTeam, subquery.Sixes
FROM
(SELECT a.season, b.BattingTeam, count(b.total_run) Sixes, row_number() over (partition by a.season order by count(b.total_run) DESC)as row_num
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE batsman_run = 6
GROUP BY b.BattingTeam, a.season) as subquery
WHERE row_num <=3
ORDER BY season DESC, Sixes DESC;





