# Retail-Store-Sales-Analysis

## Project Overview:
**Dataset:** project utilizes the Retail Store Sales dataset, sourced from  for cleaning, analyzing and visualizing.
The project focuses on cleaning, performing EDA and analysis to analyze the category performance over time, sales trends, and segment customers using RFM analysis. 

**Techniques:** Data cleaning, EDA, data analysis and data visualization.

**Tools:** 
- SQL Server: For data cleaning, data analysis and create data report.
- Power BI: Visualizing data and analysis

## Dataset
- **Table Name:** dbo.retail_store_sales
- **Columns:**
  - `Transaction_ID` (nvarchar): A unique identifier for each transaction.
  - `Customer_ID` (nvarchar): A unique customer identifier for each customer.
  - `Category` (nvarchar): Category of the purchased item.
  - `Item` (nvarchar): Purchase name.
  - `Price_Per_Unit` (float): Price per unit of the item.
  - `Quantity` (tinyint): Number of items sold.
  - `Total_Spent` (float): Total amount spent in the transaction.
  - `Payment_Method` (nvarchar): Method of payment 
  - `Location` (varchar): Location where the transaction occurred.
  - `Transaction_Date` (date): Date of the transaction.
  - `Discount_Applied` (bit): Indicate whether a discount was applied (0 to 1).

## DATA CLEANING
### Purpose
The goal of this data cleaning process is to:
- Handle missing (NULL) values.
- Remove duplicates.
- Trim white spaces from string columns.
- Check data types
- Validate data against business rules to ensure quality.

The cleaning process is performed using SQL, consists of the following steps:

1. **View table:**
   - Display a sample of the dataset to understand its structure.
2. **Handle NULL values**
   - Check for NULL values in all columns.
   - Handle NULL values by deleting rows where ```Item``` or ```Discount_Applied``` are NULL, as these columns are critical. For ```Price_Per_Unit``` and ```Quantity```, if one is NULL, infer its value from ```Total_Spent``` if possible, but prioritize removing rows with NULLs in ```Item``` or ```Discount_Applied```.
3. **Check and remove duplicates:**
   - Identify duplicates based on all columns and ensure ```Transaction_ID``` is unique.
   - Use ROW_NUMBER() to find duplicates.
4. **Trim white spaces:** 
   - Check for extra white spaces in columns.
   - Trim white spaces using TRIM().
5. **Check data types:**
   - Retrieve data type of each columns, standardizing if needed.
   - Use DATA_TYPE to retrieve data type from table.
6. **Validate data:**
   - Base on business rules, ensure ```Price_Per_Unit```, ```Quantity``` and ```Total_Spent``` are greater than 0.
   - Validate ```Payment_Method``` either Cash, Credit Card, Digital Wallet.
   - Ensure ```Discount_Applied``` is between 0 and 1.

### Files
- `cleaning_process.sql`: Contains SQL scripts for all cleaning steps, with comments explaining.

## EXPLORATORY DATA ANALYSIS
### Purpose
The goal of EDA is to thoroughly explore the dataset, understand its structure, focuses on evaluating category performance over time and identifying sales trends. By examining the data from multiple angles like dimensions, measures, time-based trends, and rankings. This step provides a comprehensive understanding of the retail sales data and sets the stage for deeper analyses.

### Steps
The EDA process is performed using SQL and consists of the following steps:

1. **View table:**
   - Display a sample of the dataset to understand its structure.
2. **Dimension exploration:**
   - Count distinct values for ```Customer_ID```, ```Category```, ```Item```, ```Payment_Method```, and ```Location``` to understand the variety and diversity of the data. 
   - This step reveals the number of unique customers in the dataset, the range of product categories and individual items sold, the different payment methods used by customers, and the geographical spread of store locations.
3. **Measure exploration:**
   - Calculate key metrics to get a high-level overview of the dataset’s scale and performance, including total sales ```Total_Spent```, total number of transactions ```Transaction_ID```, total items sold ```Quantity```, and average sales per transaction ```Total_Spent```. These metrics provide a baseline understanding of the business’s overall performance.
4. **Date exploration:** 
   - Define the time scope.
5. **Magnitude:**
   - Calculate aggregated metrics to understand the scale of sales and purchasing behavior across various dimensions, such as customers, locations, payment methods, items, and categories. This step includes analyzing total orders and spending by customer, total spending by location and payment method, and category performance over time to track sales trends.
6. **Ranking:**
   - Rank entities to identify top performers across different dimensions, providing insights.
   - Top 10 customers by total spent, to highlight the most valuable customers in terms of revenue contribution.
   - Top categories by number of transactions, to determine which categories are the most popular in terms of transaction frequency, providing insight into customer demand and preferences.
   - Top items by number of transactions, to identify the most frequently purchased items, which can help optimize inventory management.

### Files
- `EDA_process.sql`: Contains SQL scripts for all EDA steps, with comments explaining.

## DATA ANALYSIS 
### Purpose
The goal of this phase is to perform deeper analyses to derive actionable insights, focusing on evaluating category performance over time, identifying sales trends, and segmenting customers and products. This phase builds on the findings from EDA by applying more advanced techniques, such as time-series analysis, performance comparisons, and segmentation, to uncover patterns and provide business recommendations.

### Steps
The Advanced Analytics process is performed using SQL and consists of the following steps:

1. **View table:**
   - Display a sample of the dataset to understand its structure.
