USE store_productivity;
SELECT COUNT(*) AS total_sales_records
FROM sales;

SELECT COUNT(*) AS imported_records
FROM sales;

USE store_productivity;

DELETE FROM sales;

SELECT COUNT(*) AS total_records
FROM sales;

SELECT COUNT(*) AS imported_records
FROM sales;

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

