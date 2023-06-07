Select p.number,p2.name
FROM PLAYERSINGAME p, players p2
WHERE p.number=p2.number AND p.identifier=9033 AND p.country='Mexico'
;