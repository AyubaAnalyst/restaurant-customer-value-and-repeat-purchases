-- Data cleaning 
-- clean cutomers_medium 

SELECT * 
FROM customers_medium;

CREATE TABLE customers_clean AS 
SELECT 	customer_id,
		TRIM(city) AS city,
        STR_TO_DATE(signup_date,'%Y-%m-%d') AS signup_date 
FROM customers_medium;

SELECT * 
FROM customers_clean;

DESCRIBE customers_clean;

SELECT * 
FROM restaurants;

CREATE TABLE restaurants_clean AS
SELECT 	restaurant_id,
		TRIM(cuisine) AS cuisine,
        TRIM(city) AS city, 
        rating
FROM restaurants;

SELECT * 
FROM restaurants_clean 
LIMIT 10;

-- validate the rating 
SELECT * 
FROM restaurants_clean
WHERE rating < 0 
OR rating > 5 ;


-- clean menu_items 

SELECT * 
FROM menu_items;

CREATE TABLE menu_clean
SELECT 	item_id, 
		restaurant_id, 
        price
FROM menu_items;

-- check for bad prices 
SELECT * 
FROM menu_clean
WHERE price <= 0;


--- clean orders_medium
SELECT * 
FROM orders_medium;

CREATE TABLE orders_clean 
SELECT 	order_id,
		customer_id,
        restaurant_id,
        STR_TO_DATE(order_time, '%Y-%m-%d') AS order_time,
        STR_TO_DATE(delivery_time, '%Y-%m-%d %H:%i:%s') AS delivery_time,
        TRIM(`status`) AS status 
FROM orders_medium;

SELECT * 
FROM orders_clean;

SELECT 	status, 
		COUNT(*) AS order_count
FROM orders_clean
GROUP BY status;

-- Clean order_items (2)

SELECT * 
FROM `order_items (2)` ;

CREATE TABLE order_items_clean 
SELECT 	order_id,
		item_id, 
        quantity, 
        price
FROM `order_items (2)` ;

--- check price and quantity
SELECT *
FROM order_items_clean
WHERE price <= 0
OR quantity <= 0;


--- searching for duplicates table by table 

SELECT 	customer_id, 
		COUNT(*) AS occurrences
FROM customers_clean 
GROUP BY customer_id
HAVING COUNT(*) > 1 ;

--- check completely identical row on customers_clean table 
SELECT 	customer_id,
		city, 
        signup_date,
        COUNT(*) AS occurences
FROM customers_clean
GROUP BY 	customer_id,
			city, 
            signup_date
HAVING COUNT(*) > 1;


---- checking duplicates on restaurants table 

SELECT * 
FROM restaurants_clean;

SELECT 	restaurant_id, 
		COUNT(*) AS occurrences
FROM restaurants_clean 
GROUP BY restaurant_id 
HAVING COUNT(*) > 1 ; -- NO DUPLICATE RESTAURANTS IDS 

--- checking exact duplicates record on restaurants_clean table 
SELECT 		restaurant_id, 
			cuisine, 
			city, 
			rating, 
			COUNT(*) AS occurrences 
FROM restaurants_clean
GROUP BY 	restaurant_id, 
			cuisine, 
            city, 
            rating 
HAVING COUNT(*) > 1 ;  -- NO DUPLICATE RECORD 


---- checking duplicates on menu_clean table 

SELECT * 
FROM menu_clean;

SELECT 	item_id, COUNT(*) AS occurrences 
FROM menu_clean 
GROUP BY item_id 
HAVING COUNT(*) > 1 ; -- NO DUPLICATE ITEM_IDs


--- CHECKING exact duplicates rows on menu_cclean table 

SELECT 		item_id, 
			restaurant_id, 
			price,
			COUNT(*) AS occurrences
FROM menu_clean 
GROUP BY 	item_id, 
			restaurant_id, 
            price
HAVING COUNT(*) > 1;


---- checking duplicates on orders_clean table 

SELECT * 
FROM orders_clean;

SELECT 	order_id,
		COUNT(*) AS occurrences 
FROM orders_clean 
GROUP BY order_id 
HAVING COUNT(*) > 1; 


--- CHECKING exact duplicates record on orders_clean table 
SELECT 		order_id, 
			customer_id, 
			restaurant_id, 
			order_time, 
			delivery_time, 
			status, 
			COUNT(*) AS occurrences 
FROM orders_clean
GROUP BY 	order_id,
			customer_id, 
			restaurant_id, 
            order_time, 
            delivery_time, 
            status
HAVING COUNT(*) > 1 ;


---- checking duplicates on orders_items_clean table 

SELECT * 
FROM order_items_clean;

SELECT 		order_id,
			item_id, 
			COUNT(*) AS occurrences
FROM order_items_clean
GROUP BY 	order_id,
			item_id
