import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class App {
    //define connection string
    private static String connectionUrl = 
        "jdbc:sqlserver://cxp-sql-02\\axv427;"  //correct sql server profile
        + "database=travelmanagement;"
        + "user=dbuser;"
        + "password=csds341143sdsc;"
        + "encrypt=true;"
        + "trustServerCertificate=true;"
        + "loginTimeout=15;";
    public static void main(String[] args)  {
        //define main functionality loop
        boolean running = true;

        try (Scanner scanner = new Scanner(System.in)) {  //use try-with-resources to ensure scanner always closes
            while (running) {
                System.out.println("Welcome to the Travel Management Database! \nPlease select one of the following options by pressing its number:");
                System.out.println("(1) Cancel Traveler's Trip   (2) Insert Restaurant and Suggest Better   (3) Rate Activity and Get Recommendations \n"
                                    + "(4) Book Hotel for Travelers Without Hotels   (5) Close Restaurants Below a Certain Rating in a Country   (6) Update Hotel Rating and Notify Travelers");
                                    
                String numSelected = scanner.nextLine();
                switch (numSelected) {
                    case "1":
                        callCancelTrip(scanner);
                        break;
                    case "2":
                        callInsertRestaurant(scanner);
                        break;
                    case "3":
                        callRateActivity(scanner);
                        break;
                    case "4":
                        bookHotel(scanner);
                        break;
                    case "5":
                        callCloseRestaurant(scanner);
                        break;
                    case "6":
                        callUpdateHotelRating(scanner);
                        break;
                    default:
                        System.out.println("Invalid value selected - returning to Main Menu\n");
                        continue;
                }
        
                System.out.println("Would you like to run another procedure? (Y/N)");
                String runAgain = scanner.nextLine();
                if (!runAgain.equalsIgnoreCase("Y") && !runAgain.equalsIgnoreCase("Yes")) {
                    running = false;
                }
            }
        }
    }

    // method stub for procedure 1
    private static void callCancelTrip(Scanner scanner) {
        // define input
        int travelerID;
    
        System.out.print("Enter the travelerID whose trip you want to cancel: ");
        travelerID = Integer.parseInt(scanner.nextLine());
    
        // stored procedure call
        String callStoredProc = "{CALL CancelTravelerTrip(?)}";
    
        try (Connection connection = DriverManager.getConnection(connectionUrl);
             CallableStatement stmt = connection.prepareCall(callStoredProc)) {
    
            // bind input parameter
            stmt.setInt(1, travelerID);
    
            // execute stored procedure
            boolean hasResults = stmt.execute();
            int resultSetCount = 0;
    
            while (hasResults) {
                try (ResultSet rs = stmt.getResultSet()) {
                    resultSetCount++;
    
                    List<TableColumn> columns;
                    String sectionTitle;
    
                    ResultSetMetaData meta = rs.getMetaData();
                    int colCount = meta.getColumnCount();
    
                    if (colCount == 7) {  // hotelBookings
                        sectionTitle = "Hotel Bookings Being Canceled:";
                        columns = List.of(
                            new TableColumn("bookingID", 15),
                            new TableColumn("travelerID", 15),
                            new TableColumn("hotelName", 20),
                            new TableColumn("hotelLocation", 20),
                            new TableColumn("price", 10),
                            new TableColumn("startDate", 15),
                            new TableColumn("endDate", 15)
                        );
                    } else if (colCount == 4) {  // activityBookings
                        sectionTitle = "Activity Bookings Being Canceled:";
                        columns = List.of(
                            new TableColumn("bookingID", 15),
                            new TableColumn("travelerID", 15),
                            new TableColumn("activityID", 15),
                            new TableColumn("date", 15)
                        );
                    } else {  // flightBookings
                        sectionTitle = "Flight Bookings Being Canceled:";
                        columns = List.of(
                            new TableColumn("bookingID", 15),
                            new TableColumn("travelerID", 15),
                            new TableColumn("flightNumber", 20),
                            new TableColumn("seatClass", 15),
                            new TableColumn("seatNumber", 15),
                            new TableColumn("seatPrice", 12)
                        );
                    } 
    
                    // print section and formatted table
                    System.out.println("\n" + sectionTitle + "\n");
                    printTable(rs, columns);
                }
    
                // Move to the next result set 
                hasResults = stmt.getMoreResults();
            }
    
            if (resultSetCount == 0) {
                System.out.println("No bookings found or traveler does not exist.");
            } else {
                System.out.println("Trip cancellation process completed successfully.");
            }
    
        } 
        // Handle any errors that may have occurred
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private static void callInsertRestaurant(Scanner scanner) {
        // Define inputs
        String name, cuisine, city, country;
        int rating = -1;
    
        // Prompt for user input
        System.out.println("Enter restaurant name:");
        name = scanner.nextLine();
    
        System.out.println("Enter cuisine:");
        cuisine = scanner.nextLine();
    
        System.out.println("Enter city:");
        city = scanner.nextLine();
    
        System.out.println("Enter country:");
        country = scanner.nextLine();
    
        // Prompt for rating and ensure it is valid
        boolean validRating = false;
        while (!validRating) {
            System.out.println("Enter rating (0–5):");
            rating = Integer.parseInt(scanner.nextLine());
            if (rating >= 0 && rating <= 5) {
                validRating = true;
            } else {
                System.out.println("Invalid rating. Must be between 0 and 5.");
            }
        }
    
        // Stored procedure call
        String callStoredProc = "{CALL InsertRestaurantAndSuggestBetter(?,?,?,?,?)}";
    
        try (Connection connection = DriverManager.getConnection(connectionUrl);
             CallableStatement stmt = connection.prepareCall(callStoredProc)) {
    
            // Bind input parameters
            stmt.setString(1, name);
            stmt.setString(2, cuisine);
            stmt.setString(3, city);
            stmt.setString(4, country);
            stmt.setInt(5, rating);
    
            // Execute stored procedure
            boolean hasResults = stmt.execute();
    
            // Process the result
            if (hasResults) {
                try (ResultSet rs = stmt.getResultSet()) {
                    System.out.println("\nRecommended Restaurants in the Same City with Higher Rating:\n");
    
                    List<TableColumn> columns = List.of(
                        new TableColumn("restaurantID", 15),
                        new TableColumn("name", 25),
                        new TableColumn("cuisine", 20),
                        new TableColumn("rating", 8),
                        new TableColumn("city", 20),
                        new TableColumn("country", 20)
                    );
    
                    printTable(rs, columns);
                    System.out.println();
                }
            } else {
                System.out.println("No better-rated restaurants found.");
            }
    
        } 
        // Handle any errors that may have occurred
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //method stub for procedure 3
    private static void callRateActivity(Scanner scanner) {
        //define inputs and outputs
        int rating = -1;
        int activityID;
        String activityName;
        String activityCity;
        String activityCountry;

        boolean ratingInvalid = true;
        while (ratingInvalid) {
            System.out.println("Enter rating between 0-5: ");
            rating = Integer.parseInt(scanner.nextLine());
            if (rating > 0 && rating <= 5)
                ratingInvalid = false;
            else
                System.out.println("Invalid rating. Value must be between 0 and 5");
        }

        System.out.println("Enter activityID: ");
        activityID = Integer.parseInt(scanner.nextLine());

        System.out.println("Enter activity name: ");
        activityName= scanner.nextLine();

        System.out.println("Enter activity city");
        activityCity = scanner.nextLine();

        System.out.println("Enter activity country");
        activityCountry = scanner.nextLine();

        //call procedure on user input
        String callStoredProc = "{CALL rateActivityAndGetRecommendations(?,?,?,?,?)}"; 
   
        //call procedure and output selected tables
        try (Connection connection = DriverManager.getConnection(connectionUrl);
                CallableStatement stmt = connection.prepareCall(callStoredProc);) {                    
            //bind input params for prepared statement
            stmt.setInt(1, rating); 
            stmt.setInt(2, activityID);
            stmt.setString(3, activityName);
            stmt.setString(4, activityCity);
            stmt.setString(5,activityCountry);
            
            //execute statement
            boolean hasResults = stmt.execute();
            
            outerloop: //define label for labeled break statement
            while (true) {   //loop through potential results from each DML statement
                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        System.out.println("Top 5 Recommended Activities in Your City:\n");

                        //define columns of output table - NOTE - column names must match names of cols in SQL

                        List<TableColumn> columns = List.of(
                            new TableColumn("activityID", 15),
                            new TableColumn("name", 20),
                            new TableColumn("description", 30),
                            new TableColumn("price", 10),
                            new TableColumn("rating", 8),
                            new TableColumn("city", 15),
                            new TableColumn("country", 15)
                        );

                        printTable(rs, columns);  //print the table for output

                        System.out.println(); //add extra line after table output
                    }
                }
                //check if there are more results
                int updateCount = stmt.getUpdateCount();
                if (updateCount == -1) {
                    // No more results
                    break outerloop;
                }
                hasResults = stmt.getMoreResults();
            }
        }
        // Handle any errors that may have occurred
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //method stub for procedure 4
    private static void bookHotel(Scanner scanner) {
        //input
        String yesOrNo;

        System.out.println("Would you like to book hotels for all travelers with flights and no hotels in their destination? (Y/N)");
        yesOrNo = scanner.nextLine();

        if (yesOrNo.equals("Y") || yesOrNo.equals("y") || yesOrNo.equals("yes") || yesOrNo.equals("Yes")) {
             //call stored procedure for the use case on user input
            String callStoredProc = "{CALL bookHotel()}";

            try (Connection connection = DriverManager.getConnection(connectionUrl);
                CallableStatement stmt = connection.prepareCall(callStoredProc)) {

                // execute statement
                boolean hasResults = stmt.execute();
                hasResults = stmt.getMoreResults();
                hasResults = stmt.getMoreResults();
                    
                // process and print the result
                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        System.out.println("New Hotel Bookings: ");

                        List<TableColumn> columns = List.of(
                            new TableColumn("bookingID", 10),
                            new TableColumn("travelerID", 10),
                            new TableColumn("hotelName", 30),
                            new TableColumn("hotelLocation", 10),
                            new TableColumn("price", 15),
                            new TableColumn("startDate", 30),
                            new TableColumn("endDate", 30)
                        );
                        printTable(rs, columns);
                        System.out.println();
                    }
                }
                else {
                    System.out.println("All travelers have booked hotels in their destinations.");
                }
            }
            // Handle any errors that may have occurred
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    //method stub for procedure 5
    private static void callCloseRestaurant(Scanner scanner) {
        //define inputs
        String country;
        int rating = -1;
    
        System.out.println("Enter the country enforcing new food codes: ");
        country = scanner.nextLine();

        boolean ratingInvalid = true;
        while (ratingInvalid) {
            System.out.println("Enter rating between 0-5: ");
            rating = Integer.parseInt(scanner.nextLine());
            if (rating > 0 && rating <= 5)
                ratingInvalid = false;
            else
                System.out.println("Invalid rating. Value must be between 0 and 5");
        }
        
        //call stored procedure for the use case on user input
        String callStoredProc = "{CALL restaurantClose(?,?)}";

        try (Connection connection = DriverManager.getConnection(connectionUrl);
             CallableStatement stmt = connection.prepareCall(callStoredProc)) {

            // Bind input parameters
            stmt.setString(1, country);
            stmt.setInt(2, rating);

            // execute statement
            boolean hasResults = stmt.execute();
            
            // process and print the result
            if (hasResults) {
                try (ResultSet rs = stmt.getResultSet()) {
                    System.out.println("Close Restaurants: ");

                    List<TableColumn> columns = List.of(
                        new TableColumn("name", 20),
                        new TableColumn("rating", 10)
                    );

                    printTable(rs, columns);
                    System.out.println();
                }
            }
            else {
                System.out.println("All restaurants are up to code.");
            }
        }
        // Handle any errors that may have occurred
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //method stub for procedure 6
    private static void callUpdateHotelRating(Scanner scanner) {
        //define inputs and outputs
        int rating = -1;
        String hotelName;
        String hotelCity;
        String hotelCountry;

        boolean ratingInvalid = true;
        while (ratingInvalid) {
            System.out.println("Enter rating between 0-5: ");
            rating = Integer.parseInt(scanner.nextLine());
            if (rating > 0 && rating <= 5)
                ratingInvalid = false;
            else
                System.out.println("Invalid rating. Value must be between 0 and 5");
        }

        System.out.println("Enter hotel name: ");
        hotelName = scanner.nextLine();

        System.out.println("Enter hotel city: ");
        hotelCity = scanner.nextLine();

        System.out.println("Enter hotel country");
        hotelCountry = scanner.nextLine();

        //call procedure on user input
        String callStoredProc = "{CALL updateHotelRatingAndNotifyUsers(?,?,?,?)}"; 

        //call procedure and output selected tables
        try (Connection connection = DriverManager.getConnection(connectionUrl);
                CallableStatement stmt = connection.prepareCall(callStoredProc);) {                    
            //bind input params for prepared statement
            stmt.setInt(1, rating); 
            stmt.setString(2, hotelName);
            stmt.setString(3, hotelCity);
            stmt.setString(4, hotelCountry);
            
            //execute statement
            boolean hasResults = stmt.execute();
            
            outerloop: //define label for labeled break statement
            while (true) {   //loop through potential results from each DML statement
                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        System.out.println("Names and emails of affected travelers who booked this hotel:\n");

                        //define columns of output table - NOTE - column names must match names of cols in SQL
                        List<TableColumn> columns = List.of(
                            new TableColumn("firstName", 20),
                            new TableColumn("lastName", 20),
                            new TableColumn("email", 30)
                        );

                        printTable(rs, columns);  //print the table for output

                        System.out.println(); //add extra line after table output
                    }
                }
                //check if there are more results
                int updateCount = stmt.getUpdateCount();
                if (updateCount == -1) {
                    // No more results
                    break outerloop;
                }
                hasResults = stmt.getMoreResults();
            }
        }
        // Handle any errors that may have occurred
        catch (SQLException e) {
            e.printStackTrace();
        }
    }


    //***********HELPERS FOR TABLE OUTPUT FORMATTING**************

    //nested class to define a column of a table
    private static class TableColumn {
        public final String name;
        public final int width;
    
        public TableColumn(String name, int width) {
            this.name = name;
            this.width = width;
        }
    }

    //priave helper to print a table - takes as input a SQL result set and a list of columns
    private static void printTable(ResultSet rs, List<TableColumn> columns) throws SQLException {
        // Print header
        for (TableColumn col : columns) {
            System.out.printf("%-" + col.width + "s  ", col.name); // <-- Added double space
        }
        System.out.println();

        // Print a separator line
        int totalWidth = columns.stream().mapToInt(c -> c.width + 2).sum(); // account for extra spaces
        System.out.println("-".repeat(totalWidth));

        // Print rows
        while (rs.next()) {
            // Wrap each column's text
            List<String[]> wrappedCells = new ArrayList<>();
            int maxLines = 1;

            for (TableColumn col : columns) {
                String value = rs.getString(col.name);  //NOTE - column name input must match column name in SQL output
                String[] wrapped = wrapText(value != null ? value : "N/A", col.width).split("\n");
                wrappedCells.add(wrapped);
                maxLines = Math.max(maxLines, wrapped.length);
            }

            // Print wrapped lines for this row
            for (int i = 0; i < maxLines; i++) {
                for (int j = 0; j < columns.size(); j++) {
                    String[] cellLines = wrappedCells.get(j);
                    String cell = i < cellLines.length ? cellLines[i] : "";
                    System.out.printf("%-" + columns.get(j).width + "s  ", cell); // <-- Double space
                }
                System.out.println();
            }

            System.out.println(); // space between rows
        }
    }


    //helper method to wrap text for table outputs
    private static String wrapText(String text, int width) {
        StringBuilder wrappedText = new StringBuilder();
        int start = 0;
        while (start < text.length()) {
            int end = Math.min(start + width, text.length());
            wrappedText.append(text, start, end).append("\n");
            start = end;
        }
        return wrappedText.toString();
    }
}