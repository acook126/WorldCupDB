Select p2.name,p.number,p.DETAILEDPOSITION,p.MINUTEENTERED,p.MINUTELEFT,p.NUMBEROFYELLOWCARDS,p.REDCARD
FROM playersInGame p, players p2
WHERE p.number=p2.number AND p.identifier='9033' AND p.country='Mexico'
;