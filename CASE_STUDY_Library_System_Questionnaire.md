# Case Study: Library Management System using Stored Procedures

This case study demonstrates how to build a simple library management system using MariaDB and stored procedures. The system will manage books, members, and the process of borrowing and returning books.

## 1. System Requirements

The system should be able to:
- Add new members to the library.
- Track books and their availability.
- Allow members to borrow available books.
- Allow members to return borrowed books.

## 2. Database Schema

We will need three tables: `Books`, `Members`, and `Loans`.

```sql
-- Table to store information about books
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    total_copies INT NOT NULL,
    available_copies INT NOT NULL
);

-- Table to store information about library members
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL
);

-- Table to track books borrowed by members
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
```

## 3. Stored Procedures

We will create stored procedures to handle the core logic of the system.

### Add a New Member

This procedure adds a new member to the `Members` table and returns their new ID.

```sql
DELIMITER //

CREATE PROCEDURE sp_add_member(
    IN p_member_name VARCHAR(100),
    OUT p_member_id INT
)
BEGIN
    -- start code here


    -- end code here
END//

DELIMITER ;
```

### Borrow a Book

This procedure handles the process of a member borrowing a book. It checks for the book's availability before creating a loan record.

```sql
DELIMITER //

CREATE PROCEDURE sp_borrow_book(
    IN p_member_id INT,
    IN p_book_id INT
)
BEGIN
    -- start code here




    -- end code here
END//

DELIMITER ;
```

### Return a Book

This procedure handles the book return process. It updates the loan record and the book's availability.

```sql
DELIMITER //

CREATE PROCEDURE sp_return_book(
    IN p_loan_id INT
)
BEGIN
    -- start code here




    -- end code here
END//

DELIMITER ;
```

## 4. How to Use the System

Follow these steps to set up and use the library management system.

### Step 1: Setup the Database and Tables

Execute the `CREATE TABLE` statements from Section 2 to create the `Books`, `Members`, and `Loans` tables in your MariaDB database.

### Step 2: Create the Stored Procedures

Execute the `CREATE PROCEDURE` statements from Section 3 to create the `sp_add_member`, `sp_borrow_book`, and `sp_return_book` procedures.

### Step 3: Populate Initial Data

Add some books and members to your library to simulate a real-world scenario.

**Books Data:**
```sql
INSERT INTO Books (title, author, total_copies, available_copies) VALUES
('The Hobbit', 'J.R.R. Tolkien', 5, 5),
('1984', 'George Orwell', 3, 3),
('Pride and Prejudice', 'Jane Austen', 4, 4),
('To Kill a Mockingbird', 'Harper Lee', 2, 2),
('The Great Gatsby', 'F. Scott Fitzgerald', 1, 1);
```

**Members Data:**
```sql
INSERT INTO Members (member_name, join_date) VALUES
('Alice', '2024-01-15'),
('Bob', '2024-02-20');
```

**Initial Loans Data:**
To make the scenario more realistic, let's assume there is already an active loan.
```sql
-- Get the IDs for the member and book
SET @gatsby_id = (SELECT book_id FROM Books WHERE title = 'The Great Gatsby');
SET @bob_id = (SELECT member_id FROM Members WHERE member_name = 'Bob');

-- Process the loan
CALL sp_borrow_book(@bob_id, @gatsby_id);
```

## 5. Student Activity

Based on the provided schema, data, and stored procedures, complete the following tasks. Write down the SQL commands you use for each task.

**Initial State:** Before you begin, assume the database is in the state defined by the `CREATE` statements and the initial data population scripts in this document.

**Task 1: New Members**
- A new member, 'Charlie', joins the library. Add him to the system.
- Another new member, 'Diana', also joins. Add her to the system.

**Task 2: Borrowing Books**
- Charlie wants to borrow 'To Kill a Mockingbird'. Process this loan.
- Diana wants to borrow 'The Great Gatsby'. Process this loan. What is the result and why?

**Task 3: Querying Data**
- Write a `SELECT` query to find all members who joined in 2024.
- Write a `SELECT` query to list all books that are currently on loan. The query should return the book title, the name of the member who borrowed it, and the date it was loaned.

**Task 4: Returning a Book**
- Bob returns 'The Great Gatsby'. Find the correct `loan_id` for his active loan for this book and process the return.

**Task 5 (Advanced): Create a Stored Procedure**
- Write a new stored procedure named `sp_get_member_loans` that accepts a `p_member_id` as input.
- The procedure should return a list of all books (past and present) that the specified member has borrowed.
- The list should include the book title, loan date, and return date (which can be `NULL` if the book hasn't been returned yet).
- Demonstrate how to call your new procedure for Bob.
