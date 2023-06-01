create database ipl_analysis;
use ipl_analysis;

select * from ipl_matches;
select * from ipl_balltoball;


select ID, batter, count(ballnumber) as balls from ipl_balltoball group by ID, batter;
select ID, batter, sum(batsman_run) as runs from ipl_balltoball group by ID, batter;



### STRIKE RATE ###
SELECT a.id, a.innings, a.batter, a.runs, b.balls, (a.runs / b.balls) * 100 as strike_rate
FROM
  (SELECT id, innings, batter, SUM(batsman_run) AS runs
   FROM ipl_balltoball
   GROUP BY id,batter,innings) AS a
JOIN
  (SELECT id, innings, batter, COUNT(ballnumber) AS balls
   FROM ipl_balltoball
   GROUP BY id, batter,innings) AS b
ON a.id = b.id AND a.batter = b.batter AND a.innings = b.innings;



### HIGHEST BATTING STRIKE RATE SEASON WISE (Criteria is runs > 50, balls > 20, innings >= 5) ###
(SELECT a.season, a.Innings, a.batter, a.runs, b.balls, (a.runs / b.balls) * 100 as strike_rate
FROM
  (SELECT x.season, count(distinct(y.id)) as Innings, y.batter, SUM(y.batsman_run) AS runs
   FROM ipl_matches x
   JOIN ipl_balltoball y
   ON x.id = y.id
   GROUP BY season, batter) AS a
JOIN
  (SELECT x.season, y.batter, COUNT(y.ballnumber) AS balls
   FROM ipl_matches x
   JOIN ipl_balltoball y
   ON x.id = y.id where y.extra_type = "NA" OR y.extra_type = "byes"  OR y.extra_type = "legbyes" OR y.extra_type = "noballs"
   GROUP BY season, batter) AS b
ON a.season = b.season AND a.batter = b.batter WHERE runs > 50 AND balls > 20 AND Innings >= 5)
ORDER BY season DESC, strike_rate DESC;


### HIGHEST BATTING STRIKE RATE IN IPL History (Criteria is runs > 50, balls > 20, innings >= 20) ###
(SELECT a.Innings, a.batter, a.runs, b.balls, (a.runs / b.balls) * 100 as strike_rate
FROM
  (SELECT count(distinct(y.id)) as Innings, y.batter, SUM(y.batsman_run) AS runs
   FROM ipl_matches x
   JOIN ipl_balltoball y
   ON x.id = y.id
   GROUP BY batter) AS a
JOIN
  (SELECT y.batter, COUNT(y.ballnumber) AS balls
   FROM ipl_matches x
   JOIN ipl_balltoball y
   ON x.id = y.id where y.extra_type = "NA" OR y.extra_type = "byes"  OR y.extra_type = "legbyes" OR y.extra_type = "penalty"
   GROUP BY batter) AS b
ON a.batter = b.batter WHERE runs > 50 AND balls > 20 AND Innings >= 20)
ORDER BY strike_rate DESC
LIMIT 10;




### PLAYER IPL STATS of every SEASON USING NAME ###
(SELECT a.season, a.Innings, a.batter, a.runs, b.balls, (a.runs / b.balls) * 100 as strike_rate
FROM
  (SELECT x.season, count(distinct(y.id)) as Innings, y.batter, SUM(y.batsman_run) AS runs
   FROM ipl_matches x
   JOIN ipl_balltoball y
   ON x.id = y.id
   GROUP BY season, batter) AS a
JOIN
  (SELECT x.season, y.batter, COUNT(y.ballnumber) AS balls
   FROM ipl_matches x
   JOIN ipl_balltoball y
   ON x.id = y.id where y.extra_type = "NA" OR y.extra_type = "byes"  OR y.extra_type = "legbyes" OR y.extra_type = "noballs"
   GROUP BY season, batter) AS b
ON a.season = b.season AND a.batter = b.batter WHERE runs > 50 AND balls > 20 AND Innings >= 5 AND b.batter = "V Kohli")
ORDER BY strike_rate DESC;




### SEASON-WISE PLAYER RUNS ("ORANGE CAP" WINNERS)###
SELECT subquery.season, subquery.batter, subquery.Runs, subquery.balls
FROM (
  SELECT a.season, b.batter, SUM(b.batsman_run) AS Runs, COUNT(b.ballnumber) AS balls,
         ROW_NUMBER() OVER (PARTITION BY a.season ORDER BY SUM(b.batsman_run) DESC) AS row_num
  FROM ipl_matches a
  JOIN ipl_balltoball b ON a.id = b.id
  GROUP BY a.season, b.batter
) subquery
WHERE subquery.row_num <= 5 # AND season = 2016 #
ORDER BY subquery.season DESC, runs DESC;



### TOP 5 Highest Run Scorer in IPL History of ONE SEASON ###
select a.season, b.batter, sum(b.batsman_run) as Runs, count(b.ballnumber) as balls 
from ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
GROUP BY a.season, b.batter
ORDER BY runs DESC
LIMIT 5;


### TOP 5 Highest Run Scorer in IPL History of ONE INNING ###
select a.season, b.batter, sum(b.batsman_run) as Runs, count(b.ballnumber) as balls 
from ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
GROUP BY a.id, a.season, b.batter
ORDER BY runs DESC
LIMIT 5;


