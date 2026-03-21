
--Podstawowe zapytania SELECT

-- Pobiera wszystkie kolumny i wiersze z tabeli Address
SELECT * FROM Person.Address;

-- Pobiera wszystkie kolumny i wiersze z tabeli Person
SELECT * FROM Person.Person;

-- Pobiera tylko wybrane kolumny: tytuł, imię i nazwisko
SELECT Title, FirstName, LastName
FROM Person.Person;

--Tabela produktów

-- Pobiera wszystkie kolumny z tabeli Product
SELECT * FROM Production.Product;

-- Pobiera wybrane kolumny: ID, nazwa, cena katalogowa, kolor
SELECT ProductID, Name, ListPrice, Color
FROM Production.Product;

--Filtrowanie i sortowanie

-- Produkty w kolorze niebieskim, posortowane rosnąco po cenie,
-- a malejąco po koszcie standardowym (kolumna StandardCost pominięta w SELECT)
SELECT ProductID, Name, ListPrice, Color
FROM Production.Product
WHERE Color = 'blue'
ORDER BY ListPrice ASC, StandardCost DESC;

-- Przełączanie baz danych

-- Przełącza kontekst na bazę danych DWQueue
USE DWQueue;
GO -- GO kończy wsad (batch) i wysyła polecenia do serwera

-- Pobiera wszystkie wiersze z tabeli ScrapReason w bazie AdventureWorks2019
-- Użycie pełnej nazwy trójczłonowej: baza.schemat.tabela
SELECT * FROM AdventureWorks2019.Production.ScrapReason;

-- Przełącza kontekst na bazę AdventureWorks2019
USE AdventureWorks2019;
GO

-- Pobiera wszystkie kolumny z tabeli Employee w schemacie HumanResources
SELECT * FROM HumanResources.Employee;

