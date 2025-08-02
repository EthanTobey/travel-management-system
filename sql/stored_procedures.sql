-- Use Case 1: Cancel a Traveler's Trip (Select, Delete) 

CREATE OR ALTER PROCEDURE CancelTravelerTrip
    @travelerID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if traveler exists
        IF NOT EXISTS (
            SELECT 1 FROM traveler WHERE travelerID = @travelerID
        )
        BEGIN
            -- Traveler doesn't exist, rollback and exit
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Show bookings that will be deleted
        SELECT * FROM hotelBookings WHERE travelerID = @travelerID;
        SELECT * FROM activityBookings WHERE travelerID = @travelerID;
        SELECT * FROM flightBookings WHERE travelerID = @travelerID;

        -- Delete the bookings
        DELETE FROM hotelBookings WHERE travelerID = @travelerID;
        DELETE FROM activityBookings WHERE travelerID = @travelerID;
        DELETE FROM flightBookings WHERE travelerID = @travelerID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- rethrow the error for visibility
        THROW;
    END CATCH
END;

GRANT SELECT ON traveler TO dbuser;
GRANT SELECT, DELETE ON hotelBookings TO dbuser;
GRANT SELECT, DELETE ON activityBookings TO dbuser;
GRANT SELECT, DELETE ON flightBookings TO dbuser;
GRANT EXECUTE ON CancelTravelerTrip TO dbuser;




-- Use Case 2: Add a New Restaurant and Show Other Options in Same City and Country with Higher Rating (Insert, Select)

CREATE OR ALTER PROCEDURE insertRestaurantAndSuggestBetter
    @name VARCHAR(100),
    @cuisine VARCHAR(50),
    @city VARCHAR(100),
    @country VARCHAR(100),
    @rating INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @locationID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Get locationID based on city and country
        SELECT @locationID = locationID
        FROM location
        WHERE city = @city AND country = @country;

        -- Optionally check if location exists
        IF @locationID IS NULL
        BEGIN
            -- Location not found, rollback and exit
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insert the new restaurant
        INSERT INTO restaurant (name, locationID, cuisine, rating)
        VALUES (@name, @locationID, @cuisine, @rating);

        -- Return restaurants in same location with higher rating
        SELECT r.restaurantID, r.name, r.cuisine, r.rating, l.city, l.country
        FROM restaurant r
        JOIN location l ON r.locationID = l.locationID
        WHERE l.city = @city AND l.country = @country
          AND r.rating > @rating;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Optional: raise the error to the caller
        THROW;
    END CATCH
END;

GRANT EXECUTE ON InsertRestaurantAndSuggestBetter TO dbuser;
GRANT SELECT, INSERT ON restaurant TO dbuser;
GRANT SELECT ON location TO dbuser;




--Use Case 3
--Rate an Activity and Retrieve the Most Highly Rated Activities in the Same City (Insert, Update, Select)
--This involves the following tables: activity, rating, and location. 
--First, if it does not already exist, we will add the desired rating to the rating table. 
--Then, we will check if the activity exists in the activity table, and if it does, we will update it to add the desired rating. 
--If it does not exist, we will insert the activity (along with its corresponding rating). 
--Then, we will select all activities in the same city and sort them by rating in descending order.

CREATE OR ALTER PROCEDURE rateActivityAndGetRecommendations
    @rating INT,
    @activityID INT,
    @activityName VARCHAR(50),
    @activityCity VARCHAR(50),
    @activityCountry VARCHAR(50)
AS
BEGIN 
    SET NOCOUNT ON;

    DECLARE @locationID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insert into rating if it doesn't already exist
        IF NOT EXISTS (SELECT 1 FROM rating WHERE rating = @rating)
        BEGIN
            INSERT INTO rating(rating, description)
            VALUES (@rating, NULL);
        END

        -- 2. Insert location if it doesn't already exist
        SELECT @locationID = locationID
        FROM location
        WHERE city = @activityCity AND country = @activityCountry;

        IF @locationID IS NULL
        BEGIN
            INSERT INTO location(city, country, language)
            VALUES (@activityCity, @activityCountry, NULL);

            SELECT @locationID = SCOPE_IDENTITY();
        END

        -- 3. Update rating if activity exists, else insert activity with new rating
        IF EXISTS (SELECT 1 FROM activity WHERE activityID = @activityID)
        BEGIN
            SELECT @locationID = locationID FROM activity WHERE activityID = @activityID;

            UPDATE activity
            SET rating = @rating
            WHERE activityID = @activityID;
        END
        ELSE
        BEGIN
            INSERT INTO activity(name, description, price, locationID, rating)
            VALUES (@activityName, NULL, NULL, @locationID, @rating);

            -- Set @activityID to the newly inserted activityID
            SET @activityID = SCOPE_IDENTITY();
        END

        -- 4. Select top 5 highest rated activities excluding the one just inserted/updated
        SELECT TOP 5 
            a.activityID,
            a.name,
            a.description,
            a.price,
            a.rating,
            l.city,
            l.country
        FROM activity a
        JOIN location l ON a.locationID = l.locationID
        WHERE a.activityID <> @activityID 
            AND a.locationID = @locationID
        ORDER BY a.rating DESC;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

GRANT EXECUTE ON rateActivityAndGetRecommendations TO dbuser;



--Use Case 4: Find Travelers with Flights but no Hotel Bookings and Book Them at a Hotel in their Destination

USE TravelManagement
GO

