-- Insert into Passport
insert into passport(passportNumber, dob, country) values
('A1234561', '1990-05-12', 'USA'),
('B1234562', '1985-11-23', 'Canada'),
('C1234563', '2001-02-14', 'India'),
('D1234564', '1998-07-30', 'UK'),
('E1234565', '1975-12-01', 'France'),
('F1234566', '1993-03-15', 'Germany'),
('G1234567', '2000-08-08', 'Japan'),
('H1234568', '1991-09-22', 'Australia'),
('I1234569', '1988-06-17', 'Brazil'),
('J1234570', '1996-01-05', 'Italy'),
('K1234571', '1983-10-10', 'Spain'),
('L1234572', '1999-04-25', 'China'),
('M1234573', '1992-03-13', 'Mexico'),
('N1234574', '2004-07-19', 'Egypt'),
('O1234575', '1987-05-03', 'South Korea')

-- Insert into Traveler
insert into traveler(passportID, fname, lname, email, phone) values
((select passportID from passport where passportNumber = 'A1234561'), 'John', 'Doe', 'john.doe@gmail.com', '123-456-7890'),
((select passportID from passport where passportNumber = 'B1234562'), 'Alice', 'Smith', 'alice.smith@gmail.com', null),
((select passportID from passport where passportNumber = 'C1234563'), 'Ravi', 'Patel', 'ravi.patel@gmail.com', '123-456-7892'),
((select passportID from passport where passportNumber = 'D1234564'), 'Emma', 'Brown', 'emma.brown@gmail.com', '123-456-7893'),
((select passportID from passport where passportNumber = 'E1234565'), 'Pierre', 'Dubois', 'pierre.dubois@gmail.com', '123-456-7894'),
((select passportID from passport where passportNumber = 'F1234566'), 'Hans', 'Mueller', 'hans.mueller@gmail.com', null),
((select passportID from passport where passportNumber = 'G1234567'), 'Yuki', 'Takahashi', 'yuki.takahashi@gmail.com', '123-456-7896'),
((select passportID from passport where passportNumber = 'H1234568'), 'Liam', 'Taylor', 'liam.taylor@gmail.com', '123-456-7897'),
((select passportID from passport where passportNumber = 'I1234569'), 'Carlos', 'Silva', 'carlos.silva@gmail.com', null),
((select passportID from passport where passportNumber = 'J1234570'), 'Giulia', 'Bianchi', 'giulia.bianchi@gmail.com', null),
((select passportID from passport where passportNumber = 'K1234571'), 'Lucia', 'Martinez', 'lucia.martinez@gmail.com', '112-345-6789'),
((select passportID from passport where passportNumber = 'L1234572'), 'Wei', 'Zhang', 'wei.zhang@gmail.com', '122-345-6789'),
((select passportID from passport where passportNumber = 'M1234573'), 'Juan', 'Lopez', 'juan.lopez@gmail.com', '123-345-6789'),
((select passportID from passport where passportNumber = 'N1234574'), 'Fatima', 'Ali', 'fatima.ali@gmail.com', '123-445-6789'),
((select passportID from passport where passportNumber = 'O1234575'), 'Jin', 'Park', 'jin.park@gmail.com', '123-455-6789')

-- Insert into Location
insert into location(city, country, language) values
('San Francisco', 'USA', 'English'),
('Toronto', 'Canada', null),
('Mumbai', 'India', 'Hindi'),
('London', 'UK', null),
('Paris', 'France', 'French'),
('Berlin', 'Germany', 'German'),
('Tokyo', 'Japan', 'Japanese'),
('Sydney', 'Australia', 'English'),
('Rio de Janeiro', 'Brazil', 'Portuguese'),
('Rome', 'Italy', 'Italian'),
('Madrid', 'Spain', 'Spanish'),
('Beijing', 'China', 'Mandarin'),
('Mexico City', 'Mexico', 'Spanish'),
('Cairo', 'Egypt', 'Arabic'),
('Seoul', 'South Korea', 'Korean')

