-- ============================================================
-- COFFEE SHOP SALES - DATA CLEANING & EXPLORATION
-- Dataset: Maven Analytics - Coffee Shop Sales
-- Author: [Su nombre]
-- Date: 2025
-- Description: Initial exploration and cleaning of the dataset
--              prior to analysis
-- ============================================================


-- ============================================================
-- 1. INITIAL CHECK
-- ============================================================

-- Full table preview
SELECT * 
FROM  coffee_sales.coffee_shop_sales css;

-- Total number of rows
SELECT COUNT(1) AS total_rows
FROM  coffee_sales.coffee_shop_sales css;


-- ============================================================
-- 2. RANGE AND UNIQUE VALUE CHECKS
-- Note: For high-cardinality columns (IDs, dates, prices)
--       we check min/max range instead of distinct values
-- ============================================================

-- Date range covered by the dataset
SELECT 
    MIN(css.transaction_date::DATE) AS first_date, 
    MAX(css.transaction_date::DATE) AS last_date
FROM  coffee_sales.coffee_shop_sales css;

-- Transaction ID range (to detect gaps or unexpected values)
SELECT 
    MIN(css.transaction_id) AS min_id, 
    MAX(css.transaction_id) AS max_id
FROM  coffee_sales.coffee_shop_sales css;

-- Time range (stored as text before cleaning)
SELECT 
    MIN(css.transaction_time::TIME) AS opening_time, 
    MAX(css.transaction_time::TIME) AS closing_time
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: quantity sold per transaction
SELECT DISTINCT css.transaction_qty AS qty
from  coffee_sales.coffee_shop_sales css;

-- Unique values: store IDs
SELECT DISTINCT css.store_id
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: store locations
SELECT DISTINCT css.store_location
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: product IDs
SELECT DISTINCT css.product_id
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: unit price (comma replaced with period before casting)
SELECT DISTINCT REPLACE(css.unit_price, ',', '.')::NUMERIC AS unit_price
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: product categories
SELECT DISTINCT css.product_category
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: product types
SELECT DISTINCT css.product_type
FROM  coffee_sales.coffee_shop_sales css;

-- Unique values: product details
SELECT DISTINCT css.product_detail
FROM  coffee_sales.coffee_shop_sales css;


-- ============================================================
-- 3. NULL VALUE CHECKS
-- Note: Columns imported as text may contain 'null' strings
--       or empty strings instead of true NULLs
-- ============================================================

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.transaction_id IS NULL;

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.transaction_date IS NULL 
   OR css.transaction_date = 'null' 
   OR css.transaction_date = '';

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.transaction_time IS NULL 
   OR css.transaction_time = 'null' 
   OR css.transaction_time = '';

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.transaction_qty IS NULL;

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.store_id IS NULL;

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.store_location IS NULL 
   OR css.store_location = 'null' 
   OR css.store_location = '';

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.product_id IS NULL;

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.unit_price IS NULL 
   OR css.unit_price = 'null' 
   OR css.unit_price = '';

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.product_category IS NULL 
   OR css.product_category = 'null' 
   OR css.product_category = '';

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.product_type IS NULL 
   OR css.product_type = 'null' 
   OR css.product_type = '';

SELECT * FROM  coffee_sales.coffee_shop_sales css 
WHERE css.product_detail IS NULL 
   OR css.product_detail = 'null' 
   OR css.product_detail = '';


-- ============================================================
-- 4. DUPLICATE CHECKS
-- Note: Some columns are expected to have repeated values
--       (e.g. dates, locations, categories). Duplicates are
--       only a concern for transaction_id (primary key)
-- ============================================================

-- transaction_id should be unique per transaction
SELECT css.transaction_id, COUNT(transaction_id) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.transaction_id
HAVING COUNT(css.transaction_id) > 1;

-- Dates: duplicates expected (multiple transactions per day)
SELECT css.transaction_date, COUNT(css.transaction_date) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.transaction_date
HAVING COUNT(css.transaction_date) > 1
ORDER BY 2 DESC;

