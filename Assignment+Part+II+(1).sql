use supply_db ;

/*  Question: Month-wise NIKE sales

	Description:
		Find the combined month-wise sales and quantities sold for all the Nike products. 
        The months should be formatted as ‘YYYY-MM’ (for example, ‘2019-01’ for January 2019). 
        Sort the output based on the month column (from the oldest to newest). The output should have following columns :
			-Month
			-Quantities_sold
			-Sales
		HINT:
			Use orders, ordered_items, and product_info tables from the Supply chain dataset.
*/	

	
SELECT DATE_FORMAT(O.Order_Date,'%Y-%m') AS Month,SUM(Ord.Quantity) as Quantities_Sold, SUM(Ord.Sales) AS Sales
 FROM
 Ordered_Items as Ord
 INNER JOIN
 Orders as O
 ON
 Ord.Order_Id  = O.Order_Id
 INNER JOIN 
 product_info as p
 ON
 p.Product_Id = Ord.Item_Id
 WHERE p.Product_Name LIKE '%nike%'
 GROUP BY Month
 ORDER BY Month ASC;

-- **********************************************************************************************************************************
/*

Question : Costliest products

Description: What are the top five costliest products in the catalogue? Provide the following information/details:
-Product_Id
-Product_Name
-Category_Name
-Department_Name
-Product_Price

Sort the result in the descending order of the Product_Price.

HINT:
Use product_info, category, and department tables from the Supply chain dataset.


 SELECT Product_Id,Product_Name,c.Name AS Category_Name,d.Name AS Department_Name,max(Product_Price) as Product_Price
 FROM
 product_info as p 
 INNER JOIN category as c 
 ON
 p.category_id = c.id
 INNER JOIN department as d
 ON
 p.department_id = d.id
 GROUP by Product_Id
 ORDER BY Product_Price DESC
 LIMIT 5;
-- **********************************************************************************************************************************

/*

Question : Cash customers

Description: Identify the top 10 most ordered items based on sales from all the ‘CASH’ type orders. 
Provide the Product Name, Sales, and Distinct Order count for these items. Sort the table in descending
 order of Order counts and for the cases where the order count is the same, sort based on sales (highest to
 lowest) within that group.
 
HINT: Use orders, ordered_items, and product_info tables from the Supply chain dataset.


SELECT p.Product_Name,SUM(Sales) AS Sales,COUNT(DISTINCT(O.Order_Id))AS Distinct_Order_Count 
 FROM
 Ordered_Items as Ord
 INNER JOIN
 Orders as O
 ON
 Ord.Order_Id  = O.Order_Id
 INNER JOIN 
 product_info as p
 ON
 p.Product_Id = Ord.Item_Id
 WHERE O.Type ='CASH'
 GROUP BY p.Product_Name
 ORDER BY Distinct_Order_Count DESC
 LIMIT 10;
-- **********************************************************************************************************************************
/*
Question : Customers from texas

Obtain all the details from the Orders table (all columns) for customer orders in the state of Texas (TX),
whose street address contains the word ‘Plaza’ but not the word ‘Mountain’. The output should be sorted by the Order_Id.

HINT: Use orders and customer_info tables from the Supply chain dataset.

SELECT O.* FROM
orders AS O
INNER JOIN
customer_info as cust
ON
cust.Id = O.Customer_Id
WHERE (Street LIKE'%Plaza%' AND Street NOT LIKE'%Mountain%') AND (cust.State ='TX')
ORDER BY Order_Id;
-- **********************************************************************************************************************************
/*
 
Question: Home office

For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging to
“Apparel” or “Outdoors” departments. Compute the total count of such orders. The final output should contain the 
following columns:
-Order_Count


SELECT COUNT(O.Order_Id) AS Order_Count
 FROM
 Ordered_Items AS Ord
 INNER JOIN
 Orders AS O
 ON
 Ord.Order_Id  = O.Order_Id
 INNER JOIN 
 product_info AS p
 ON
 p.Product_Id = Ord.Item_Id
INNER JOIN
customer_info AS cust
ON
cust.Id = O.Customer_Id
INNER JOIN 
department AS D ON
p.Department_Id = D.Id
WHERE (D.Name = 'Apparel' OR 'Outdoors') AND (cust.Segment = 'Home Office');
-- **********************************************************************************************************************************
/*

Question : Within state ranking
 
For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging
to “Apparel” or “Outdoors” departments. Compute the count of orders for all combinations of Order_State and Order_City. 
Rank each Order_City within each Order State based on the descending order of their order count (use dense_rank). 
The states should be ordered alphabetically, and Order_Cities within each state should be ordered based on their rank. 
If there is a clash in the city ranking, in such cases, it must be ordered alphabetically based on the city name. 
The final output should contain the following columns:
-Order_State
-Order_City
-Order_Count
-City_rank

HINT: Use orders, ordered_items, product_info, customer_info, and department tables from the Supply chain dataset.


SELECT O.Order_State,O.Order_City,COUNT(O.Order_Id) AS Order_Count,
DENSE_RANK() OVER (PARTITION BY Order_State ORDER BY COUNT(Order_Id) DESC) AS City_rank
 FROM
 Orders AS O
 INNER JOIN
 Ordered_Items AS Ord
 ON
 Ord.Order_Id  = O.Order_Id
 INNER JOIN 
 product_info AS p
 ON
 p.Product_Id = Ord.Item_Id
INNER JOIN
customer_info AS cust
ON
cust.Id = O.Customer_Id
INNER JOIN 
department AS D ON
p.Department_Id = D.Id
WHERE (D.Name = 'Apparel' OR 'Outdoors') AND (cust.Segment = 'Home Office')
GROUP BY O.Order_State,O.Order_City;
-- **********************************************************************************************************************************

Question : Underestimated orders

Rank (using row_number so that irrespective of the duplicates, so you obtain a unique ranking) the 
shipping mode for each year, based on the number of orders when the shipping days were underestimated 
(i.e., Scheduled_Shipping_Days < Real_Shipping_Days). The shipping mode with the highest orders that meet 
the required criteria should appear first. Consider only ‘COMPLETE’ and ‘CLOSED’ orders and those belonging to 
the customer segment: ‘Consumer’. The final output should contain the following columns:
-Shipping_Mode,
-Shipping_Underestimated_Order_Count,
-Shipping_Mode_Rank

HINT: Use orders and customer_info tables from the Supply chain dataset.

SELECT O.Shipping_Mode, COUNT(O.Order_Id) AS Shipping_Underestimated_Order_Count, 
ROW_NUMBER() OVER (PARTITION BY YEAR (O.Order_Date) ORDER BY COUNT(O.Order_Id)DESC) AS Shipping_Mode_Rank
 FROM
 Orders AS O
INNER JOIN
customer_info AS cust
ON
cust.Id = O.Customer_Id
WHERE O.Order_Status IN('COMPLETE','CLOSED' ) AND (cust.Segment = 'Consumer') AND (O.Scheduled_Shipping_Days < O.Real_Shipping_Days)
GROUP BY YEAR (O.Order_Date),O.Shipping_Mode;

-- **********************************************************************************************************************************





