/* Tyler Smith
CS3550 */



/* #1 */

Select p.FirstName, p.LastName, e.Gender , Cast(DateDiff(DD, e.BirthDate, GetDate()) /365.25 AS int) AS Age, e.JobTitle
FROM HumanResources.Employee e
Inner Join person.person p
On e.BusinessEntityID = p.BusinessEntityID
Where e. BirthDate =
(SELECT Min(BirthDate)
FROM HumanResources.Employee);


/* #2 */

SELECT CAST(( SELECT COUNT(*)
FROM HumanResources.Employee 
WHERE Gender = 'M') AS FLOAT) /
CAST((SELECT COUNT(*)
FROM HumanResources.Employee 
WHERE Gender = 'F') AS FLOAT ) AS 'Male To Female Ratio' ;

/* #3 What name and product ID of the highest quantity ordered item? */

SELECT name,ProductID
FROM Production.Product
WHERE productID =
		(SELECT t1.productID
		FROM
		(SELECT ProductID, SUM(ORDERQTY) AS qty
		FROM sales.salesOrderDetail
		GROUP BY ProductID) t1
		WHERE qty =
(SELECT MAX(x.maxq)
FROM
(SELECT SUM(OrderQty) AS maxq, ProductID
FROM sales.SalesOrderDetail
GROUP BY ProductID) AS x) );

/* #4 Show the state(s) with the most online orders. */

SELECT DISTINCT s.name 
FROM sales.SalesOrderHeader h
INNER JOIN person.Address a
ON h.BillToAddressID = a.AddressID
INNER JOIN person.StateProvince s
ON a.StateProvinceID = s.StateProvinceID
WHERE OnlineOrderFlag = 1 AND s.name =
(SELECT s.name AS SName
FROM sales.SalesOrderHeader h
INNER JOIN person.Address a
ON h.BillToAddressID = a.AddressID
INNER JOIN person.StateProvince s
ON a.StateProvinceID = s.StateProvinceID
GROUP BY s.Name
HAVING COUNT(*) = 
		(SELECT MAX(t1.morder)
		FROM(
		SELECT COUNT(*) AS morder
		FROM sales.SalesOrderHeader h
		INNER JOIN person.Address a
		ON h.BillToAddressID = a.AddressID
		INNER JOIN person.StateProvince s
		ON a.StateProvinceID = s.StateProvinceID
		GROUP BY s.Name) t1) ) ;

/* #5 Display the vendor ID, credit rating and address for vendors that have a credit rating higher than 3. */

SELECT DISTINCT poh.VendorID, v.CreditRating, a.AddressLine1 + ' ' + a.City + ' '+ sp.Name + ' ' + a.PostalCode AS Address
FROM Purchasing.PurchaseOrderHeader poh
INNER JOIN Purchasing.PurchaseOrderDetail pod
ON poh.PurchaseOrderID = pod.PurchaseOrderID
INNER JOIN Production.Product p
ON pod.ProductID = p.ProductID
INNER JOIN Purchasing.ProductVendor pv
ON p.ProductID = pv.ProductID
INNER JOIN Purchasing.Vendor v
ON pv.BusinessEntityID = v.BusinessEntityID
INNER JOIN person.BusinessEntity be
ON v.BusinessEntityID = be.BusinessEntityID
INNER JOIN person.BusinessEntityAddress bea
ON be.BusinessEntityID = bea.BusinessEntityID
INNER JOIN person.Address a
ON bea.AddressID = a.AddressID
INNER JOIN person.StateProvince sp 
ON a.StateProvinceID = sp.StateProvinceID
WHERE v.CreditRating > 3 ; 

/* #6  Display the territory (ID, Name, CountryRegionCode, Group and Number of Employees) of the territory that has the most customers. Arrange by highest to lowest number of employees. */
SELECT st.TerritoryID, Name, CountryRegionCode, [Group], numcust
FROM sales.SalesTerritory st
INNER JOIN
	(SELECT territoryID, COUNT(*) AS numcust
	FROM sales.Customer
	GROUP BY territoryID) t2
