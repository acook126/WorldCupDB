--Displays match info for all matches
SELECT DISTINCT m.identifier,m.dateTime,m.round,m.stadiumName,c1.COUNTRY ,c2.COUNTRY
FROM Matches m, PlayersInGame c1,PlayersInGame c2
WHERE m.IDENTIFIER=c1.IDENTIFIER AND c1.IDENTIFIER=c2.identifier  AND c1.country<>c2.country
;

--Displays all match info for all matches within the time specified 
SELECT DISTINCT m.identifier,t1.COUNTRY,t2.COUNTRY, m.dateTime,m.round
FROM Matches m,team t1,team t2
WHERE m.IDENTIFIER=t1.IDENTIFIER AND t1.IDENTIFIER=t2.IDENTIFIER AND t1.COUNTRY<>t2.COUNTRY AND m.DATETIME between '2023-02-23 00:00:00.000000' and '2023-02-26 00:00:00.000000'
;

--Displays all the players of a specific country that played in a specific match (data from above query)
Select p2.name,p.number,p.DETAILEDPOSITION,p.MINUTEENTERED,p.MINUTELEFT,p.NUMBEROFYELLOWCARDS,p.REDCARD
FROM playersInGame p, players p2
WHERE p.number=p2.number AND p.identifier='9033' AND p.country='Mexico'
;

--Dsiplays all players from a specific country
SELECT DISTINCT p.number,p.name,p.position
FROM players p, PLAYERSINGAME p2
WHERE p.country='Mexico'  AND p.IDENTIFIER='9033' AND p.IDENTIFIER NOT IN (SELECT p2.IDENTIFIER
                                                  FROM PLAYERSINGAME)
;

--Displays goals scored by a specific country in a specific match
SELECT DISTINCT p.number,g.occurance
FROM playersInGame p,GOALSSCORED g
WHERE p.COUNTRY='Canada' AND p.IDENTIFIER=1566 AND p.NUMBER=g.NUMBER
;

--Displays the top 5 countries that scored the most goals throughout the world cup
SELECT country, sum(goals) Total_Goals
FROM (SELECT DISTINCT p.COUNTRY, g.NUMBER,count(g.OCCURANCE) goals
      FROM PLAYERSINGAME p, Matches m,GOALSSCORED g
      WHERE p.IDENTIFIER=m.IDENTIFIER and g.IDENTIFIER=p.IDENTIFIER AND m.ROUND='Group' AND g.NUMBER=p.NUMBER
      GROUP BY p.COUNTRY, g.NUMBER)
GROUP BY country
ORDER BY Total_Goals desc
    LIMIT 5
;

--Displays info of matches in which a specifc player has played and scored a goal
SELECT s.stadiumName, s.location, m.DATETIME
FROM Stadiums s,
     Matches m
WHERE s.STADIUMNAME = m.STADIUMNAME
  AND m.identifier in (SELECT identifier
                       FROM GoalsScored
                       WHERE number in (SELECT number
                                        FROM PlayersInGame
                                        WHERE number in (SELECT number
                                                         FROM Players
                                                         WHERE name = 'Christine Sinclair')))
;

--Displays info about players that have played for all of their country's matches
SELECT NAME, NUMBER, COUNTRY
FROM PLAYERS
WHERE NUMBER in (SELECT NUMBER
                 FROM (SELECT NUMBER, COUNTRY, COUNT(COUNTRY) as cone
                       FROM PLAYERSINGAME
                       GROUP BY NUMBER, COUNTRY) one
                          INNER JOIN (SELECT p.COUNTRY, COUNT(DISTINCT IDENTIFIER) ctwo
                                      FROM PLAYERSINGAME p
                                      GROUP BY p.COUNTRY) two
                                     ON one.COUNTRY = two.COUNTRY AND one.cone = two.ctwo)
;

