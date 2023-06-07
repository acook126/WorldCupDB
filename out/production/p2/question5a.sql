--a)
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