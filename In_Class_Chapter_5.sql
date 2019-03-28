/* In-Class MySQL commands */
/* Chapter-5 */
use tald;

/* 1.	List the number and name of each customer, together with the number, last name and first name of the sales rep who represents the customer.
Solved by joining 2 tables: */
SELECT Customer_Num, Customer_Name, Rep.Rep_Num, Last_Name, First_Name
FROM Customer, Rep
WHERE Customer.Rep_Num = Rep.Rep_Num;

/* 2.	List the number and name of each customer whose credit limit is $7500, together with the number, last name and first name of the sales rep who represents the customer.
Solved by joining 2 tables: */
SELECT Customer_Num, Customer_Name, Rep.Rep_Num, Last_Name, First_Name, Credit_Limit
FROM Customer, Rep
WHERE Customer.Rep_Num = Rep.Rep_Num
AND Credit_Limit = 7500;

/* 3.	For every item on order, list the order number, item number, description, number of units ordered, quoted price and unit price.
Solved by joining 2 tables: */
SELECT Order_Num, Order_Line.Item_Num, Description, Num_Ordered, Quoted_Price, Price
FROM Order_Line, Item
WHERE Order_Line.Item_Num = Item.Item_Num

/* 4.	Find the description of each item included in order number 51623. 
Solved by joining 2 tables: */
SELECT Order_Num, Order_Line.Item_Num, Description, Num_Ordered, Quoted_Price, Price
FROM Order_Line, Item
WHERE Order_Line.Item_Num = Item.Item_Num
AND Order_Num = ‘51623’;

/* Using the IN and EXISTS operators to get the same results:
5.	Find the Order_Number and Order_Date for each order that contains item number FD11.
IN operator*/
SELECT Order_Num, Order_Date
FROM Orders
WHERE Order_Num IN (SELECT Order_Num FROM Order_Line WHERE item_Num = ‘FD11’);

/* Exists Operator */
SELECT Order_Num, Order_Date
FROM Orders
WHERE EXISTS (SELECT * FROM Order_Line WHERE Orders.Order_Num = Order_Line.Order_Num AND item_Num = ‘FD11’);

/* Solved by joining 2 tables: */
SELECT Order_Num, Order_Date, Item_Num
FROM Orders, Order_Line
WHERE Orders.Order_Num = Order_Line.Order_Num
AND Item_Num = ‘FD11’;

/* Solved by joining 2 tables: */
Select Order_Num, category
From Order_Line, Item
Where Item.Item_Num = Order_Line.Item_Num
AND category = 'PZL';

/* 6.	Find the order number and the order date for each order that includes an item located in storehouse 3.
Solved using Query with a Subquery */
SELECT Order_Num, Order_Date
FROM Orders
WHERE Order_Num IN (SELECT Order_Num 
FROM Order_Line 
WHERE Item_Num IN (SELECT Item_Num FROM  Item WHERE Storehouse = ‘3’));

/* Solved by joining 3 tables */
SELECT Orders.Order_Num, Order_Date
FROM Orders, Order_Line, Item
WHERE Order_line.Order_Num = Orders.Order_Num   
AND Order_Line.Item_Num = Item.Item_Num
AND Storehouse = ‘3’;

/* 7.	List the customer number, order number, order date and order total for each order. Assign a column name of order total to the column that displays the order totals. Order by order number.
Solved by joining 2 tables using a calculated column: */
SELECT Customer_Num, Order_Num, Order_Date, SUM(Num_Ordered * Quoted_Price) AS Order Total
FROM Orders, Order_Line
WHERE Orders.OrderNum = Order_Line.Order_Num
GROUP BY Orders.OrderNum, Customer_Num, Order_Date
ORDER BY Orders.Order_Num;

/* 8.	List the number, last name and first name for each sales rep along with the number and name of each customer he represents.
Solved by joining 2 tables using an alias: */
SELECT R.Rep_Num, Last_Name, First_Name, C.Customer_Num, Customer_Name
FROM Customer C, Rep R
WHERE R.Rep_Num = C.Rep_Num;