-- Insert into Rating
insert into rating(rating, description) values
(0, 'Very Poor'),
(1, 'Poor'),
(2, 'Fair'),
(3, 'Good'),
(4, 'Very Good'),
(5, 'Excellent')

--insert into flight
INSERT INTO flight(flightNumber, airline, startLocation, endLocation, startTime, endTime) VALUES
(1001, 'American Airlines', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT locationID FROM location WHERE city = 'Toronto' AND country = 'Canada'), '2025-05-01 08:00:00', '2025-05-01 12:00:00'),
(1002, 'Delta Airlines', (SELECT locationID FROM location WHERE city = 'Toronto' AND country = 'Canada'), (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), '2025-05-02 09:00:00', '2025-05-02 13:00:00'),
(1003, 'British Airways', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), '2025-05-03 10:00:00', '2025-05-03 12:30:00'),
(1004, 'Air France', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), '2025-05-04 07:30:00', '2025-05-04 09:30:00'),
(1005, 'Lufthansa', (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), '2025-05-05 14:00:00', '2025-05-05 22:00:00'),
(1006, 'Japan Airlines', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT locationID FROM location WHERE city = 'Sydney' AND country = 'Australia'), '2025-05-06 17:00:00', '2025-05-06 21:30:00'),
(1007, 'Qantas', (SELECT locationID FROM location WHERE city = 'Sydney' AND country = 'Australia'), (SELECT locationID FROM location WHERE city = 'Rio de Janeiro' AND country = 'Brazil'), '2025-05-07 08:30:00', '2025-05-07 22:00:00'),
(1008, 'Emirates', (SELECT locationID FROM location WHERE city = 'Sydney' AND country = 'Australia'), (SELECT locationID FROM location WHERE city = 'Mumbai' AND country = 'India'), '2025-05-08 11:00:00', '2025-05-08 15:30:00'),
(1009, 'KLM', (SELECT locationID FROM location WHERE city = 'Seoul' AND country = 'South Korea'), (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), '2025-05-09 12:30:00', '2025-05-09 15:00:00'),
(1010, 'United Airlines', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT locationID FROM location WHERE city = 'Mexico City' AND country = 'Mexico'), '2025-05-10 09:15:00', '2025-05-10 12:15:00'),
(1011, 'Aeromexico', (SELECT locationID FROM location WHERE city = 'Mexico City' AND country = 'Mexico'), (SELECT locationID FROM location WHERE city = 'Cairo' AND country = 'Egypt'), '2025-05-11 08:00:00', '2025-05-11 18:30:00'),
(1012, 'Turkish Airlines', (SELECT locationID FROM location WHERE city = 'Cairo' AND country = 'Egypt'), (SELECT locationID FROM location WHERE city = 'Seoul' AND country = 'South Korea'), '2025-05-12 16:00:00', '2025-05-12 20:30:00'),
(1013, 'Singapore Airlines', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT locationID FROM location WHERE city = 'Beijing' AND country = 'China'), '2025-05-13 12:00:00', '2025-05-13 16:00:00'),
(1014, 'Cathay Pacific', (SELECT locationID FROM location WHERE city = 'Mumbai' AND country = 'India'), (SELECT locationID FROM location WHERE city = 'Rio de Janeiro' AND country = 'Brazil'), '2025-05-14 14:00:00', '2025-05-14 23:00:00'),
(1015, 'United Airlines', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), '2025-05-14 14:00:00', '2025-05-14 23:00:00');

