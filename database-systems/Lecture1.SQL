-- ============================================================
-- WYBÓR BAZY DANYCH
-- ============================================================

USE NazwaBazy;
GO

-- Niezależnie od USE można używać pełnej ścieżki:
SELECT * FROM NazwaBazy.dbo.Customers;


-- ============================================================
-- STRUKTURA SELECT + KOLEJNOŚĆ WYKONANIA NA SERWERZE
-- ============================================================

SELECT [modyfikatory] kolumny
FROM   tabela
WHERE  warunek
GROUP BY kolumna
HAVING warunek_agregacji
ORDER BY kolumna ASC;  -- ASC domyślne, można też DESC

/*
  Kolejność PISANIA:    SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY
  Kolejność WYKONANIA:  FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT/TOP → ORDER BY
*/


-- ============================================================
-- OPERATORY
-- ============================================================

-- Relacyjne
SELECT * FROM Tabela WHERE Wiek  >  18;
SELECT * FROM Tabela WHERE Cena  <= 100;
SELECT * FROM Tabela WHERE Imie  <> 'Anna';   -- różne od
SELECT * FROM Tabela WHERE Imie  != 'Anna';   -- alternatywna składnia

-- Logiczne
SELECT * FROM Tabela WHERE Wiek > 18 AND Miasto = 'Warszawa';
SELECT * FROM Tabela WHERE Wiek < 10 OR  Wiek > 65;
SELECT * FROM Tabela WHERE NOT Aktywny = 1;

-- Specjalne
SELECT * FROM Tabela WHERE Cena     BETWEEN 10 AND 100;                  -- włącznie z krańcami
SELECT * FROM Tabela WHERE Kraj     IN ('Polska', 'Niemcy', 'Francja');
SELECT * FROM Tabela WHERE Email    IS NULL;
SELECT * FROM Tabela WHERE Email    IS NOT NULL;
SELECT * FROM Tabela WHERE Nazwisko LIKE 'Ko%';

-- Arytmetyczne
SELECT Ilosc * Cena    AS Wartosc          FROM Tabela;
SELECT Cena  + 10      AS CenaPowiekszona  FROM Tabela;
SELECT Cena  - Rabat   AS CenaPoRabacie    FROM Tabela;
SELECT Wartosc / Ilosc AS CenaJednostkowa  FROM Tabela;
SELECT Wartosc % 3     AS Reszta           FROM Tabela;  -- modulo

/*
  Konkatenacja — T-SQL: TYLKO pojedyncze apostrofy!
  Cudzysłów " NIE działa w T-SQL!
*/
SELECT Imie + ' ' + Nazwisko AS PelneImie FROM Pracownicy;


-- ============================================================
-- SORTOWANIE
-- ============================================================

SELECT * FROM Produkty   ORDER BY Cena ASC;                     -- domyślne: rosnąco
SELECT * FROM Produkty   ORDER BY Cena DESC;                    -- malejąco
SELECT * FROM Pracownicy ORDER BY Dzial ASC, Nazwisko DESC;     -- kilka kolumn


-- ============================================================
-- OGRANICZENIA WYNIKÓW
-- ============================================================

SELECT TOP 10        * FROM Zamowienia ORDER BY Data DESC;   -- pierwsze n wierszy
SELECT TOP 5 PERCENT * FROM Produkty   ORDER BY Cena DESC;   -- procent wierszy

/*
  DISTINCT — usuwa duplikaty z WYNIKU zapytania, nie modyfikuje tabeli!
*/
SELECT DISTINCT Kraj FROM Klienci;


-- ============================================================
-- ŁĄCZENIE ZBIORÓW — UNION / UNION ALL
-- ============================================================

/*
  Wymagania:
  - ta sama liczba kolumn
  - zgodne typy danych
  - nazwy kolumn w wyniku brane z pierwszego zapytania
*/

