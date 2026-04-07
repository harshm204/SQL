create database project2;
use project2;

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers VALUES
(1,'Harsh','M','harsh.m@mail.com','2022-03-15'),
(2,'Om','G','om.g@gmail.com','2021-11-02');

INSERT INTO Customers VALUES
(3,'Kelvin','B','kelvin.b@mail.com','2023-04-17');

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101,1,'2023-07-01',150.50),
(102,2,'2023-07-03',200.75);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1,'Harsh','Maradiya','Sales','2020-01-15',50000),
(2,'Kelvin','Badeliya','HR','2021-03-20',55000);

-- INNER JOIN
SELECT o.*, c.FirstName, c.LastName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- LEFT JOIN
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- RIGHT JOIN
SELECT o.*, c.*
FROM Orders o
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;

-- FULL OUTER JOIN
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.*, o.*
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Customers with orders above average amount
SELECT *
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- Employees with salary above average
SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- Extract year & month
SELECT OrderID, YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month
FROM Orders;

-- Date difference
SELECT OrderID, DATEDIFF(CURDATE(), OrderDate) AS DaysDifference
FROM Orders;

-- Format date
SELECT OrderID, DATE_FORMAT(OrderDate, '%d-%m-%Y') AS FormattedDate
FROM Orders;

-- Full name
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- Replace string
SELECT REPLACE(FirstName, 'Harsh', 'Harshvardhan')
FROM Customers;

-- Upper & lower case
SELECT UPPER(FirstName), LOWER(LastName)
FROM Customers;

-- Trim
SELECT TRIM(Email)
FROM Customers;

-- Running total
SELECT OrderID, TotalAmount,
SUM(TotalAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- Rank orders
SELECT OrderID, TotalAmount,
RANK() OVER (ORDER BY TotalAmount DESC) AS RankOrder
FROM Orders;

-- Discount calculation
SELECT OrderID, TotalAmount,
CASE 
    WHEN TotalAmount > 1000 THEN '10% Discount'
    WHEN TotalAmount > 500 THEN '5% Discount'
    ELSE 'No Discount'
END AS Discount
FROM Orders;

-- Salary category
SELECT EmployeeID, Salary,
CASE 
    WHEN Salary >= 55000 THEN 'High'
    WHEN Salary >= 50000 THEN 'Medium'
    ELSE 'Low'
END AS SalaryCategory
FROM Employees;