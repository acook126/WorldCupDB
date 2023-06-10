SELECT DISTINCT m.identifier,m.dateTime,m.round,m.stadiumName,c1.COUNTRY ,c2.COUNTRY
FROM Matches m, PlayersInGame c1,PlayersInGame c2
WHERE m.IDENTIFIER=c1.IDENTIFIER AND c1.IDENTIFIER=c2.identifier  AND c1.country<>c2.country
;

SELECT DISTINCT m.identifier,t1.COUNTRY,t2.COUNTRY, m.dateTime,m.round
FROM Matches m,team t1,team t2
WHERE m.IDENTIFIER=t1.IDENTIFIER AND t1.IDENTIFIER=t2.IDENTIFIER AND t1.COUNTRY<>t2.COUNTRY AND m.DATETIME between '2023-02-23 00:00:00.000000' and '2023-02-26 00:00:00.000000'
;

Select p2.name,p.number,p.DETAILEDPOSITION,p.MINUTEENTERED,p.MINUTELEFT,p.NUMBEROFYELLOWCARDS,p.REDCARD
FROM playersInGame p, players p2
WHERE p.number=p2.number AND p.identifier='9033' AND p.country='Mexico'
;

SELECT DISTINCT p.number,p.name,p.position
FROM players p, PLAYERSINGAME p2
WHERE p.country='Mexico'  AND p.IDENTIFIER='9033' AND p.IDENTIFIER NOT IN (SELECT p2.IDENTIFIER
                                                  FROM PLAYERSINGAME)
;

Select p.number,p2.name
FROM PLAYERSINGAME p, players p2
WHERE p.number=p2.number AND p.identifier=9033 AND p.country='Mexico'
;

SELECT DISTINCT p.number,g.occurance
FROM playersInGame p,GOALSSCORED g
WHERE p.COUNTRY='Canada' AND p.IDENTIFIER=1566 AND p.NUMBER=g.NUMBER
;

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

CREATE OR REPLACE VIEW playerinfo (NAME,NUMBER,DATEOFBIRTH,COUNTRY,ASSOCIATION,GROUP)
AS
SELECT p.NAME,p.NUMBER,p.DATEOFBIRTH,p.COUNTRY,t.NAME,t.GROUP
FROM PLAYERS p,TEAM t
WHERE p.COUNTRY=t.COUNTRY
;

SELECT *
FROM playerinfo
         LIMIT 5
;

SELECT *
FROM playerinfo
WHERE GROUP='A'
    LIMIT 5
;

INSERT INTO playerinfo(name, number, dateofbirth, country, association, group)
VALUES ('Tom Smith',26,'1990-03-21','USA','USA Football Club','D');

ALTER TABLE PLAYERS
ADD CONSTRAINT check_shirtnumber
CHECK ( NUMBER BETWEEN 1 AND 99);

INSERT INTO PLAYERS(number, dateofbirth, name, position, stadiumname, identifier, country)
VALUES (121,'2000-01-01','John','forward','Rose Bowl',5949,'Canada');