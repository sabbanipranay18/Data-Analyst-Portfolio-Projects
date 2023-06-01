use ipl_analysis;
select * from ipl_matches;
select * from ipl_balltoball;


### TOP-10 HIGHEST WICKET TAKER IN IPL HISTORY ###
SELECT a.Bowler, a.Innings, a.Wickets
FROM
	(SELECT Bowler, count(distinct(id)) as Innings, count(iswicketdelivery) as Wickets
	FROM ipl_balltoball
	WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
	GROUP BY bowler, total_run
	ORDER BY wickets DESC
	LIMIT 10) as a
GROUP BY Bowler, Innings, Wickets;
    
    
    
### BEST BOWLER ###
SELECT Bowler, count(distinct(id)) as Innings, count(iswicketdelivery) as Wickets
FROM ipl_balltoball
WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
GROUP BY bowler, total_run
ORDER BY wickets DESC
LIMIT 1;



### TOP-10 LOWEST WICKET TAKER IN IPL HISTORY ###
select a.bowler, a.innings, a.wickets from
(SELECT Bowler,count(distinct(id))as innings, count(iswicketdelivery) as Wickets
FROM ipl_balltoball
WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
GROUP BY bowler
ORDER BY wickets ASC) as a
Where innings > 10;


### TOP-10 HIGHEST WICKET TAKER IN ONE INNING ###
SELECT Bowler, count(iswicketdelivery) as Wickets
FROM ipl_balltoball
WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
GROUP BY id, bowler
ORDER BY wickets DESC
LIMIT 10;


### TOP-10 LOWEST WICKET TAKER IN ONE INNING ###
SELECT Bowler, count(iswicketdelivery) as Wickets
FROM ipl_balltoball
WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
GROUP BY id, bowler
ORDER BY wickets ASC
LIMIT 10;


### TOP-3 HIGHEST WICKET TAKER IN EACH SEASON (PURPLE CAP) ###
SELECT x.season, x.Innings, x.Bowler, x.Wickets
FROM
	(SELECT subquery.season, sub.Innings, subquery.Bowler, subquery.Wickets,
	row_number() over (PARTITION BY subquery.season ORDER BY subquery.wickets  DESC) as row_num
	FROM
			(SELECT a.Season, b.Bowler, count(b.iswicketdelivery) as Wickets
			FROM ipl_matches a
			JOIN ipl_balltoball b
			ON a.id = b.id
			WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
			GROUP BY a.season, b.bowler
			ORDER BY season DESC, wickets DESC) as subquery
			JOIN
			(select c.season, d.bowler, count(distinct(d.id)) as innings
			from ipl_matches c
			JOIN ipl_balltoball d
			ON c.id = d.id
			GROUP BY c.season, d.bowler) as sub
            ON subquery.season = sub.season AND subquery.bowler = sub.bowler) as x
WHERE row_num <= 3;



### TOP-3 LOWEST WICKET TAKER IN EACH SEASON ###
SELECT subquery.season, subquery.Innings, subquery.Bowler, subquery.Wickets
FROM
	(SELECT a.Season, COUNT(distinct(b.id)) as Innings, b.Bowler, count(b.iswicketdelivery) as Wickets,
    row_number() over (PARTITION BY a.season ORDER BY count(b.iswicketdelivery) ASC) as row_num
	FROM ipl_matches a
	JOIN ipl_balltoball b
	ON a.id = b.id
	WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
	GROUP BY a.season, b.bowler
	ORDER BY season DESC, wickets ASC) as subquery
WHERE row_num <= 3;



### TOP 5 Highest Wicket Taker in One Season
SELECT x.season, x.Bowler, x.Innings, x.Wickets
FROM
	(SELECT subquery.season, sub.Innings, subquery.Bowler, subquery.Wickets
	FROM
			(SELECT a.Season, b.Bowler, count(b.iswicketdelivery) as Wickets
			FROM ipl_matches a
			JOIN ipl_balltoball b
			ON a.id = b.id
			WHERE kind != "run out" AND kind != "retired hurt" AND kind != "retired out" AND kind != "NA"
			GROUP BY a.season, b.bowler
			ORDER BY season DESC, wickets DESC) as subquery
			JOIN
			(select c.season, d.bowler, count(distinct(d.id)) as innings
			from ipl_matches c
			JOIN ipl_balltoball d
			ON c.id = d.id
			GROUP BY c.season, d.bowler) as sub
            ON subquery.season = sub.season AND subquery.bowler = sub.bowler) as x
