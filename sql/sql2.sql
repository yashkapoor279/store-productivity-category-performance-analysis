CREATE TABLE sales (
    Store INT,
    Dept INT,
    Date DATE,
    Weekly_Sales DECIMAL(12,2),
    IsHoliday BOOLEAN,

    PRIMARY KEY (Store, Dept, Date),

    FOREIGN KEY (Store)
        REFERENCES stores(Store)
);

DESCRIBE sales;