-- UNION — łączy i usuwa duplikaty
SELECT CustKey, Imie, 'Klient'    AS Osoba FROM Klienci
UNION
SELECT EmpKey,  Imie, 'Pracownik' AS Osoba FROM Pracownicy;

-- UNION ALL — łączy, zachowuje duplikaty (szybsze)
SELECT CustKey, Imie, 'Klient'    AS Osoba FROM Klienci
UNION ALL
SELECT EmpKey,  Imie, 'Pracownik' AS Osoba FROM Pracownicy;


-- ============================================================
-- FUNKCJE MATEMATYCZNE
-- ============================================================

SELECT ABS(-15);                -- 15      wartość bezwzględna
SELECT CEILING(4.1);            -- 5       zaokrąglenie w górę do całości
SELECT FLOOR(4.9);              -- 4       zaokrąglenie w dół do całości
SELECT ROUND(4.567, 2);         -- 4.570   zaokrąglenie do n miejsc po przecinku
SELECT ROUND(4.567, 0);         -- 5.000   zaokrąglenie do całości


-- ============================================================
-- FUNKCJE TEKSTOWE
-- ============================================================

SELECT UPPER('hello');                  -- 'HELLO'    zmiana na wielkie litery
SELECT LOWER('HELLO');                  -- 'hello'    zmiana na małe litery
SELECT TRIM('  ala  ');                 -- 'ala'      usuwa spacje z obu stron
SELECT LTRIM('  ala');                  -- 'ala'      usuwa spacje z lewej
SELECT RTRIM('ala  ');                  -- 'ala'      usuwa spacje z prawej
SELECT STR(3.14159, 6, 2);             -- '  3.14'   liczba na tekst (szerokość, miejsca po przecinku)
SELECT SUBSTRING('Warszawa', 1, 4);     -- 'Wars'     fragment: od pozycji 1, długość 4
SELECT REPLACE('Kraków', 'ó', 'o');     -- 'Krakow'   zamiana fragmentu tekstu
SELECT PATINDEX('%[0-9]%', 'abc123');   -- 4          pozycja pierwszego wzorca (0 = brak)


-- ============================================================
-- FUNKCJE DATY
-- ============================================================

SELECT GETDATE();             -- bieżąca data i czas lokalny
SELECT SYSDATETIME();         -- wyższa precyzja (datetime2)
SELECT GETUTCDATE();          -- bieżąca data UTC
SELECT SYSDATETIMEOFFSET();   -- data + czas + strefa czasowa

SELECT YEAR(GETDATE());       -- 2026
SELECT MONTH(GETDATE());      -- 3
SELECT DAY(GETDATE());        -- 22

-- DATEPART — wyciąga dowolną część daty
SELECT DATEPART(yyyy,     GETDATE());   -- rok
SELECT DATEPART(mm,       GETDATE());   -- miesiąc
SELECT DATEPART(dd,       GETDATE());   -- dzień
SELECT DATEPART(dw,       GETDATE());   -- dzień tygodnia (1 = niedziela)
SELECT DATEPART(iso_week, GETDATE());   -- numer tygodnia ISO

-- DATEDIFF — różnica między datami
SELECT DATEDIFF(day, DATEFROMPARTS(2026, 3, 12), GETDATE()) AS 'roznica w dniach';

-- DATEFROMPARTS — tworzy datę z podanych składowych
SELECT DATEFROMPARTS(2026, 3, 12);   -- 2026-03-12


-- ============================================================
-- OPERATOR LIKE — WZORCE
-- ============================================================

/*
  Symbole wieloznaczne:
  %        dowolny ciąg znaków (0 lub więcej)
  _        dokładnie jeden dowolny znak
  [a-f]    jeden znak z zakresu a do f
  [abcd]   jeden znak z podanej listy
  [^a-b]   jeden znak SPOZA zakresu
*/

