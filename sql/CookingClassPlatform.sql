-- CIS 344 Individual Project
-- Name: Emmanuel Ubah
-- Scenario: Cooking Class Platform
-- Database name: cooking_class_platform_db

CREATE DATABASE IF NOT EXISTS cooking_class_platform_db;

USE cooking_class_platform_db;


CREATE TABLE student (
    student_id INT AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),

    PRIMARY KEY (student_id),
    UNIQUE (email)
);


CREATE TABLE instructor (
    instructor_id INT AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(100) NOT NULL,
    specialty VARCHAR(80),

    PRIMARY KEY (instructor_id),
    UNIQUE (email)
);


CREATE TABLE cooking_class (
    class_id INT AUTO_INCREMENT,
    instructor_id INT NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50),
    difficulty_level VARCHAR(20),
    standard_price DECIMAL(7,2) NOT NULL,

    PRIMARY KEY (class_id),

    CONSTRAINT fk_class_instructor
        FOREIGN KEY (instructor_id)
        REFERENCES instructor(instructor_id)
);


CREATE TABLE class_session (
    session_id INT AUTO_INCREMENT,
    class_id INT NOT NULL,
    start_datetime DATETIME NOT NULL,
    duration_minutes INT NOT NULL,
    capacity INT NOT NULL,
    location VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',

    PRIMARY KEY (session_id),

    CONSTRAINT fk_session_class
        FOREIGN KEY (class_id)
        REFERENCES cooking_class(class_id)
);


CREATE TABLE enrollment (
    student_id INT NOT NULL,
    session_id INT NOT NULL,
    enrollment_date DATETIME NOT NULL,
    enrollment_status VARCHAR(20) NOT NULL DEFAULT 'Registered',

    PRIMARY KEY (student_id, session_id),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_enrollment_session
        FOREIGN KEY (session_id)
        REFERENCES class_session(session_id)
);

-- STUDENT DATA

INSERT INTO student
(first_name, last_name, email, phone)
VALUES
('Maya', 'Johnson', 'maya.johnson@example.com', '555-1001'),
('Daniel', 'Lee', 'daniel.lee@example.com', '555-1002'),
('Sophia', 'Martinez', 'sophia.martinez@example.com', '555-1003'),
('Kevin', 'Brown', 'kevin.brown@example.com', '555-1004'),
('Aisha', 'Patel', 'aisha.patel@example.com', '555-1005');

SELECT * FROM student;

-- INSTRUCTOR DATA

INSERT INTO instructor
(first_name, last_name, email, specialty)
VALUES
('Marco', 'Rossi', 'marco.rossi@example.com', 'Italian Cuisine'),
('Yuki', 'Tanaka', 'yuki.tanaka@example.com', 'Japanese Cuisine'),
('Claire', 'Martin', 'claire.martin@example.com', 'French Pastry'),
('Elena', 'Garcia', 'elena.garcia@example.com', 'Spanish Cuisine');
 
 SELECT * FROM instructor;

-- CookingClass DATA 

INSERT INTO cooking_class
(instructor_id, class_name, cuisine_type, difficulty_level, standard_price)
VALUES
(1, 'Italian Pasta Basics', 'Italian', 'Beginner', 65.00),
(2, 'Sushi Workshop', 'Japanese', 'Intermediate', 80.00),
(3, 'French Pastry Basics', 'French', 'Beginner', 70.00),
(4, 'Spanish Tapas Night', 'Spanish', 'Beginner', 75.00),
(1, 'Advanced Italian Sauces', 'Italian', 'Advanced', 90.00);

SELECT * FROM cooking_class ;

-- ClassSession Data

