/*
Build Product Report
Description:
Aggregate product data by category and item to summarize sales performance and segment products into High, Mid, or Low based on total sales.
SQL Function Used:
- WITH (CTE): Defines a Common Table Expression for reusable subqueries.
- COUNT: Counts rows (e.g., transactions).
- SUM: Aggregates numeric values (e.g., Total_Spent, Quantity).
- CASE: Applies conditional logic to segment products.
- GROUP BY: Groups rows by a specified column for aggregation.
*/
-- Step 1: Create a base CTE to select relevant product data
CREATE VIEW product_report AS
WITH base_query AS (
    SELECT
        Category,
        Item,
        Quantity,
        Total_Spent,
        Transaction_ID
    FROM dbo.retail_store_sales
),
-- Step 2: Aggregate product data to calculate orders, quantities sold, and sales by category and item
agg_query AS (
    SELECT
        Category,
        Item,
        COUNT(Transaction_ID) AS total_orders,
        SUM(Quantity) AS total_quantity_solds,
        SUM(Total_Spent) AS total_sales
    FROM base_query
    GROUP BY  Category, Item
)
-- Step 3: Segment products into High, Mid, or Low based on total sales
SELECT
    *,
    CASE 
        WHEN total_sales > 10000 THEN 'High'
        WHEN total_sales >= 5000 THEN 'Mid'
        ELSE 'Low'
    END AS product_segment
FROM agg_query;