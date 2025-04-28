/*
View Table
Description:
Display a sample of the retail_store_sales table to understand its structure and data.
*/
SELECT TOP 10 *
FROM dbo.retail_store_sales;



/*
Dimension Exploration
Description:
Count distinct values for CUSTOMER_ID, CATEGORY, ITEM, PAYMENT_METHOD, and LOCATION to understand data variety.
SQL Function Used:
- COUNT(DISTINCT): Counts unique values.
*/
-- Customer, Item, Category
SELECT 
    COUNT(DISTINCT CUSTOMER_ID) AS total_customer,
    COUNT(DISTINCT Category) AS total_category,
    COUNT(DISTINCT Item) AS total_item
FROM dbo.retail_store_sales;

-- Payment
SELECT DISTINCT Payment_Method AS payment_method
FROM dbo.retail_store_sales;

-- Location
SELECT DISTINCT Location AS location
FROM dbo.retail_store_sales;



/*
Measure Exploration
Description:
Calculate total sales, transactions, items sold, and average sales to understand key metrics.
SQL Function Used:
- SUM: Calculates total sales.
- COUNT: Counts transactions and items.
- AVG: Calculates average sales.
*/
-- Total sales, transaction, item sold, average sales
SELECT 
    SUM(total_spent) AS total_sales,
    COUNT(Transaction_ID) AS total_transaction,
    COUNT(item) AS total_item_sold,
    AVG(total_spent) AS average_sales
FROM dbo.retail_store_sales;



/*
Date Exploration
Description:
Define the time scope by finding the first and last transaction dates.
SQL Function Used:
- MIN: Finds the earliest date.
- MAX: Finds the latest date.
*/
-- Define scope
SELECT 
    MIN(Transaction_Date) AS first_order,
    MAX(Transaction_Date) AS lastest_order
FROM dbo.retail_store_sales;



/*
Magnitude
Description:
Calculate aggregated metrics to understand the scale of sales across customers, locations, payment methods, items, and categories.
SQL Function Used:
- COUNT(DISTINCT): Counts unique transactions.
- SUM: Aggregates total spent and quantity.
- AVG: Calculates average price.
*/
-- Total item per category
SELECT
    Category,
    COUNT(DISTINCT Item) AS total_item
FROM dbo.retail_store_sales
GROUP BY Category;

-- Total order, spent by customer
SELECT 
    Customer_ID,
    COUNT(DISTINCT Transaction_ID) AS total_orders,
    SUM(total_spent) AS total_spent
FROM dbo.retail_store_sales
GROUP BY Customer_ID
ORDER BY total_spent DESC, total_orders DESC;

-- Total spent by location
SELECT 
    Location,
    SUM(total_spent) AS total_spent_by_location
FROM dbo.retail_store_sales
GROUP BY Location
ORDER BY total_spent_by_location DESC;

-- Total spent by payment method
SELECT 
    Payment_Method,
    SUM(total_spent) AS total_spent_by_payment_method
FROM dbo.retail_store_sales
GROUP BY Payment_Method
ORDER BY total_spent_by_payment_method DESC;

-- Average sales price by item
SELECT
    Item,
    AVG(total_spent) AS average_price
FROM dbo.retail_store_sales
GROUP BY Item
ORDER BY average_price DESC;

-- Total item sales
SELECT
    Item,
    SUM(Quantity) AS total_quantity 
FROM dbo.retail_store_sales
GROUP BY Item
ORDER BY total_quantity DESC;

-- Total category sales
SELECT
    Category,
    SUM(total_spent) AS total_spent 
FROM dbo.retail_store_sales
GROUP BY Category
ORDER BY total_spent DESC;

-- Category performance over time
SELECT
    YEAR(Transaction_Date) AS order_year,
    MONTH(Transaction_Date) AS order_month,
    Category,
    SUM(total_spent) AS total_spent 
FROM dbo.retail_store_sales
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date), Category
ORDER BY YEAR(Transaction_Date), MONTH(Transaction_Date);



/*
Ranking
Description:
Rank top customers, categories, and items based on total spent, number of transactions, and quantity.
SQL Function Used:
- SELECT TOP: Limits results to top N.
- SUM: Aggregates total spent and quantity.
- COUNT: Counts transactions.
*/
-- Top 10 customer by total spent
SELECT TOP 10
    Customer_ID,
    SUM(total_spent) AS total_spent 
FROM dbo.retail_store_sales
GROUP BY Customer_ID
ORDER BY total_spent DESC;

-- Top category by number of transactions
SELECT TOP 10
    Category,
    COUNT(Transaction_ID) AS number_transactions
FROM dbo.retail_store_sales
GROUP BY Category
ORDER BY number_transactions DESC;

-- Top item by number of transactions
SELECT TOP 10
    Item,
    COUNT(Transaction_ID) AS number_transactions
FROM dbo.retail_store_sales
GROUP BY Item
ORDER BY number_transactions DESC;