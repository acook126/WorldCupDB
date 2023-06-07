CREATE OR REPLACE VIEW playerinfo (NAME,NUMBER,DATEOFBIRTH,COUNTRY,ASSOCIATION,GROUP)
AS
SELECT p.NAME,p.NUMBER,p.DATEOFBIRTH,p.COUNTRY,t.NAME,t.GROUP
FROM PLAYERS p,TEAM t
WHERE p.COUNTRY=t.COUNTRY
;


SELECT *
FROM playerinfo
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