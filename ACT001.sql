-- problem 1

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    biography TEXT,
    date_of_birth DATE
);

CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    publication_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
        ON DELETE SET NULL
);

CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
        ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
        ON DELETE CASCADE
);

--problem 2

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    licensed_year YEAR
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    reason TEXT,
    status ENUM('Scheduled', 'Completed', 'Canceled', 'No-Show') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE CASCADE
);

--problem 3

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    office_location VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    credits TINYINT UNSIGNED NOT NULL CHECK (credits > 0),
    department_id INT NOT NULL,
    prerequisite_course_id INT DEFAULT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE,
    FOREIGN KEY (prerequisite_course_id) REFERENCES courses(course_id)
        ON DELETE SET NULL
);


