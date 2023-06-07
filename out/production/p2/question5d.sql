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




