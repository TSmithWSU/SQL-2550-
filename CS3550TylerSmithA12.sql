/* 1. Display the name of the day, the average online order sales subtotal and average in-store order sales subtotal for each day of the week (Sunday - Saturday). 
You should have days of the week as headers across the top and online vs In store down the side */



SELECT OrderFlag, [Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday]
FROM 
	(SELECT Case WHEN OnlineOrderFlag = 1 THEN 'Online Order' ELSE 'In Store Order' END AS OrderFlag, subTotal, DateName(dw, OrderDate) AS OrderDay
		FROM sales.SalesOrderHeader) sq1
Pivot (Avg(subtotal)
FOR sq1.OrderDay IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])) p;

/* 2. List each product category and the number of units sold by month.
You should have months as headers across the top and product categories down the side */


SELECT p.Name, [January], [February], [March], [April], [May], [June], [July], [August], [September], [October], [November], [December]
FROM 
(SELECT orderqty,pc.Name AS Name, DateName(mm, OrderDate) AS OrderMonth
FROM Production.ProductCategory pc
INNER JOIN Production.ProductSubcategory sc
ON pc.ProductCategoryID = sc.ProductCategoryID
INNER JOIN Production.Product p
ON sc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail sod
ON p.ProductID = sod.ProductID
INNER JOIN sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID) sq1
 PIVOT (SUM(Orderqty) 
 FOR sq1.OrderMonth IN ([January], [February], [March], [April], [May], [June], [July], [August], [September], [October], [November], [December])) p;


 /*Dynamic Pivot*/ 

DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);
SET @columns = N'';
SELECT @columns +=N',' + QUOTENAME(MonthName)
FROM (SELECT Distinct DATENAME(Month, OrderDate) AS MonthName, Datepart(mm,orderdate) AS Month_Order
 FROM sales.SalesOrderHeader) x Order BY Month_Order;
SET @columns = STUFF(@columns, 1,1,'');

 SET @sql = N'SELECT ProductCategory, '+@columns + N'
FROM 
	(SELECT orderqty,pc.Name AS ProductCategory, DateName(mm, OrderDate) AS OrderMonth
	FROM Production.ProductCategory pc
	INNER JOIN Production.ProductSubcategory sc
	ON pc.ProductCategoryID = sc.ProductCategoryID
	INNER JOIN Production.Product p
	ON sc.ProductSubcategoryID = p.ProductSubcategoryID
	INNER JOIN Sales.SalesOrderDetail sod
	ON p.ProductID = sod.ProductID
	INNER JOIN sales.SalesOrderHeader soh
	ON sod.SalesOrderID = soh.SalesOrderID) sq1
	 PIVOT (SUM(Orderqty) 
	 FOR sq1.OrderMonth IN ('+@columns +N')) p';

EXECUTE sp_executesql @sql;







