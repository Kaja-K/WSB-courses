-- 1. Proste wyrażenia i literały (bez tabeli)
SELECT 10, 5, 10*5, '10*5', 'Kaja';

-- 2. Wybór konkretnych kolumn: imiona i nazwiska
SELECT FirstName, LastName FROM Person.Person;

-- 3. Filtrowanie tekstu (=): adresy z San Francisco
SELECT * FROM Person.Address WHERE City = 'San Francisco';

-- 4. Filtrowanie po kodzie pocztowym: miasta o kodzie 32804
SELECT City FROM Person.Address WHERE PostalCode = '32804';

-- 5. Warunek OR: kod 32804 lub 98104
SELECT City FROM Person.Address WHERE PostalCode = '32804' OR PostalCode = '98104';

-- 6. Operator IN (krótszy zapis OR): ten sam wynik co wyżej
SELECT City FROM Person.Address WHERE PostalCode IN ('32804', '98104');

-- 7. Różne od (<>): wszystkie miasta poza Paris
SELECT City FROM Person.Address WHERE City <> 'Paris';

-- 8. NOT IN: wszystkie miasta poza Paris i London
SELECT City FROM Person.Address WHERE City NOT IN ('Paris', 'London');

-- 9. Sortowanie malejące (DESC): jak wyżej, Z -> A
SELECT City FROM Person.Address WHERE City NOT IN ('Paris', 'London') ORDER BY City DESC;

-- 10. AND + IN + sortowanie rosnące: urlop > 50 h, płeć F lub M
SELECT JobTitle, Gender, VacationHours FROM HumanResources.Employee WHERE VacationHours > 50 AND Gender IN ('F', 'M') ORDER BY Gender ASC;

-- 11. AND + nawias z OR: to samo co wyżej, płeć przez OR
SELECT JobTitle, Gender, VacationHours FROM HumanResources.Employee WHERE VacationHours > 50 AND (Gender = 'F' OR Gender = 'M') ORDER BY Gender ASC;

-- 12. Priorytet AND nad OR (bez nawiasów): (czarne i cena > 500) LUB (białe)
SELECT Name, ListPrice, Color FROM Production.Product WHERE Color = 'Black' AND ListPrice > 500 OR Color = 'White' ORDER BY Color;

-- 13. BETWEEN (włącznie z końcami): klasa M, cena 1000-2000
SELECT Name, ListPrice, Color FROM Production.Product WHERE ListPrice BETWEEN 1000 AND 2000 AND Class = 'M';