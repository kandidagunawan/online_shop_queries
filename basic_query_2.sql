-- Show the contents of offices table
SELECT * FROM offices;

-- Show city, state, and country of customer, state is not null and its country is not USA
SELECT city, state, country 
FROM customers
WHERE state IS NOT NULL AND country != 'USA';

-- Show productCode, productName, quantityInStock, and buyPrice of product which its name 
-- contains 'Ford', 'Ferrari', 'Pont', or 'Bus'
-- sorted by buyPrice ascending, quantityInStock descending
SELECT productCode, productName, quantityInStock, buyPrice
FROM products 
WHERE productName LIKE '%Ford%' OR productName LIKE '%Ferrari%' OR productName LIKE '%Pont%' OR productName LIKE '%Bus%'
ORDER BY buyPrice ASC, quantityInStock DESC;


-- Show customerName which has suffix 'Co.', contactName which has firstName that consists of 4 letters
SELECT customerName, CONCAT(contactFirstName, ' ', contactLastName) AS contactName 
FROM customers
WHERE customerName LIKE '%Co' AND contactFirstName LIKE '____';

-- Show officeCode and office's telephone number from office which has employee that has served customer with creditLimit between 100000 and 150000 and their country data is not null
SELECT offices.officeCode, offices.phone
FROM offices, employees, customers
WHERE offices.officeCode = employees.officeCode AND employees.employeeNumber = customers.salesRepEmployeeNumber AND
creditLimit BETWEEN 100000 AND 150000 AND customers.country IS NOT NULL;


--Show 15 customerNumber, checkNumber, and payment amount from customers who has payment amount more than 1 or some other customers
-- sorted by payment amount ascending
SELECT DISTINCT p1.customerNumber, p1.checkNumber, p1.amount
FROM payments AS p1, payments AS p2
WHERE p1.customerNumber != p2.customerNumber AND p1.amount > p2.amount
ORDER BY p1.amount
LIMIT 15;


-- Show customerName of customer whose order's status is 'On Hold', also show the order's comment, orderDate, and productname ordered
SELECT c.customerName, o.comments, o.orderDate, p.productName
FROM customers AS c, orders AS o, orderDetails AS od, products AS p
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber AND od.productCode = p.productCode
AND status = 'On Hold';


-- Show the fullName, office's city, office's addressLine1 of employee who has served customer whose name contains 'Mini'
SELECT DISTINCT CONCAT(e.firstName, ' ', e.lastName) AS employeeName, o.city, o.addressLine1 
FROM employees AS e, offices AS o, customers AS c
WHERE c.salesRepEmployeeNumber = e.employeeNumber AND e.officeCode = o.officeCode
AND customerName LIKE '%Mini%';


-- Show customerName of the customer from London who has ordered 'Pont Yacht' in 2004 or has ordered product which has productLine, 'Vintage Cars' in 2003
SELECT DISTINCT c.customerName
FROM customers AS c, orders AS o, orderDetails AS od, products AS p
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber AND od.productCode = p.productCode
AND city = 'London' AND productName = 'Pont Yacht' AND YEAR(orderDate) = 2004
UNION
SELECT DISTINCT c.customerName
FROM customers AS c, orders AS o, orderDetails AS od, products AS p
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber AND od.productCode = p.productCode
AND city = 'London' AND productLine = 'Vintage Cars' AND YEAR(orderDate) = 2003;