-- Times: duplicates expected (multiple transactions at the same time)
SELECT css.transaction_time, COUNT(css.transaction_time) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.transaction_time
HAVING COUNT(css.transaction_time) > 1
ORDER BY 2 DESC;

-- Quantity: duplicates expected (low cardinality field)
SELECT css.transaction_qty, COUNT(css.transaction_qty) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.transaction_qty
HAVING COUNT(css.transaction_qty) > 1
ORDER BY 2 DESC;

-- Store ID: duplicates expected (only 3 stores)
SELECT css.store_id, COUNT(css.store_id) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.store_id
HAVING COUNT(css.store_id) > 1
ORDER BY 2 DESC;

-- Store location: duplicates expected (only 3 locations)
SELECT css.store_location, COUNT(css.store_location) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.store_location 
HAVING COUNT(css.store_location) > 1
ORDER BY 2 DESC;

-- Product ID: duplicates expected (same product sold multiple times)
SELECT css.product_id, COUNT(css.product_id) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.product_id 
HAVING COUNT(css.product_id) > 1
ORDER BY 2 DESC;

-- Unit price: duplicates expected (multiple products at the same price)
SELECT css.unit_price, COUNT(css.unit_price) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.unit_price 
HAVING COUNT(css.unit_price) > 1
ORDER BY 2 DESC;

-- Product category: duplicates expected (low cardinality field)
SELECT css.product_category, COUNT(css.product_category) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.product_category 
HAVING COUNT(css.product_category) > 1
ORDER BY 2 DESC;

-- Product type: duplicates expected (low cardinality field)
SELECT css.product_type, COUNT(css.product_type) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.product_type 
HAVING COUNT(css.product_type) > 1
ORDER BY 2 DESC;

-- Product detail: duplicates expected (low cardinality field)
SELECT css.product_detail, COUNT(css.product_detail) AS occurrences
FROM  coffee_sales.coffee_shop_sales css 
GROUP BY css.product_detail 
HAVING COUNT(css.product_detail) > 1
ORDER BY 2 DESC;


-- ============================================================
-- 5. DATA CLEANING
-- ============================================================

-- Step 1: Convert date and time columns from text to proper types
--         Add a new numeric column for unit_price (clean version)
ALTER TABLE  coffee_sales.coffee_shop_sales
    ALTER COLUMN transaction_date TYPE DATE USING transaction_date::DATE,
    ALTER COLUMN transaction_time TYPE TIME USING transaction_time::TIME,
    ADD COLUMN unit_price_clean NUMERIC;

-- Step 2: Populate the clean price column replacing comma with period
UPDATE  coffee_sales.coffee_shop_sales
SET unit_price_clean = REPLACE(unit_price, ',', '.')::NUMERIC;

-- Step 3: Drop the original text column
ALTER TABLE  coffee_sales.coffee_shop_sales 
DROP COLUMN unit_price;

-- Step 4: Rename the clean column to the original name
ALTER TABLE  coffee_sales.coffee_shop_sales
RENAME COLUMN unit_price_clean TO unit_price;

-- Final check: verify the cleaned table
SELECT *
FROM  coffee_sales.coffee_shop_sales;


-- ============================================================
-- COFFEE SHOP SALES - BUSINESS QUESTIONS ANALYSIS
-- Dataset: Maven Analytics - Coffee Shop Sales
-- Author: [Your name]
-- Date: 2025
-- Description: SQL queries answering 12 business questions
--              covering revenue, transactions, products and
--              time-based patterns
-- ============================================================


-- ============================================================
-- Q1. What is the total revenue generated by each location?
-- ============================================================
SELECT 
    css.store_location, 
    SUM(css.transaction_qty * css.unit_price) AS revenue
FROM coffee_sales.coffee_shop_sales css  
GROUP BY css.store_location
ORDER BY 2 DESC;

-- Hell's Kitchen generates the highest revenue among the three locations


-- ============================================================
-- Q2. How many transactions were made per month?
-- ============================================================
SELECT 
    TRIM(TO_CHAR(css.transaction_date, 'Month')) AS month, 
    COUNT(css.transaction_id) AS n_transactions
