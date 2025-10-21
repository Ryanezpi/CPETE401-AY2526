
# Case Study: Inventory Management System

## Scenario

A small business needs a simple inventory management system to track its products. They need to ensure data integrity, maintain an audit trail of stock changes, and enforce certain business rules.

## Database Structure

The database consists of three tables: `products`, `stock_movements`, and `product_summary`.

### `products` table

This table stores information about each product.

```sql
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    quantity_on_hand INT NOT NULL,
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### `stock_movements` table

This table will act as an audit log for any changes in the `products` table's `quantity_on_hand`.

```sql
CREATE TABLE stock_movements (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    old_quantity INT,
    new_quantity INT,
    movement_type VARCHAR(50), -- e.g., 'IN', 'OUT', 'INITIAL'
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### `product_summary` table

This table will store a summary of the total number of products in stock.

```sql
CREATE TABLE product_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    total_products INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Initialize the summary table with a single row
INSERT INTO product_summary (total_products) VALUES (0);
```

## Sample Data

```sql
INSERT INTO products (product_name, quantity_on_hand) VALUES
('Laptop', 50),
('Mouse', 200),
('Keyboard', 150);
```

# Problem Sets

## Instructions for Students

For each problem set, you are required to:

1.  Create the trigger as described in the problem.
2.  Write SQL statements to test the trigger.
3.  Capture screenshots of:
    *   The trigger creation code.
    *   The SQL statements used for testing.
    *   The results of your testing (e.g., the contents of the tables after the trigger has fired).
4.  Compile your work into a single PDF document. The document should include the problem statement, your trigger code, testing SQL, and the corresponding screenshots with results.

---

## Problem 1: Audit Stock Changes

**Objective:** Create a trigger that automatically logs any changes to the `quantity_on_hand` in the `products` table into the `stock_movements` table.

**Trigger Type:** `AFTER UPDATE`

**Scenario:** When a product's quantity is updated, the system should automatically record the product ID, the old quantity, the new quantity, and the type of movement ('UPDATE') in the `stock_movements` table.

---

## Problem 2: Prevent Negative Stock

**Objective:** Create a trigger that prevents the `quantity_on_hand` of a product from becoming negative.

**Trigger Type:** `BEFORE UPDATE`

**Scenario:** If an update to the `products` table would result in a `quantity_on_hand` less than 0, the trigger should prevent the update and return an error message.

---

## Problem 3: Enforce Maximum Order Quantity

**Objective:** Create a trigger that enforces a business rule: a single update cannot decrease the stock by more than 100 units at a time.

**Trigger Type:** `BEFORE UPDATE`

**Scenario:** If an update to the `products` table attempts to decrease the `quantity_on_hand` by more than 100 units in a single transaction, the trigger should block the update and provide a descriptive error message.

---

## Problem 4: Maintain Product Summary

**Objective:** Create triggers to automatically update the `product_summary` table.

**Trigger Types:** `AFTER INSERT`, `AFTER DELETE` on the `products` table.

**Scenario:**
*   When a new product is added to the `products` table, a trigger should increment the `total_products` count in the `product_summary` table.
*   When a product is deleted from the `products` table, a trigger should decrement the `total_products` count in the `product_summary` table.

---

## Problem 5: Automatically Log Initial Stock

**Objective:** Create a trigger that logs the initial stock of a new product.

**Trigger Type:** `AFTER INSERT`

**Scenario:** When a new product is inserted into the `products` table, a trigger should automatically log the initial stock in the `stock_movements` table. The `old_quantity` should be 0, the `new_quantity` should be the quantity of the new product, and the `movement_type` should be 'INITIAL'.
