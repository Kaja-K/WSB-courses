-- JOIN

-- Zadanie 1
-- Wyświetl imię, nazwisko i bonus sprzedawców posortowanych malejąco po bonusie
SELECT pp.FirstName, pp.LastName, ss.Bonus
FROM Person.Person pp INNER JOIN Sales.SalesPerson ss
ON pp.BusinessEntityID = ss.BusinessEntityID
ORDER BY ss.Bonus DESC;

-- Zadanie 2
-- Wyświetl szczegóły zamówień: numer, datę, produkt, ilość i cenę jednostkową posortowane rosnąco po cenie
SELECT h.SalesOrderID, h.OrderDate, h.SalesOrderNumber, d.ProductID, d.OrderQty, d.UnitPrice
FROM Sales.SalesOrderHeader h INNER JOIN Sales.SalesOrderDetail d
ON h.SalesOrderID = d.SalesOrderID
ORDER BY d.UnitPrice ASC;

-- Zadanie 3
-- Wyświetl nazwę produktu i datę zamówienia (złączenie trzech tabel)
SELECT pp.Name, soh.OrderDate
FROM Production.Product pp INNER JOIN Sales.SalesOrderDetail sod
ON pp.ProductID = sod.ProductID
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID;

-- Zadanie 4
-- Wyświetl nazwę produktu i datę jego ostatniego zamówienia, posortowane malejąco po dacie
SELECT pp.Name, MAX(soh.OrderDate) AS LastOrderDate
FROM Production.Product pp INNER JOIN Sales.SalesOrderDetail sod
ON pp.ProductID = sod.ProductID
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY pp.Name
ORDER BY LastOrderDate DESC;

-- Zadanie 5
-- Wyświetl produkty, które nigdy nie zostały zamówione (brak daty zamówienia)
SELECT pp.Name, MAX(soh.OrderDate) AS LastOrderDate
FROM Production.Product pp
LEFT JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
LEFT JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate IS NULL
GROUP BY pp.Name
ORDER BY LastOrderDate DESC;

-- Zadanie 6
-- Wyświetl łączną ilość zamówionych produktów dla każdego klienta i miasta, posortowane malejąco po sumie
SELECT soh.CustomerID, pa.City, SUM(sod.OrderQty) AS SumOrderQty
FROM Person.Address pa
INNER JOIN Sales.SalesOrderHeader soh ON pa.AddressID = soh.ShipToAddressID
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.CustomerID, pa.City
ORDER BY SumOrderQty DESC;