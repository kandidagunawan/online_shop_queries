--Show all tables in latihan database
SHOW tables;


-- Show all employee numbers and full names of employees who report to senior whose jobtitle is 'Sales Manager (APAC)'
SELECT e1.employeeNumber, CONCAT(e1.firstName, ' ', e1.lastName) AS fullName
FROM employees AS e1, employees AS e2
WHERE e1.reportsTo = e2.employeeNumber AND e2.jobTitle = 'Sales Manager (APAC)';


-- Show productnames, buyprices, productscales, and productvendors of product which has buyPrice > 15.5 and buyPrice < 50
-- sorted by buyPrice descending
SELECT productName, buyPrice, productScale, productVendor
FROM products
WHERE buyPrice > 15.5 AND buyPrice < 50
ORDER BY buyPrice DESC;


-- Show fullName, jobTitle, addressLine1, and the country of the office where employees work, whose firstnames start with the letter G and consists of 6 letters
SELECT CONCAT(firstname, ' ', lastName) AS fullName, addressLine1, country
FROM employees, offices
WHERE employees.officeCode = offices.officeCode AND firstName LIKE 'G_____'


-- Show 5 distinct customers' names with their ordernumbers for vehicle with productLine 'Classic Cars' which recently were delivered 
SELECT DISTINCT customerName, orders.orderNumber 
FROM customers, orders, orderDetails, products 
WHERE customers.customerNumber = orders.customerNumber AND orders.orderNumber = orderDetails.orderNumber AND orderdetails.productCode = products.productCode
AND productLine = 'Classic Cars'
ORDER BY shippedDate DESC
LIMIT 5;


-- Show customers'names from Singapore who has ordered '1926 Ford Fire Engine' in 2004 and 'Corsair F4U (Bird Cage)' in 2003
SELECT DISTINCT customerName
FROM customers AS c, orders AS o, orderDetails AS od, products AS p
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber AND od.productCode = p.productCode
AND p.productName = '1926 Ford Fire Engine' AND YEAR(orderDate) = 2004 AND country = 'Singapore'
INTERSECT
SELECT DISTINCT customerName
FROM customers AS c, orders AS o, orderDetails AS od, products AS p
WHERE c.customerNumber = o.customerNumber AND o.orderNumber = od.orderNumber AND od.productCode = p.productCode
AND p.productName = 'Corsair F4U ( Bird Cage)' AND YEAR(orderDate) = 2003 AND country = 'Singapore';


-- Show all productnames, orderdates, shippedDate for products which were shipped > 30 days from the orderdate
SELECT productName, orderDate, shippedDate
FROM products AS p, orderDetails AS od, orders AS o
WHERE p.productCode = od.productCode AND od.orderNumber = o.orderNumber AND 
TIMESTAMPDIFF(DAY, orderDate, shippedDate) > 30;


-- Show customers' names from Spain or Denmark with their ordernumbers, orderdates, and orderstatus before 2004 and not on March - August
SELECT customerName, orderNumber, orderDate, status
FROM customers, orders
WHERE customers.customerNumber = orders.customerNumber AND (country = 'Spain' OR country = 'Denmark') AND 
YEAR(orderDate) < 2004 AND (MONTH(orderDate) < 3 OR MONTH(orderDate) > 8);


-- The company plans to give credit limit bonus of 13000 to special customers
-- There are 2 conditions to make a customer special status:
-- 1. The customer contact's lastname is the same as the serving employee's lastname or
-- 2. The postal code of the customer is the same as the postal code of the office where the serving employee works
-- Shwo the name of the special customer and their newCreditLimit
SELECT customerName, (13000 + creditLimit) AS newCreditLimit
FROM customers, employees, offices
WHERE customers.salesRepEmployeeNumber = employees.employeeNumber AND offices.officeCode = employees.officeCode AND
(contactLastName = lastName OR offices.postalCode = customers.postalCode);



