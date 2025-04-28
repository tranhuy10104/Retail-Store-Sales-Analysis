/*
View Table
Description:
Display a sample of the retail_store_sales table to confirm its structure and data before analysis.
SQL Function Used:
- SELECT TOP: Limits the number of rows returned to a specified amount (e.g., 10).
*/
-- Retrieve the first 10 rows to confirm the table's structure and data
SELECT TOP 10 *
FROM dbo.retail_store_sales;

/*
Change Over Time Analysis
Description:
Analyze sales and quantity trends by year and month to identify patterns, including the best and worst years for sales.
SQL Function Used:
- YEAR: Extracts the year from a date column.
- MONTH: Extracts the month from a date column.
- SUM: Aggregates numeric values.
- GROUP BY: Groups rows by YEAR or MONTH.
- ORDER BY: Sorts results in ascending order.
*/
-- Calculate total quantity and sales for each year, ordered chronologically
CREATE VIEW YearlySalesTrends AS
SELECT
    YEAR(Transaction_Date) AS years,
    SUM(Quantity) AS total_quantity_by_year,
    SUM(Total_Spent) AS total_sales_by_year
FROM dbo.retail_store_sales
GROUP BY YEAR(Transaction_Date);
GO

-- Calculate total quantity and sales for each month, ordered by month
CREATE VIEW MonthlySalesTrends AS
SELECT
    MONTH(Transaction_Date) AS months,
    SUM(Quantity) AS total_quantity_by_month,
    SUM(Total_Spent) AS total_sales_by_month
FROM dbo.retail_store_sales
GROUP BY MONTH(Transaction_Date);
GO



/*
Cumulative Analysis
Description:
Calculate running totals and moving averages for quantity, sales, and average sales by month to track cumulative trends over time.
SQL Function Used:
- WITH (CTE): Defines a Common Table Expression for reusable subqueries.
- MONTH: Extracts the month from a date column.
- SUM: Aggregates numeric values (e.g., Total_Spent, Quantity).
- ROUND: Rounds a numeric value to a specified number of decimal places.
- AVG: Calculates the average of a numeric column.
- SUM OVER: Computes a running total over a specified order.
- GROUP BY: Groups rows by a specified column for aggregation.
- ORDER BY: Sorts results in ascending order.
*/

CREATE VIEW CumulativeSalesByMonth AS
-- Step 1: Create a CTE to calculate monthly totals for quantity, sales, and average sales
WITH running AS (
    SELECT
        MONTH(Transaction_Date) AS months,
        SUM(Quantity) AS total_quantity,
        SUM(Total_Spent) AS total_sales,
        ROUND(AVG(Total_Spent), 2) AS average_sales
    FROM dbo.retail_store_sales
    GROUP BY MONTH(Transaction_Date)
)
-- Step 2: Compute running totals for quantity, sales, and average sales over months
SELECT 
    months,
    total_quantity,
    SUM(total_quantity) OVER (ORDER BY months) AS running_total_quantity,
    total_sales,
    SUM(total_sales) OVER (ORDER BY months) AS running_total_sales,
    average_sales,
    SUM(average_sales) OVER (ORDER BY months) AS running_average_sales
FROM running;
GO


/*
Performance Analysis
Description:
Compare yearly sales to the average and previous year to assess performance, identifying years above or below average and growth trends.
SQL Function Used:
- WITH (CTE): Defines a Common Table Expression for reusable subqueries.
- YEAR: Extracts the year from a date column.
- SUM: Aggregates numeric values (e.g., Total_Spent).
- AVG OVER: Calculates the average across all rows in a window.
- LAG: Retrieves the previous row’s value in a specified order.
- CASE: Applies conditional logic to categorize results.
- GROUP BY: Groups rows by a specified column for aggregation.
- ORDER BY: Sorts results in ascending order.
*/
CREATE VIEW YearlySalesPerformance AS
-- Step 1: Create a CTE to calculate total sales for each year
WITH yearly_product_sales AS (
    SELECT
        YEAR(Transaction_Date) AS years,
        SUM(Total_Spent) AS total_sales
    FROM dbo.retail_store_sales
    GROUP BY YEAR(Transaction_Date)
)
-- Step 2: Compare yearly sales to the overall average and previous year, labeling performance
SELECT
    years,
    total_sales,
    AVG(total_sales) OVER () AS average_sales,
    total_sales - (AVG(total_sales) OVER ()) AS difference_from_average,
    CASE 
        WHEN total_sales - (AVG(total_sales) OVER ()) > 0 THEN 'Above average'
        WHEN total_sales - (AVG(total_sales) OVER ()) < 0 THEN 'Below average'
        ELSE 'Average'
    END AS average_compare_status,
    total_sales - LAG(total_sales, 1) OVER (ORDER BY years) AS difference_from_previous_year,
    CASE 
        WHEN total_sales - LAG(total_sales, 1) OVER (ORDER BY years) > 0 THEN 'Increase'
        WHEN total_sales - LAG(total_sales, 1) OVER (ORDER BY years) < 0 THEN 'Decrease'
        ELSE 'No change'
    END AS year_over_year_status
FROM yearly_product_sales;
GO



/*
Part to Whole Analysis
Description:
Calculate the proportion of total sales contributed by each category to understand category performance relative to overall sales.
SQL Function Used:
- WITH (CTE): Defines a Common Table Expression for reusable subqueries.
- SUM: Aggregates numeric values (e.g., Total_Spent).
- SUM OVER: Calculates the total across all rows in a window.
- CONCAT: Combines strings (e.g., percentage value with '%').
- ROUND: Rounds a numeric value to a specified number of decimal places.
- GROUP BY: Groups rows by a specified column for aggregation.
*/
CREATE VIEW CategorySalesProportion AS
-- Step 1: Create a CTE to calculate total sales for each category
WITH category_sales AS (
    SELECT
        Category,
        SUM(Total_Spent) AS total_sales
    FROM dbo.retail_store_sales
    GROUP BY Category
)
-- Step 2: Compute the percentage of total sales for each category
SELECT
    Category,
    total_sales,
    CONCAT(ROUND((total_sales / (SUM(total_sales) OVER ())) * 100, 2), '%') AS proportion
FROM category_sales;
GO



/*
Data Segmentation
Description:
Segment items by total sales into predefined ranges (e.g., Below 5000, 5000-10000, 10000-15000) and count items in each range to analyze sales distribution.
SQL Function Used:
- WITH (CTE): Defines a Common Table Expression for reusable subqueries.
- SUM: Aggregates numeric values (e.g., Total_Spent).
- CASE: Applies conditional logic to categorize items into sales ranges.
- COUNT: Counts the number of items in each range.
- GROUP BY: Groups rows by a specified column for aggregation.
- ORDER BY: Sorts results in ascending order.
*/
CREATE VIEW ItemSalesSegmentation AS
-- Step 1: Create a CTE to calculate total sales per item and assign sales ranges
WITH sales_segmentation AS (
    SELECT
        Item,
        SUM(Total_Spent) AS total_sales,
        CASE 
            WHEN SUM(Total_Spent) < 5000 THEN 'Below 5000'
            WHEN SUM(Total_Spent) BETWEEN 5000 AND 10000 THEN '5000-10000'
            ELSE '10000-15000'
        END AS sales_range
    FROM dbo.retail_store_sales
    GROUP BY Item
)
-- Step 2: Count the number of items in each sales range and sort by count
SELECT
    sales_range,
    COUNT(Item) AS count_item
FROM sales_segmentation
GROUP BY sales_range
GO