/* 9.	For each pair of customers located in the same city, display the customer number, customer name and city. */
SELECT F.Customer_Num, F.Customer_Name, S.Customer_Num, S.Customer_Name, City
FROM Customer F, Customer S
Where F.City = S.City 
AND F.Customer_Num < S.Customer_Num;

/* 10.	For each item on order, list the item number, number ordered, order number, order date, customer number, customer name and the customer’s sales rep last name.
Solve by joining 4 tables: */
SELECT Item_Num, Num_Ordered, Order_Line.Order_Num, Order_Date, Customer.Customer_Num, Customer_Name, Rep.Last_Name
FROM Order_Line, Orders, Customer, Rep
WHERE Order_Line.Order_Num = Orders.Order_Num
AND Customer.Customer_Num = Orders.Customer_Num
AND Rep.Rep_Num = Customer.Rep_Num
ORDER BY Item_Num, Order_Line.Item_Num;

/* Solve by joining 4 tables and including criteria: */
SELECT Item_Num, Num_Ordered, Order_Num, Order_Date, Customer.Customer_Num, Customer_Name, Rep.Last_Name, credit_Limit
FROM Order_Line, Orders, Customer, Rep
WHERE Order_Line.Order_Num = Orders.Order_Num
AND Customer.Customer_Num = Orders.Customer_Num
AND Rep.Rep_Num = Customer.Rep_Num
AND Credit_Limit = 7500
ORDER BY Item_Num, Order_Line.Item_Num;

/* 11.	List the number and name of each customer that is either represented by sales rep 15 or currently has orders on file, or both */
SELECT Orders.Customer_Num, Customer_Name
FROM Customer, Orders
WHERE Customer.Customer_Num  =  Orders.Customer_Num
AND Rep_Num  = ‘15’
UNION
SELECT Customer.Customer_Num, Customer_Name
FROM Customer, Orders
WHERE Customer.Customer_Num  =  Orders.Customer_Num;

/* 12.	Find the customer number, name, current balance and rep number of each customer whose balance exceeds the maximum balance of all customers represented by sales rep 30. */
Select Customer_Num, Customer_Name, Balance, Rep_Num
FROM Customer
Where Balance > ALL (SELECT Balance FROM Customer WHERE rep_Num = ‘30’);
/* OR solve by using the MAX aggregate function:*/
Select Customer_Num, Customer_Name, Balance, Rep_Num
FROM Customer
Where Balance > (SELECT MAX(Balance) FROM Customer WHERE rep_Num = ‘30’);

/* 13.	Find the customer number, name, current balance, and rep number of each customer whose balance is greater than the balance of at least one customer of sales rep 30.
Solve by using the ANY operator: */
Select Customer_Num, Customer_Name, Balance, Rep_Num
FROM Customer
Where Balance > ANY (SELECT Balance FROM Customer WHERE rep_Num = ‘30’);
/* OR solve by using the MIN function: */
Select Customer_Num, Customer_Name, Rep_Num
FROM Customer
Where Balance > (SELECT MIN(Balance) FROM Customer WHERE rep_Num = ‘30’);

/* 14.	Display the customer number, customer name, order number and order date for each order. Sort by customer number.
Solve by creating an inner join on the customer and orders table: */
SELECT Customer.Customer_Num, Customer_Name, Order_Num, Order_Date
FROM Customer
INNER JOIN Orders
ON Customer.Customer_Num  = Orders.Order_Num
ORDER BY Customer.Customer_Num;

/* 15.	Display the customer number, customer name, order number and order date for each order. Sort by customer number. Include all customers in the results. */
SELECT Customer.Customer_Num, Customer_Name, Order_Num, Order_Date
FROM Customer
LEFT JOIN Orders
ON Customer.Customer_Num  = Orders.Customer_Num
ORDER BY Customer.Customer_Num;

/* 16.	Form the Product of the Customers and Orders tables. */
SELECT Customer.Customer_Num, Customer_Name, Order_Num, Order_Date
FROM Customer, Orders;











