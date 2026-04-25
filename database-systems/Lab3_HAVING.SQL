-- AGREGACJE I HAVING Zadania

/*1. Pracujemy na tabeli Person.Person
-oblicz ilość rekordów
-oblicz ile osób podało swoje drugie imię (kolumna MiddleName)
-oblicz ile osób podało swoje pierwsze imię (kolumna FirstName)
-oblicz ile osób wyraziło zgodę na otrzymywanie maili (kolumna EmailPromotion ma być równa 1)*/

SELECT COUNT(*) FROM Person.Person;
SELECT COUNT(*) FROM Person.Person WHERE MiddleName IS NOT NULL;
SELECT COUNT(*) FROM Person.Person WHERE FirstName IS NOT NULL;
SELECT COUNT(*) FROM Person.Person WHERE EmailPromotion=1;

/*2. Pracujemy na tabeli Sales.SalesOrderDetail
-wyznacz całkowitą wielkość sprzedaży bez uwzględnienia rabatów - suma UnitPrice * OrderQty
-wyznacz całkowitą wielkość sprzedaży z uwzględnieniem rabatów - suma (UnitPrice-UnitPriceDiscount) * OrderQty*/

SELECT SUM(UnitPrice * OrderQty) AS saleSum FROM Sales.SalesOrderDetail;
SELECT SUM((UnitPrice-UnitPriceDiscount)*OrderQty) AS saleDiscountSum FROM Sales.SalesOrderDetail;

/*3. Pracujemy na tabeli Production.Product
-dla rekordów z podkategorii 14
-wylicz minimalną cenę, maksymalną cenę, średnią cenę i odchylenie standardowe dla ceny (użyj funkcji STDEV)*/

SELECT MIN(ListPrice) AS minPrice, MAX(ListPrice) AS maxPrice, AVG(ListPrice) AS avgPrice, STDEV(ListPrice) AS stdevPrice 
FROM Production.Product WHERE ProductSubcategoryID=14;

/*4. Pracujemy na tabeli Sales.SalesOrderHeader
-wyznacz ilość zamówień zrealizowanych przez poszczególnych pracowników (kolumna SalesPersonId)
-wynik posortuj wg wyliczonej ilości malejąco
-ogranicz do zamówień z 2012 roku*/

SELECT SalesPersonID, COUNT(*) AS ordersRealised FROM Sales.SalesOrderHeader 
WHERE YEAR(OrderDate)=2012 GROUP BY SalesPersonID ORDER BY ordersRealised DESC;

/*5. Poprzednie polecenie zmień, aby zamiast liczby rekordów (funkcja COUNT) wyświetlać sumę kolumny SubTotal (funkcja SUM).
Dodatkowo dodaj ograniczenie tak, aby wyświetlane były tylko wiersze, w których wyznaczona suma jest większa od 100000*/

SELECT SalesPersonID, SUM(SubTotal) AS sumSubTotal FROM Sales.SalesOrderHeader 
WHERE YEAR(OrderDate)=2012 GROUP BY SalesPersonID HAVING SUM(SubTotal)>100000 ORDER BY sumSubTotal DESC;

/*6. Pracujemy na tabeli Sales.SalesOrderHeader
Policz ile zamówień było dostarczanych z wykorzystaniem różnych metod dostawy (kolumna ShipMethodId)*/

SELECT ShipMethodID, COUNT(*) AS countShipMethodAmount FROM Sales.SalesOrderHeader GROUP BY ShipMethodID;

/*7. Pracujemy na tabeli Production.Product
Napisz zapytanie, które wyświetla:
-ProductID, Name, StandardCost, ListPrice
-różnicę między ListPrice a StandardCost zaaliasowaną jako "Profit"
-w wyniku opuść produkty które mają ListPrice lub StandardCost <=0*/

SELECT ProductID, Name, StandardCost, ListPrice, ListPrice-StandardCost AS Profit FROM Production.Product WHERE ListPrice>0 AND StandardCost>0;