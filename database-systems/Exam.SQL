--1
SELECT pl.LocationID, SUM(ppi.Quantity) AS ilosc_w_magazynie
FROM Production.Location pl
INNER JOIN Production.ProductInventory ppi ON pl.LocationID = ppi.LocationID
GROUP BY pl.LocationID
HAVING SUM(ppi.Quantity) > 200
ORDER BY SUM(ppi.Quantity) DESC;

--2
SELECT pa.City, SUM(sod.OrderQty) AS ilosc_zamawianych
FROM Person.Address pa
INNER JOIN Sales.SalesOrderHeader soh ON pa.AddressID = soh.ShipToAddressID
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY pa.City
ORDER BY SUM(sod.OrderQty) ASC, pa.City DESC;

--3
SELECT DATEPART(QUARTER, soh.OrderDate) AS numer_kwartalu, 
       AVG(DATEDIFF(DAY, soh.OrderDate, soh.ShipDate)) AS sredni_czas_realizacji
FROM Sales.SalesOrderHeader soh
WHERE YEAR(soh.OrderDate) = 2014
GROUP BY DATEPART(QUARTER, soh.OrderDate);

--4
SELECT pp.ProductID, pp.Name, pp.StandardCost
FROM Production.Product pp
LEFT JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

--5
SELECT soh.SalesOrderID, soh.CustomerID, soh.TotalDue, YEAR(soh.OrderDate) AS rok_zamowienia
FROM Sales.SalesOrderHeader soh
WHERE soh.TotalDue > (
    SELECT AVG(sohh.TotalDue)
    FROM Sales.SalesOrderHeader sohh
    WHERE YEAR(sohh.OrderDate) = YEAR(soh.OrderDate));s