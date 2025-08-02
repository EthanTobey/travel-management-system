-- Create Passport table
create table passport(
	passportID int identity(1,1),
	passportNumber varchar(20) not null,
	dob date not null,
	country varchar(50) not null,
	primary key(passportID)
)

-- Create Traveler table
create table traveler(
	travelerID int identity(1,1),
	passportID int not null,
	fname varchar(50) not null,
	lname varchar(50) not null,
	email varchar(100) not null,
	phone varchar(20),
	primary key(travelerID),
	foreign key(passportID) references passport on delete cascade
)

-- Create Location Table
create table location(
	locationID int identity(1,1),
	city varchar(50) not null,
	country varchar(50) not null,
	language varchar(50),
	primary key(locationID)
)

-- Create Rating Table
create table rating(
	rating int check(rating in (0, 1, 2, 3, 4, 5)),
	description varchar(50),
	primary key(rating)
)

CREATE TABLE flight(
	flightNumber INT PRIMARY KEY,
	airline VARCHAR(100) NOT NULL,
	startLocation INT NOT NULL,
	endLocation INT NOT NULL,
	startTime DATETIME NOT NULL,
	endTime DATETIME NOT NULL,
	FOREIGN KEY (startLocation) REFERENCES location(locationID),
	FOREIGN KEY (endLocation) REFERENCES location(locationID),
	CHECK (startLocation <> endLocation),
	CHECK (startTime < endTime)
);


CREATE TABLE hotel(
	hotelName VARCHAR(100) NOT NULL,
	hotelLocation INT NOT NULL,
	rating INT NOT NULL,
	PRIMARY KEY (hotelName, hotelLocation),
	FOREIGN KEY (hotelLocation) REFERENCES location(locationID),
	FOREIGN KEY (rating) REFERENCES rating(rating)
);

CREATE TABLE flightBookings(
	bookingID INT IDENTITY(1,1) PRIMARY KEY,
	travelerID INT NOT NULL,
	flightNumber INT NOT NULL,
	seatClass VARCHAR(15) CHECK(seatClass in ('First', 'Business', 'Premium', 'EconomyPlus', 'Economy')),
	seatNumber INT,
	seatPrice DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (travelerID) REFERENCES traveler(travelerID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (flightNumber) REFERENCES flight(flightNumber) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT UC_FlightSeat UNIQUE (flightNumber, seatNumber)  -- ensure seat can't be double booked on same flight
);

CREATE TABLE hotelBookings(
	bookingID INT IDENTITY(1,1) PRIMARY KEY,
	travelerID INT NOT NULL,
	hotelName VARCHAR(100) NOT NULL,
	hotelLocation INT NOT NULL,
	price DECIMAL(10, 2) NOT NULL,
	startDate DATETIME NOT NULL,
	endDate DATETIME NOT NULL,
	FOREIGN KEY (travelerID) REFERENCES traveler(travelerID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (hotelName, hotelLocation) REFERENCES hotel(hotelName, hotelLocation) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (startDate < endDate)
);

--Create activity table
CREATE TABLE activity(
	activityID int identity(1,1),
	name varchar(50) NOT NULL,
	description varchar(100),
	price int,
	locationID int NOT NULL,
	rating int NULL,
	primary key(activityID),
	foreign key (locationID) references location,
	foreign key (rating) references rating
)

--Create table activityBookings
CREATE TABLE activityBookings(
	bookingID int identity (1,1),
	travelerID int NOT NULL,
	activityID int NOT NULL,
	date DATE NOT NULL,
	primary key (bookingID),
	foreign key (travelerID) references traveler,
	foreign key (activityID) references activity
)

--Create restaurant table
CREATE TABLE restaurant(
	restaurantID int identity (1,1),
	name varchar(50),
	locationID int,
	cuisine varchar(20),
	rating int,
	primary key (restaurantID),
	foreign key (locationID) references location,
	foreign key (rating) references rating
)