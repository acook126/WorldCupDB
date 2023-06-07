SELECT DISTINCT m.IDENTIFIER,c1.country country_a,c2.country country_b,m.dateTime,m.round,count(DISTINCT g1.OCCURANCE) num_goals_a,count(DISTINCT g2.OCCURANCE) num_goals_b
FROM playersInGame c1,playersInGame c2,Matches m,goalsScored g1,goalsScored g2
WHERE m.IDENTIFIER=c1.identifier AND c1.IDENTIFIER=c2.identifier AND c1.COUNTRY<>c2.COUNTRY AND g1.IDENTIFIER=c1.IDENTIFIER AND g1.NUMBER=c1.NUMBER and g2.IDENTIFIER=c2.IDENTIFIER AND g2.NUMBER=c2.NUMBER AND m.DATETIME BETWEEN '2002-02-23 00:00:00.000000' and '2023-02-23 00:00:00.000000'
GROUP BY m.identifier,c1.country, c2.country, m.dateTime, m.round
;


Select name from Team where country='Canada'



SELECT DISTINCT m.identifier,m.dateTime,m.round,m.stadiumName,c1.COUNTRY,two.COUNTRY
FROM Matches m, PlayersInGame c1
INNER JOIN (SELECT DISTINCT c1.COUNTRY,c1.IDENTIFIER
            FROM Matches m, PlayersInGame c1
            WHERE m.IDENTIFIER=c1.IDENTIFIER) two
        ON c1.COUNTRY<>two.COUNTRY and c1.IDENTIFIER=two.IDENTIFIER
WHERE m.IDENTIFIER=c1.IDENTIFIER


SELECT country, sum(goals) numGoals
FROM (SELECT DISTINCT p.COUNTRY, g.NUMBER,count(g.OCCURANCE) goals
            FROM PLAYERSINGAME p, Matches m,GOALSSCORED g
            WHERE p.IDENTIFIER=m.IDENTIFIER and g.IDENTIFIER=p.IDENTIFIER AND m.ROUND='Group' AND g.NUMBER=p.NUMBER
            GROUP BY p.COUNTRY, g.NUMBER)
GROUP BY country
ORDER BY numGoals desc
LIMIT 5

CREATE INDEX priceIndex
ON Seat(BASEPRICE);