SELECT * FROM Faktury    WHERE Numer    LIKE '[A-Z]%-%-[0-9][0-9]';  -- np. "A-12-B-99"
SELECT * FROM Klienci    WHERE Nazwisko LIKE 'Ko%';                   -- zaczyna się na Ko
SELECT * FROM Produkty   WHERE Kod      LIKE '_____';                 -- dokładnie 5 znaków
SELECT * FROM Produkty   WHERE Kod      LIKE '[0-9]%';                -- zaczyna się od cyfry
SELECT * FROM Pracownicy WHERE Imie     LIKE '[^A-C]%';               -- nie zaczyna się od A, B, C


-- ============================================================
-- NULL
-- ============================================================

SELECT * FROM Klienci WHERE Email IS NULL;       -- brak wartości
SELECT * FROM Klienci WHERE Email IS NOT NULL;   -- wartość istnieje

/*
  UWAGA: poniższe NIE DZIAŁA — zawsze zwraca false!
  WHERE Email = NULL    <- błąd logiczny!
*/


-- ============================================================
-- AGREGACJA I GRUPOWANIE
-- ============================================================

/*
  Funkcje agregujące ignorują NULL.
  Wyjątek: COUNT(*) — liczy wszystkie wiersze łącznie z NULL.
*/

SELECT COUNT(*)             AS LiczbaWierszy  FROM Zamowienia;
SELECT COUNT(Email)         AS LiczbaEmaili   FROM Klienci;     -- pomija NULL
SELECT COUNT(DISTINCT Kraj) AS LiczbaKrajow   FROM Klienci;     -- unikalne wartości
SELECT MIN(Cena)            AS NajnizsaCena   FROM Produkty;
SELECT MAX(Cena)            AS NajwyzsaCena   FROM Produkty;
SELECT SUM(Wartosc)         AS Suma           FROM Zamowienia;
SELECT AVG(Ocena)           AS Srednia        FROM Recenzje;
SELECT STDEV(Wynik)         AS OdchStand      FROM Wyniki;

-- GROUP BY — grupowanie wyników
SELECT Kraj, COUNT(*) AS LiczbaKlientow
FROM Klienci
GROUP BY Kraj
ORDER BY LiczbaKlientow DESC;

-- HAVING — filtrowanie PO agregacji (odpowiednik WHERE dla grup)
SELECT Kraj, COUNT(*) AS LiczbaKlientow
FROM Klienci
GROUP BY Kraj
HAVING COUNT(*) > 10
ORDER BY LiczbaKlientow DESC;


-- ============================================================
-- TYPY DANYCH
-- ============================================================

/*
  CAŁKOWITE (storage w bajtach):
    BIGINT     8 B    zakres: ok. ±9.2 kwadryliona
    INT        4 B    zakres: ok. ±2.1 miliarda
    SMALLINT   2 B    zakres: -32 768 do 32 767
    TINYINT    1 B    zakres: 0 do 255

  DZIESIĘTNE PRECYZYJNE (bez błędów zaokrąglenia):
    DECIMAL(10, 2)   10 cyfr łącznie, 2 po przecinku
    NUMERIC(10, 2)   synonim DECIMAL

  ZMIENNOPRZECINKOWE (przybliżone):
    FLOAT(24)        ok. 7 cyfr precyzji
    REAL             odpowiednik FLOAT(24)

  TEKSTOWE:
    CHAR(10)         stała długość 10 znaków (dopełniana spacjami)
    VARCHAR(255)     zmienna długość, max 255 znaków

  LOGICZNE:
    BIT              0 (false) lub 1 (true)
*/

-- Przykłady deklaracji kolumn w CREATE TABLE:
CREATE TABLE Przyklad (
    Id          INT          NOT NULL,
    Nazwa       VARCHAR(255) NOT NULL,
    Kod         CHAR(10)     NOT NULL,
    Cena        DECIMAL(10, 2),
    Wynik       FLOAT(24),
    Aktywny     BIT,
    LiczbaGloss BIGINT,
    Wiek        TINYINT
);