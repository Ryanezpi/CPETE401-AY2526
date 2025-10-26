# ATM System Case Study - Answer Key

This document provides the SQL solutions for the stored procedures and triggers outlined in the ATM System Case Study.

## Database Setup (for testing)

```sql
-- Drop tables if they exist to allow for clean re-creation
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

-- Create accounts table
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_holder_name VARCHAR(255) NOT NULL,
    pin INT NOT NULL, -- In a real system, this would be hashed and salted
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

-- Create transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type ENUM('Deposit', 'Withdrawal') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Success', 'Failed') NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Insert sample data
INSERT INTO accounts (account_holder_name, pin, balance) VALUES
('Alice Smith', 1234, 1000.00),
('Bob Johnson', 5678, 500.00),
('Charlie Brown', 9999, 2500.00);
```

## Problem Set A: Stored Procedures

### Problem A1: Deposit Funds

```sql
DELIMITER //

CREATE PROCEDURE DepositFunds (
    IN p_account_id INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deposit amount must be positive.';
    ELSE
        -- Insert a successful deposit transaction. The trigger will update the balance.
        INSERT INTO transactions (account_id, transaction_type, amount, status)
        VALUES (p_account_id, 'Deposit', p_amount, 'Success');
    END IF;
END //

DELIMITER ;
```

### Problem A2: Withdraw Funds

```sql
DELIMITER //

CREATE PROCEDURE WithdrawFunds (
    IN p_account_id INT,
    IN p_pin INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE v_current_balance DECIMAL(10, 2);
    DECLARE v_correct_pin INT;

    -- Get current balance and PIN for the account
    SELECT balance, pin INTO v_current_balance, v_correct_pin
    FROM accounts
    WHERE account_id = p_account_id;

    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Withdrawal amount must be positive.';
    ELSEIF v_correct_pin IS NULL THEN
        -- Account not found
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found.';
    ELSEIF v_correct_pin <> p_pin THEN
        -- Incorrect PIN, log as failed transaction
        INSERT INTO transactions (account_id, transaction_type, amount, status)
        VALUES (p_account_id, 'Withdrawal', p_amount, 'Failed');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid PIN.';
    ELSEIF v_current_balance < p_amount THEN
        -- Insufficient balance, log as failed transaction
        INSERT INTO transactions (account_id, transaction_type, amount, status)
        VALUES (p_account_id, 'Withdrawal', p_amount, 'Failed');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance.';
    ELSE
        -- All checks pass, insert a successful withdrawal transaction. The trigger will update the balance.
        INSERT INTO transactions (account_id, transaction_type, amount, status)
        VALUES (p_account_id, 'Withdrawal', p_amount, 'Success');
    END IF;
END //

DELIMITER ;
```

### Problem A3: Check Account Balance

```sql
DELIMITER //

CREATE PROCEDURE CheckBalance (
    IN p_account_id INT,
    IN p_pin INT
)
BEGIN
    DECLARE v_correct_pin INT;
    DECLARE v_balance DECIMAL(10, 2);

    -- Get PIN and balance for the account
    SELECT pin, balance INTO v_correct_pin, v_balance
    FROM accounts
    WHERE account_id = p_account_id;

    IF v_correct_pin IS NULL THEN
        -- Account not found
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found.';
    ELSEIF v_correct_pin <> p_pin THEN
        -- Incorrect PIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid PIN.';
    ELSE
        -- Return the balance
        SELECT v_balance AS AccountBalance;
    END IF;
END //

DELIMITER ;
```

## Problem Set B: Triggers

### Problem B1: Automate Balance Update

```sql
DELIMITER //

CREATE TRIGGER trg_AfterTransactionInsert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.status = 'Success' THEN
        IF NEW.transaction_type = 'Deposit' THEN
            UPDATE accounts
            SET balance = balance + NEW.amount
            WHERE account_id = NEW.account_id;
        ELSEIF NEW.transaction_type = 'Withdrawal' THEN
            UPDATE accounts
            SET balance = balance - NEW.amount
            WHERE account_id = NEW.account_id;
        END IF;
    END IF;
END //

DELIMITER ;
```

### Problem B2: Prevent Overdraft

```sql
DELIMITER //

CREATE TRIGGER trg_BeforeAccountUpdatePreventOverdraft
BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
    -- Only check if the balance is being decreased
    IF NEW.balance < OLD.balance THEN
        IF NEW.balance < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Insufficient funds. Cannot go into overdraft.';
        END IF;
    END IF;
END //

DELIMITER ;
```