--Displays for each team info about their country, the number of matches the have played and the number of goals they scored disregarding goals from penalty kicks
SELECT two.COUNTRY, numMatches, numGoals
FROM (SELECT COUNTRY, COUNT(NUMBER) numGoals
      FROM (SELECT COUNTRY, p.NUMBER
            FROM PLAYERSINGAME p
                     INNER JOIN(SELECT NUMBER, COUNT(OCCURANCE)
                                FROM GOALSSCORED
                                WHERE PENALTYKICK = false
                                GROUP BY NUMBER) one
                               ON p.NUMBER = one.NUMBER)
      GROUP BY COUNTRY) two
         INNER JOIN (SELECT COUNTRY, COUNT(DISTINCT IDENTIFIER) numMatches
                     FROM PLAYERSINGAME
                     GROUP BY COUNTRY) three
                    ON two.COUNTRY = three.COUNTRY
;

--Displays the number of tickets sold by each country per match they played
SELECT five.country, five.numTickets / six.numGames AvgTicketsPerGame
FROM (SELECT DISTINCT two.COUNTRY, SUM(three.four) numTickets
      FROM (SELECT DISTINCT t.IDENTIFIER, p.COUNTRY, COUNT(DISTINCT t.IDENTIFIER) one
            FROM TICKETS t,
                 PLAYERSINGAME p
            WHERE t.IDENTIFIER = p.IDENTIFIER
            GROUP BY t.IDENTIFIER, p.COUNTRY) two
               INNER JOIN (SELECT IDENTIFIER, COUNT(IDENTIFIER) four
                           FROM TICKETS
                           GROUP BY IDENTIFIER) three
                          ON two.IDENTIFIER = three.IDENTIFIER
      GROUP BY two.COUNTRY) five
         INNER JOIN(SELECT COUNTRY, COUNT(DISTINCT IDENTIFIER) numGames
                    FROM PLAYERSINGAME
                    GROUP BY COUNTRY) six
                   ON five.COUNTRY = six.COUNTRY
;

--Displays the number of cards (both red and yellow) given be each referee throught the tournament (assumes that only the main ref can give cards)
SELECT DISTINCT r.NAME, SUM(numCards)
FROM REFEREESINGAME r
         INNER JOIN
     (SELECT one.IDENTIFIER, yellow + red AS numCards
      FROM (SELECT IDENTIFIER, COUNT(NUMBEROFYELLOWCARDS) yellow
            FROM PLAYERSINGAME
            GROUP BY IDENTIFIER) one
               INNER JOIN
           (SELECT IDENTIFIER, COUNT(REDCARD) red
            FROM PLAYERSINGAME
            WHERE REDCARD = true
            GROUP BY IDENTIFIER) two
           ON one.IDENTIFIER = two.IDENTIFIER) three
     ON three.IDENTIFIER = r.IDENTIFIER
WHERE r.ROLE = 'main'
GROUP BY r.NAME
;

--Create a view for more information about a player by combining their info with info about the team they play on
--Important to not that you are unable to insert players directly into the view as it combines data from two different tables
CREATE OR REPLACE VIEW playerinfo (NAME,NUMBER,DATEOFBIRTH,COUNTRY,ASSOCIATION,GROUP)
AS
SELECT p.NAME,p.NUMBER,p.DATEOFBIRTH,p.COUNTRY,t.NAME,t.GROUP
FROM PLAYERS p,TEAM t
WHERE p.COUNTRY=t.COUNTRY
;

--Select the first 5 players from the view
SELECT *
FROM playerinfo
         LIMIT 5
;

--Select the first 5 players from the view that belong to teams in Group A
SELECT *
FROM playerinfo
WHERE GROUP='A'
    LIMIT 5
;

--Creates a check to ensure all players have an appropriate shirt number (between 1 and 99)
ALTER TABLE PLAYERS
ADD CONSTRAINT check_shirtnumber
CHECK ( NUMBER BETWEEN 1 AND 99);

--Insert will fail as the shirt number (121) fails to comply with the check creared above 
INSERT INTO PLAYERS(number, dateofbirth, name, position, stadiumname, identifier, country)
VALUES (121,'2000-01-01','John','forward','Rose Bowl',5949,'Canada');