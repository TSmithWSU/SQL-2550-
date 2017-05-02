--Find the average pay for all females who work in the sales department

SELECT AVG(h.Rate) AS 'Average Pay'
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeePayHistory h
ON e.BusinessEntityID = h.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory d
ON e.BusinessEntityID = d.BusinessEntityID
INNER JOIN HumanResources.Department dpt
ON d.DepartmentID = dpt.DepartmentID
WHERE dpt.Name = 'Sales' AND e.Gender = 'F';

--List the name of the StateProvince, the name of the CountryRegion, and theTax Rate for the area with the highest tax rate

SELECT sp.Name AS State, cr.Name AS CountryRegion, t.TaxRate
FROM person.CountryRegion cr
INNER JOIN person.StateProvince sp
ON cr.CountryRegionCode = sp.CountryRegionCode
INNER JOIN sales.SalesTaxRate t
ON sp.StateProvinceID = t.StateProvinceID
WHERE t.TaxRate =
(SELECT MAX(TaxRate)
FROM Sales.SalesTaxRate);


