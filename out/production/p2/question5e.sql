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