HAVING COUNT(*) > 1 ;

--- check whether an entire ow is repeated 

SELECT 
			order_id,
			item_id, 
            quantity, 
            price,
            COUNT(*) AS occurrences 
FROM order_items_clean 
GROUP BY 	order_id, 
			item_id,
            quantity, 
            price
HAVING COUNT(*) > 1 ;



--- ISSUE FROM THE DATA SET 
SELECT * 
FROM customers_clean;

SELECT * 
FROM orders_clean;

SELECT	COUNT(*) AS orders_before_signup_date
FROM customers_clean AS c 
JOIN orders_clean AS o
	ON c.customer_id = o.customer_id 
WHERE o.order_time < c.signup_date; --- 848 orders before signup dates were found

--- FIND THE CUSTOMERS THAT HAVE THE PROBLEM 
SELECT * 
FROM customers_clean;

SELECT * 
FROM orders_clean;

SELECT 	c.customer_id AS customer_id, 	
        c.signup_date AS signup_date,
        MIN(o.order_time) AS first_order,
        COUNT(*) AS orders_before_signup       	
FROM customers_clean AS c
JOIN orders_clean AS o 
	ON c.customer_id = o.customer_id 
WHERE o.order_time < c.signup_date
GROUP BY customer_id, signup_date
ORDER BY orders_before_signup DESC;


----- FINAL JOINED ANALYTICAL DATASET 
SELECT * 
FROM customers_clean;

SELECT * 
FROM menu_clean;

SELECT *
FROM order_items_clean;

SELECT * 
FROM orders_clean;

SELECT * 
FROM restaurants_clean;


CREATE TABLE restaurants_eda AS 
	SELECT 	c.customer_id AS customer_id,
			c.city AS customer_city, 
            c.signup_date AS signup_date,
            
            o.order_id AS order_id,
            o.order_time AS order_time,
            o.delivery_time AS delivery_time,
            o.status AS status,
            
            r.restaurant_id AS restaurant_id,
            r.cuisine AS cuisine, 
            r.city AS restaurant_city, 
            r.rating AS rating,
            
            oi.item_id AS item_id, 
            oi.quantity AS quantity, 
            oi.price AS item_price ,
            
            oi.quantity * oi.price AS item_revenue,
    
    CASE 
		WHEN o.order_time < c.signup_date 
        THEN 1
        ELSE 0 
	END AS order_before_signup_flag,

	CASE
		WHEN o.status IN ('Delivered', 'Late')
        THEN 1 
        ELSE 0 
	END AS completed_order_flag
    
    FROM customers_clean AS c 
    JOIN orders_clean AS o 
		ON c.customer_id = o.customer_id 
	JOIN restaurants_clean AS r 
		ON o.restaurant_id = r.restaurant_id 
	JOIN order_items_clean AS oi
		ON o.order_id = oi.order_id 
	JOIN menu_clean AS m 
		ON oi.item_id = m.item_id 
    ; --- MAIN ANALYTICAL DATASET 
        

SELECT * 
FROM restaurants_eda;


---- Validate main analytical dataset 
SELECT 	COUNT(*) AS total_rows, 
		COUNT(DISTINCT customer_id) AS customers,
        COUNT(DISTINCT order_id) AS orders, 
        COUNT(DISTINCT restaurant_id) AS restaurants,
        COUNT(DISTINCT item_id) AS items 
FROM restaurants_eda;

--- Now check customers with no orders to validate the total customers that was returned 

SELECT * 
FROM customers_clean;

SELECT * 
FROM orders_clean;

SELECT 	
        COUNT(*) AS no_order_id
FROM customers_clean AS c 
LEFT JOIN orders_clean AS o 
	ON c.customer_id = o.customer_id 
WHERE order_id IS NULL; --- All 1452 customers who have orders are represented 
						---- in restaurant_eda; the remaining 48 customers simply have no order;


SELECT * 
FROM order_items_clean;

SELECT * 
FROM orders_clean;

SELECT COUNT(*) orders_without_item 
FROM orders_clean AS oi
LEFT JOIN order_items_clean AS o
	ON oi.order_id = o.order_id 
WHERE o.order_id IS NULL;

SELECT 	order_id,
		COUNT(*) AS rows_per_order 
        FROM restaurants_eda 
        GROUP BY order_id 
        ORDER BY rows_per_order DESC;

SELECT 	
		COUNT(DISTINCT order_id) AS unique_orders 
FROM restaurants_eda;


SELECT * 
FROM restaurants_eda;


SELECT SUM(item_revenue) AS total_item_revenue
FROM restaurants_eda ;

SELECT SUM( CASE 
				WHEN completed_order_flag = 1
                THEN item_revenue
                ELSE 0 
			END) AS completed_revenue 
FROM restaurants_eda ;

		
        

















