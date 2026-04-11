--USE AdventureWorks2019

-- WARUNKI I SORTOWANIE
-- Wyświetl produkty, które są w kolorze black i w cenie powyżej 1000
SELECT Name, ProductNumber, ListPrice, Size FROM Production.Product WHERE Color='Black' and ListPrice>1000 ORDER BY ListPrice, Size;

-- AGREGACJE
SELECT COUNT(Color) FROM Production.Product;
SELECT COUNT(DISTINCT Color) FROM Production.Product;
SELECT AVG(ListPrice) FROM Production.Product WHERE ListPrice>0;

-- GRUPOWANIE
SELECT Color FROM Production.Product WHERE Color IS NOT NULL GROUP BY Color;
SELECT Color, COUNT(*) FROM Production.Product WHERE Color IS NOT NULL GROUP BY Color;

-- HAVING
SELECT Color FROM Production.Product GROUP BY Color HAVING COUNT(*)>10;
SELECT Color, COUNT(*) FROM Production.Product GROUP BY Color HAVING COUNT(*)>10;
SELECT Color, Size, COUNT(*) FROM Production.Product GROUP BY Color, Size HAVING COUNT(*)>10;
-- Ważne jest dodawanie wszystkich kolumn, które się chce wyświetlić, do group by

-- Wyświetl zamówienia zrealizowane po 23 kwietnia 2012 roku.
SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate>'2012-04-23';

-- Wyświetl zamówienia zrealizowane po 23 kwietnia 2012 roku. Zlicz je.
SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE OrderDate>'2012-04-23';

-- Wyświetl zamówienia zrealizowane po 23 kwietnia 2012 roku. Zlicz je i wyświetl kolumny order date, status, customerid, subtotal.
SELECT OrderDate, Status, CustomerID, SubTotal, COUNT(*) AS 'Count' 
FROM Sales.SalesOrderHeader
WHERE OrderDate>'2012-04-23' 
GROUP BY OrderDate, Status, CustomerID, SubTotal;

-- FUNKCJE DATY
-- Wyświetl zamówienia klientów, w tym średnią wartość zamówienia dla każdego z klientów w lutym 2012.
SELECT CustomerID, SUM(TotalDue) AS 'SUM', AVG(TotalDue) AS 'Average' 
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2012-02-01' AND '2012-02-29' 
GROUP BY CustomerID;

SELECT CustomerID, SUM(TotalDue) AS 'SUM', AVG(TotalDue) AS 'Average' 
FROM Sales.SalesOrderHeader
WHERE MONTH(OrderDate) = 2 AND YEAR(OrderDate) = 2012
GROUP BY CustomerID;

-- Wyświetl sumę zamówień klientów między lutym a majem 2012r.
SELECT CustomerID, SUM(TotalDue) AS 'SumaZamowien'
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2012-02-01' AND '2012-05-31'
GROUP BY CustomerID;

SELECT CustomerID, SUM(TotalDue) AS 'SumaZamowien' FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2012 AND MONTH(OrderDate) BETWEEN 2 AND 5
GROUP BY CustomerID;