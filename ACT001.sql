-- problem 1

CREATE TABLE authors (
    author_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    biography TEXT,
    dob DATE
);

CREATE TABLE publishers (
    publisher_id INT,
    name VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE books (
    book_id INT,
    title VARCHAR(100),
    isbn VARCHAR(20),
    publication_date DATE,
    price DECIMAL(10, 2),
    publisher_id INT
);

CREATE TABLE book_authors (
    book_id INT,
    author_id INT
);

--problem 2

CREATE TABLE patients (
    patient_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    phone_number VARCHAR(20),
    created_timestamp TIMESTAMP
);

CREATE TABLE doctors (
    doctor_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(100),
    licensed_year YEAR
);

CREATE TABLE appointments (
    appointment_id INT,
    patient_id INT,
    doctor_id INT,
    appointment_datetime DATETIME,
    reason TEXT,
    status VARCHAR(20)
);

--problem 3

CREATE TABLE departments (
    department_id INT,
    name VARCHAR(50),
    office_location VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT,
    course_code VARCHAR(20),
    title VARCHAR(100),
    credits TINYINT,
    department_id INT,
    prerequisite_course_id INT
);


