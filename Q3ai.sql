SELECT DISTINCT m.identifier,m.dateTime,m.round,m.stadiumName,c1.COUNTRY ,c2.COUNTRY
FROM Matches m, PlayersInGame c1,PlayersInGame c2
WHERE m.IDENTIFIER=c1.IDENTIFIER AND c1.IDENTIFIER=c2.identifier  AND c1.country<>c2.country
;