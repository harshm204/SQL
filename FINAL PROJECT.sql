CREATE DATABASE UniversityDB;
USE UniversityDB;

-- Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Students VALUES
(1, 'Harsh', 'Maradiya', 'harsh.maradiya@gmail.com', '2000-01-15', '2022-08-01'),
(2, 'Om', 'Gajjar', 'om.gajjar@gmail.com', '1999-05-25', '2021-08-01');

INSERT INTO Students VALUES
(3, 'Kelvin', 'Badeliya','kelvin.badeliya@gmail.com','2003-08-19','2023-07-5');

SELECT * FROM Students;

UPDATE Students
SET Email = 'harsh.m@gmail.com'
WHERE StudentID = 1;

DELETE FROM Students
WHERE StudentID = 3;

SELECT * FROM Students;

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Departments VALUES
(3, 'Python');

SELECT * FROM Departments;

UPDATE Departments
SET DepartmentName =  'CS'
WHERE DepartmentID = 1;

DELETE FROM Departments
WHERE DepartmentID = 3;

SELECT * FROM Departments;

-- Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

INSERT INTO Courses VALUES
(103, 'Introduction to Python', 3,5);

SELECT * FROM Courses;

UPDATE Courses
SET CourseName = 'Introduction to SQL'
WHERE CourseID = 1;

DELETE FROM Courses
WHERE CourseID = 3;

-- Instructors Table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Instructors VALUES
(1, 'Harsh', 'Maradiya', 'harsh.maradiya@univ.com', 1, 70000),
(2, 'Kelvin', 'Badeliya', 'kelvin.badeliya@univ.com', 2, 80000);

INSERT INTO Instructors VALUES
(3, 'Om', 'Gajjar', 'om.gajjar@univ.com', 3,90000);

SELECT * FROM Instructors;

UPDATE Instructors
SET Email = 'harsh.m@univ.com'
WHERE InstructorID = 1;

DELETE FROM Instructors
WHERE InstructorID = 3;

-- Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

INSERT INTO Enrollments VALUES
(3, 3, 103, '2023-08-01');

SELECT * FROM Enrollments;

UPDATE Enrollments
SET CourseID = '102'
WHERE EnrollmentID = '1';

DELETE FROM Enrollments
WHERE EnrollmentID = 3;

-- Students enrolled after 2022
SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- Courses offered by Mathematics department (limit 5)
SELECT c.*
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

-- Number of students in each course (more than 5)
SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- Students enrolled in BOTH courses
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102)
GROUP BY s.StudentID
HAVING COUNT(DISTINCT e.CourseID) = 2;

-- Students enrolled in ANY of the two courses
SELECT DISTINCT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102);

-- Average credits of all courses
SELECT AVG(Credits) AS AvgCredits
FROM Courses;

-- Maximum salary in CS Department
SELECT MAX(i.Salary) AS MaxSalary
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

-- Count students in each department
SELECT d.DepartmentName, COUNT(e.StudentID) AS TotalStudents
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName; 

-- INNER JOIN 
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- LEFT JOIN
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- Courses with more than 10 students
SELECT *
FROM Students
WHERE StudentID IN (
    SELECT StudentID
    FROM Enrollments
    WHERE CourseID IN (
        SELECT CourseID
        FROM Enrollments
        GROUP BY CourseID
        HAVING COUNT(StudentID) > 10
    )
);