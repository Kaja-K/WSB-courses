-- ZADANIE 2
-- a)
SELECT * FROM farmers_market.customer
ORDER BY customer_last_name, customer_first_name LIMIT 10;
-- b)
SELECT customer_id, customer_first_name
FROM farmers_market.customer
ORDER BY customer_first_name;

-- ZADANIE 3
-- a)
SELECT * FROM farmers_market.customer_purchases
WHERE product_id IN (4, 9);
-- b)
-- AND:
SELECT * FROM farmers_market.customer_purchases
WHERE vendor_id >= 8 AND vendor_id <= 10;
-- BETWEEN:
SELECT * FROM farmers_market.customer_purchases
WHERE vendor_id BETWEEN 8 AND 10;
-- c)
SELECT * FROM farmers_market.customer_purchases
WHERE vendor_id BETWEEN 8 AND 10
AND market_date IN (SELECT market_date FROM farmers_market.market_date_info WHERE market_rain_flag = 0);

-- ZADANIE 4 
-- a)
SELECT product_id,product_name,
CASE WHEN product_qty_type = 'unit' THEN 'na sztuki' ELSE 'luzem' END AS prod_qty_type_condensed
FROM farmers_market.product;
-- b)
SELECT product_id, product_name,
CASE WHEN product_qty_type = 'unit' THEN 'na sztuki' ELSE 'luzem' END AS prod_qty_type_condensed,
CASE WHEN LOWER(product_name) LIKE '%pepper%' THEN 1 ELSE 0 END AS pepper_flag
FROM farmers_market.product;
 
-- ZADANIE 5
-- a)
SELECT * FROM farmers_market.customer AS c
RIGHT JOIN farmers_market.customer_purchases AS cp ON c.customer_id = cp.customer_id;
-- b)
SELECT * FROM farmers_market.customer_purchases AS cp
LEFT JOIN farmers_market.customer AS c ON cp.customer_id = c.customer_id;
-- c)
SELECT v.vendor_id,v.vendor_name, vba.booth_number,vba.market_date
FROM farmers_market.vendor AS v
INNER JOIN farmers_market.vendor_booth_assignments AS vba ON v.vendor_id = vba.vendor_id
ORDER BY v.vendor_name, vba.market_date;
-- d)
SELECT pc.product_category_name, p.product_name, vi.market_date, vi.quantity, vi.original_price
FROM farmers_market.product_category AS pc
INNER JOIN farmers_market.product AS p ON pc.product_category_id = p.product_category_id
INNER JOIN farmers_market.vendor_inventory AS vi ON p.product_id = vi.product_id
WHERE pc.product_category_name = 'Fresh Fruits & Vegetables'
ORDER BY p.product_name, vi.market_date;
 

-- ZADANIE 6
-- a)
SELECT vendor_id, COUNT(*) AS liczba_przypisań_stoisk
FROM farmers_market.vendor_booth_assignments
GROUP BY vendor_id ORDER BY vendor_id;
-- b)
SELECT pc.product_category_name, p.product_name, MIN(vi.market_date) AS najwczesniejsza_data,  MAX(vi.market_date) AS najpozniejsza_data
FROM farmers_market.product_category AS pc
INNER JOIN farmers_market.product AS p ON pc.product_category_id = p.product_category_id
INNER JOIN farmers_market.vendor_inventory AS vi ON p.product_id = vi.product_id
WHERE pc.product_category_name = 'Fresh Fruits & Vegetables'
GROUP BY pc.product_category_name, p.product_name ORDER BY p.product_name;
-- c)
SELECT cp.customer_id, c.customer_first_name, c.customer_last_name, SUM(cp.quantity * cp.cost_to_customer_per_qty) AS total_spent
FROM farmers_market.customer AS c
LEFT JOIN farmers_market.customer_purchases AS cp ON c.customer_id = cp.customer_id
GROUP BY cp.customer_id, c.customer_first_name, c.customer_last_name
HAVING total_spent > 50
ORDER BY c.customer_last_name, c.customer_first_name;
 
-- ZADANIE 7
-- a)
-- ROW_NUMBER()
SELECT customer_id, market_date, transaction_time, product_id,
ROW_NUMBER() OVER ( PARTITION BY customer_id ORDER BY market_date, transaction_time) AS numer_wizyty
FROM farmers_market.customer_purchases;
-- DENSE_RANK()
SELECT DISTINCT customer_id, market_date,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date) AS numer_wizyty
FROM farmers_market.customer_purchases
ORDER BY customer_id, market_date;
-- b)
--Odwrocona:
SELECT DISTINCT customer_id, market_date,
DENSE_RANK() OVER ( PARTITION BY customer_idORDER BY market_date DESC AS numer_wizyty_od_konca
FROM farmers_market.customer_purchases
ORDER BY customer_id, market_date DESC;
SELECT customer_id, market_date
FROM (SELECT DISTINCT customer_id, market_date,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS numer_wizyty_od_konca
FROM farmers_market.customer_purchases) AS ranked_visits
WHERE numer_wizyty_od_konca = 1
ORDER BY customer_id;
-- c)
SELECT customer_id, market_date, product_id,vendor_id,quantity, cost_to_customer_per_qty,
COUNT(*) OVER (PARTITION BY customer_id, product_id) AS ile_razy_kupil_produkt
FROM farmers_market.customer_purchases
ORDER BY customer_id, product_id, market_date;
 
-- ZADANIE 8
-- a)
SELECT customer_id, market_date,
EXTRACT(MONTH FROM market_date) AS miesiac,
EXTRACT(YEAR  FROM market_date) AS rok
FROM farmers_market.customer_purchases;
-- b)
-- Wersja testowa
SELECT  MIN(market_date) AS sales_since_date, SUM(quantity * cost_to_customer_per_qty) AS total_sales
FROM farmers_market.customer_purchases
WHERE market_date BETWEEN DATE_SUB('2019-08-10', INTERVAL 2 WEEK) AND '2019-08-10';
-- Wersja produkcyjna (CURDATE()): 
SELECT MIN(market_date) AS sales_since_date,  SUM(quantity * cost_to_customer_per_qty) AS total_sales
FROM farmers_market.customer_purchases
WHERE market_date BETWEEN  DATE_SUB((SELECT MAX(market_date) FROM farmers_market.customer_purchases), INTERVAL 2 WEEK) 
AND (SELECT MAX(market_date) FROM farmers_market.customer_purchases); 
-- c)
SELECT  market_date, market_day AS dzien_w_bazie, DAYNAME(market_date) AS obliczony_dzien,
CASE WHEN market_day = DAYNAME(market_date) THEN 'OK' ELSE 'NIEZGODNOŚĆ' END AS status_kontroli
FROM farmers_market.market_date_info
ORDER BY market_date;
 
-- ZADANIE 9
-- a)
SELECT MIN(market_date) AS najwczesniejsza_data, MAX(market_date) AS najpozniejsza_data
FROM farmers_market.customer_purchases;
-- b)
SELECT DAYNAME(cp.market_date) AS dzien_tygodnia,
EXTRACT(HOUR FROM cp.transaction_time) AS godzina,
COUNT(DISTINCT cp.customer_id) AS liczba_klientow
FROM farmers_market.customer_purchases AS cp
WHERE DAYNAME(cp.market_date) IN ('Wednesday', 'Saturday')
GROUP BY DAYNAME(cp.market_date), EXTRACT(HOUR FROM cp.transaction_time)
ORDER BY DAYNAME(cp.market_date), godzina;