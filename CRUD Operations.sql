--Create Database
create database firstDB


--Use FirstDB
use firstDB


--Create Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Age INT,
    Department NVARCHAR(50)
);



--Add values into the Table
INSERT INTO Employees (Name, Age, Department)
VALUES ('Nikhil Patil', 22, 'Database'), 
       ('Jay Sonar', 23, 'IT'), 
       ('Deven Gupta', 22, 'Finance');

--Display the details
SELECT * FROM Employees;

--Display Name and Department only
SELECT Name, Department FROM Employees;


CREATE TABLE StudentInfo (
    StudID INT PRIMARY KEY IDENTITY(1,1),
    StudName NVARCHAR(100),
    StudAge INT,
    StudDep NVARCHAR(50)
);

INSERT INTO StudentInfo(StudName, StudAge, StudDep)
VALUES ('Nikhil Patil', 22, 'Computer'), 
       ('Jay Sonar', 23, 'IT'), 
       ('Deven Gupta', 22, 'ETC');


SELECT * FROM StudentInfo;

--Display employees where department  is IT
SELECT * FROM Employees WHERE Department = 'IT';


--Display student name where department  is computer
select  StudName from StudentInfo where StudDep='Computer';


--Display student name and age where age is greatter than 22.
select  StudName, StudAge from StudentInfo where StudAge >= 22;


--Display employees where age is sort by ascending order.
SELECT * FROM Employees ORDER BY Age ASC;


--Display employees where age is sort by descending order.
SELECT * FROM Employees ORDER BY Age DESC;


--Update the insert values
UPDATE Employees
SET Age = 29, Department = 'Marketing'
WHERE Name = 'Jay Sonar';

select * from Employees

UPDATE Employees
SET Department = 'IT'
WHERE Department = 'Marketing';

select * from Employees

--Delete One Employee
DELETE FROM Employees
WHERE Name = 'Deven Gupta';

select * from Employees

SELECT * FROM Employees
WHERE Department = 'IT' AND Age > 25;

SELECT * FROM Employees
WHERE Department IN ('HR', 'Finance', 'IT');


--Import Data From CSV
create table Customer(
	customer_id int primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50),
	address_id int
)

select * from Customer

BULK INSERT Customer
FROM 'D:\BridgeLabz\MS SQL\customer.csv'  --Path of CSV file
WITH (
    FIELDTERMINATOR = ',',   -- CSV field delimiter
    ROWTERMINATOR = '\n',    -- Row delimiter (typically new line)
    FIRSTROW = 2,            -- Start reading from the second row if the first row has column headers
    TABLOCK
);

select * from Customer



--SQL Stored Procedures


create procedure spStudDepComp
as
begin
select * from StudentInfo where StudDep='Computer';
end

-- Call the procedure by 3 ways
--1
spStudDepComp
--2
execute spStudDepComp
--3
exec spStudDepComp

--Parameters in Stored Procedure
create procedure spStudDepComp1
@StudentDepartment varchar(100)
as
begin
select * from StudentInfo where StudDep=@StudentDepartment ;
end

--Call procedure with pass the arguments by 2 ways
--1
spStudDepComp1 'IT'
--2
spStudDepComp1  @StudentDepartment='IT'

--To display the Query for a given procedure
sp_helptext spStudDepComp1


--Views

create view vwComStud
as
select * from StudentInfo where StudDep='Computer'

--Display the view
select * from vwComStud

