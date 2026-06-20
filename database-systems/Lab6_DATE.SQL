-- ============================================================
-- FUNKCJE DATY I CZASU
-- ============================================================
-- YEAR(data)
--   Zwraca rok z podanej daty jako liczbę całkowitą.
--   Przykład: YEAR('2023-06-15') = 2023
-- MONTH(data)
--   Zwraca numer miesiąca (1-12) z podanej daty.
--   Przykład: MONTH('2023-06-15') = 6
-- DAY(data)
--   Zwraca numer dnia miesiąca (1-31) z podanej daty.
--   Przykład: DAY('2023-06-15') = 15
-- GETDATE()
--   Zwraca bieżącą datę i godzinę serwera (bez parametrów).
--   Przykład: GETDATE() = '2026-06-20 09:30:00.000'
-- DATEDIFF(jednostka, data_start, data_koniec)
--   Oblicza różnicę między dwiema datami w podanej jednostce.
--   Jednostki: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
--   Przykład: DATEDIFF(YEAR, '2010-01-01', GETDATE()) = 16
-- DATEPART(część, data)
--   Zwraca wybraną część daty jako liczbę całkowitą.
--   Części: YEAR, MONTH, DAY, WEEKDAY, HOUR, MINUTE, SECOND
--   Przykład: DATEPART(WEEKDAY, '2026-06-20') = 7 (sobota)
-- DATENAME(część, data)
--   Zwraca wybraną część daty jako tekst (nazwę).
--   Przykład: DATENAME(WEEKDAY, '2026-06-20') = 'Saturday'
-- EOMONTH(data [, przesuniecie_miesiecy])
--   Zwraca ostatni dzień miesiąca dla podanej daty.
--   Przykład: EOMONTH('2026-06-05') = '2026-06-30'
-- FORMAT(wartość, format [, kultura])
--   Formatuje datę lub liczbę jako tekst wg podanego wzorca.
--   Przykład: FORMAT(GETDATE(), 'yyyy-MM-dd') = '2026-06-20'
-- DATEADD(jednostka, liczba, data)
--   Dodaje podaną liczbę jednostek do daty.
--   Przykład: DATEADD(MONTH, 3, '2026-01-01') = '2026-04-01'
-- COUNT(*) / COUNT(kolumna)
--   Zlicza wiersze w grupie. COUNT(*) liczy wszystkie,
--   COUNT(kolumna) pomija wartości NULL.
-- SUM(kolumna)
--   Sumuje wartości liczbowe w grupie
-- AVG(kolumna)
--   Oblicza średnią arytmetyczną wartości w grupie.
-- ============================================================

USE AdventureWorks2019;

-- ============================================================
-- Wyświetl ilość zatrudnionych pracowników
-- (rok z największą liczbą zatrudnień)
-- ============================================================
SELECT TOP 1
    YEAR(HireDate)   AS Rok,       
    COUNT(*)         AS LiczbaPracownikow
FROM HumanResources.Employee
GROUP BY YEAR(HireDate)
ORDER BY LiczbaPracownikow DESC;

-- ============================================================
--  Wyświetl pracowników zatrudnionych ponad 10 lat temu
-- ============================================================
SELECT
    BusinessEntityID,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS StazLata
FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 10
ORDER BY StazLata DESC;   

-- ============================================================
-- Oblicz łączną sprzedaż per klient,
-- pokaż tylko tych z zakupami powyżej 50 000
-- ============================================================
SELECT
    CustomerID,
    COUNT(SalesOrderID)  AS LiczbaZamowien, 
    SUM(TotalDue)        AS LacznaWartoscZakupow 
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 50000       
ORDER BY LacznaWartoscZakupow DESC;

-- ============================================================
-- Ile zamówień złożono w każdym dniu tygodnia?
-- ============================================================
SELECT
    DATEPART(WEEKDAY, OrderDate) AS NumerDniaTygodnia,
    DATENAME(WEEKDAY, OrderDate) AS NazwaDniaTygodnia,
    COUNT(*)                     AS LiczbaZamowien
FROM SalesOrder                   
GROUP BY
    DATEPART(WEEKDAY, OrderDate),
    DATENAME(WEEKDAY, OrderDate)
ORDER BY NumerDniaTygodnia;

-- ============================================================
-- Znajdź miesiące, w których sprzedaż była wyższa
-- niż średnia miesięczna sprzedaż za cały okres
-- ============================================================
SELECT
    YEAR(OrderDate)  AS Rok,
    MONTH(OrderDate) AS Miesiac,
    SUM(TotalDue)    AS SprzedazMiesieczna
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING SUM(TotalDue) > (
    -- podzapytanie oblicza średnią miesięczną sprzedaż za cały okres
    SELECT AVG(MiesiecznaSuma)
    FROM (
        -- najpierw sumujemy sprzedaż per miesiąc
        SELECT SUM(TotalDue) AS MiesiecznaSuma
        FROM Sales.SalesOrderHeader
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    ) AS Podsum
)
ORDER BY Rok, Miesiac;

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