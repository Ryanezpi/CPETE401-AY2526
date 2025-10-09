# Case Study: Advanced Stored Procedures and Functions

## Objective
This case study is designed to challenge your skills in creating and using stored procedures and functions with a more complex database schema. You will be working with a database for a company that manages employees, departments, and projects.

## Database Schema
The database consists of four tables: `employees`, `departments`, `projects`, and `employee_projects`.

### `departments` table
| Column | Type | Description |
|---|---|---|
| `department_id` | INT | Primary Key |
| `department_name` | VARCHAR(255) | Name of the department |

### `employees` table
| Column | Type | Description |
|---|---|---|
| `employee_id` | INT | Primary Key |
| `first_name` | VARCHAR(255) | First name of the employee |
| `last_name` | VARCHAR(255) | Last name of the employee |
| `salary` | DECIMAL(10, 2) | Monthly salary of the employee |
| `department_id` | INT | Foreign Key to `departments` table |

### `projects` table
| Column | Type | Description |
|---|---|---|
| `project_id` | INT | Primary Key |
| `project_name` | VARCHAR(255) | Name of the project |
| `start_date` | DATE | Date the project started |
| `end_date` | DATE | Date the project is expected to end |

### `employee_projects` table
| Column | Type | Description |
|---|---|---|
| `assignment_id` | INT | Primary Key |
| `employee_id` | INT | Foreign Key to `employees` table |
| `project_id` | INT | Foreign Key to `projects` table |

## Database Structure (SQL)
```sql
-- departments table
CREATE TABLE `departments` (
  `department_id` INT PRIMARY KEY,
  `department_name` VARCHAR(255)
);

-- employees table
CREATE TABLE `employees` (
  `employee_id` INT PRIMARY KEY,
  `first_name` VARCHAR(255),
  `last_name` VARCHAR(255),
  `salary` DECIMAL(10, 2),
  `department_id` INT,
  FOREIGN KEY (`department_id`) REFERENCES `departments`(`department_id`)
);

-- projects table
CREATE TABLE `projects` (
  `project_id` INT PRIMARY KEY,
  `project_name` VARCHAR(255),
  `start_date` DATE,
  `end_date` DATE
);

-- employee_projects table
CREATE TABLE `employee_projects` (
  `assignment_id` INT PRIMARY KEY,
  `employee_id` INT,
  `project_id` INT,
  FOREIGN KEY (`employee_id`) REFERENCES `employees`(`employee_id`),
  FOREIGN KEY (`project_id`) REFERENCES `projects`(`project_id`)
);
```

## Sample Data
Use the following SQL statements to populate your database with some sample data:

```sql
-- Departments
INSERT INTO `departments` (`department_id`, `department_name`) VALUES
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Marketing');

-- Employees
INSERT INTO `employees` (`employee_id`, `first_name`, `last_name`, `salary`, `department_id`) VALUES
(1, 'John', 'Doe', 60000.00, 2),
(2, 'Jane', 'Smith', 75000.00, 2),
(3, 'Peter', 'Jones', 50000.00, 3),
(4, 'Mary', 'Williams', 80000.00, 2),
(5, 'David', 'Brown', 45000.00, 1);

-- Projects
INSERT INTO `projects` (`project_id`, `project_name`, `start_date`, `end_date`) VALUES
(1, 'Project Alpha', '2025-01-15', '2025-06-30'),
(2, 'Project Beta', '2025-03-01', '2025-08-31'),
(3, 'Project Gamma', '2025-05-10', '2025-12-31');

-- Employee Projects
INSERT INTO `employee_projects` (`assignment_id`, `employee_id`, `project_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 1, 2),
(4, 3, 2),
(5, 4, 3),
(6, 5, 3);
```

## Problem Set

### Stored Procedures
1.  **`get_employees_in_department`**: A stored procedure that takes a `department_name` as input and returns a list of all employees (first name and last name) working in that department.
2.  **`get_projects_for_employee`**: A stored procedure that takes an `employee_id` as input and returns a list of all projects (project name, start date, and end date) that the employee is assigned to.
3.  **`add_employee_to_project`**: A stored procedure that takes an `employee_id` and a `project_id` as input and assigns an employee to a project.
4.  **`get_department_salary_expense`**: A stored procedure that takes a `department_name` as input and returns the total salary expense for that department.
5.  **`get_employees_with_multiple_projects`**: A stored procedure that returns a list of all employees who are assigned to more than one project.

### Stored Functions
1.  **`get_employee_full_name`**: A stored function that takes an `employee_id` as input and returns the full name of the employee (e.g., "John Doe").
2.  **`get_project_duration`**: A stored function that takes a `project_id` as input and returns the duration of the project in days.
3.  **`get_total_project_assignments`**: A stored function that takes a `project_id` as input and returns the total number of employees assigned to that project.
4.  **`get_department_of_employee`**: A stored function that takes an `employee_id` as input and returns the name of the department the employee belongs to.
5.  **`is_employee_on_project`**: A stored function that takes an `employee_id` and a `project_id` as input and returns `TRUE` if the employee is assigned to the project and `FALSE` otherwise.

## Submission Instructions
1.  For each problem, create the stored procedure or function in your MySQL client.
2.  Test each stored procedure and function to ensure it works correctly.
3.  Take a screenshot of your MySQL client showing the created stored procedure/function and a successful execution.
4.  Compile all your screenshots into a single PDF document.
5.  The sequence would be the following:
    1.  Question
    2.  Screenshot of the stored procedure/function
    3.  Result of the successful execution. If it does not provide any results (e.g., deleting a record), query the record to show the change.
6.  Submit the PDF document to the "Case Study: Advanced Stored Procedures and Functions" assignment on Canvas.