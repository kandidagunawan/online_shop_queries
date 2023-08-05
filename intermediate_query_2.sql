-- Show year, number of customer, and total payment of every year
SELECT YEAR(paymentDate) AS year, COUNT(DISTINCT customerNumber) AS number_of_customers, SUM(amount) AS total_payment_amount
FROM customers NATURAL INNER JOIN payments
GROUP BY year;

-- Show list of employee whose lastName is the same
-- show the number of employees has that lastName
SELECT lastName, COUNT(employeeNumber) AS number_of_employees
FROM employees
GROUP BY lastName;


-- Show productName that has buyPrice more than buyPrice average on market
-- show also the buyPrice of products
-- sorted by buyPrice descending
SELECT productName, buyPrice
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
ORDER BY buyPrice DESC;

-- Show productCode, name of the product with productLine has substring 'Cars' 
-- which has been ordered by customer who has more than 10 payments
SELECT DISTINCT productCode, productname
FROM products NATURAL INNER JOIN orderDetails NATURAL INNER JOIN orders NATURAL INNER JOIN customers NATURAL INNER JOIN payments
WHERE productLine LIKE '%Cars%'
GROUP BY customerNumber
HAVING COUNT(checkNumber) > 10;

-- Show customerName that has substring 'Gift', also show the number of products have been ordered
-- sorted by QUANTITY order ascending
SELECT customerName, SUM(quantityOrdered) AS total_quantity_ordered
FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderDetails
WHERE customerName LIKE '%Gift%' 
GROUP BY customerNumber
ORDER BY total_quantity_ordered;


-- Show employeeNumber, fullName,email of employee who has served customer with 5 least number of order
-- Also show the customerName and number of order they have done
SELECT employeeNumber, CONCAT(firstName, ' ', lastName) AS fullName, email, customerName, COUNT(orderNumber) AS number_of_order
FROM employees INNER JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber INNER JOIN orders ON orders.customerNumber = customers.customerNumber
GROUP BY customers.customerNumber
ORDER BY number_of_order
LIMIT 5;


-- Show orderNumber, name of product which has category of 'Vintage Cars' which gives profit percentage of 106-107% and has been bought in 2004
-- show also the profit percentage and sorted by profit percentage descending
SELECT orderNumber, productName, ((priceEach - buyPrice)/buyPrice *100) AS profit_percentage
FROM orders NATURAL INNER JOIN orderDetails NATURAL INNER JOIN products
WHERE productLine = 'Vintage Cars' AND YEAR(orderDate) = 2004
HAVING profit_percentage BETWEEN 106 AND 107;


-- Show name of customer who hasn't ordered product with vendor 'Min Lin Diecast'
SELECT DISTINCT customerName 
FROM customers
EXCEPT
SELECT DISTINCT customerName
FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderDetails NATURAL INNER JOIN products
WHERE productVendor = 'Min Lin Diecast';

-- Show name of product that has buyPrice > priceEach and that product has ever been ordered by customer with phone number = '3105552373'
SELECT productName
FROM products NATURAL INNER JOIN orderDetails NATURAL INNER JOIN orders NATURAL INNER JOIN customers
WHERE buyPrice > priceEach AND phone = '3105552373';


-- Show number, name, creditLimit, and employee that served customer.
-- customer has credit limit < avg of all credit limit customer in USA
SELECT customerNumber, customerName, creditLimit, CONCAT(firstName, ' ', lastName) AS employeeName
FROM customers INNER JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber 
WHERE creditLimit < (SELECT AVG(creditLimit) FROM customers WHERE country = 'USA')
