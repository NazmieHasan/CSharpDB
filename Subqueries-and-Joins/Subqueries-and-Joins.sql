-- 01.Employee Address
SELECT 
    TOP(5) em.EmployeeID, em.JobTitle, 
	a.AddressID, a.AddressText 
FROM 
    Employees AS em
INNER JOIN 
    Addresses AS a 
ON 
    em.AddressID = a.AddressID
ORDER BY 
    a.AddressID;
	
-- 02.Addresses with Towns
SELECT 
    TOP(50) FirstName, LastName, 
	T.Name, AddressText
FROM 
    Employees AS e
INNER JOIN 
    Addresses AS a 
ON 
    a.AddressID = e.AddressID
INNER JOIN 
    Towns AS t 
ON 
    t.TownID = a.TownID
ORDER BY 
    FirstName, LastName;

-- 03.Sales Employees
SELECT 
    EmployeeID, FirstName, 
	LastName, D.[Name]
FROM 
    Employees AS e
INNER JOIN 
    Departments AS d 
ON 
    e.DepartmentID = d.DepartmentID
WHERE 
    d.[Name] = 'Sales'
ORDER BY 
    EmployeeID;

-- 04.Employee Departments
SELECT 
    TOP(5) EmployeeID, FirstName, 
	Salary, d.Name
FROM 
    Employees AS e
INNER JOIN 
    Departments AS d
ON 
    e.DepartmentID = d.DepartmentID
WHERE 
    e.Salary > 15000
ORDER BY 
    d.DepartmentID;

-- 05.Employees Without Projects
SELECT 
    TOP(3) em.EmployeeID, em.FirstName
FROM 
    Employees AS em
LEFT OUTER JOIN 
    EmployeesProjects AS ep 
ON 
    ep.EmployeeID = em.EmployeeID
WHERE 
    ep.ProjectID IS NULL
ORDER BY 
    EmployeeID;

-- 06.Employees Hired After
SELECT 
    FirstName, LastName, 
	HireDate, d.[Name]
FROM 
    Employees AS e 
INNER JOIN 
    Departments AS d 
ON 
    d.DepartmentID = e.DepartmentID
WHERE 
    e.HireDate > '1.1.1999' AND 
	d.[Name] IN ('Sales', 'Finance')
ORDER BY 
    HireDate;

-- 07.Employees With Project
SELECT 
    TOP(5) e.EmployeeID, 
	FirstName, p.Name
FROM 
    Employees AS e 
INNER JOIN 
    EmployeesProjects AS ep 
ON 
    ep.EmployeeID = e.EmployeeID
INNER JOIN 
    Projects AS p 
ON 
    p.ProjectID = ep.ProjectID
WHERE 
    p.StartDate > '08/13/2002' AND 
	p.EndDate IS NULL
ORDER BY 
    e.EmployeeID;

-- 08.Employee 24
SELECT 
    e.EmployeeID, FirstName,
    CASE 
        WHEN p.StartDate > '01/01/2005' THEN NULL
        ELSE p.[NAME]
    END 
FROM 
    Employees AS e
INNER JOIN 
    EmployeesProjects AS ep 
ON 
    ep.EmployeeID = e.EmployeeID
INNER JOIN 
    Projects AS p
ON 
    ep.ProjectID = p.ProjectID
WHERE 
    e.EmployeeID = 24;
	
-- 09.Employee Manager	
SELECT 
    e.EmployeeID, e.FirstName, 
	e.ManagerID, m.FirstName 
FROM 
    Employees AS e
INNER JOIN 
    Employees AS m 
ON 
    e.ManagerID = m.EmployeeID
WHERE 
    e.ManagerID IN (3, 7)
ORDER BY 
    e.EmployeeID;

-- 10.Employees Summary
SELECT 
    TOP(50) e.EmployeeID, 
	CONCAT(e.FirstName, ' ', e.LastName) AS [EmployeeName], 
	CONCAT (m.FirstName, ' ', m.LastName) AS [ManagerName], 
	d.[Name]
FROM 
    Employees AS e
INNER JOIN 
    Employees AS m 
ON 
    e.ManagerID = m.EmployeeID
JOIN 
    Departments AS d 
ON 
    d.DepartmentID = e.DepartmentID