--insert into hotel
INSERT INTO hotel (hotelName, hotelLocation, rating) VALUES
('Marriott Marquis', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT rating FROM rating WHERE rating = 5)),
('Marriott San Francisco', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT rating FROM rating WHERE rating = 4)),
('Hilton Garden Inn', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 4)),
('Hilton Paris Opera', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 5)),
('The Ritz-Carlton', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT rating FROM rating WHERE rating = 5)),
('Sheraton Grand', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 4)),
('Sheraton Sydney', (SELECT locationID FROM location WHERE city = 'Sydney' AND country = 'Australia'), (SELECT rating FROM rating WHERE rating = 3)),
('Four Seasons Resort', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT rating FROM rating WHERE rating = 5)),
('Holiday Inn Express', (SELECT locationID FROM location WHERE city = 'Toronto' AND country = 'Canada'), (SELECT rating FROM rating WHERE rating = 3)),
('Holiday Inn London', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT rating FROM rating WHERE rating = 4)),
('Grand Hyatt', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 5)),
('Grand Hyatt Seoul', (SELECT locationID FROM location WHERE city = 'Seoul' AND country = 'South Korea'), (SELECT rating FROM rating WHERE rating = 5)),
('Intercontinental Hotel', (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), (SELECT rating FROM rating WHERE rating = 4)),
('Intercontinental Madrid', (SELECT locationID FROM location WHERE city = 'Madrid' AND country = 'Spain'), (SELECT rating FROM rating WHERE rating = 3)),
('Westin Tokyo', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 4)),
('Westin Paris', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 4)),
('Park Hyatt', (SELECT locationID FROM location WHERE city = 'Rio de Janeiro' AND country = 'Brazil'), (SELECT rating FROM rating WHERE rating = 5)),
('Park Hyatt Rome', (SELECT locationID FROM location WHERE city = 'Rome' AND country = 'Italy'), (SELECT rating FROM rating WHERE rating = 4)),
('The Langham', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT rating FROM rating WHERE rating = 5)),
('The Langham Hong Kong', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 4)),
('Accor Hotels', (SELECT locationID FROM location WHERE city = 'Beijing' AND country = 'China'), (SELECT rating FROM rating WHERE rating = 3)),
('Radisson Blu', (SELECT locationID FROM location WHERE city = 'Seoul' AND country = 'South Korea'), (SELECT rating FROM rating WHERE rating = 5)),
('Radisson Blu Paris', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 4)),
('Marriott Courtyard', (SELECT locationID FROM location WHERE city = 'Toronto' AND country = 'Canada'), (SELECT rating FROM rating WHERE rating = 3)),
('Courtyard by Marriott', (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), (SELECT rating FROM rating WHERE rating = 2)),
('Wyndham Grand', (SELECT locationID FROM location WHERE city = 'Mexico City' AND country = 'Mexico'), (SELECT rating FROM rating WHERE rating = 4)),
('Wyndham Hotel', (SELECT locationID FROM location WHERE city = 'Mexico City' AND country = 'Mexico'), (SELECT rating FROM rating WHERE rating = 3));

