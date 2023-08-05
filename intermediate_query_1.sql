-- Show 6 countries with the most customers
-- sorted by the number of customers descending
SELECT country, COUNT(customerNumber) AS numOfCustomers
FROM customers
GROUP BY country
ORDER BY numOfCustomers DESC
LIMIT 6;

-- Show customerName, contactName, country, paymentDate, paymentAmount of customer on April 2005
SELECT customerName, CONCAT(contactFirstName, ' ', contactLastName) AS contactName, country, paymentDate, amount
FROM customers NATURAL INNER JOIN payments
WHERE YEAR(paymentDate) = 2005 AND MONTH(paymentDate) = 4;


-- Show customerName whic contains 'Mini', with the number of products they have ordered.
-- sorted by the number of products ordered descending
SELECT customerName, SUM(quantityOrdered) AS numberOfProducts
FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderDetails
WHERE customerName LIKE '%Mini%'
GROUP BY customerName
ORDER BY numberOfProducts DESC;


-- Show firstName, officeCode of employee who has served more than 7 customers.
-- Also show number of customers the employee has served
-- sorted by numberofcustomers descending
SELECT firstName, officeCode, COUNT(customerNumber) AS numberOfCustomersSeved
FROM customers INNER JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY employeeNumber
HAVING numberOfCustomersSeved > 7
ORDER BY numberOfCustomersSeved DESC;


-- Show employeeNumber, fullName, email of employee who has served customers with 2 most orders
-- Also show customer's name and the number of order
SELECT employeeNumber, CONCAT(firstName, ' ', lastName) AS employeeName, email, customerName, COUNT(orderNumber) AS numberOfOrder
FROM employees INNER JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber INNER JOIN orders ON orders.customerNumber = customers.customerNumber
GROUP BY customers.customerNumber
ORDER BY numberOfOrder DESC
LIMIT 2;


-- Show name of customer who has total payment amount (ALL PAYMENT THEY HAVE DONE) > 50000 and served by an employee who works at the office in Australia
SELECT customerName, SUM(amount) AS total_payment_amount
FROM customers AS c NATURAL INNER JOIN payments AS p NATURAL INNER JOIN employees AS e INNER JOIN offices AS o ON o.officeCode = e.officeCode
WHERE o.country = 'Australia'
GROUP BY customerNumber
HAVING total_payment_amount > 50000;


-- Show orderNumber, productName with the category 'Classic Cars' and has been ordered with the buyPrice 
-- that gives profit of 35-36% or 104-105%
-- Show the profit percentage and sort by the percentage descending
SELECT orderNumber, productName, ((priceEach - buyPrice)/buyPrice *100) AS profit_percentage
FROM orders AS o NATURAL INNER JOIN orderDetails AS od NATURAL INNER JOIN products AS p 
WHERE productLine = 'Classic Cars' 
HAVING (profit_percentage BETWEEN 35 AND 36) OR (profit_percentage BETWEEN 104 AND 105)
ORDER BY profit_percentage DESC;


-- Show number, name, and payment amount average of a customer
-- show also the number of transactions has been done by the customers
-- total payment amount of that customer > 500000
-- sorted by number of transactions descending
SELECT customerNumber, customerName, AVG(amount) AS average_payment_amount, COUNT(checkNumber) AS number_of_transaction
FROM customers NATURAL JOIN payments 
GROUP BY customerNumber
HAVING SUM(amount) > 500000
ORDER BY number_of_transaction DESC;


-- Show name, contactName, phone number of a customer who hasnt ordered anything yet.
SELECT customerName, CONCAT(contactFirstName, ' ', contactLastName) AS contactName, phone
FROM customers LEFT JOIN orders ON customers.customerNumber = orders.customerNumber
WHERE orderNumber IS NULL; 


-- Show customerNumber and customerName who has ordered one of 3 products with the highest number of order
-- Highest number of ordered is in range 900-950
SELECT customerNumber, customerName
FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderDetails NATURAL INNER JOIN products
WHERE productCode IN (
    SELECT productCode 
    from products INNER JOIN orderDetails
    WHERE SUM(quantityOrdered) BETWEEN 900 AND 950
    GROUP BY productCode
    ORDER BY SUM(quantityOrdered) DESC
    LIMIT 3
);



