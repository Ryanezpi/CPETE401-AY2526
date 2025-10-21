# Case Study: Library System - Answer Key

This document provides the answers to the student exercises in `CASE_STUDY_Library_System.md`.

**Note:** For operations that create data like adding members or borrowing books, the auto-incremented IDs (`member_id`, `loan_id`) might differ when you run the commands. The logic remains the same.

---

### Task 1: New Members

```sql
-- Add 'Charlie'
CALL sp_add_member('Charlie', @charlie_id);
SELECT @charlie_id;

-- Add 'Diana'
CALL sp_add_member('Diana', @diana_id);
SELECT @diana_id;
```

---

### Task 2: Borrowing Books

```sql
-- Get the required IDs first
SET @mockingbird_id = (SELECT book_id FROM Books WHERE title = 'To Kill a Mockingbird');
SET @gatsby_id = (SELECT book_id FROM Books WHERE title = 'The Great Gatsby');
SET @charlie_id = (SELECT member_id FROM Members WHERE member_name = 'Charlie');
SET @diana_id = (SELECT member_id FROM Members WHERE member_name = 'Diana');

-- 1. Charlie borrows 'To Kill a Mockingbird'
CALL sp_borrow_book(@charlie_id, @mockingbird_id);
-- Result: 'Book borrowed successfully.'

-- 2. Diana borrows 'The Great Gatsby'
CALL sp_borrow_book(@diana_id, @gatsby_id);
-- Result: An error is raised: "Error: Book is not available for loan."
-- Why: The initial data shows 'The Great Gatsby' has only 1 total copy. In the initial data setup, Bob borrows that copy. Therefore, there are 0 available copies left and Diana's request is denied.
```

---

### Task 3: Querying Data

```sql
-- 1. Find all members who joined in 2024
SELECT *
FROM Members
WHERE YEAR(join_date) = 2024;

-- 2. List all books currently on loan
SELECT
    b.title,
    m.member_name,
    l.loan_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;
```

---

### Task 4: Returning a Book

```sql
-- First, find the loan_id for Bob's loan of 'The Great Gatsby'
SET @bob_id = (SELECT member_id FROM Members WHERE member_name = 'Bob');
SET @gatsby_id = (SELECT book_id FROM Books WHERE title = 'The Great Gatsby');

SELECT loan_id
FROM Loans
WHERE member_id = @bob_id
  AND book_id = @gatsby_id
  AND return_date IS NULL;

-- Let's assume the query returned a loan_id of 1. Use that ID to process the return.
CALL sp_return_book(1);

-- Verify the return
SELECT available_copies FROM Books WHERE book_id = @gatsby_id; -- Should be 1
SELECT return_date FROM Loans WHERE loan_id = 1; -- Should be the current date
```

---

### Task 5 (Advanced): Create a Stored Procedure

```sql
-- 1. Create the stored procedure
DELIMITER //

CREATE PROCEDURE sp_get_member_loans(IN p_member_id INT)
BEGIN
    SELECT
        b.title,
        l.loan_date,
        l.return_date
    FROM Loans l
    JOIN Books b ON l.book_id = b.book_id
    WHERE l.member_id = p_member_id;
END//

DELIMITER ;

-- 2. Call the procedure for Bob
SET @bob_id = (SELECT member_id FROM Members WHERE member_name = 'Bob');
CALL sp_get_member_loans(@bob_id);
```