--insert into flightBookings
--insert into hotel
INSERT INTO hotel (hotelName, hotelLocation, rating) VALUES
('Marriott Marquis', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT rating FROM rating WHERE rating = 5)),
('Marriott San Francisco', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT rating FROM rating WHERE rating = 4)),
('Hilton Garden Inn', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 4)),
('Hilton Paris Opera', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 5)),
('The Ritz-Carlton', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT rating FROM rating WHERE rating = 5)),
('Sheraton Grand', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 4)),
('Sheraton Sydney', (SELECT locationID FROM location WHERE city = 'Sydney' AND country = 'Australia'), (SELECT rating FROM rating WHERE rating = 3)),
('Four Seasons Resort', (SELECT locationID FROM location WHERE city = 'San Francisco' AND country = 'USA'), (SELECT rating FROM rating WHERE rating = 5)),
('Holiday Inn Express', (SELECT locationID FROM location WHERE city = 'Toronto' AND country = 'Canada'), (SELECT rating FROM rating WHERE rating = 3)),
('Holiday Inn London', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT rating FROM rating WHERE rating = 4)),
('Grand Hyatt', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 5)),
('Grand Hyatt Seoul', (SELECT locationID FROM location WHERE city = 'Seoul' AND country = 'South Korea'), (SELECT rating FROM rating WHERE rating = 5)),
('Intercontinental Hotel', (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), (SELECT rating FROM rating WHERE rating = 4)),
('Intercontinental Madrid', (SELECT locationID FROM location WHERE city = 'Madrid' AND country = 'Spain'), (SELECT rating FROM rating WHERE rating = 3)),
('Westin Tokyo', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 4)),
('Westin Paris', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 4)),
('Park Hyatt', (SELECT locationID FROM location WHERE city = 'Rio de Janeiro' AND country = 'Brazil'), (SELECT rating FROM rating WHERE rating = 5)),
('Park Hyatt Rome', (SELECT locationID FROM location WHERE city = 'Rome' AND country = 'Italy'), (SELECT rating FROM rating WHERE rating = 4)),
('The Langham', (SELECT locationID FROM location WHERE city = 'London' AND country = 'UK'), (SELECT rating FROM rating WHERE rating = 5)),
('The Langham Hong Kong', (SELECT locationID FROM location WHERE city = 'Tokyo' AND country = 'Japan'), (SELECT rating FROM rating WHERE rating = 4)),
('Accor Hotels', (SELECT locationID FROM location WHERE city = 'Beijing' AND country = 'China'), (SELECT rating FROM rating WHERE rating = 3)),
('Radisson Blu', (SELECT locationID FROM location WHERE city = 'Seoul' AND country = 'South Korea'), (SELECT rating FROM rating WHERE rating = 5)),
('Radisson Blu Paris', (SELECT locationID FROM location WHERE city = 'Paris' AND country = 'France'), (SELECT rating FROM rating WHERE rating = 4)),
('Marriott Courtyard', (SELECT locationID FROM location WHERE city = 'Toronto' AND country = 'Canada'), (SELECT rating FROM rating WHERE rating = 3)),
('Courtyard by Marriott', (SELECT locationID FROM location WHERE city = 'Berlin' AND country = 'Germany'), (SELECT rating FROM rating WHERE rating = 2)),
('Wyndham Grand', (SELECT locationID FROM location WHERE city = 'Mexico City' AND country = 'Mexico'), (SELECT rating FROM rating WHERE rating = 4)),
('Wyndham Hotel', (SELECT locationID FROM location WHERE city = 'Mexico City' AND country = 'Mexico'), (SELECT rating FROM rating WHERE rating = 3));

