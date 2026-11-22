CREATE DATABASE store_productivity;

USE store_productivity;
SELECT DATABASE();

USE store_productivity;

CREATE TABLE stores (
    Store INT PRIMARY KEY,
    Type VARCHAR(10),
    Size INT
);

DESCRIBE stores;

SELECT COUNT(*) AS total_stores
FROM stores;

SELECT * FROM stores LIMIT 10;


