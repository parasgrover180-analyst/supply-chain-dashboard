-- ============================================
-- INVENTORY ANALYSIS
-- Objective: Analyze stock levels and risk
-- ============================================

-- 1. Avg Daily Sales per Product
SELECT 
    product_id,
    ROUND(SUM(quantity_sold) / COUNT(DISTINCT date), 2) AS avg_daily_sales
FROM sales
GROUP BY product_id;


-- 2. Days of Inventory Remaining
WITH avg_sales AS (
    SELECT 
        i.product_id,
        i.current_stock,
        ROUND(SUM(s.quantity_sold) / COUNT(DISTINCT s.date), 2) AS avg_daily_sales
    FROM inventory i
    JOIN sales s USING(product_id)
    GROUP BY i.product_id, i.current_stock
)

SELECT 
    product_id,
    current_stock,
    avg_daily_sales,
    ROUND(current_stock / avg_daily_sales, 2) AS days_remaining
FROM avg_sales;


-- 3. Stock Risk Classification
WITH avg_sales AS (
    SELECT 
        i.product_id,
        i.current_stock,
        ROUND(SUM(s.quantity_sold) / COUNT(DISTINCT s.date), 2) AS avg_daily_sales
    FROM inventory i
    JOIN sales s USING(product_id)
    GROUP BY i.product_id, i.current_stock
)

SELECT 
    *,
    ROUND(current_stock / avg_daily_sales, 2) AS days_remaining,
    CASE 
        WHEN (current_stock / avg_daily_sales) < 3 THEN 'CRITICAL'
        WHEN (current_stock / avg_daily_sales) BETWEEN 3 AND 7 THEN 'MEDIUM'
        ELSE 'SAFE'
    END AS stock_risk
FROM avg_sales;


                   
				
                
                
