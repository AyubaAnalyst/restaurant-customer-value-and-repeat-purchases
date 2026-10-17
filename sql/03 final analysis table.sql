
-- CUSTOMER VALUE 
-- Business Question 'who are the most valuable customers?

CREATE TABLE customer_value AS
SELECT		customer_id,
			COUNT(DISTINCT order_id) AS total_orders,
			ROUND(SUM(item_revenue)) AS total_revenue,
            ROUND(SUM(item_revenue) / COUNT(DISTINCT order_id)) AS average_order_value
FROM restaurants_eda 
GROUP BY customer_id ;

SELECT * 
FROM customer_value;

-- TABLE 2 ITEM PERFORMANCE 
-- Business Question 'which menu items sell the most and generate the most revenue?

CREATE TABLE item_performance AS
SELECT 	item_id, 		
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity) AS total_quantity_sold,        
		ROUND(SUM(item_revenue)) AS total_revenue 
FROM restaurants_eda 
GROUP BY item_id;


-- TABLE 3 cuisine performance 

CREATE TABLE cuisine_performance AS 
SELECT		cuisine, 
			COUNT(DISTINCT order_id) AS total_orders, 
            SUM(quantity) AS total_quantity_sold, 
            ROUND(SUM(item_revenue)) AS total_revenue 
FROM restaurants_eda 
GROUP BY cuisine ;

-- TABLE 4 RESTAURANT PERFORMANCE 

CREATE TABLE restaurant_performance AS 
SELECT	restaurant_id, cuisine,
		COUNT(DISTINCT order_id) AS total_orders, 
        SUM(quantity) AS total_quantity_sold, 
        ROUND(SUM(item_revenue)) AS total_revenue 
FROM restaurants_eda
GROUP BY restaurant_id, cuisine ;


-- TABLE 5 REPEAT CUSTOMER ANALYSIS
CREATE TABLE repeat_customer_analysis AS 
SELECT 	
		CASE
			WHEN total_orders = 1 THEN 'one time customer'
            ElSE 'repeat_customer'
            END AS customer_type,
            COUNT(*) AS number_of_customers,
            ROUND(SUM(total_revenue)) AS total_revenue,
            ROUND(AVG(total_revenue)) AS avg_revenue_per_customer
FROM 
            
		(SELECT	customer_id, 
		COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(item_revenue)) AS total_revenue
        FROM restaurants_eda 
        GROUP BY customer_id ) AS customer_summary

GROUP BY 
CASE
			WHEN total_orders = 1 THEN 'one time customer'
            ElSE 'repeat_customer'
            END;


-- TABLE 6 Cuisine Repeat Analysis
CREATE TABLE cuisine_repeat_analysis AS 
SELECT 	cuisine, 
		COUNT(DISTINCT customer_id) AS customers, 
        COUNT(	DISTINCT CASE 
				WHEN total_orders > 1 THEN customer_id
                END) AS repeat_customers, 
		ROUND(	COUNT(DISTINCT CASE 
				WHEN total_orders > 1 THEN customer_id 
                END) * 100.0 / COUNT(DISTINCT customer_id), 1) AS repeat_customer_rate
FROM 
		(	SELECT	customer_id, 
					cuisine, 
                    COUNT(DISTINCT order_id) AS total_orders 
			FROM restaurants_eda 
            GROUP BY customer_id, cuisine) AS customer_cuisine
GROUP BY cuisine;






















        
        
        
        
        