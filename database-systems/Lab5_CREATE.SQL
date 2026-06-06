-- użycie bazy danych biblioteka
USE biblioteka;

-- tabela przechowująca dane czytelników
CREATE TABLE czytelnik (
    id_czytelnik INT IDENTITY(1,1) NOT NULL,
    login        VARCHAR(10)       NOT NULL,
    haslo        VARCHAR(20)       NOT NULL,
    imie         VARCHAR(10)       NOT NULL,
    CONSTRAINT pk_id_czytelnik PRIMARY KEY (id_czytelnik)
);

-- tabela przechowująca kategorie książek
CREATE TABLE kategoria (
    id_kategoria INT IDENTITY(1,1) NOT NULL,
    nazwa        VARCHAR(100)      NOT NULL,
    CONSTRAINT pk_kategoria PRIMARY KEY (id_kategoria)
);

-- tabela przechowująca dane książek
CREATE TABLE ksiazka (
    id_ksiazka   INT IDENTITY(1,1) NOT NULL,
    id_kategoria INT               NOT NULL,
    isbn         VARCHAR(13),
    tytul        VARCHAR(100)      NOT NULL,
    CONSTRAINT pk_ksiazka PRIMARY KEY (id_ksiazka),
    CONSTRAINT fk_ksiazka_kategoria FOREIGN KEY (id_kategoria)
        REFERENCES kategoria (id_kategoria)
);

-- tabela przechowująca zamówienia czytelników
CREATE TABLE zamowienie (
    id_zamowienia   INT IDENTITY(1,1) NOT NULL,
    id_czytelnik    INT               NOT NULL,
    id_ksiazka      INT               NOT NULL,
    data_zamowienia DATE              NOT NULL,
    data_zwrotu     DATE,
    CONSTRAINT pk_zamowienie PRIMARY KEY (id_zamowienia),
    CONSTRAINT fk_zamowienie_czytelnik FOREIGN KEY (id_czytelnik)
        REFERENCES czytelnik (id_czytelnik),
    CONSTRAINT fk_zamowienie_ksiazka FOREIGN KEY (id_ksiazka)
        REFERENCES ksiazka (id_ksiazka)
);

-- tworzenie bazy i schematów
USE [biblioteka];
GO
CREATE SCHEMA wypo;
GO
CREATE SCHEMA zbior;
GO

-- tabela czytelników w schemacie wypo
DROP TABLE IF EXISTS wypo.czytelnik;
CREATE TABLE wypo.czytelnik (
    id_czytelnik INT IDENTITY(1,1) NOT NULL,
    pesel        CHAR(13)          NOT NULL,
    login        VARCHAR(13)       NOT NULL,
    haslo        VARCHAR(20)       NOT NULL,
    imie         VARCHAR(20)       NOT NULL,
    nazwisko     VARCHAR(50)       NOT NULL,
    CONSTRAINT pk_id_czytelnik PRIMARY KEY (id_czytelnik)
);

-- tabela kategorii w schemacie zbior
DROP TABLE IF EXISTS zbior.kategoria;
CREATE TABLE zbior.kategoria (
    id_kategoria INT IDENTITY(10,1) NOT NULL,
    nazwa        VARCHAR(100)       NOT NULL,
    CONSTRAINT pk_kategoria PRIMARY KEY (id_kategoria)
);

-- wstawienie przykładowej kategorii
INSERT INTO zbior.kategoria (nazwa)
VALUES ('Poezja');

-- tabela książek w schemacie zbior
DROP TABLE IF EXISTS zbior.ksiazka;
CREATE TABLE zbior.ksiazka (
    id_ksiazka   INT IDENTITY(1,1) NOT NULL,
    id_kategoria INT               NOT NULL,
    isbn         VARCHAR(13)       NOT NULL,
    tytul        VARCHAR(100)      NOT NULL,
    autor        VARCHAR(70)       NOT NULL,
    stron        INT               NOT NULL,
    wydawnictwo  VARCHAR(50)       NOT NULL,
    rok          INT               NOT NULL,
    opis         VARCHAR(200),
    CONSTRAINT pk_id_ksiazka PRIMARY KEY (id_ksiazka),
    FOREIGN KEY (id_kategoria) REFERENCES zbior.kategoria (id_kategoria)
);

-- wstawienie przykładowej książki
INSERT INTO zbior.ksiazka
VALUES (10, 4876377, 'Zbior wierszy', 'Jak NNN', 50, 'WNT', 2026, 'opis');

-- tabela zamówień w schemacie wypo
DROP TABLE IF EXISTS wypo.zamowienie;
CREATE TABLE wypo.zamowienie (
    id_zamowienie   INT IDENTITY(1,1) NOT NULL,
    id_czytelnik    INT               NOT NULL,
    id_ksiazka      INT               NOT NULL,
    data_zamowienia DATE              NOT NULL,
    data_odbioru    DATE              NOT NULL,
    data_zwrotu     DATE              NOT NULL,
    CONSTRAINT pk_id_zamowienie PRIMARY KEY (id_zamowienie),
    CONSTRAINT fk_id_czytelnik FOREIGN KEY (id_czytelnik)
        REFERENCES wypo.czytelnik (id_czytelnik),
    CONSTRAINT fk_id_ksiazka FOREIGN KEY (id_ksiazka)
        REFERENCES zbior.ksiazka (id_ksiazka)
);