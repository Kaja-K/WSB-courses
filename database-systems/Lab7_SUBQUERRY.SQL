
-- ============================================================
-- PODZAPYTANIA W SELECT I WHERE
-- ============================================================
-- Podzapytanie (subquery) to zapytanie zagnieżdżone wewnątrz
-- innego zapytania. Może wystąpić w:
--   SELECT – oblicza dodatkową wartość dla każdego wiersza
--   WHERE  – filtruje wiersze na podstawie wyniku podzapytania
-- ============================================================

USE AdventureWorks2019;

-- ============================================================
-- PODZAPYTANIA W WHERE
-- ============================================================

-- ============================================================
-- Pracownicy zatrudnieni w roku z największą
-- liczbą zatrudnień (rok zwraca podzapytanie)
-- ============================================================
SELECT
    BusinessEntityID,
    HireDate
FROM HumanResources.Employee
WHERE YEAR(HireDate) = (
    SELECT TOP 1 YEAR(HireDate)
    FROM HumanResources.Employee
    GROUP BY YEAR(HireDate)
    ORDER BY COUNT(*) DESC);

-- ============================================================
-- Zamówienia, których wartość jest wyższa
-- niż średnia wartość wszystkich zamówień
-- ============================================================
SELECT
    SalesOrderID,
    CustomerID,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > (
    SELECT AVG(TotalDue)
    FROM Sales.SalesOrderHeader
)ORDER BY TotalDue DESC;

-- ============================================================
-- Klienci, którzy złożyli więcej niż 1 zamówienie
-- (podzapytanie z IN – lista wartości)
-- ============================================================
SELECT
    CustomerID,
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    HAVING COUNT(*) > 1
)
ORDER BY CustomerID;

-- ============================================================
-- PODZAPYTANIA W SELECT
-- ============================================================

-- ============================================================
-- Dla każdego pracownika pokaż jego staż
-- oraz średni staż wszystkich pracowników
-- ============================================================
SELECT
    BusinessEntityID,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE())   AS StazLata,
    (
        SELECT AVG(DATEDIFF(YEAR, HireDate, GETDATE()))
        FROM HumanResources.Employee
    )                                     AS SredniStazFirmy
FROM HumanResources.Employee
ORDER BY StazLata DESC;

-- ============================================================
-- Dla każdego klienta pokaż wartość jego ostatniego
-- zamówienia (podzapytanie korelowane – odwołuje się do wiersza
-- z zapytania zewnętrznego przez alias soh)
-- ============================================================
SELECT
    CustomerID,
    COUNT(SalesOrderID)   AS LiczbaZamowien,
    SUM(TotalDue)         AS LacznaWartosc,
    (
        SELECT TOP 1 TotalDue
        FROM Sales.SalesOrderHeader AS ostatnie
        WHERE ostatnie.CustomerID = soh.CustomerID
        ORDER BY OrderDate DESC
    )                     AS OstatnieZamowienie
FROM Sales.SalesOrderHeader AS soh
GROUP BY CustomerID
ORDER BY LacznaWartosc DESC;


-- Zadania

USE AdventureWorks2016

-- 1. Wyświetl LoginID i SickLeaveHours wszystkich pracowników
SELECT LoginID, SickLeaveHours FROM HumanResources.Employee;

-- 2. Oblicz średnią wartość SickLeaveHours
SELECT AVG(SickLeaveHours) FROM HumanResources.Employee;

-- 3. Wyświetl LoginID, SickLeaveHours oraz średnią jako dodatkową kolumnę
SELECT LoginID, SickLeaveHours, (SELECT AVG(SickLeaveHours) 
FROM HumanResources.Employee) AS avgSickLeaveHours FROM HumanResources.Employee;

-- 4. Wyświetl LoginID, SickLeaveHours, średnią oraz różnicę między SickLeaveHours a średnią
SELECT LoginID, SickLeaveHours, (SELECT AVG(SickLeaveHours) FROM HumanResources.Employee) AS avgSickLeaveHours, 
(SickLeaveHours - (SELECT AVG(SickLeaveHours) FROM HumanResources.Employee)) AS diff 
FROM HumanResources.Employee;

-- 5. Jak wyżej, ale tylko pracownicy z SickLeaveHours powyżej średniej, posortowani po różnicy
SELECT LoginID, SickLeaveHours, (SELECT AVG(SickLeaveHours) FROM HumanResources.Employee) AS avgSickLeaveHours, 
(SickLeaveHours - (SELECT AVG(SickLeaveHours) FROM HumanResources.Employee)) AS diff FROM HumanResources.Employee 
WHERE SickLeaveHours > (SELECT AVG(SickLeaveHours) FROM HumanResources.Employee) ORDER BY diff;

-- 6. Wyświetl ProductID produktów o kolorze 'Multi'
SELECT ProductID FROM Production.Product WHERE Color = 'Multi';

-- 7. Wyświetl Produkty które kiedykolwiek pojawiły się w zamówieniach
SELECT ProductID FROM Production.Product WHERE ProductID IN (SELECT ProductID FROM Sales.SalesOrderDetail);

-- 8. Wyświetl Produkty które nigdy nie zostały sprzedane
SELECT ProductID FROM Production.Product WHERE ProductID NOT IN (SELECT ProductID FROM Sales.SalesOrderDetail);

-- 9. Wyświetl Produkty które są droższe od średniej ceny wszystkich produktów
SELECT ProductID FROM Production.Product WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product);

-- 10. Wyświetl najtańsze produkty z bazy
SELECT ProductID, ListPrice FROM Production.Product 
WHERE ListPrice = (SELECT MIN(ListPrice) FROM Production.Product WHERE ListPrice > 0);

-- 11. Wyświetl najdroższe produkty z bazy
SELECT ProductID, ListPrice FROM Production.Product 
WHERE ListPrice = (SELECT MAX(ListPrice) FROM Production.Product); 

-- Wyświetl produkty należące do podkategorii 'Helmets'
SELECT ProductID, Name FROM Production.Product 
WHERE ProductSubcategoryID = (SELECT ProductSubcategoryID FROM Production.ProductSubcategory 
WHERE Name = 'Helmets');
