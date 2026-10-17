-- VALIDATE THE FINAL TABLES 

-- validating TABLE 1 - customer_value

SELECT 	COUNT(*) AS customers, 
		SUM(total_orders) AS total_orders, 
        ROUND(SUM(total_revenue)) AS total_revenue 
        FROM customer_value ;
        
-- validating table 2 - item_performance        
SELECT	COUNT(*) AS items, 
		SUM(total_orders) AS order_item_record,
        SUM(total_quantity_sold) AS total_quantity_sold,
        SUM(total_revenue) AS total_revenue 
FROM item_performance;


-- validating cuisine performance table 

SELECT 	COUNT(*) AS cuisine, 		
        SUM(total_quantity_sold) AS total_quantity_sold, 
        SUM(total_revenue)AS total_revenue
FROM cuisine_performance;

-- TABLE 4 VALIDATE RESTAURANT PERFORMANCE
SELECT	COUNT(*) AS total_restaurants,		
        SUM(total_quantity_sold) AS total_quantity_sold, 
        SUM(total_revenue) AS total_revenue
FROM restaurant_performance;

-- VALIDATE repeat_customer_analysis Table
SELECT 	
		SUM(number_of_customers) AS total_customers,
        SUM(total_revenue) AS total_revenue
FROM repeat_customer_analysis;

-- VALIDATE cuisine_repeat_analysis table 

SELECT	COUNT(*) AS cuisine, 
		SUM(customers) AS total_customers_cuisine_records, 
        SUM(repeat_customers) AS total_repeat_customer_cuisine_records
FROM cuisine_repeat_analysis;





        
