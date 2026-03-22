-- ============================================
-- DEMAND vs SUPPLY ANALYSIS
-- Objective: Identify mismatch between demand and procurement
-- ============================================

WITH sales_data AS (
    SELECT
        product_id,
        SUM(quantity_sold) AS total_sales
    FROM sales  
    GROUP BY product_id
),

purchase_data AS (
    SELECT
        product_id,
        SUM(quantity_purchased) AS total_purchase
    FROM purchases
    GROUP BY product_id
)

SELECT 
    sd.product_id,
    sd.total_sales,
    pd.total_purchase,
    ROUND(pd.total_purchase - sd.total_sales, 2) AS gap,
    
    CASE 
        WHEN sd.total_sales > pd.total_purchase THEN 'SHORTAGE_RISK'
        WHEN pd.total_purchase > sd.total_sales * 1.5 THEN 'OVER_STOCK'
        ELSE 'BALANCED'
    END AS status

FROM sales_data sd
JOIN purchase_data pd USING(product_id);