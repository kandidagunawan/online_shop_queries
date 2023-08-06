-- Show name of customer that has made payment in 2003 with amount > 50000 or amount < 10000
-- sorted by amount ascending
SELECT customerName
FROM customers NATURAL INNER JOIN payments
WHERE YEAR(paymentDate) = 2003 AND (amount > 50000 OR amount < 10000)
ORDER BY amount;

-- Create a view with name 'cancelled_order' for order with status order = 'Cancelled' 
-- that view includes contact_name, phone number, orderDate, and productName that has been ordered, status, and comments
-- sorted by latest orderDate
CREATE VIEW cancelled_order AS
SELECT CONCAT(contactFirstName, ' ', contactLastName) AS contact_name, phone, orderDate, productName, status, comments
FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderDetails NATURAL INNER JOIN products
WHERE status = 'Cancelled'
ORDER BY orderDate DESC;


-- Update jobTitle to 'Sales Manager' for employee with total payment amount of his customer from USA over than 500000
UPDATE employees
SET jobTitle = 'Sales Manager'
WHERE employeeNumber IN (
    SELECT employeeNumber
    FROM employees INNER JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber NATURAL INNER JOIN payments
    WHERE country = 'USA'
    GROUP BY employeeNumber
    HAVING SUM(amount) > 50000
);

-- Insert new entry for offices table
-- officeCode	: 8
-- city		: Bandung
-- phone		: +62 831 8243 4940
-- addressLine1	: Jl. Ganesha No. 10
-- addressLine2	: Labtek V
-- state		: NULL
-- country	: Indonesia
-- postalCode	: 40132
-- territory	: APAC
INSERT INTO offices(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory)
VALUES(8, 'Bandung', '+62 831 8243 4940', 'Jl. Ganesha No. 10', 'Labtek V', NULL, 'Indonesia', '40132', 'APAC');


-- The company wants to add new column 'email' to table customers. 
-- This column has datatype VARCHAR(255) and default NULL
-- Change all email value to this format : <contactFirstName><contactLastName>@gmail.com
-- EMAIL DOESN'T contain spaces and the email must in lowercase format
ALTER TABLE customers
ADD COLUMN email VARCHAR(255) DEFAULT NULL;
UPDATE customers
SET email = REPLACE(LOWER(CONCAT(contactFirstName, contactLastName, '@gmail.com')), ' ', '');


-- The company wants to fire employees from office at London and have never served cutomers from Liverpool
CREATE TEMPORARY TABLE employee_to_fire AS(
    SELECT DISTINCT employeeNumber
    FROM employees NATURAL INNER JOIN offices
    WHERE city = 'London'
    EXCEPT
    SELECT DISTINCT employeeNumber
    FROM customers INNER JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber 
    INNER JOIN offices ON offices.officeCode = employees.officeCode 
    WHERE offices.city = 'London' AND  customers.city = 'Liverpool'
);
UPDATE customers
SET salesRepEmployeeNumber = NULL
WHERE salesRepEmployeeNumber IN (
    SELECT employeeNumber 
    FROM employee_to_fire
);

DELETE FROM employees
WHERE employeeNumber IN(
    SELECT employeeNumber
    FROM employee_to_fire
);


-- Company wants to add 2 more tables
-- 1. Warehouse table
-- ●	warehouseCode : primary key with datatype integer
-- ●	warehouseName : max 50 chars and every warehouse should have this
-- ●	managerName: max 255 chars and every warehouse should have this
-- ●	addressLine : max 255 chars and every warehouse should have this
-- ●	city: every warehouse should have this
-- ●	country: every warehouse should have this
-- 2. Manufacture table
-- ●	productCode: foreign key that points to productCode at product table, NOT NULL
-- ●	warehouseCode: foreign key that points to warehouseCode at warehouse table, NOT NULL
CREATE TABLE warehouse(
    warehouseCode INT AUTO_INCREMENT,
    warehouseName VARCHAR(50) NOT NULL,
    managerName VARCHAR(255) NOT NULL,
    addressLine VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    PRIMARY KEY (warehouseCode)
);
CREATE TABLE manufacture(
    productCode VARCHAR(30) NOT NULL,
    warehouseCode INT NOT NULL,
    CONSTRAINT 'fk_product_code'
    FOREIGN KEY productCode 
    REFERENCES product(productCode),
    CONSTRAINT 'fk_warehouse_code'
    FOREIGN KEY warehouseCode
    REFERENCES warehouse(warehouseCode)
    PRIMARY KEY(productCode, warehouseCode)
) COLLATE=latin1_swedish_ci;


-- Change image column to imageUrl, change the datatype to VARCHAR(255)
ALTER TABLE productLines 
RENAME COLUMN image to imageUrl;
ALTER TABLE productLines
MODIFY COLUMN imageUrl VARCHAR(255);