--insert into flightBookings
INSERT INTO flightBookings (travelerID, flightNumber, seatClass, seatNumber, seatPrice) VALUES
((SELECT travelerID FROM traveler WHERE travelerID = 1), (SELECT flightNumber FROM flight WHERE flightNumber = 1001), 'Economy', 1, 250.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 2), (SELECT flightNumber FROM flight WHERE flightNumber = 1002), 'Business', 2, 750.00),
((SELECT travelerID FROM traveler WHERE travelerID = 3), (SELECT flightNumber FROM flight WHERE flightNumber = 1003), 'Premium', 3, 550.00),
((SELECT travelerID FROM traveler WHERE travelerID = 4), (SELECT flightNumber FROM flight WHERE flightNumber = 1004), 'First', 4, 1200.00),
((SELECT travelerID FROM traveler WHERE travelerID = 5), (SELECT flightNumber FROM flight WHERE flightNumber = 1005), 'EconomyPlus', 5, 450.00),
((SELECT travelerID FROM traveler WHERE travelerID = 6), (SELECT flightNumber FROM flight WHERE flightNumber = 1006), 'Business', 6, 800.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 7), (SELECT flightNumber FROM flight WHERE flightNumber = 1007), 'Economy', 7, 300.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 8), (SELECT flightNumber FROM flight WHERE flightNumber = 1008), 'First', 8, 1500.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 9), (SELECT flightNumber FROM flight WHERE flightNumber = 1009), 'Premium', 9, 600.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 10), (SELECT flightNumber FROM flight WHERE flightNumber = 1010), 'EconomyPlus', 10, 500.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 11), (SELECT flightNumber FROM flight WHERE flightNumber = 1011), 'Business', 11, 750.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 12), (SELECT flightNumber FROM flight WHERE flightNumber = 1012), 'First', 12, 1400.00), 
((SELECT travelerID FROM traveler WHERE travelerID = 13), (SELECT flightNumber FROM flight WHERE flightNumber = 1013), 'Premium', 13, 600.00),
((SELECT travelerID FROM traveler WHERE travelerID = 14), (SELECT flightNumber FROM flight WHERE flightNumber = 1014), 'Economy', 14, 350.00),
((SELECT travelerID FROM traveler WHERE travelerID = 15), (SELECT flightNumber FROM flight WHERE flightNumber = 1001), 'Business', 15, 850.00); 
--Activity table inserts
INSERT INTO activity(name, description, price, locationID, rating)
VALUES
	('Trolley Ride', 'Explore the city via cable car', 50, (SELECT locationID FROM location WHERE city = 'San Francisco'), (SELECT rating FROM rating WHERE rating = 4)),
	('CN Tower', 'Tallest tower in Canada', 100, (SELECT locationID FROM location WHERE city = 'Toronto'), (SELECT rating FROM rating WHERE rating = 3)),
	('Gateway of India', 'Magnificent historical arch', 0, (SELECT locationID FROM location WHERE city = 'Mumbai'), (SELECT rating FROM rating WHERE rating = 5)),
	('Buckingham Palace', 'Home of the British Crown', 40, (SELECT locationID FROM location WHERE city = 'London'), (SELECT rating FROM rating WHERE rating = 4)),
	('Big Ben', null, 60, (SELECT locationID FROM location WHERE city = 'London'), null),
	('Eiffel Tower', 'Architectural and engineering monument', 150, (SELECT locationID FROM location WHERE city = 'Paris'), (SELECT rating FROM rating WHERE rating = 3)),
	('Berlin Wall', 'Legacy of Cold War', 0, (SELECT locationID FROM location WHERE city = 'Berlin'), (SELECT rating FROM rating WHERE rating = 4)),
	('Sushi-making', 'Experience Japanese food and culture', 40, (SELECT locationID FROM location WHERE city = 'Tokyo'), (SELECT rating FROM rating WHERE rating = 5)),
	('Paragliding', 'Take in the beautiful views', 250, (SELECT locationID FROM location WHERE city = 'Rio de Janeiro'), (SELECT rating FROM rating WHERE rating = 5)),
	('Colosseum', 'Learn about Roman architecture and history', 20, (SELECT locationID FROM location WHERE city = 'Rome'), null),
	('Watch Soccer', null, 400, (SELECT locationID FROM location WHERE city = 'Madrid'), (SELECT rating FROM rating WHERE rating = 4)),
	('Architectural Tour', 'Experience the Great Wall and much more', null, (SELECT locationID FROM location WHERE city = 'Beijing'), (SELECT rating FROM rating WHERE rating = 2)),
	('ATV Tour', 'Travel the desert uniquely', 1500, (SELECT locationID FROM location WHERE city = 'Cairo'), (SELECT rating FROM rating WHERE rating = 1)),
	('Hiking and Eating', 'Experience many parts of Seoul', 70, (SELECT locationID FROM location WHERE city = 'Seoul'), (SELECT rating FROM rating WHERE rating = 4)) 

