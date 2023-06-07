-- Include your drop table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the drop table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been dropped (reverse of the creation order).

DROP TABLE User;
DROP TABLE Tickets;
DROP TABLE Seat;
DROP TABLE RefereesInGame;
DROP TABLE Referees;
DROP TABLE Coaches;
DROP TABLE GoalsScored;
DROP TABLE PlayersInGame;
DROP TABLE Players;
DROP TABLE Team;
DROP TABLE Matches;
DROP TABLE Stadiums;