CREATE OR ALTER PROCEDURE bookHotel
AS
BEGIN
    -- Start a transaction to ensure atomicity
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Make temp table to store the new bookings - it will be removed later
        CREATE TABLE #NewBookings (
            bookingID INT,
            travelerID INT,
            hotelName VARCHAR(100),
            hotelLocation INT,
            price DECIMAL(10, 2),
            startDate DATETIME,
            endDate DATETIME
        );
        
        -- Step 1: Find travelers with no hotel bookings at destination
        WITH RankedHotels AS (
            SELECT 
                fb.travelerID,
                h.hotelName,
                h.hotelLocation,
                h.rating * 100.0 AS price,
                f.endTime AS startDate,
                DATEADD(DAY, 1, f.endTime) AS endDate,
                ROW_NUMBER() OVER (                              
                    PARTITION BY fb.travelerID, f.endLocation
                    ORDER BY h.rating * 100.0 ASC
                ) AS rn
            FROM flightBookings fb
            INNER JOIN flight f 
                ON fb.flightNumber = f.flightNumber
            INNER JOIN traveler t 
                ON fb.travelerID = t.travelerID
            LEFT JOIN hotelBookings hb 
                ON hb.travelerID = t.travelerID AND hb.hotelLocation = f.endLocation
            INNER JOIN hotel h 
                ON h.hotelLocation = f.endLocation
            WHERE hb.bookingID IS NULL 
              AND NOT EXISTS (
                    SELECT 1
                    FROM hotelBookings hb2
                    WHERE hb2.travelerID = fb.travelerID 
                      AND hb2.hotelLocation = f.endLocation
                )
        )

        -- Step 2: Insert the cheapest hotel option per traveler/destination
        INSERT INTO hotelBookings(travelerID, hotelName, hotelLocation, price, startDate, endDate)
        OUTPUT INSERTED.bookingID, INSERTED.travelerID, INSERTED.hotelName, INSERTED.hotelLocation,
               INSERTED.price, INSERTED.startDate, INSERTED.endDate
        INTO #NewBookings(bookingID, travelerID, hotelName, hotelLocation, price, startDate, endDate)
        SELECT 
            travelerID,
            hotelName,
            hotelLocation,
            price,
            startDate,
            endDate
        FROM RankedHotels
        WHERE rn = 1;

        -- Step 3: Return all new bookings
        SELECT * FROM #NewBookings

        -- Commit transaction if everything was successful
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction in case of an error
        ROLLBACK TRANSACTION;

        -- throw error to caller (java) so they see it
        THROW;
    END CATCH;
END;

GRANT EXECUTE ON bookHotel TO dbuser;



--Use Case 5: Close Restaurants in a specific Country Below a Given Rating - implemented by Lekh

USE TravelManagement
GO

--A Country Cracks Down on Food Code Violations, and All the Restaurants with a Rating Below x Close. 
--Then, Show the User Which Restaurants Have Closed  (Select, Delete) - implemented by Lekh
--This case involves the following tables: location and restaurant.
--A delete statement (with a where clause) must be used to find and remove all of the restaurants that are linked to these cities that have a rating lower than the designated rating.
--Then, a select statement will inform the user as to which restaurants have been closed.
--In order to expedite this process, a non-clustered index will be implemented across the location table for the city and country attributes. This will allow for more expedient querying of cities.

CREATE OR ALTER PROCEDURE restaurantClose
    @country VARCHAR(50),
    @rating INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Show the restaurants that are to be closed
        SELECT name, rating
        FROM restaurant
        WHERE rating < @rating AND locationID IN (SELECT locationID FROM location WHERE country = @country);

        -- Step 2: Delete all restaurants in the input country where the rating is less than the input rating
        DELETE
        FROM restaurant
        WHERE rating < @rating AND locationID IN (SELECT locationID FROM location WHERE country = @country);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

GRANT SELECT, DELETE ON restaurant to dbuser;
GRANT SELECT ON location to dbuser;
GRANT EXECUTE ON restaurantClose TO dbuser;


-- Use Case 6
--Update a hotel's rating, and select all users who booked it to notify them of the change (Update, Select)
--This involves the following tables: hotel, hotelBookings, and traveler. 
--To implement this case, first update the rating of the hotel in the hotel table. 
--Then, a select statement must be used to find the IDs of every traveler who has booked this hotel. 
--Then, another select statement must be used to return the emails of every traveler who booked at the designated hotel.

CREATE OR ALTER PROCEDURE updateHotelRatingAndNotifyUsers
    @rating INT,
    @hotelName VARCHAR(50),
    @hotelCity VARCHAR(50),
    @hotelCountry VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @locationID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Get locationID so as to not have to fetch repeatedly
        SELECT @locationID = locationID
        FROM location
        WHERE city = @hotelCity AND country = @hotelCountry;

        -- Insert location if it doesn't exist
        IF @locationID IS NULL
        BEGIN
            INSERT INTO location(city, country, language)
            VALUES (@hotelCity, @hotelCountry, NULL);

            -- Get modified location id after insert
            SELECT @locationID = SCOPE_IDENTITY();
        END

        -- 2. Update hotel rating, or insert hotel if it doesn't exist
        IF EXISTS (SELECT 1 FROM hotel WHERE hotelName = @hotelName
            AND hotelLocation = @locationID)
        BEGIN
            UPDATE hotel
            SET rating = @rating
            WHERE hotelName = @hotelName AND hotelLocation = @locationID;
        END
        ELSE
        BEGIN
            INSERT INTO hotel(hotelName, hotelLocation, rating)
            VALUES (@hotelName, @locationID, @rating);
        END

        -- 3. Select all users who have booked this hotel to notify them of the rating change
        SELECT 
            traveler.fname AS firstName,
            traveler.lname AS lastName,
            traveler.email
        FROM traveler
        JOIN hotelBookings ON traveler.travelerID = hotelBookings.travelerID
        WHERE hotelBookings.hotelName = @hotelName 
            AND hotelBookings.hotelLocation = @locationID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;


GRANT EXECUTE ON updateHotelRatingAndNotifyUsers TO dbuser;