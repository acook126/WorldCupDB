SELECT DISTINCT p.number,p.name,p.position
FROM players p, PLAYERSINGAME p2
WHERE p.country='Mexico'  AND p.IDENTIFIER='9033' AND p.IDENTIFIER NOT IN (SELECT p2.IDENTIFIER
                                                  FROM PLAYERSINGAME)
;