-- Tables

CREATE TABLE Cities (
 id SERIAL PRIMARY KEY,
 name varchar(255) NOT NULL,
 state varchar(255) NOT NULL,
 population int
);

CREATE TABLE Passengers (
 id SERIAL PRIMARY KEY,
 firstName varchar(255) NOT NULL,
 lastName varchar(255) NOT NULL,
 phoneNumber varchar(20) NOT NULL,
 cityId int,
 FOREIGN KEY (cityId) REFERENCES Cities(id)
);

CREATE TABLE Airports (
 id SERIAL PRIMARY KEY,
 name varchar(255) NOT NULL,
 code varchar(255) NOT NULL,
 cityId int,
 FOREIGN KEY (cityId) REFERENCES Cities(id)
);

CREATE TABLE Aircraft (
 id SERIAL PRIMARY KEY,
 type varchar(255) NOT NULL,
 airlineName varchar(255) NOT NULL,
 numberOfPassengers int
);

CREATE TABLE AircraftPassengers (
 aircraftId int,
 passengerId int,
 PRIMARY KEY (aircraftId, passengerId),
 FOREIGN KEY (aircraftId) REFERENCES Aircraft(id),
 FOREIGN KEY (passengerId) REFERENCES Passengers(id)
);

CREATE TABLE AircraftAirports (
 aircraftId int,
 airportId int,
 PRIMARY KEY (aircraftId, airportId),
 FOREIGN KEY (aircraftId) REFERENCES Aircraft(id),
 FOREIGN KEY (airportId) REFERENCES Airports(id)
);

-- Insert

INSERT INTO Cities (name, state, population) VALUES ('New York', 'New York', 8398748);
INSERT INTO Cities (name, state, population) VALUES ('Denver', 'Colorado', 727211);
INSERT INTO Cities (name, state, population) VALUES ('Seattle', 'Washington', 744955);

INSERT INTO Passengers (firstName, lastName, phoneNumber, cityId) VALUES ('John', 'Doe', '555-1234', 1);
INSERT INTO Passengers (firstName, lastName, phoneNumber, cityId) VALUES ('Jane', 'Doe', '555-5678', 2);
INSERT INTO Passengers (firstName, lastName, phoneNumber, cityId) VALUES ('Bob', 'Smith', '555-9876', 3);

INSERT INTO Airports (name, code, cityId) VALUES ('JFK', 'JFK', 1);
INSERT INTO Airports (name, code, cityId) VALUES ('LaGuardia', 'LGA', 1);
INSERT INTO Airports (name, code, cityId) VALUES ('Denver International', 'DEN', 2);
INSERT INTO Airports (name, code, cityId) VALUES ('Seattle-Tacoma International', 'SEA', 3);

INSERT INTO Aircraft (type, airlineName, numberOfPassengers) VALUES ('Boeing 747', 'Delta', 416);
INSERT INTO Aircraft (type, airlineName, numberOfPassengers) VALUES ('Airbus A320', 'Southwest', 150);
INSERT INTO Aircraft (type, airlineName, numberOfPassengers) VALUES ('Boeing 787', 'United', 219);

INSERT INTO AircraftPassengers (aircraftId, passengerId) VALUES (1, 1);
INSERT INTO AircraftPassengers (aircraftId, passengerId) VALUES (1, 2);
INSERT INTO AircraftPassengers (aircraftId, passengerId) VALUES (2, 3);
INSERT INTO AircraftPassengers (aircraftId, passengerId) VALUES (3, 1);
INSERT INTO AircraftPassengers (aircraftId, passengerId) VALUES (3, 2);

INSERT INTO AircraftAirports (aircraftId, airportId) VALUES (1, 1);
INSERT INTO AircraftAirports (aircraftId, airportId) VALUES (1, 2);
INSERT INTO AircraftAirports (aircraftId, airportId) VALUES (2, 1);
INSERT INTO AircraftAirports (aircraftId, airportId) VALUES (2, 2);
INSERT INTO AircraftAirports (aircraftId, airportId) VALUES (2, 3);
INSERT INTO AircraftAirports (aircraftId, airportId) VALUES (3, 3);

-- Query 1: What airports are in what cities?
SELECT Airports.name AS airport_name, Cities.name AS city_name
FROM Airports
INNER JOIN Cities ON Airports.cityid = Cities.id;

-- Query 2: List all aircraft passengers have travelled on.
SELECT DISTINCT Passengers.firstName, Passengers.lastName, Aircraft.type
FROM Passengers
INNER JOIN AircraftPassengers ON Passengers.id = AircraftPassengers.passengerid
INNER JOIN Aircraft ON AircraftPassengers.aircraftid = Aircraft.id;

-- Query 3: Which airports can aircrafts take off from and land at?
SELECT Aircraft.type, STRING_AGG(DISTINCT Airports.name, ', ') AS airport_names
FROM Aircraft
INNER JOIN AircraftAirports ON Aircraft.id = AircraftAirports.aircraftid
INNER JOIN Airports ON AircraftAirports.airportid = Airports.id
GROUP BY Aircraft.type;

-- Query 4: What airports have passengers used?
SELECT DISTINCT Airports.name
FROM Airports
INNER JOIN AircraftAirports ON Airports.id = AircraftAirports.airportid
INNER JOIN AircraftPassengers ON AircraftAirports.aircraftid = AircraftPassengers.aircraftid
INNER JOIN Passengers ON AircraftPassengers.passengerid = Passengers.id;
