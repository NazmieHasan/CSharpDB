-- 01.Find Names of All Employees by First Name
SELECT 
    FirstName, LastName 
FROM 
    Employees
WHERE 
    LEFT(FirstName, 2) = 'Sa';

-- 02.Find Names of All Employees by Last Name
SELECT 
    FirstName, LastName 
FROM 
    Employees
WHERE 
    CHARINDEX('ei', LastName) > 0;

-- 03.Find First Names of All Employees
SELECT 
    FirstName 
FROM 
    Employees
WHERE 
    DepartmentID IN (3, 10) AND 
	YEAR(HireDate) BETWEEN 1995 AND 2005;
	
-- 04.Find All Employees Except Engineers
SELECT 
    FirstName, LastName 
FROM 
    Employees 
WHERE 
    CHARINDEX('engineer', JobTitle) = 0;

-- 05.Find Towns with Name Length
SELECT 
    [Name]
FROM 
    Towns
WHERE 
    LEN(Name) = 5 OR LEN(Name) = 6
ORDER BY 
    [Name]; --Name;

-- 06.Find Towns Starting With
SELECT 
    * 
FROM 
    Towns
WHERE 
    [Name] LIKE '[MKBE]%'
ORDER BY 
    [Name]; -- Name;	
	
-- 07.Find Towns Not Starting With
SELECT 
    * 
FROM 
    Towns
WHERE 
    NOT LEFT([Name], 1) IN ('R', 'D', 'B')
ORDER BY 
    [Name]; -- Name;

-- 08.Create View Employees Hired After 2000 Year
CREATE VIEW 
    V_EmployeesHiredAfter2000 AS
SELECT 
    FirstName, LastName 
FROM 
    Employees
WHERE 
    (SELECT YEAR(HireDate)) > 2000;
	
-- 09.Length of Last Name	
SELECT 
    FirstName, LastName 
FROM 
    Employees
 WHERE LEN(LastName) = 5;	
	
-- 10.Rank Employees by Salary
SELECT 
    EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() 
    OVER(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM 
    Employees
WHERE 
    Salary BETWEEN 10000 AND 50000
ORDER BY 
    Salary DESC;
	
-- 11. Find All Employees with Rank 2
SELECT 
    * 
FROM 
    (
    SELECT 
	    EmployeeID, FirstName, LastName, Salary,
    DENSE_RANK() 
	    OVER(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
    FROM 
	    Employees
    WHERE 
	    Salary BETWEEN 10000 AND 50000
    ) AS [RankingSubqueries]
WHERE 
    [Rank] = 2
ORDER BY 
    Salary DESC;

-- 12.Countries Holding 'A' 3 or More Times
SELECT 
    CountryName AS [Country Name], 
	IsoCode AS [Iso Code] 
FROM 
    Countries
WHERE 
    LEN(CountryName) - LEN(REPLACE(LOWER(CountryName), 'a', '')) >=3
ORDER BY 
    [Iso Code];

-- 13.Mix of Peak and River Names
SELECT 
    PeakName, RiverName, 
	LOWER(CONCAT(PeakName, '', SUBSTRING(RiverName, 2, LEN(RiverName) - 1))) AS Mix 
FROM 
    Peaks, Rivers 
WHERE 
    RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY 
    Mix;

-- 14.Games From 2011 and 2012 Year
SELECT 
    TOP 50 [Name], 
	FORMAT(Start,'yyyy-MM-dd') AS [Start Date] 
FROM 
    Games
WHERE 
    (SELECT YEAR(Start)) IN (2011, 2012)
ORDER BY 
    [Start Date], [Name]; 
	
-- 	15.User Email Providers
SELECT 
    Username, 
	SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider] 
FROM 
    Users
ORDER BY 
    [Email Provider], Username;

-- 16.Get Users with IP Address Like Pattern
SELECT 
    Username, IpAddress 
FROM 
    Users
WHERE 
    IpAddress LIKE '___.1%.%.___'
ORDER BY 
    Username;
	
-- 17.Show All Games with Duration & Part of the Day
SELECT 
    [Name] AS [Game],
        CASE 
            WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
            ELSE 'Evening'
        END 
	AS [Part of the Day],
        CASE
            WHEN [Duration] <= 3 THEN 'Extra Short'
            WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
            WHEN [Duration] > 6 THEN 'Long'
            ELSE 'Extra Long'
        END 
	AS [Duration]
FROM 
	[Games] AS [g]
ORDER BY 
    [Game], [Duration], [Part of the Day];

-- 18.Orders Table
SELECT 
    ProductName, OrderDate, 
    DATEADD(day, 3, OrderDate) AS [Pay Due],
    DATEADD(month, 1, OrderDate) AS [Delivery Due]
FROM Orders;
