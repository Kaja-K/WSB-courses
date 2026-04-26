-- ============================================================
-- CROSS JOIN — iloczyn kartezjański
-- Każda kombinacja wierszy z obu tabel
-- ============================================================
SELECT * FROM tabela1 AS t1 CROSS JOIN tabela2 AS t2;

-- ============================================================
-- INNER JOIN — złączenie wewnętrzne
-- Tylko wiersze z dopasowaniem po obu stronach
-- ============================================================
SELECT t1.id AS id_t1, t1.kolumna1, t2.id AS id_t2, t2.kolumna2
FROM tabela1 AS t1 INNER JOIN tabela2 AS t2 ON t1.id = t2.id;

-- ============================================================
-- LEFT JOIN — złączenie lewostronne
-- Wszystkie wiersze z lewej; brak dopasowania → NULL po prawej
-- ============================================================
SELECT t1.id AS id_t1, t1.kolumna1, t2.id AS id_t2, t2.kolumna2
FROM tabela1 AS t1 LEFT JOIN tabela2 AS t2 ON t1.id = t2.id;

-- ============================================================
-- RIGHT JOIN — złączenie prawostronne
-- Wszystkie wiersze z prawej; brak dopasowania → NULL po lewej
-- ============================================================
SELECT t1.id AS id_t1, t1.kolumna1, t2.id AS id_t2, t2.kolumna2 
FROM tabela1 AS t1 RIGHT JOIN tabela2 AS t2 ON t1.id = t2.id;

-- ============================================================
-- FULL OUTER JOIN — pełne złączenie zewnętrzne
-- Wszystkie wiersze z obu tabel; brak dopasowania → NULL
-- ============================================================
SELECT t1.id AS id_t1, t1.kolumna1, t2.id AS id_t2, t2.kolumna2
FROM tabela1 AS t1 FULL OUTER JOIN tabela2 AS t2 ON t1.id = t2.id;

-- ============================================================
-- LEFT ANTI JOIN — tylko wiersze z lewej BEZ pary w prawej
-- ============================================================
SELECT t1.id, t1.kolumna1 FROM tabela1 AS t1 
LEFT JOIN tabela2 AS t2 ON t1.id = t2.id WHERE t2.id IS NULL;

-- ============================================================
-- RIGHT ANTI JOIN — tylko wiersze z prawej BEZ pary w lewej
-- ============================================================
SELECT t2.id, t2.kolumna2 FROM tabela1 AS t1
RIGHT JOIN tabela2 AS t2 ON t1.id = t2.id WHERE t1.id IS NULL;

-- ============================================================
-- FULL OUTER ANTI JOIN — wiersze bez pary w żadnej tabeli
-- (różnica symetryczna)
-- ============================================================
SELECT t1.id AS id_t1, t2.id AS id_t2 FROM tabela1 AS t1
FULL OUTER JOIN tabela2 AS t2 ON t1.id = t2.id 
WHERE t1.id IS NULL OR t2.id IS NULL;

-- ============================================================
-- INNER JOIN z warunkami filtrującymi obie tabele
-- ============================================================
SELECT t1.id, t1.kolumna1, t2.kolumna2 FROM tabela1 AS t1
INNER JOIN tabela2 AS t2 ON t1.id = t2.id
WHERE t1.kolumna1 > 10 AND t2.kolumna2 < 20;

-- ============================================================
-- LEFT JOIN z warunkiem filtrującym tylko lewą tabelę
-- (filtr w WHERE dotyczy lewej; NULL z prawej nie wyklucza wiersza)
-- ============================================================
SELECT t1.id, t1.kolumna1, t2.kolumna2 FROM tabela1 AS t1
LEFT JOIN tabela2 AS t2 ON t1.id = t2.id WHERE t1.kolumna1 > 10;

-- ============================================================
-- UNION — łączy wyniki dwóch zapytań, usuwa duplikaty
-- Liczba kolumn i typy muszą się zgadzać
-- Nazwy kolumn brane z pierwszego zapytania
-- ============================================================
SELECT id, kolumna1 FROM tabela1 
UNION 
SELECT id, kolumna2 FROM tabela2;

-- ============================================================
-- UNION ALL — jak UNION, ale zachowuje duplikaty (szybsze)
-- ============================================================
SELECT id, kolumna1 FROM tabela1 
UNION ALL 
SELECT id, kolumna2 FROM tabela2;

-- ============================================================
-- UNION z ORDER BY — sortowanie dotyczy całego połączonego wyniku
-- ORDER BY tylko na końcu ostatniego zapytania
-- ============================================================
SELECT id, kolumna1 FROM tabela1 
UNION ALL
SELECT id, kolumna2 FROM tabela2 ORDER BY id ASC;

-- ============================================================
-- UNION z warunkami WHERE w każdym zapytaniu z osobna
-- ============================================================
SELECT id, kolumna1 FROM tabela1 WHERE kolumna1 > 10 
UNION
SELECT id, kolumna2 FROM tabela2 WHERE kolumna2 < 20;