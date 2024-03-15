use supply_db ;


Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.


SELECT p.Product_Name,p.Product_Id
 FROM
 product_info as p
INNER JOIN category as c on 
 c.id = p.Category_Id
WHERE name like '%golf%'
 ORDER BY p.product_id;
-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


SELECT p.Product_Name,SUM(O.Sales) AS Sales
FROM
product_info as p
LEFT JOIN  ordered_items as O ON
p.Product_Id = O.Item_Id
LEFT JOIN category as c ON
c.Id = p.Category_Id
LEFT JOIN orders as Ord ON
Ord.Order_Id = O.Order_Id
WHERE LOWER(c.Name) LIKE '%golf%'
GROUP BY p.Product_Name
ORDER BY Sales DESC
LIMIT 10;
-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders

 SELECT Segment AS customer_segment,COUNT(Order_Id) AS Orders
 FROM
 customer_info as cust
 INNER JOIN
 orders AS O ON
 cust.Id = O.Customer_Id
 GROUP BY customer_segment
 ORDER BY Orders DESC;
-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.

WITH Segment_Orders AS
(
SELECT
cust.Segment AS customer_segment,
COUNT(ord.Order_Id) AS Orders
FROM
orders AS ord
INNER JOIN
customer_info AS cust
ON ord.Customer_Id = cust.Id
WHERE Real_Shipping_Days=6
GROUP BY customer_segment
)
SELECT
a.customer_segment,
ROUND(a.Orders/SUM(b.Orders)*100,1) AS percentage_order_split
FROM
Segment_Orders AS a
INNER JOIN
Segment_Orders AS b
GROUP BY customer_segment
ORDER BY percentage_order_split DESC;
-- **********************************************************************************************************************************
