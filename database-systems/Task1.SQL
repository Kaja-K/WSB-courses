/*Zadanie 1
 Wyświetl dla każdego koloru produktu liczbę produktów oraz minimalną, maksymalną i średnią cenę katalogową.
 Uwzględnij tylko produkty z ceną większą od 0. Wyniki posortuj malejąco po średniej cenie.*/

SELECT Color AS Kolor, COUNT(ProductID) AS LiczbaProduktow, MIN(ListPrice) AS NajnizsaCena, MAX(ListPrice) AS NajwyzsaCena, AVG(ListPrice) AS SredniaCena
FROM Production.Product WHERE ListPrice > 0 AND Color IS NOT NULL GROUP BY Color ORDER BY SredniaCena DESC;

/*Zadanie 2
 Wyświetl dla każdego roku liczbę złożonych zamówień, łączny przychód oraz średnią wartość zamówienia.
 Uwzględnij tylko zamówienia ze statusem 5. Wyniki posortuj rosnąco po roku. */

SELECT YEAR(OrderDate) AS Rok, COUNT(SalesOrderID) AS LiczbaZamowien, SUM(TotalDue) AS Przychod, AVG(TotalDue) AS SredniaWartoscZamowienia
FROM Sales.SalesOrderHeader WHERE Status = 5 GROUP BY YEAR(OrderDate) ORDER BY Rok ASC;

/*Zadanie 3
 Dla każdej częstotliwości wypłat wyświetl liczbę pracowników, minimalną, maksymalną i średnią stawkę godzinową.
 Pokaż tylko grupy gdzie średnia stawka przekracza 15. Wyniki posortuj malejąco po średniej stawce. */

SELECT PayFrequency AS CzestotliwoscWyplaty, COUNT(BusinessEntityID) AS LiczbaPracownikow, MIN(Rate) AS MinStawka, MAX(Rate) AS MaxStawka, AVG(Rate) AS SredniaStawka
FROM HumanResources.EmployeePayHistory GROUP BY PayFrequency HAVING AVG(Rate) > 15 ORDER BY SredniaStawka DESC;

/*Zadanie 4
 Wyświetl produkty, których łączna sprzedana ilość sztuk przekracza 100. Podaj też łączny przychód z każdego produktu.
 Wyniki posortuj malejąco po sprzedanych sztukach.*/

SELECT ProductID, SUM(OrderQty) AS SprzedaneJednostki, SUM(LineTotal) AS PrzychodZProduktu
FROM Sales.SalesOrderDetail GROUP BY ProductID HAVING SUM(OrderQty) > 100 ORDER BY SprzedaneJednostki DESC;


/*Zadanie 5
 Dla każdego terytorium sprzedażowego wyświetl liczbę zamówień, łączny przychód oraz średnią wartość zamówienia.
 Uwzględnij tylko terytoria z przychodem powyżej 500 000. Wyniki posortuj malejąco po przychodzie.*/

SELECT TerritoryID, COUNT(SalesOrderID) AS LiczbaZamowien, SUM(TotalDue) AS Przychod, AVG(TotalDue) AS SredniaWartoscZamowienia
FROM Sales.SalesOrderHeader GROUP BY TerritoryID HAVING SUM(TotalDue) > 500000 ORDER BY Przychod DESC;