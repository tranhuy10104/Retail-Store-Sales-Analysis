/*
Build Customer Report
Description:
Aggregate customer data to summarize purchasing behavior (e.g., total orders, spending) and segment customers into VIP, Regular, or New based on lifespan and spending.
SQL Function Used:
- WITH (CTE): Defines a Common Table Expression for reusable subqueries.
- COUNT: Counts rows or distinct values (e.g., transactions, items).
- COUNT(DISTINCT): Counts unique values (e.g., items bought).
- SUM: Aggregates numeric values (e.g., Total_Spent, Quantity).
- MIN: Identifies the earliest date (e.g., first order).
- MAX: Identifies the latest date (e.g., last order).
- DATEDIFF: Calculates the time difference between dates (e.g., lifespan in months).
- CASE: Applies conditional logic to segment customers.
- GROUP BY: Groups rows by a specified column for aggregation.
*/
-- Step 1: Create a base CTE to select relevant customer data
CREATE VIEW customer_report AS
WITH base_query AS (
    SELECT
        Customer_ID,
        Item,
        Quantity,
        Total_Spent,
        Transaction_Date,
        Transaction_ID
    FROM dbo.retail_store_sales
),
-- Step 2: Aggregate customer data to calculate orders, items, spending, and lifespan
agg_query AS (
    SELECT 
        Customer_ID,
        COUNT(Transaction_ID) AS total_order,
        COUNT(DISTINCT Item) AS total_item_bought,
        SUM(Quantity) AS total_quantity,
        SUM(Total_Spent) AS total_spent,
        DATEDIFF(MONTH, MIN(Transaction_Date), GETDATE()) AS life_span_by_month
    FROM base_query
    GROUP BY Customer_ID
	
)
-- Step 3: Segment customers into VIP, Regular, or New based on lifespan and spending
SELECT
    *,
    CASE 
        WHEN life_span_by_month >= 12 AND total_spent > 40000 THEN 'VIP'
        WHEN life_span_by_month >= 12 AND total_spent <= 40000 THEN 'REGULAR'
        ELSE 'NEW'
    END AS customer_segment
FROM agg_query