FROM coffee_sales.coffee_shop_sales css  
GROUP BY 
    TRIM(TO_CHAR(css.transaction_date, 'Month')), 
    EXTRACT('MONTH' FROM css.transaction_date) 
ORDER BY EXTRACT('MONTH' FROM css.transaction_date);

-- May has the highest number of transactions and February the lowest
-- Note: the dataset only covers January through June


-- ============================================================
-- Q3. Which product is sold most often by number of units?
-- ============================================================
SELECT 
    css.product_type AS product, 
    SUM(css.transaction_qty) AS n_units
FROM coffee_sales.coffee_shop_sales css 
GROUP BY css.product_type  
ORDER BY 2 DESC
LIMIT 1;

-- Brewed Chai Tea is the best-selling product by units


-- ============================================================
-- Q4. Which are the top 5 product categories by revenue?
-- ============================================================
SELECT 
    css.product_category AS category, 
    SUM(css.transaction_qty * css.unit_price) AS revenue
FROM coffee_sales.coffee_shop_sales css 
GROUP BY css.product_category 
ORDER BY 2 DESC 
LIMIT 5;

-- Top 5 categories by revenue: Coffee, Tea, Bakery, Drinking Chocolate and Coffee Beans


-- ============================================================
-- Q5. What is the average ticket per transaction?
-- ============================================================
WITH ticket_per_transaction AS (
    SELECT 
        css.transaction_id, 
        SUM(css.transaction_qty * css.unit_price) AS ticket
    FROM coffee_sales.coffee_shop_sales css 
    GROUP BY css.transaction_id
)
SELECT ROUND(AVG(ticket), 2) AS avg_ticket
FROM ticket_per_transaction;

-- The average ticket per transaction is 4.69


-- ============================================================
-- Q6. What is the revenue by day of the week? Which is the most profitable?
-- ============================================================
SELECT 
    TRIM(TO_CHAR(css.transaction_date, 'Day')) AS day_of_week, 
    SUM(css.transaction_qty * css.unit_price) AS revenue
FROM coffee_sales.coffee_shop_sales css 
GROUP BY TRIM(TO_CHAR(css.transaction_date, 'Day'))
ORDER BY 2 DESC;

-- Monday generates the highest revenue


-- ============================================================
-- Q7. Which time of day has the most transactions? (Morning, Noon, Evening)
-- ============================================================
WITH transactions_by_time AS (
    SELECT 
        css.transaction_id,
        CASE 
            WHEN TO_CHAR(css.transaction_time, 'HH24')::INTEGER >= 6 
             AND TO_CHAR(css.transaction_time, 'HH24')::INTEGER < 12 THEN 'Morning'
            WHEN TO_CHAR(css.transaction_time, 'HH24')::INTEGER >= 12 
             AND TO_CHAR(css.transaction_time, 'HH24')::INTEGER < 17 THEN 'Noon'
            ELSE 'Evening'
        END AS part_of_day 
    FROM coffee_sales.coffee_shop_sales css
)
SELECT 
    part_of_day, 
    COUNT(transaction_id) AS n_transactions
FROM transactions_by_time
GROUP BY part_of_day
ORDER BY 
    CASE part_of_day 
        WHEN 'Morning' THEN 1 
        WHEN 'Noon' THEN 2 
        WHEN 'Evening' THEN 3 
    END;

-- Morning is by far the busiest time of day


