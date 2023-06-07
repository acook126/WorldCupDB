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



