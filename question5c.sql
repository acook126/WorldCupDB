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
