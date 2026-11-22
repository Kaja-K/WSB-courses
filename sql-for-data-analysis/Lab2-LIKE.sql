-- 1. Wszystkie kolumny z tabeli osób
SELECT * FROM Person.Person;

-- 2. BETWEEN + sortowanie malejące: produkty w cenie 500-1500
SELECT Name, ListPrice, Color FROM Production.Product WHERE ListPrice BETWEEN 500 AND 1500 ORDER BY ListPrice DESC;

-- 3. LIKE '%': imiona zaczynające się na A, sortowanie po nazwisku i imieniu
SELECT FirstName, LastName FROM Person.Person WHERE FirstName LIKE 'A%' ORDER BY LastName ASC, FirstName ASC;

-- 4. LIKE '%...%': nazwa zawiera BIKE, sortowanie po kolorze i cenie malejąco
SELECT Name, ListPrice, Color FROM Production.Product WHERE Name LIKE '%BIKE%' ORDER BY Color DESC, ListPrice DESC;

-- 5. LIKE '____%': imiona o długości co najmniej 4 znaków (4 x "_" = dokładnie 4 znaki, % = reszta)
SELECT FirstName, LastName FROM Person.Person WHERE FirstName LIKE '____%';

-- 6. LIKE + OR: nazwiska na W lub S
SELECT FirstName, LastName FROM Person.Person WHERE LastName LIKE 'W%' OR LastName LIKE 'S%' ORDER BY LastName ASC;

-- 7. LIKE z zakresem znaków []: to samo co wyżej, krótszy zapis
SELECT FirstName, LastName FROM Person.Person WHERE LastName LIKE '[SW]%' ORDER BY LastName ASC;

-- 8. LIKE + OR: kody pocztowe zaczynające się na 98 lub 93
SELECT City, PostalCode FROM Person.Address WHERE PostalCode LIKE '98%' OR PostalCode LIKE '93%';

-- 9. LIKE z '_' + AND: nazwa M_u..., cena >= 700, sortowanie po numerze produktu malejąco
SELECT ProductID, ProductNumber FROM Production.Product WHERE Name LIKE 'M_u%' AND ListPrice >= 700 ORDER BY ProductNumber DESC;

-- 10. IS NULL: osoby bez drugiego imienia
SELECT FirstName, MiddleName, LastName FROM Person.Person WHERE MiddleName IS NULL;

-- 11. IS NULL: produkty bez przypisanego koloru
SELECT Name, Color FROM Production.Product WHERE Color IS NULL;

-- 12. ISNULL: zamiana NULL na tekst 'brak danych' (kolumna bez nazwy)
SELECT FirstName, LastName, MiddleName, ISNULL(MiddleName, 'brak danych') FROM Person.Person;

-- 13. Alias kolumny (AS): ta sama zamiana, kolumna nazwana NOWA
SELECT FirstName, LastName, MiddleName, ISNULL(MiddleName, 'brak danych') AS NOWA FROM Person.Person;

-- 14. NOT LIKE z zakresem []: nazwiska nie zaczynające się na A ani B
SELECT FirstName, LastName, MiddleName, ISNULL(MiddleName, 'brak danych') AS NOWA FROM Person.Person WHERE LastName NOT LIKE '[AB]%';

-- 15. Konkatenacja (+): imię i nazwisko w jednej kolumnie RAZEM
SELECT FirstName, LastName, MiddleName, ISNULL(MiddleName, 'brak danych') AS NOWA, FirstName + ' ' + LastName AS RAZEM FROM Person.Person WHERE LastName NOT LIKE '[AB]%';