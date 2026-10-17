--- EDA 
SELECT * 
FROM restaurants_eda;


SELECT 	COUNT(DISTINCT customer_id) AS total_customers,
		COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity) AS total_quantities_purchased,
        ROUND(SUM(item_revenue)) AS total_revenue 
FROM restaurants_eda; 
-- KPI customers - orders - quantity purchased - revenue 
-- 1452 customers generated 5000 orders 
-- those orders contained 24,699 total quantities purchased 
-- those purchases generated 560,509 in revenue 
-- this tells us the size and overall activity of the business


SELECT 	customer_id,
		COUNT(DISTINCT order_id) AS total_orders_made
FROM restaurants_eda
GROUP BY customer_id
ORDER BY total_orders_made DESC
LIMIT 10 ;
-- the most frequent customer has 11 orders 
-- the top 10 customers have between 9 and 11 orders 


SELECT 	customer_id, 
		ROUND(SUM(item_revenue), 2) AS total_revenue 
FROM restaurants_eda 
GROUP BY customer_id 
ORDER BY total_revenue DESC
LIMIT 10;

-- do customers who order more frequently also generate more revenue?

SELECT 	customer_id,
		COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(item_revenue)) AS total_revenue 
FROM restaurants_eda 
GROUP BY customer_id
ORDER BY total_revenue DESC;


-- how much does customer spend per order on average

SELECT	customer_id, 
		COUNT(DISTINCT order_id) AS total_orders, 
        ROUND(SUM(item_revenue)) AS total_revenue,
        ROUND(SUM(item_revenue) / COUNT(DISTINCT order_id)) AS average_order_value 
FROM restaurants_eda
GROUP BY customer_id 
ORDER BY average_order_value DESC; 

-- so we shouldn't define 'valuable customer' using one metric

-- ARE CUSTOMERS WHO ORDER MORE FREQUENTLY ALSO THE CUSTOMERS WHO GENERATE MORE REVENUE?

SELECT		total_orders,
			COUNT(*) AS number_of_customers, 
            ROUND(AVG(total_revenue)) AS average_customer_revenue, 
            ROUND(AVG(avg_order_value)) AS average_order_value 
			
FROM		(
				SELECT customer_id,
				COUNT(DISTINCT order_id) AS total_orders,
				SUM(item_revenue) AS total_revenue,
				SUM(item_revenue) / COUNT(DISTINCT order_id) AS avg_order_value
				FROM restaurants_eda
				GROUP BY customer_id ) AS customer_summary 

GROUP BY total_orders
ORDER BY total_orders ;


-- Are high value customers concentrated in particular cities? 


SELECT 	customer_city,
		COUNT(DISTINCT customer_id) AS customers,
		COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(item_revenue)) AS total_revenue, 
        ROUND(SUM(item_revenue) / COUNT(DISTINCT customer_id)) AS average_revenue_per_customer        
FROM restaurants_eda
GROUP BY customer_city
ORDER BY total_revenue DESC;

-- Bristol is the strongest customer market in this dataset by both total customer revenue and average revenue per customer


-- SECTION 2 WHAT DO VALUABLE CUSTOMERS BUY 
-- Q1 which menu items are most frequently purchased?

SELECT	item_id,
		SUM(quantity) AS total_quantity_sold,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(item_revenue)) AS total_revenue
FROM restaurants_eda 
GROUP BY item_id
ORDER BY total_quantity_sold DESC;

-- popularity and revenue are not the same thing in this database 


-- Q2 which menu items contribute the most revenue to the business?
SELECT	item_id,
		SUM(quantity) AS total_quantity_sold,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(item_revenue)) AS total_revenue
FROM restaurants_eda 
GROUP BY item_id
ORDER BY total_revenue DESC;

-- item M0270 contribute the most revenue to the business 

-- which cuisines generates the most revenue to the business?

SELECT 	cuisine,
		COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity) AS total_quantity_sold,
        ROUND(SUM(item_revenue)) AS total_revenue 
FROM restaurants_eda 
GROUP BY cuisine 
ORDER BY total_revenue DESC;

-- Thai cuisine is the largest contributor to both customer activity and revenue 

-- Q which restaurants generate the most revenue 

SELECT 	restaurant_id,	
		cuisine,
		COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity) AS quantity_sold,
        ROUND(SUM(item_revenue)) AS total_revenue
FROM restaurants_eda 
GROUP BY restaurant_id, cuisine
ORDER BY total_revenue DESC ;
-- R061 generated the highest restaurant revenue at 6908 followed by R073 at 6817 
-- 3 of the top 5 are thai 


-- SECTTION 3 
-- Q how many customers are one-time customers and how many are repeat customer 

SELECT 	COUNT(*) AS repeat_customers
		
FROM

			(SELECT	customer_id,
					COUNT(DISTINCT order_id) AS total_orders
			FROM restaurants_eda 
			GROUP BY customer_id ) AS re_customers

WHERE total_orders > 1;


SELECT 
		CASE 
			WHEN total_orders = 1 THEN 'one_time_customer'
            ELSE 'repeat_customer'
            END AS customer_type,
            COUNT(*) AS total_customers
FROM 	
(SELECT 		customer_id, 
				COUNT(DISTINCT order_id) AS total_orders
				FROM restaurants_eda 
                GROUP BY customer_id ) AS customer_summary 
GROUP BY 
        CASE 
			WHEN total_orders = 1 THEN 'one_time_customer'
            ELSE 'repeat_customer'
            END    ;
            
-- repeat purchasing is already a major part of the business activity in this dataset 

-- Q Do repeat customers generate significantly more revenue than one time customers? 

SELECT 	CASE
			WHEN total_orders = 1 THEN 'One Time Customers'
            ELSE 'Repeat Customers'
            END AS customer_type,
            COUNT(*) AS total_customers,
            ROUND(SUM(total_revenue)) AS total_revenue,
            ROUND(AVG(total_revenue)) AS average_revenue_per_customer

FROM
(SELECT	customer_id, 
		COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(item_revenue)) AS total_revenue 
        
FROM restaurants_eda
GROUP BY customer_id ) AS customer_summary

GROUP BY 
			CASE
				WHEN total_orders = 1 THEN 'One Time Customers'
            ELSE 'Repeat Customers'
            END ;
-- repeat customers substantially generate the most revenue in this dataset
-- the restaurant business has a relatively small group of one time customers

-- are there particular cuisines associated with repeat customers?

SELECT 	cuisine, 
		COUNT(DISTINCT customer_id) AS customers, 
        COUNT(DISTINCT CASE 
						WHEN total_orders > 1 THEN customer_id 
                        END ) AS repeat_customers, 
                        ROUND(COUNT(DISTINCT CASE 
						WHEN total_orders > 1 THEN customer_id 
                        END) * 100.0 / COUNT(DISTINCT customer_id), 1 ) AS repeat_customer_rate 
FROM 
		(	SELECT customer_id, 
					cuisine, 
                    COUNT(DISTINCT order_id) AS total_orders 
                    FROM restaurants_eda
                    GROUP BY customer_id, cuisine) AS customer_cuisine
GROUP BY cuisine
ORDER BY repeat_customer_rate DESC
		
            




            
		
            
            
            













		

	




















