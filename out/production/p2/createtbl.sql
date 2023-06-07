-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.

CREATE TABLE Stadiums
(
    stadiumName VARCHAR (50) NOT NULL
    ,capacity INTEGER
    ,location VARCHAR (50)
    ,directions VARCHAR (50)
    ,vipPrice FLOAT
    ,food VARCHAR (50)
    ,PRIMARY KEY (stadiumName)
);

CREATE TABLE Matches
(
    identifier INTEGER NOT NULL
    ,priceMultiplier FLOAT
    ,length VARCHAR (50)
    ,dateTime DATETIME
    ,round VARCHAR (50)
    ,stadiumName VARCHAR (50)
    ,PRIMARY KEY (identifier)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
);

CREATE TABLE Team
(
    country VARCHAR (25) NOT NULL
    ,name VARCHAR (50)
    ,URL VARCHAR (50)
    ,group CHAR(1)
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER
    ,PRIMARY KEY (country)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)
);

CREATE TABLE Players
(
    number INTEGER NOT NULL
    ,dateOfBirth DATE
    ,name VARCHAR (25)
    ,position VARCHAR (50)
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER
    ,country VARCHAR (25)
    ,PRIMARY KEY (number)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)
    ,FOREIGN KEY (country) REFERENCES Team(country)
);

CREATE TABLE PlayersInGame
(
    number INTEGER NOT NULL
    ,numberOfYellowCards INTEGER
    ,redCard BOOLEAN
    ,minuteEntered INTEGER
    ,minuteLeft INTEGER
    ,detailedPosition VARCHAR (50)
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER NOT NULL
    ,country VARCHAR (50)
    ,PRIMARY KEY (number,identifier)
    ,FOREIGN KEY (number) REFERENCES Players(number)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)
    ,FOREIGN KEY (country) REFERENCES Team(country)
);

CREATE TABLE GoalsScored
(
    occurance INTEGER NOT NULL
    ,minute INTEGER
    ,penaltyKick BOOLEAN
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER NOT NULL
    ,number INTEGER NOT NULL
    ,PRIMARY KEY (occurance,identifier)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)
    ,FOREIGN KEY (number) REFERENCES Players (number)
);


CREATE TABLE Coaches
(
    name VARCHAR (50) NOT NULL
    ,dateOfBirth DATE
    ,role VARCHAR (50)
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER
    ,country VARCHAR (50)
    ,PRIMARY KEY (name)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)
    ,FOREIGN KEY (country) REFERENCES Team(country)
);



CREATE TABLE Referees
(
    refID INTEGER NOT NULL
    ,name VARCHAR (50)
    ,yearsOfExperience INTEGER
    ,country VARCHAR (50)
    ,PRIMARY KEY (refID)
);

CREATE TABLE RefereesInGame
(
    refID INTEGER NOT NULL
    ,name VARCHAR (50)
    ,role VARCHAR (50) NOT NULL
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER NOT NULL
    ,PRIMARY KEY (refID,identifier)
    ,FOREIGN KEY (refID) REFERENCES Referees(refID)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)
);

CREATE TABLE Seat
(
    seatNumber INTEGER NOT NULL
    ,seatSection CHAR(1)
    ,basePrice FLOAT
    ,stadiumName VARCHAR (50)
    ,identifier INTEGER NOT NULL
    ,PRIMARY KEY (seatNumber,identifier)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)

);

CREATE TABLE Tickets
(
    verificationNumber INTEGER NOT NULL
    ,finalPrice FLOAT
    ,stadiumName VARCHAR (50)
    ,seatNumber INTEGER NOT NULL
    ,identifier INTEGER NOT NULL
    ,PRIMARY KEY (verificationNumber)
    ,FOREIGN KEY (stadiumName) REFERENCES Stadiums(stadiumName)
    ,FOREIGN KEY (seatNumber,identifier) REFERENCES Seat(seatNumber,identifier)
    ,FOREIGN KEY (identifier) REFERENCES Matches(identifier)

);

CREATE TABLE User
(
    password VARCHAR (50) NOT NULL
    ,name VARCHAR (50)
    ,paymentInfo VARCHAR (50)
    ,email VARCHAR (50)
    ,verificationNumber INTEGER
    ,PRIMARY KEY (password)
    ,FOREIGN KEY (verificationNumber) REFERENCES Tickets (verificationNumber)
);