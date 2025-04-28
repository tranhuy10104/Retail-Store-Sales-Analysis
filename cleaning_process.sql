/*
View Table
Description:
Display a sample of the retail_store_sales table to understand its structure and data.
*/
SELECT TOP 10 *
FROM dbo.retail_store_sales;



/*
Checking Null Values 
Description:
Identify rows with NULL values in any column to assess data quality.
*/
SELECT *
FROM dbo.retail_store_sales
WHERE 
    Transaction_ID IS NULL OR
    Customer_ID IS NULL OR
    Category IS NULL OR
    Quantity IS NULL OR
    Item IS NULL OR
    Price_Per_Unit IS NULL OR
    Quantity IS NULL OR
    Total_Spent IS NULL OR
    Payment_Method IS NULL OR
    Location IS NULL OR
    Transaction_Date IS NULL OR
    Discount_Applied IS NULL;



/*
Handling Null Values - Missing Item Values
Description:
Delete rows where the Item column is NULL, as Item is a critical field.
SQL Function Used:
- DELETE: Removes rows.
- WHERE: Filters rows with NULL in the Item column.
*/
DELETE 
FROM dbo.retail_store_sales
WHERE Item IS NULL OR Discount_Applied IS NULL;



/*
Checking Duplicates - Overall
Description:
Identify duplicate rows based on all columns to ensure data unique.
SQL Function Used:
- WITH: Creates a Common Table Expression (CTE).
- ROW_NUMBER(): Assigns a unique number to each row within a partition.
- PARTITION BY: Groups rows by specified columns.
- ORDER BY: Sorts rows through Transaction_Date.
- WHERE: Filters row with row_numbers > 1(Duplicates).
*/
WITH duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Transaction_ID, Customer_ID, Category, Item, Price_Per_Unit, Quantity, Payment_Method, Location, Transaction_Date, Discount_Applied
                             ORDER BY Transaction_Date) AS row_numbers
    FROM dbo.retail_store_sales
)
SELECT *
FROM duplicates
WHERE row_numbers > 1;



/*
Checking Duplicates - Transaction ID Uniqueness
Description:
Ensure Transaction_ID is unique, as it should be a primary key.
SQL Function Used:
- WITH: Creates a Common Table Expression (CTE).
- ROW_NUMBER(): Assigns a unique number to each row within a partition.
- PARTITION BY: Groups rows by Transaction_ID.
- ORDER BY: Sorts rows by Transaction_Date.
- WHERE: Filters row with row_numbers > 1(Duplicates).
*/
WITH duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Transaction_ID
                             ORDER BY Transaction_Date) AS row_numbers
    FROM dbo.retail_store_sales
)
SELECT *
FROM duplicates
WHERE row_numbers > 1;



/*
Trimming White Space - Checking White Space
Description:
Identify columns with extra white spaces by comparing their lengths before and after trimming.
SQL Function Used:
- LEN(): Calculates the length of a string.
- TRIM(): Removes leading and trailing white spaces.
- WHERE: Filters rows where lengths difference.
*/
SELECT 
    Transaction_ID,
    Customer_ID,
    Category,
    LEN(Transaction_ID) AS len_Transaction_ID,
    LEN(TRIM(Transaction_ID)) AS len_trimmed_Transaction_ID,
    LEN(Customer_ID) AS len_Customer_ID,
    LEN(TRIM(Customer_ID)) AS len_trimmed_Customer_ID,
    LEN(Category) AS len_Category,
    LEN(TRIM(Category)) AS len_trimmed_Category
FROM dbo.retail_store_sales
WHERE 
    LEN(Transaction_ID) != LEN(TRIM(Transaction_ID)) OR
    LEN(Customer_ID) != LEN(TRIM(Customer_ID)) OR
    LEN(Category) != LEN(TRIM(Category));



/*
Check Data Types
Description:
Retrieve the data type of each column to understand the table's structure and standardizing if needed.
SQL Function Used:
- INFORMATION_SCHEMA.COLUMNS: System view containing column metadata.
*/
SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retail_store_sales' 
  AND TABLE_SCHEMA = 'dbo';



/*
Validating Data
Description:
Validate data against business rules:	
									 - Price_Per_Unit, Quantity, and Total_Spent must be greater than 0.
									 - Payment_Method must be valid.
									 - Discount_Applied must be between 0 and 1.
SQL Function Used:
- WHERE: Filters rows based on conditions.
*/
SELECT *
FROM dbo.retail_store_sales
WHERE Price_Per_Unit = 0 OR Quantity = 0 OR Total_Spent = 0
    OR Payment_Method NOT BETWEEN 'Cash' AND 'Digital Wallet'
    OR (Discount_Applied > 1 OR Discount_Applied < 0);