### TOP 5 HIghest Runs Scorer in OVERALL IPL History ###
select batter, count(distinct(id)) as Innings, sum(batsman_run) as Runs, count(ballnumber) as balls
from ipl_balltoball
where extra_type = "NA" OR extra_type = "byes"  OR extra_type = "legbyes" OR extra_type = "noballs"
GROUP BY batter
ORDER BY runs DESC
LIMIT 5;


### BEST BATSMAN ###
select batter, count(distinct(id)) as Innings, sum(batsman_run) as Runs, count(ballnumber) as balls
from ipl_balltoball
where extra_type = "NA" OR extra_type = "byes"  OR extra_type = "legbyes" OR extra_type = "noballs"
GROUP BY batter
ORDER BY runs DESC
LIMIT 1;

### BEST PARTNERSHIP ###
SELECT batter, non_striker, SUM(batsman_run)as Runs 
FROM ipl_balltoball
GROUP BY batter, non_striker
ORDER BY runs DESC
LIMIT 10;




### MOST FOURS HIT IN OVERALL IPL HISTORY ###
SELECT batter, count(batsman_run) 4s
FROM ipl_balltoball 
WHERE batsman_run = 4
GROUP BY batter
ORDER BY 4s DESC;

### MOST FOURS HIT IN ONE INNING ###
SELECT a.season, b.batter, count(b.batsman_run) 4s
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE batsman_run = 4
GROUP BY b.id, b.batter, a.season
ORDER BY 4s DESC;

### MOST FOURS HIT IN EACH SEASON ###
SELECT subquery.season, subquery.batter, subquery.Fours
FROM
(SELECT a.season, b.batter, count(b.batsman_run) Fours, row_number() over (partition by a.season order by count(b.batsman_run) DESC)as row_num
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE batsman_run = 4
GROUP BY b.batter, a.season) as subquery
WHERE row_num <=3
ORDER BY season DESC, Fours DESC;



### MOST SIXES HIT IN OVERALL IPL HISTORY ###
SELECT batter, count(batsman_run) 6s 
FROM ipl_balltoball
WHERE batsman_run = 6
GROUP BY batter
ORDER BY 6s DESC;

### MOST SIXES HIT IN ONE INNING ###
SELECT a.season, b.batter, count(b.batsman_run) 6s
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE batsman_run = 6
GROUP BY b.id, b.batter, a.season
ORDER BY 6s DESC;

### MOST SIXES HIT IN EACH SEASON ###
SELECT subquery.season, subquery.batter, subquery.Sixes
FROM
(SELECT a.season, b.batter, count(b.batsman_run) Sixes, row_number() over (partition by a.season order by count(b.batsman_run) DESC)as row_num
FROM ipl_matches a
JOIN ipl_balltoball b
ON a.id = b.id
WHERE batsman_run = 6
GROUP BY b.batter, a.season) as subquery
WHERE row_num <=3
ORDER BY season DESC, Sixes DESC;



### FASTEST FIFTY IN IPL HISTORY ###
SELECT a.id, a.batter, b.balls, a.runs
FROM
	(SELECT id, batter, sum(batsman_run) Runs 
    FROM ipl_balltoball 
    GROUP BY id, batter) as a
	JOIN
	(SELECT id, batter, count(ballnumber) Balls 
    FROM ipl_balltoball
    where extra_type = "NA"
    GROUP BY id, batter, extra_type, extras_run
    order by balls) as b
	ON a.id = b.id AND a.batter = b.batter
WHERE runs BETWEEN 50 AND 175
ORDER BY balls
LIMIT 5;





### FASTEST FIFTY IN EACH SEASON ###
select subquery.season, subquery.batter,subquery.balls, subquery.runs
FROM
	(SELECT a.season, a.batter, a.runs, b.balls, row_number() over (PARTITION BY a.season ORDER BY balls ASC) as row_num 
	FROM
		(SELECT x.season, y.id, y.batter, sum(y.batsman_run) Runs
		FROM ipl_matches x JOIN ipl_balltoball y ON x.id = y.id GROUP BY x.season, y.batter, y.id) as a
		JOIN 
		(SELECT x.season, y.id, y.batter, count(y.ballnumber) Balls
		FROM ipl_matches x JOIN ipl_balltoball y ON x.id = y.id
        WHERE extra_type != "wides" AND extra_type != "noballs" AND extra_type != "legbyes"
        GROUP BY x.season, y.batter, y.id) as b
		ON a.season = b.season AND a.id = b.id AND a.batter = b.batter
		WHERE runs BETWEEN 50 AND 55) as subquery
WHERE row_num <= 3
ORDER BY season DESC, balls ASC;



### FASTEST HUNDRED IN IPL HISTORY ###
SELECT a.batter, b.balls, a.runs
FROM
(SELECT id, batter, sum(batsman_run) Runs FROM ipl_balltoball GROUP BY id, batter) as a
JOIN
(SELECT id, batter, count(ballnumber) Balls FROM ipl_balltoball where extra_type = "NA" OR extra_type = "legbyes" OR extra_type = "byes" OR extra_type = "noballs" GROUP BY id, batter) as b
ON a.id = b.id AND a.batter = b.batter
WHERE runs BETWEEN 100 AND 105 
ORDER BY balls asc
LIMIT 5;






