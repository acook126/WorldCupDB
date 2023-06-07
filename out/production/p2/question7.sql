ALTER TABLE PLAYERS
ADD CONSTRAINT check_shirtnumber
CHECK ( NUMBER BETWEEN 1 AND 99);

INSERT INTO PLAYERS(number, dateofbirth, name, position, stadiumname, identifier, country)
VALUES (121,'2000-01-01','John','forward','Rose Bowl',5949,'Canada');