2. **Change over time analysis:**
   - Analyze sales (```Total_Spent```) and quantity (```Quantity```) trends by year and month to identify patterns, such as the best and worst years for sales and seasonal fluctuations. 
   - This step helps track sales trends over time, supporting the project goal of understanding category performance and identifying growth opportunities.
3. **Cumulative analysis:**
   - Calculate running totals and moving averages for quantity, sales, and average sales by month to track cumulative trends
   - Running totals show the cumulative growth of sales over time, while moving averages smooth out short-term fluctuations to highlight long-term trends, aiding in trend identification.  
4. **Performance analysis:** 
   - Compare yearly sales to the overall average and the previous year, labeling years as above or below average and identifying growth or decline trends.
   - This step assesses yearly performance, helping to understand which years performed well and supporting budgeting or forecasting decisions.
5. **Part to whole analysis:**
   - Calculate the proportion of total sales contributed by each category to evaluate their relative performance.
   - This analysis highlights which categories drive the most revenue, guiding marketing strategies and inventory allocation.
6. **Data segmentation:**
   - Segment items by total sales into predefined ranges (e.g., Below 5000, 5000-10000, 10000-15000) and count items in each range to analyze sales distribution
   - This step provides insights into the distribution of item sales, helping to identify high- and low-performing products.

### Customer and Product reporting
The following steps focus on generating reports to summarize customer and product insights: 

1. **Build Customer Report:**
   - Aggregate customer data to summarize purchasing behavior (e.g., total orders, spending, lifespan) and segment customers into VIP, Regular, or New categories based on lifespan and spending. 
   - This step provides insights into the distribution of item sales, helping to identify high- and low-performing products.
2. **Build Product Report**
   - Aggregate product data by category and item to summarize sales performance and segment products into High, Mid, or Low based on total sales.

### Files
- `product_report.sql`: Contains product report key metric.
- `customer_report.sql`: Contains customer report key metric.

## Retail Analytics Reports
### Overview
This step contains two Power BI reports for retail analytics: Customer report and Product report.

### Purpose
The goal of this phase is perform reports to get insight about customer and product, create actionable insights into purchasing volume patterns, product sales trends, improve inventory management and enhance overall business performance.

### Reports
1. **Customer report:**
   - **Visuals:**
     - **Dashboard button:**
       - Total customer card: displays the total number of customers.
       - Total order card: displays the total order.
       - Total spent card: displays the total spent from customers.
       - Date slicer: perform filtering by date range
       - Customer purchase trend (line chart): show trends in customer spending over time.
       - Rank and segment customer spent (stake bar chart): ranks customers by spending and segment customer type (VIP, REGULAR).
     - **Detail button:** 
       - Show a detail table with those field: ```customer_id```, life span by month, total order, total item bought, total quantity bought, total spent and rank. 
   - **Customer report insights:** 
     - Total customer (25 customer), Total order (7579 orders), and Total spent ($988.51k).
     - Relative between customer and order: 7579 orders / 25 customer ≈ 303 order per customer.
     - The average orders (AOV) is $130 show that customer are purchasing high-value per orders.
     - Customer purchase trends: Seasonal patterns high at January peak (111k) this is highest spending month possibly due to holiday, New Year promotions, spending dip in February (75k), August (75k) and October (76k), spending rise in June (79k) to July (86k) increase in summer season, at the end of the year from October (76k) to December (86k) show gradual increase.
     - Customer purchase trends: Overall trend shows fluctuations but unclear upward or downward. Spending high at the start of the year, drop significantly down in February and fluctuates between 75k and 86k for the rest of the year.
     - Customer spending ranking: Top spender is VIP customers are key revenue drivers. REGULAR spender dominate the lower half of ranking.
   - **Actionable:**
     - Since January is the highest spending months start plan major promotions and product launch.
     - For low spending months target on promotions (special offer for each type of customer).
     - Since VIP customer driven revenue so prioritize with special offer, discount or loyalty prize.
     - With REGULAR customer also launch discount for each time, introduce VIP program benefits such as a 10% discount for VIP member.

2. **Product report:**
   - **Visuals:**
     - **Dashboard button:**
       - Total quantity card: displays the total quantity of items sold.
       - Total revenue card: displays the total revenue from sales.
       - Category slicer: allows filtering by product category.
       - Date slicer: perform filtering by date range.
       - Proportion sales by category (pie chart): show proportion of sales by category.
       - Quantity sold over time (staked bar chart): display quantity sold trends over time.
     - **Detail button:** 
       - Show a detail table with those field ```category```, ```item```, ```total_quantity```, ```total_sales```, ```transaction_date```.
   - **Product report insights:**
     - Total quantity sold (42k), total revenue ($988.51k).
     - Product sales trends: seasonal pattern with highest quantity sold in January (4.68k units), driven by holidays and New Year sales. Dip in February (3.22k) and recover from March to June (3.36k to 3.48k) and slightly decline afterward until December with increase to 3.64k.
     - Proportion sales by category: top 3 categories by sales butchers (13.77%), computer and electrics (12.81%) and beverage (12.6%) is the top key revenue, other categories like electric household, milk,… all range closely between 11.79% to 12.58%. Categories are fairly balanced, revenue source are well-diversified.
   - **Actionable:** 
     - Prioritize inventory, marketing, ads on top 3 categories to maximize revenue.
     - Offer special prize cross-sell with categories.

### Files
- `dashboard.pbix`: Contains customer and product reports.