ORDER BY Wickets DESC
LIMIT 5;





### ECONOMY IN IPL HISTORY ###
SELECT c.Bowler,c.Innings, c.Overs, c.Runs, c.Economy
FROM
	(SELECT a.Bowler,b.Innings, a.Overs, b.Runs, (b.runs/a.overs) as Economy
	FROM
		(SELECT bowler, ROUND(COUNT(ballnumber)/6,0) as Overs
		FROM ipl_balltoball
		WHERE extra_type != "wides" AND extra_type != "noballs" AND extra_type != "penalty"
		GROUP BY bowler) as a
	JOIN
		(SELECT bowler, count(distinct(ID)) as Innings, sum(total_run)as Runs
		FROM ipl_balltoball 
		GROUP BY bowler) as b
	ON a.Bowler = b.Bowler) as c
WHERE Economy IS NOT NULL AND Innings > 25
ORDER BY Economy;




SELECT c.season, c.Bowler,c.Innings, c.Overs, c.Runs, c.Economy
FROM
	(SELECT a.season, a.Bowler, b.Innings, a.Overs, b.Runs, (b.runs/a.overs) as Economy
	FROM
		(SELECT m.season, bb.bowler, ROUND(COUNT(bb.ballnumber)/6,0) as Overs
		FROM ipl_matches m
        JOIN
        ipl_balltoball bb ON m.id = bb.id
		WHERE extra_type != "wides" AND extra_type != "noballs" AND extra_type != "penalty"
		GROUP BY bowler, season) as a
	JOIN
		(SELECT x.season, y.bowler, count(distinct(y.ID)) as Innings, sum(y.total_run)as Runs
		FROM ipl_matches x
        JOIN
        ipl_balltoball y ON x.id = y.id
		GROUP BY bowler, season) as b
	ON a.Bowler = b.Bowler AND a.season = b.season) as c
WHERE Economy IS NOT NULL
ORDER BY Economy;





SELECT d.Season, d.Bowler, d.Innings, d.Overs, d.Runs, d.Economy
FROM
    (SELECT c.Season, c.Bowler, c.Innings, c.Overs, c.Runs, (c.Runs / c.Overs) AS Economy,
    row_number() over (PARTITION BY c.season ORDER BY (c.Runs / c.Overs) ASC) as row_num
    FROM
        (SELECT a.Season, a.Bowler, b.Innings, a.Overs, b.Runs
        FROM
            (SELECT x.Season, y.bowler, ROUND(COUNT(y.ballnumber) / 6, 0) AS Overs
            FROM ipl_matches x 
            JOIN ipl_balltoball y
            ON x.id = y.id
            WHERE extra_type != "wides" AND extra_type != "noballs" AND extra_type != "penalty"
            GROUP BY Season, bowler) AS a
        JOIN
            (SELECT x.Season, y.bowler, COUNT(DISTINCT y.ID) AS Innings, SUM(y.total_run) AS Runs
            FROM ipl_matches x 
            JOIN ipl_balltoball y
            ON x.id = y.id 
            GROUP BY Season, bowler) AS b
        ON a.Season = b.Season AND a.Bowler = b.Bowler
        WHERE b.innings > 3
        ORDER BY b.innings ASC) AS c
) AS d
WHERE Economy IS NOT NULL AND row_num <= 3
order by d.season ASC;


SELECT a.Season, b.Bowler, b.Wicket_Type
FROM ipl_matches a
JOIN ipl_balltoball b
    ON a.id = b.id
WHERE b.iswicketdelivery = 1
    AND b.iswicketdelivery = LEAD(b.iswicketdelivery) OVER (PARTITION BY a.season, b.bowler ORDER BY b.Over)
    AND b.iswicketdelivery = LEAD(b.iswicketdelivery, 2) OVER (PARTITION BY a.season, b.bowler ORDER BY b.Over)
    AND a.season IN (
        SELECT DISTINCT c.season
        FROM ipl_matches c
        JOIN ipl_balltoball d
            ON c.id = d.id
        WHERE d.iswicketdelivery = 1
        GROUP BY c.season, d.bowler
        HAVING COUNT(*) >= 3
    )
ORDER BY a.Season DESC, b.Bowler;



