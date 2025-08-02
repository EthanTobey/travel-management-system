# Travel Management System

A database-backed CLI application developed in Java with SQL Server Management Studio (SSMS). This project features a relational schema of 12+ tables, modular stored procedures, and a Java-based command-line interface that uses JDBC for interaction.

---

## 📌 Overview

This system manages core travel-related data such as travelers, flights, hotels, activities, and more. It simulates a basic travel agency backend, supporting user actions through stored procedures invoked by a Java CLI.

---

## 💡 Features

- ✅ Normalized SQL schema with foreign key constraints
- 🛠️ Over a dozen stored procedures for inserting, updating, and querying key entities
- 💻 Java CLI frontend built using JDBC to interface with the database
- 📊 Sample data included for demonstration and testing

---

## 🧰 Tech Stack

- **Database:** SQL Server (SSMS)
- **Language:** Java
- **Libraries:** JDBC
- **Tools:** SSMS, JDK, any Java IDE (e.g., VSCode, IntelliJ, Eclipse)

---

## 🗂️ Project Structure
```
travel-management-system/
│
├── sql/
│ ├── schema.sql # Table creation statements
│ ├── stored_procedures.sql # All stored procedures used by the CLI
│ └── sample_data.sql # Optional: inserts for test/demo
│
├── java-cli/
│ ├── src/ # Java source code
│ │ └── (your .java files)
│ ├── Config.java # Database connection configuration
│ └── README.md # Java CLI usage notes
│
├── README.md # This file
└── LICENSE # (Optional)
```

---

## 🚀 Getting Started

### 1. Set Up the Database

1. Open SSMS and execute the following scripts in order:
   - `schema.sql` — creates all necessary tables.
   - `stored_procedures.sql` — adds business logic with stored procedures.
   - `sample_data.sql` (optional) — populates demo data for testing.

### 2. Set Up the Java CLI

1. Open the `java-cli/` folder in your IDE.
2. Ensure the `Config.java` file has correct credentials and connection string.
3. Compile and run the CLI from your terminal or IDE.

---

## 🔍 Example Use Cases

- Create a new traveler and book them a hotel and flight
- Retrieve all reviews for a restaurant
- Add a new activity to a travel itinerary
- Query average ratings for hotels by city

---

## 📎 Notes

- All procedures are modular and reusable
- Stored procedures enforce business rules and prevent SQL injection
- System is designed with scalability in mind

---

## 🧑‍💻 Author

Ethan Tobey — [GitHub](https://github.com/yourusername)  
Case Western Reserve University  
B.S. in Computer Science, Minor in Computer Gaming