INSERT INTO class_session
(class_id, start_datetime, duration_minutes, capacity, location, status)
VALUES
(1, '2026-10-03 18:00:00', 120, 16, 'Kitchen A', 'Scheduled'),
(1, '2026-10-10 18:00:00', 120, 16, 'Kitchen A', 'Scheduled'),
(2, '2026-10-05 17:30:00', 150, 12, 'Kitchen B', 'Scheduled'),
(3, '2026-10-08 18:30:00', 120, 14, 'Pastry Lab', 'Scheduled'),
(4, '2026-10-12 18:00:00', 120, 16, 'Kitchen C', 'Scheduled'),
(5, '2026-10-17 17:00:00', 150, 12, 'Kitchen A', 'Scheduled');

SELECT * FROM class_session;

-- ENROLLMENT DATA
 
INSERT INTO enrollment
(student_id, session_id, enrollment_date, enrollment_status)
VALUES
(1, 1, '2026-09-25 10:00:00', 'Registered'),
(2, 1, '2026-09-25 10:15:00', 'Registered'),
(3, 1, '2026-09-26 09:30:00', 'Registered'),

(1, 3, '2026-09-26 11:00:00', 'Registered'),
(4, 3, '2026-09-26 12:00:00', 'Registered'),

(2, 4, '2026-09-27 14:00:00', 'Registered'),
(5, 4, '2026-09-27 15:00:00', 'Registered'),

(3, 5, '2026-09-28 10:30:00', 'Registered'),
(4, 5, '2026-09-28 11:30:00', 'Registered'),

(5, 6, '2026-09-28 16:00:00', 'Registered');

SELECT * FROM enrollment;

-- Query 1: Classes and Instructors

SELECT
    cc.class_name AS Class_Name,
    CONCAT(i.first_name, ' ', i.last_name) AS Instructor,
    i.specialty AS Specialty,
    cc.cuisine_type AS Cuisine,
    cc.difficulty_level AS Difficulty,
    cc.standard_price AS Price
FROM cooking_class AS cc
JOIN instructor AS i
    ON cc.instructor_id = i.instructor_id
ORDER BY cc.class_name;

-- Query 2:  

SELECT
    cs.session_id AS Session_ID,
    cc.class_name AS Class_Name,
    cs.start_datetime AS Start_Time,
    cs.location AS Location,
    cs.capacity AS Capacity
FROM class_session AS cs
JOIN cooking_class AS cc
    ON cs.class_id = cc.class_id
WHERE cs.status = 'Scheduled'
ORDER BY cs.start_datetime;

-- Query 3: 

SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS Student_Name,
    cc.class_name AS Class_Name,
    cs.start_datetime AS Session_Time,
    e.enrollment_status AS Enrollment_Status
FROM enrollment AS e
JOIN student AS s
    ON e.student_id = s.student_id
JOIN class_session AS cs
    ON e.session_id = cs.session_id
JOIN cooking_class AS cc
    ON cs.class_id = cc.class_id
ORDER BY cs.start_datetime, Student_Name;

-- QUERY 4: 

SELECT
    cs.session_id AS Session_ID,
    cc.class_name AS Class_Name,
    cs.start_datetime AS Session_Time,
    COUNT(e.student_id) AS Number_Enrolled,
    cs.capacity AS Capacity
FROM class_session AS cs
JOIN cooking_class AS cc
    ON cs.class_id = cc.class_id
LEFT JOIN enrollment AS e
    ON cs.session_id = e.session_id
GROUP BY
    cs.session_id,
    cc.class_name,
    cs.start_datetime,
    cs.capacity
ORDER BY cs.start_datetime;

-- QUERY 5: 

SELECT
    class_name,
    cuisine_type,
    standard_price
FROM cooking_class
WHERE difficulty_level = 'Beginner'
AND standard_price < 80
ORDER BY standard_price;

-- UPDATE DOCUMENTATION:

-- BEFORE 
SELECT *
FROM enrollment
WHERE student_id = 1
AND session_id = 1;

-- UPDATE 
UPDATE enrollment
SET enrollment_status = 'Completed'
WHERE student_id = 1
AND session_id = 1;

-- AFTER 
SELECT *
FROM enrollment
WHERE student_id = 1
AND session_id = 1;

