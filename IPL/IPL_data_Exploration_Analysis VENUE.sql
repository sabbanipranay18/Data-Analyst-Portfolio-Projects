select * from ipl_matches;
select * from ipl_balltoball;


select venue, CONCAT(team1, " VS ", team2), tosswinner, tossdecision, COUNT(tossdecision) as toss, winningteam, wonby
FROM ipl_matches
GROUP BY venue, team1, team2, tosswinner, tossdecision, winningteam, wonby
order by toss DESC;