--activityBookings inserts
INSERT INTO activityBookings(travelerID, activityID, date)
VALUES
	((SELECT travelerID FROM traveler WHERE passportID = 1), (SELECT activityID FROM activity WHERE name = 'Berlin Wall'), '2025-01-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 2), (SELECT activityID FROM activity WHERE name = 'Trolley Ride'), '2024-10-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 3), (SELECT activityID FROM activity WHERE name = 'Big Ben'), '2024-07-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 5), (SELECT activityID FROM activity WHERE name = 'Colosseum'), '2024-08-15'),
	((SELECT travelerID FROM traveler WHERE passportID = 6), (SELECT activityID FROM activity WHERE name = 'Sushi-making'), '2025-01-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 7), (SELECT activityID FROM activity WHERE name = 'Sushi-making'), '2025-01-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 8), (SELECT activityID FROM activity WHERE name = 'Gateway of India'), '2025-01-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 9), (SELECT activityID FROM activity WHERE name = 'Eiffel Tower'), '2025-02-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 9), (SELECT activityID FROM activity WHERE name = 'Buckingham Palace'), '2025-02-05'),
	((SELECT travelerID FROM traveler WHERE passportID = 10), (SELECT activityID FROM activity WHERE name = 'Watch Soccer'), '2025-06-21'),
	((SELECT travelerID FROM traveler WHERE passportID = 11), (SELECT activityID FROM activity WHERE name = 'Hiking and Eating'), '2025-08-01'),
	((SELECT travelerID FROM traveler WHERE passportID = 12), (SELECT activityID FROM activity WHERE name = 'ATV Tour'), '2025-03-15'),
	((SELECT travelerID FROM traveler WHERE passportID = 14), (SELECT activityID FROM activity WHERE name = 'CN Tower'), '2025-04-15'),
	((SELECT travelerID FROM traveler WHERE passportID = 15), (SELECT activityID FROM activity WHERE name = 'Paragliding'), '2025-07-10')

--restaurant table inserts
INSERT INTO restaurant(name, locationID, cuisine, rating)
VALUES
	('Mission Burrito', (SELECT locationID FROM location WHERE city = 'San Francisco'), 'Mexican', (SELECT rating FROM rating WHERE rating = 5)),
	('Rol San', (SELECT locationID FROM location WHERE city = 'Toronto'), 'Chinese', (SELECT rating FROM rating WHERE rating = 4)),
	('The Bombay Canteen', (SELECT locationID FROM location WHERE city = 'Mumbai'), 'Indian', (SELECT rating FROM rating WHERE rating = 5)),
	('Maison Lendemaine', (SELECT locationID FROM location WHERE city = 'Paris'), 'French', (SELECT rating FROM rating WHERE rating = 4)),
	('Gaffel Haus', (SELECT locationID FROM location WHERE city = 'Berlin'), 'German', (SELECT rating FROM rating WHERE rating = 3)),
	('Nobunaga Ramen', (SELECT locationID FROM location WHERE city = 'Tokyo'), 'Japanese', (SELECT rating FROM rating WHERE rating = 4)),
	('McDonalds', (SELECT locationID FROM location WHERE city = 'San Francisco'), 'German', (SELECT rating FROM rating WHERE rating = 1)),
	('Marius Degustare', (SELECT locationID FROM location WHERE city = 'Rio de Janeiro'), 'Brazillian', (SELECT rating FROM rating WHERE rating = 4)),
	('Pane e Salame', (SELECT locationID FROM location WHERE city = 'Rome'), 'Italian', (SELECT rating FROM rating WHERE rating = 2)),
	('La Mi Venta', (SELECT locationID FROM location WHERE city = 'Madrid'), 'Spanish', (SELECT rating FROM rating WHERE rating = 4)),
	('Siji Minfu', (SELECT locationID FROM location WHERE city = 'Beijing'), 'Chinese', (SELECT rating FROM rating WHERE rating = 4)),
	('Gaffel Haus', (SELECT locationID FROM location WHERE city = 'Berlin'), 'German', (SELECT rating FROM rating WHERE rating = 3)),
	('El Califa de Leon', (SELECT locationID FROM location WHERE city = 'Mexico City'), 'Mexican', (SELECT rating FROM rating WHERE rating = 5)),
	('El Cardenal', (SELECT locationID FROM location WHERE city = 'Mexico City'), 'Mexican', (SELECT rating FROM rating WHERE rating = 2)),
	('Jungsik', (SELECT locationID FROM location WHERE city = 'Seoul'), 'Korean', (SELECT rating FROM rating WHERE rating = 4))
