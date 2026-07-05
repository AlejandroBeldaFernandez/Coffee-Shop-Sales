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
FROM coffee_shop_sales css;

-- Total number of rows
SELECT COUNT(1) AS total_rows
FROM coffee_shop_sales css;


-- ============================================================
-- 2. RANGE AND UNIQUE VALUE CHECKS
-- Note: For high-cardinality columns (IDs, dates, prices)
--       we check min/max range instead of distinct values
-- ============================================================

-- Date range covered by the dataset
SELECT 
    MIN(css.transaction_date::DATE) AS first_date, 
    MAX(css.transaction_date::DATE) AS last_date
FROM coffee_shop_sales css;

-- Transaction ID range (to detect gaps or unexpected values)
SELECT 
    MIN(css.transaction_id) AS min_id, 
    MAX(css.transaction_id) AS max_id
FROM coffee_shop_sales css;

-- Time range (stored as text before cleaning)
SELECT 
    MIN(css.transaction_time::TIME) AS opening_time, 
    MAX(css.transaction_time::TIME) AS closing_time
FROM coffee_shop_sales css;

-- Unique values: quantity sold per transaction
SELECT DISTINCT css.transaction_qty AS qty
FROM coffee_shop_sales css;

-- Unique values: store IDs
SELECT DISTINCT css.store_id
FROM coffee_shop_sales css;

-- Unique values: store locations
SELECT DISTINCT css.store_location
FROM coffee_shop_sales css;

-- Unique values: product IDs
SELECT DISTINCT css.product_id
FROM coffee_shop_sales css;

-- Unique values: unit price (comma replaced with period before casting)
SELECT DISTINCT REPLACE(css.unit_price, ',', '.')::NUMERIC AS unit_price
FROM coffee_shop_sales css;

-- Unique values: product categories
SELECT DISTINCT css.product_category
FROM coffee_shop_sales css;

-- Unique values: product types
SELECT DISTINCT css.product_type
FROM coffee_shop_sales css;

-- Unique values: product details
SELECT DISTINCT css.product_detail
FROM coffee_shop_sales css;


-- ============================================================
-- 3. NULL VALUE CHECKS
-- Note: Columns imported as text may contain 'null' strings
--       or empty strings instead of true NULLs
-- ============================================================

SELECT * FROM coffee_shop_sales css 
WHERE css.transaction_id IS NULL;

SELECT * FROM coffee_shop_sales css 
WHERE css.transaction_date IS NULL 
   OR css.transaction_date = 'null' 
   OR css.transaction_date = '';

SELECT * FROM coffee_shop_sales css 
WHERE css.transaction_time IS NULL 
   OR css.transaction_time = 'null' 
   OR css.transaction_time = '';

SELECT * FROM coffee_shop_sales css 
WHERE css.transaction_qty IS NULL;

SELECT * FROM coffee_shop_sales css 
WHERE css.store_id IS NULL;

SELECT * FROM coffee_shop_sales css 
WHERE css.store_location IS NULL 
   OR css.store_location = 'null' 
   OR css.store_location = '';

SELECT * FROM coffee_shop_sales css 
WHERE css.product_id IS NULL;

SELECT * FROM coffee_shop_sales css 
WHERE css.unit_price IS NULL 
   OR css.unit_price = 'null' 
   OR css.unit_price = '';

SELECT * FROM coffee_shop_sales css 
WHERE css.product_category IS NULL 
   OR css.product_category = 'null' 
   OR css.product_category = '';

SELECT * FROM coffee_shop_sales css 
WHERE css.product_type IS NULL 
   OR css.product_type = 'null' 
   OR css.product_type = '';

SELECT * FROM coffee_shop_sales css 
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
FROM coffee_shop_sales css 
GROUP BY css.transaction_id
HAVING COUNT(css.transaction_id) > 1;

-- Dates: duplicates expected (multiple transactions per day)
SELECT css.transaction_date, COUNT(css.transaction_date) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.transaction_date
HAVING COUNT(css.transaction_date) > 1
ORDER BY 2 DESC;

-- Times: duplicates expected (multiple transactions at the same time)
SELECT css.transaction_time, COUNT(css.transaction_time) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.transaction_time
HAVING COUNT(css.transaction_time) > 1
ORDER BY 2 DESC;

-- Quantity: duplicates expected (low cardinality field)
SELECT css.transaction_qty, COUNT(css.transaction_qty) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.transaction_qty
HAVING COUNT(css.transaction_qty) > 1
ORDER BY 2 DESC;

-- Store ID: duplicates expected (only 3 stores)
SELECT css.store_id, COUNT(css.store_id) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.store_id
HAVING COUNT(css.store_id) > 1
ORDER BY 2 DESC;

-- Store location: duplicates expected (only 3 locations)
SELECT css.store_location, COUNT(css.store_location) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.store_location 
HAVING COUNT(css.store_location) > 1
ORDER BY 2 DESC;

-- Product ID: duplicates expected (same product sold multiple times)
SELECT css.product_id, COUNT(css.product_id) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.product_id 
HAVING COUNT(css.product_id) > 1
ORDER BY 2 DESC;

-- Unit price: duplicates expected (multiple products at the same price)
SELECT css.unit_price, COUNT(css.unit_price) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.unit_price 
HAVING COUNT(css.unit_price) > 1
ORDER BY 2 DESC;

-- Product category: duplicates expected (low cardinality field)
SELECT css.product_category, COUNT(css.product_category) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.product_category 
HAVING COUNT(css.product_category) > 1
ORDER BY 2 DESC;

-- Product type: duplicates expected (low cardinality field)
SELECT css.product_type, COUNT(css.product_type) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.product_type 
HAVING COUNT(css.product_type) > 1
ORDER BY 2 DESC;

-- Product detail: duplicates expected (low cardinality field)
SELECT css.product_detail, COUNT(css.product_detail) AS occurrences
FROM coffee_shop_sales css 
GROUP BY css.product_detail 
HAVING COUNT(css.product_detail) > 1
ORDER BY 2 DESC;


-- ============================================================
-- 5. DATA CLEANING
-- ============================================================

-- Step 1: Convert date and time columns from text to proper types
--         Add a new numeric column for unit_price (clean version)
ALTER TABLE coffee_shop_sales
    ALTER COLUMN transaction_date TYPE DATE USING transaction_date::DATE,
    ALTER COLUMN transaction_time TYPE TIME USING transaction_time::TIME,
    ADD COLUMN unit_price_clean NUMERIC;

-- Step 2: Populate the clean price column replacing comma with period
UPDATE coffee_shop_sales
SET unit_price_clean = REPLACE(unit_price, ',', '.')::NUMERIC;

-- Step 3: Drop the original text column
ALTER TABLE coffee_shop_sales 
DROP COLUMN unit_price;

-- Step 4: Rename the clean column to the original name
ALTER TABLE coffee_shop_sales
RENAME COLUMN unit_price_clean TO unit_price;

-- Final check: verify the cleaned table
SELECT *
FROM coffee_shop_sales;