ORDER BY 
    e.EmployeeID;

-- 11.Min Average Salary
SELECT 
    TOP(1) (SELECT AVG(Salary)) AS AVERAGESALARY 
FROM 
    Employees
GROUP BY 
    DepartmentID
ORDER BY 
    AVERAGESALARY;

-- 12.Highest Peaks in Bulgaria
SELECT 
    mc.CountryCode, m.MountainRange, 
	p.PeakName, p.Elevation
FROM 
    Mountains AS m
INNER JOIN 
    Peaks AS p 
ON 
    m.Id = p.MountainId
INNER JOIN 
    MountainsCountries AS mc 
ON 
    m.Id = mc.MountainId
WHERE 
    p.Elevation > 2835 AND 
	mc.CountryCode = 'BG'
ORDER BY 
    Elevation DESC;

-- 13.Count Mountain Ranges
SELECT 
    mc.CountryCode, 
	COUNT(mc.CountryCode)
FROM 
    MountainsCountries AS mc
JOIN 
    Mountains AS m
ON 
    m.ID = mc.MountainId
WHERE 
    mc.CountryCode IN ('US', 'BG', 'RU')
GROUP BY 
    mc.CountryCode;

-- 14.Countries With or Without Rivers
SELECT 
    TOP(5) c.CountryName, r.RiverName
FROM 
    Countries AS c
LEFT OUTER JOIN 
    CountriesRivers AS cr 
ON 
    c.CountryCode = cr.CountryCode
LEFT OUTER JOIN 
    Rivers AS r 
ON 
    cr.RiverId = r.Id
WHERE 
    c.ContinentCode = 'AF'
ORDER BY 
    c.CountryName;

-- 15.Continents and Currencies
SELECT 
    rc.ContinentCode, rc.CurrencyCode, rc.[Count]
FROM(
    SELECT 
	    c.ContinentCode, c.CurrencyCode, 
		COUNT(c.CurrencyCode) AS [Count], 
		DENSE_RANK() 
		OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
    FROM 
	    Countries AS c
    GROUP BY 
	    c.ContinentCode, c.CurrencyCode
	) AS rc
WHERE 
    rc.rank = 1 AND 
	rc.Count > 1;

-- 16.Countries Without any Mountains
SELECT 
    COUNT(c.CountryCode) AS [CountryCode]
FROM 
    Countries AS c
LEFT OUTER JOIN 
    MountainsCountries AS m 
ON 
    c.CountryCode = m.CountryCode
WHERE 
    m.MountainId IS NULL;

-- 17.Highest Peak and Longest River by Country
SELECT 
    TOP(5) c.CountryName, 
	MAX(p.Elevation) AS [HighestPeakElevation], 
	MAX(r.Length) AS [LongestRiverLength]
FROM 
    Countries AS c
LEFT OUTER JOIN 
    MountainsCountries AS mc 
ON 
    c.CountryCode = mc.CountryCode
LEFT OUTER JOIN 
    Peaks AS p 
ON 
    p.MountainId = mc.MountainId
LEFT OUTER JOIN 
    CountriesRivers AS cr 
ON 
    c.CountryCode = cr.CountryCode
LEFT OUTER JOIN 
    Rivers AS r 
ON 
    cr.RiverId = r.Id
GROUP BY 
    c.CountryName
ORDER BY 
    [HighestPeakElevation] DESC, 
	[LongestRiverLength] DESC, 
	c.CountryName;

-- 18.Highest Peak Name and Elevation by Country
SELECT 
    TOP(5) WITH TIES c.CountryName, 
	ISNULL(p.PeakName, '(no highest peak)') AS 'HighestPeakName', 
	ISNULL(MAX(p.Elevation), 0) AS 'HighestPeakElevation', 
	ISNULL(m.MountainRange, '(no mountain)')
FROM 
    Countries AS c
LEFT JOIN 
    MountainsCountries AS mc 
ON 
    c.CountryCode = mc.CountryCode
LEFT JOIN 
    Mountains AS m 
ON 
    mc.MountainId = m.Id
LEFT JOIN 
    Peaks AS p 
ON 
    m.Id = p.MountainId
GROUP BY 
    c.CountryName, p.PeakName, m.MountainRange
ORDER BY 
    c.CountryName, p.PeakName;
