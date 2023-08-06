-- Show name of customer who has ever paid in 2004 with amount > 20000 and <50000
-- sorted by amount desc
SELECT customerName
FROM customers NATURAL INNER JOIN payments
WHERE YEAR(paymentDate) = 2004 AND amount > 20000 AND amount < 50000
ORDER BY amount DESC;


-- Create a view named 'inprocess_order' for order with status 'In Process'
-- This view also includes contact_name, phone number, orderDate,  ordered product, and status
-- sorted by the latest orderdate
CREATE VIEW 'inprocess_order' AS
SELECT CONCAT(contactFirstName, ' ', contactLastName) AS contactName, phone, orderDate, productName, status
FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderDetails NATURAL INNER JOIN products
WHERE status = 'In Process'
ORDER BY orderDate DESC;


-- Change the order status from 'In Process' to 'Shipped' from the order
-- made by the customer from France who has ever paid with amount > 45000 more than once
UPDATE orders
SET status = 'Shipped'
WHERE status = 'In Process' AND customerNumber IN (
    SELECT customerNumber
    FROM customers NATURAL INNER JOIN payments
    WHERE country = 'France' AND amount > 45000 
    GROUP BY customerNumber
    HAVING COUNT(checkNumber) > 1
);


-- Insert new entry for product table :
-- A.	productCode		: S135_182
-- B.	productName		: 2007 Honda Beat
-- C.	productLine		: Motorcycles
-- D.	productScale		: 1:18
-- E.	productVendor		: Warga Basdat Collectibles
-- F.	productDescription	: (isi dibebaskan)
-- G.	quantityInStock	: 25
-- H.	buyPrice		: 23.23
-- I.	MSRP			: 50.50
INSERT INTO product(productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP)
VALUES('S135_182', '2007 Honda Beat', 'Motorcycles', '1:18', 'Warga Basdat Collectibles', 'Great product!', 25, 23.23, 50.50);


-- Insert new column 'member' to customers table with datatype VARCHAR(10) and default value NULL
-- Fill the column with this term:
-- ●	Total amount spent > 500000, Platinum
-- ●	Total amount spent > 100000, Gold
-- ●	Total amount spent > 50000, Silver
-- ●	Others, Bronze
ALTER TABLE customers
ADD COLUMN member VARCHAR(10) DEFAULT NULL;
UPDATE customers AS c1, (SELECT c2.customerNumber, COALESCE(SUM(priceEach * quantityOrdered), 0) AS total
FROM customers c2 LEFT JOIN orders o ON c2.customerNumber = o.customerNumber LEFT JOIN orderDetails od ON o.orderNumber = od.orderNumber
GROUP BY c2.customerNumber) AS TEMPORARY
SET member =
CASE 
WHEN total > 500000 THEN 'Platinum'
WHEN total > 100000 THEN 'Gold'
WHEN total > 50000 THEN 'Silver'
ELSE 'Bronze'
END
WHERE  c1.customerNumber = temp.customerNumber;


-- Company decided to delete order data for order which was made by customer from the city of 'Auckland'
-- and was shipped before 2005
CREATE TEMPORARY TABLE badOrder AS(
    SELECT DISTINCT orderNumber
    FROM orders NATURAL INNER JOIN customers
    WHERE city = 'Auckland' AND YEAR(shippedDate) < 2005
);
DELETE FROM orderDetails 
WHERE orderNumber IN (
    SELECT orderNumber FROM badOrder
);
DELETE FROM orders 
WHERE orderNumber IN (
    SELECT orderNumber FROM badOrder
);


-- Create new table 'productsDiscontinue' that is similar to products table, but the new table's 
-- primary key : productDiscontinueCode that is foreign key that points to productCode at products table
CREATE TABLE productsDiscontinue(
    productDiscontinueCode VARCHAR(15),
    productName VARCHAR(70),
    productLines VARCHAR(50),
    productScale VARCHAR(10),
    productVendor VARCHAR(50),
    productDescription TEXT,
    quantityInStock SMALLINT,
    buyPrice DECIMAL(10, 2),
    MSRP DECIMAL(10, 2),
    PRIMARY KEY(productDiscontinueCode),
    CONSTRAINT 'fk_discontinue_product'
    FOREIGN KEY (productDiscontinueCode)
    REFERENCES products(productDiscontinueCode)
) COLLATE=latin1_swedish_ci;


-- Insert new column connectionString with type VARCHAR(255) at offices table
-- Not null, default value = ‘Host=localhost:5432; Database=office; Username=postgres; Password=root’
ALTER TABLE offices
ADD COLUMN connectionString VARCHAR(255) NOT NULL DEFAULT 'Host=localhost:5432; Database=office; Username=postgres; Password=root';







