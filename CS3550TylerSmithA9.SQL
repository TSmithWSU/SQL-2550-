--SELECT THE FIRST NAME, LAST NAME,SALES ORDER NUMBER,ORDER DATE, AND TAX RATE FOR CUSTOMERS THAT ORDERED ON July 08 2005. 
--TAX RATE IS DETERMINED BY THE SHIP TO ADDRESS.


SELECT p.FirstName, p.LastName, soh.SalesOrderNumber, CONVERT(VARCHAR(10), soh.OrderDate, 101) AS "Order Date", str.TaxRate
FROM person.Person p
INNER JOIN sales.PersonCreditCard pcc
ON p.BusinessEntityID = pcc.BusinessEntityID
INNER JOIN sales.CreditCard cc
ON pcc.CreditCardID = cc.CreditCardID
INNER JOIN sales.SalesOrderHeader soh
ON cc.CreditCardID = soh.CreditCardID
INNER JOIN person.Address ad
ON soh.ShipToAddressID = ad.AddressID
INNER JOIN person.StateProvince sp
ON ad.StateProvinceID = sp.StateProvinceID
INNER JOIN sales.SalesTaxRate str
ON sp.StateProvinceID = str.StateProvinceID
WHERE soh.OrderDate = '07/08/2005'

--SELECT THE ProductID, Product Name, list price, and LargePhotoFileName of the most expensive product(s).
--Sort by the Product Name.

SELECT  p.ProductID, p.Name, p.ListPrice AS Price, ph.LargePhotoFileName
FROM Production.Product p
INNER JOIN Production.ProductProductPhoto pp
ON p.ProductID = pp.ProductID
INNER JOIN Production.ProductPhoto ph
ON pp.ProductPhotoID = ph.ProductPhotoID
WHERE p.ListPrice =
(SELECT MAX(k.Price)
FROM
(SELECT p.Name, p.ListPrice AS Price
FROM Production.Product p) k)
ORDER BY p.Name;