-- ============================================================
-- Q8. Which products generate 80% of total revenue? (Pareto rule)
-- ============================================================
WITH total_revenue AS (
    SELECT SUM(css.transaction_qty * css.unit_price) AS total
    FROM coffee_sales.coffee_shop_sales css
),
revenue_by_product AS (
    SELECT 
        css.product_type AS product, 
        SUM(css.transaction_qty * css.unit_price) AS revenue
    FROM coffee_sales.coffee_shop_sales css 
    GROUP BY css.product_type  
    ORDER BY 2 DESC
),
revenue_percentage AS (
    SELECT 
        product, 
        revenue * 100 / total AS percentage
    FROM revenue_by_product, total_revenue
    ORDER BY 2 DESC
),
cumulative_revenue AS (
    SELECT 
        product,  
        SUM(percentage) OVER (
            ORDER BY percentage DESC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_percentage
    FROM revenue_percentage
)
SELECT 
    product, 
    ROUND(cumulative_percentage, 2) AS cumulative_percentage
FROM cumulative_revenue
WHERE cumulative_percentage <= 80 
   OR cumulative_percentage = (
       SELECT cumulative_percentage 
       FROM cumulative_revenue 
       WHERE cumulative_percentage > 80 
       LIMIT 1
   );

-- 10 product types account for 80% of total revenue:
-- Barista Espresso, Brewed Chai tea, Hot chocolate, Gourmet brewed coffee,
-- Brewed Black tea, Brewed herbal tea, Premium brewed coffee,
-- Organic brewed coffee, Scone and Drip coffee


-- ============================================================
-- Q9. How has monthly revenue evolved per location?
-- ============================================================
SELECT 
    css.store_location,
    TRIM(TO_CHAR(css.transaction_date, 'Month')) AS month, 
    SUM(css.transaction_qty * css.unit_price) AS revenue
FROM coffee_sales.coffee_shop_sales css  
GROUP BY 
    css.store_location,
    TRIM(TO_CHAR(css.transaction_date, 'Month')), 
    EXTRACT('MONTH' FROM css.transaction_date) 
ORDER BY 
    css.store_location, 
    EXTRACT('MONTH' FROM css.transaction_date);

-- All three locations show a clear upward trend
-- May and June are consistently the strongest months
-- January or February are consistently the weakest


-- ============================================================
-- Q10. Which is the best-selling product at each location?
-- ============================================================
WITH units_by_location AS (
    SELECT 
        css.store_location, 
        css.product_type, 
        SUM(css.transaction_qty) AS units
    FROM coffee_sales.coffee_shop_sales css  
    GROUP BY css.store_location, css.product_type
),
ranked_products AS (
    SELECT 
        store_location, 
        product_type, 
        units,
        RANK() OVER (PARTITION BY store_location ORDER BY units DESC) AS ranking
    FROM units_by_location
)
SELECT 
    store_location, 
    product_type, 
    units
FROM ranked_products
WHERE ranking = 1;

-- Astoria: Brewed Chai Tea | Hell's Kitchen: Barista Espresso | Lower Manhattan: Gourmet brewed coffee


-- ============================================================
-- Q11. Which is the least sold product by number of units?
-- ============================================================
SELECT 
    css.product_type AS product, 
    SUM(css.transaction_qty) AS n_units
FROM coffee_sales.coffee_shop_sales css 
GROUP BY css.product_type  
ORDER BY 2 ASC
LIMIT 1;

-- Green Beans is the least sold product by units


-- ============================================================
-- Q12. Which time of day has the most transactions per location?
-- ============================================================
WITH transactions_by_time AS (
    SELECT 
        css.transaction_id, 
        css.store_location,
        CASE 
            WHEN TO_CHAR(css.transaction_time, 'HH24')::INTEGER >= 6 
             AND TO_CHAR(css.transaction_time, 'HH24')::INTEGER < 12 THEN 'Morning'
            WHEN TO_CHAR(css.transaction_time, 'HH24')::INTEGER >= 12 
             AND TO_CHAR(css.transaction_time, 'HH24')::INTEGER < 17 THEN 'Noon'
            ELSE 'Evening'
        END AS part_of_day 
    FROM coffee_sales.coffee_shop_sales css
)
SELECT 
    store_location, 
    part_of_day, 
    COUNT(transaction_id) AS n_transactions
FROM transactions_by_time
GROUP BY store_location, part_of_day
ORDER BY 
    store_location,
    CASE part_of_day 
        WHEN 'Morning' THEN 1 
        WHEN 'Noon' THEN 2 
        WHEN 'Evening' THEN 3 
    END;

-- Morning is the busiest time of day across all three locations

