create database project;
use project;

create table Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(255)
);

insert into Customers values
(1,'Ram','ram@mail.com','Rajkot'),
(2,'Shyam','shyam@mail.com','Ahmedabad'),
(3,'Kelvin','kelvin@mail.com','Surat'),
(4,'Harsh','harsh@mail.com','Baroda'),
(5,'om','om@mail.com','Mumbai');

select * from Customers;

update Customers
set Address = 'Delhi'
where CustomerID = 5;

select * from Customers;

delete from Customers
where CustomerID = 5;

select * from Customers;

select * from Customers
where Name = 'Ram';

create table Orders (
    OrderID int primary key,
    CustomerID int,
    OrderDate date,
    TotalAmount decimal(10,2),
    foreign key (CustomerID) references Customers(CustomerID)
);

insert into Orders values
(101,1,'2026-03-01',1500),
(102,2,'2026-03-15',2500),
(103,1,'2026-03-20',1000),
(104,3,'2026-02-25',3000),
(105,4,'2026-03-28',2000);

select * from orders;

-- Orders by specific customer
select * from Orders
where CustomerID = 1;

-- Update total amount
update Orders
set TotalAmount = 1800
where OrderID = 101;

select * from orders;

-- Delete order
delete from Orders
where OrderID = 105;

select * from orders;

-- Orders in last 30 days
select * from Orders
where OrderDate >= CURDATE() - INTERVAL 30 DAY;

select * from orders;

-- Highest, Lowest, Average
select 
    MAX(TotalAmount) AS Highest,
    MIN(TotalAmount) AS Lowest,
    AVG(TotalAmount) AS Average
from Orders;

create TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Stock INT
);

insert into Products values
(1,'Laptop',55000,10),
(2,'Mobile',15000,25),
(3,'Tablet',12000,0),
(4,'Headphones',2000,50),
(5,'Keyboard',800,30);

-- All products sorted by price DESC
select * from Products
ORDER BY Price DESC;

-- Update price
update Products
set Price = 14000
where ProductID = 2;

select * from Products;

-- Delete out of stock products
delete FROM Products
where Stock = 0;

select * from Products;

-- Price between ₹500 and ₹2000
select * from Products
where Price BETWEEN 500 AND 2000;

select * from Products;

-- Max and Min price
select 
    MAX(Price) AS Most_Expensive,
    MIN(Price) AS Cheapest
from Products;

create TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    SubTotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

insert into OrderDetails values
(1,101,1,1,55000),
(2,102,2,2,30000),
(3,103,4,3,6000),
(4,104,5,5,4000),
(5,101,2,1,15000);

-- Details for specific order
select * from OrderDetails
where OrderID = 101;

-- Total revenue
select SUM(SubTotal) AS TotalRevenue
from OrderDetails;

-- Top 3 most ordered products
select ProductID, SUM(Quantity) AS TotalQty
from OrderDetails
GROUP BY ProductID
ORDER BY TotalQty DESC
LIMIT 3;

-- Count how many times a product sold
select ProductID, COUNT(*) AS TimesSold
FROM OrderDetails
GROUP BY ProductID;