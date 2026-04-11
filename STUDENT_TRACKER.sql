CREATE database StudentPerformance;
USE StudentPerformance;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
	Name varchar(50),
    DOB date,
    Gender varchar(50),
    Email varchar(50),
    Phone_Number varchar(15),
    Address text,
    Admission_date date,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
  
INSERT INTO students VALUES
(1, 'Harsh', '2003-10-19', 'Male', 'harshmaradiya@gmail.com', '9924418242', 'Rajkot', '2022-09-12', 1),
(2, 'Kelvin', '2005-03-07', 'Male', 'kelvinbadeliya@gmail.com', '9925417242', 'Ahemdabad', '2023-05-12', 2),
(3, 'om', '2006-08-21', 'Male', 'omgajjar@gmail.com', '9924918245', 'Junagadh', '2025-07-12', 3);

INSERT INTO students VALUES
(4, 'Brijesh', '2004-05-10', 'Male', 'brijesh@gmail.com', '9094248657', 'Jamnagar', '2024-05-14', 4);

-- update student of changed contact details
UPDATE students
Set Email = 'harshma@gmail.com'
WHERE StudentID = 1;

-- Delete Student Who Have Dropped Out
DELETE FROM students
WHERE StudentID = 4;

CREATE TABLE Faculty (
	FacultyID INT PRIMARY KEY,
    Name varchar(50),
    Email varchar(50),
    Phone_Number varchar(15),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Faculty VALUES
(1, 'Harsh', 'harshmaradiya@gmail.com', '9723518242', '1'),
(2, 'kelvin', 'kelvin@gmail.com', '9726515242', '2'),
(3, 'om', 'om@gmail.com', '9725518242', '3');

INSERT INTO Faculty VALUES
(4, 'Brijesh',  'brijesh@gmail.com', '9726418245', '4');

-- Department Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments VALUES
(1, 'AI'),
(2, 'ML'),
(3, 'DL');

CREATE TABLE Courses (
	CourseID INT PRIMARY KEY,
    CourseName varchar(50) NOT NULL,
    FacultyID INT,
	FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);

INSERT INTO Courses VALUES
(101, 'Python', 1),
(102, 'SQL', 2),
(103, 'Powerbi', 3);

INSERT INTO Courses VALUES
(104, 'Data Science', 4);

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
(2, 2, 102, '2021-08-01'),
(3, 3, 103, '2023-08-01');

INSERT INTO Enrollments VALUES
(4, 4, 104, '2023-08-05');


CREATE TABLE Attendance (
	AttendanceID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    AttendanceDate DATE,
    status varchar(10),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CHECK (status IN ('Present', 'Absent', 'Late'))
);

INSERT INTO Attendance VALUES
(1, 1, 101, '2026-05-01','Present'),
(2, 2, 102, '2026-05-02', 'Absent'),
(3, 3, 103, '2026-05-03', 'Late');

CREATE TABLE Grades (
	GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Marksobtained Decimal(5,2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Grades VALUES
(1, 1, 101, 95.80),
(2, 2, 102, 50.50),
(3, 3, 103, 81.70);

-- 2
-- Get students in AI Department
SELECT s.*
FROM Students s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'AI';

-- Top 10 highest-scoring students
SELECT s.StudentID, s.Name, g.Marksobtained
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
ORDER BY g.Marksobtained DESC
LIMIT 10;

-- Students with attendance below 75%
SELECT s.StudentID, s.Name,
       (SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Attendance_Percentage
FROM Students s
JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.StudentID, s.Name
HAVING Attendance_Percentage < 75;

-- 3 SQL Operators (AND, OR, NOT)
-- Attendance below 50% AND failing
SELECT s.StudentID, s.Name
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.StudentID, s.Name, g.Marksobtained
HAVING (SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) < 50
AND g.Marksobtained < 40;

-- Score > 90 OR perfect attendance
SELECT DISTINCT s.StudentID, s.Name
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
LEFT JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.StudentID, s.Name, g.Marksobtained
HAVING g.Marksobtained > 90
   OR (SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) = COUNT(*));
   
-- Faculty NOT assigned to any course
SELECT f.*
FROM Faculty f
LEFT JOIN Courses c ON f.FacultyID = c.FacultyID
WHERE c.CourseID IS NULL;

-- 4 SORTING & GROUPING
-- Students alphabetically
SELECT * 
FROM Students
ORDER BY Name ASC;

-- Count students per department
SELECT d.DepartmentName, COUNT(s.StudentID) AS Total_Students
FROM Departments d
LEFT JOIN Students s ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentName;

-- Average marks per course
SELECT c.CourseName, AVG(g.Marksobtained) AS Avg_Marks
FROM Courses c
JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

-- 5 Aggregrate Functions
-- Average attendance %
SELECT 
AVG(Attendance_Percentage) AS Avg_Attendance
FROM (
    SELECT (SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Attendance_Percentage
    FROM Attendance
    GROUP BY StudentID
) AS temp;

-- Highest & lowest marks per course
SELECT c.CourseName,
       MAX(g.Marksobtained) AS Highest,
       MIN(g.Marksobtained) AS Lowest
FROM Courses c
JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

-- Total students per department
SELECT d.DepartmentName, COUNT(s.StudentID) AS Total_Students
FROM Departments d
LEFT JOIN Students s ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentName;

-- 6 PRIMARY & FOREIGN KEY RELATIONSHIP
ALTER TABLE Enrollments
ADD CONSTRAINT unique_enrollment UNIQUE (StudentID, CourseID);

-- 7 JOINS
-- Student details with department (INNER JOIN)
SELECT s.StudentID, s.Name, d.DepartmentName
FROM Students s
INNER JOIN Departments d ON s.DepartmentID = d.DepartmentID;

-- Students NOT enrolled in any course (LEFT JOIN)
SELECT s.StudentID, s.Name
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;

-- Courses that have NO faculty assigned (RIGHT JOIN)
SELECT c.CourseID, c.CourseName
FROM Faculty f
RIGHT JOIN Courses c
ON f.FacultyID = c.FacultyID
WHERE f.FacultyID IS NULL;

-- Students WITHOUT grades (FULL OUTER JOIN)
SELECT s.StudentID, s.Name
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
UNION
SELECT s.StudentID, s.Name
FROM Students s
RIGHT JOIN Grades g ON s.StudentID = g.StudentID
WHERE s.StudentID IS NULL;

-- 8 SUBQUERIES
-- Students with marks above average
SELECT s.StudentID, s.Name, g.Marksobtained
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.Marksobtained > (
    SELECT AVG(Marksobtained) FROM Grades
);

-- Students who missed more than 10 classes
SELECT s.StudentID, s.Name
FROM Students s
JOIN Attendance a ON s.StudentID = a.StudentID
WHERE a.status = 'Absent'
GROUP BY s.StudentID, s.Name
HAVING COUNT(*) > 10;

-- 9. Date & Time Functions
-- Extract month from attendance date
SELECT AttendanceID, MONTH(AttendanceDate) AS Month
FROM Attendance;

-- Years since admission
SELECT StudentID, Name,
TIMESTAMPDIFF(YEAR, Admission_date, CURDATE()) AS Years_Since_Admission
FROM Students;

-- Format attendance date (DD-MM-YYYY)
SELECT AttendanceID,
DATE_FORMAT(AttendanceDate, '%d-%m-%Y') AS Formatted_Date
FROM Attendance;

-- 10. String Functions
-- Faculty names in uppercase
SELECT UPPER(Name) AS Faculty_Name
FROM Faculty;

-- Trim spaces from student names
SELECT TRIM(Name) AS Clean_Name
FROM Students;