ON st.TerritoryID = t2.TerritoryID
WHERE st.TerritoryID = 
		(SELECT TerritoryID
		FROM sales.customer
		GROUP BY TerritoryID
		HAVING COUNT(*) = 
		(SELECT MAX(numCust)
		FROM (SELECT TerritoryID, COUNT(*) as numCust
		FROM sales.customer
		GROUP BY TerritoryID) t1));


/* #7 List the first employee hired in each department, in alphabetical order by department.*/ 

SELECT p.FirstName, p.LastName, d.Name
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory edp
ON e.BusinessEntityID = edp.BusinessEntityID
INNER JOIN HumanResources.Department d
ON edp.DepartmentID = d.DepartmentID
INNER JOIN person.person p
ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN
		(SELECT MIN(HireDate) AS MINHIRE, d.Name
		FROM HumanResources.Employee e
		INNER JOIN HumanResources.EmployeeDepartmentHistory edp
		ON e.BusinessEntityID = edp.BusinessEntityID
		INNER JOIN HumanResources.Department d
		ON edp.DepartmentID = d.DepartmentID
		GROUP BY d.name)t1
ON t1.MINHIRE = e.HireDate AND t1.Name = d.Name
ORDER BY d.Name, p.LastName, p.FirstName;

/* 8. List the first and last name and current pay rate of employees who have above average YTD sales. Arrange by last name then first name*/ 

SELECT FirstName, LastName, eph.Rate
FROM person.person p
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory eph
ON e.BusinessEntityID = eph.BusinessEntityID
INNER JOIN sales.SalesPerson sp
ON e.BusinessEntityID = sp.BusinessEntityID
WHERE SalesYTD >
(SELECT AVG(SalesYTD)
FROM sales.SalesPerson)
ORDER BY LastName, FirstName;


/* 9. Identify the currency of the foreign country with the highest number of orders.*/ 
SELECT DISTINCT cu.Name
FROM Person.CountryRegion cr
	INNER JOIN person.StateProvince sp
	ON cr.CountryRegionCode = sp.CountryRegionCode
	INNER JOIN person.Address a
	ON sp.StateProvinceID = a.StateProvinceID
	INNER JOIN sales.SalesOrderHeader soh
	ON a.AddressID = soh.BillToAddressID
	INNER JOIN sales.CurrencyRate c
	ON soh.CurrencyRateID = c.CurrencyRateID
	INNER JOIN sales.Currency cu
	ON c.ToCurrencyCode = cu.CurrencyCode
	WHERE cr.Name =
		(SELECT cr.Name
			FROM Person.CountryRegion cr
			INNER JOIN person.StateProvince sp
			ON cr.CountryRegionCode = sp.CountryRegionCode
			INNER JOIN person.Address a
			ON sp.StateProvinceID = a.StateProvinceID
			INNER JOIN sales.SalesOrderHeader soh
			ON a.AddressID = soh.BillToAddressID
			GROUP BY cr.Name
			HAVING COUNT(*) = (
				SELECT MAX(t1.MAXC)
				FROM
					(SELECT COUNT(*) AS MAXC, cr.Name
					FROM Person.CountryRegion cr
					INNER JOIN person.StateProvince sp
					ON cr.CountryRegionCode = sp.CountryRegionCode
					INNER JOIN person.Address a
					ON sp.StateProvinceID = a.StateProvinceID
					INNER JOIN sales.SalesOrderHeader soh
					ON a.AddressID = soh.BillToAddressID
					WHERE cr.Name != 'United States'
					GROUP BY cr.Name) t1) ) ;

/* 10. Display the average amount of markup (standard cost vs. unit price) on bikes sold during June of 2008.*/

SELECT AVG((UnitPrice - StandardCost))  AS 'Average Markup'
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc
ON ps.ProductCategoryID = pc.ProductCategoryID
INNER JOIN Sales.SpecialOfferProduct sop
ON p.ProductID = sop.ProductID
INNER JOIN sales.SalesOrderDetail sod
ON sop.ProductID = sod.ProductID AND sop.SpecialOfferID = sod.SpecialOfferID
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE pc.Name = 'Bikes' AND  (convert(varchar, soh.OrderDate, 106) ) LIKE '%Jun 2008%' ;