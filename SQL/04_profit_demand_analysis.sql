-- ============================================
-- PROFIT + DEMAND FUSION ANALYSIS
-- Objective: Identify high-performing and risky products
-- ============================================

WITH product_sales AS (
    SELECT
        p.product_id,
        SUM(s.quantity_sold) AS total_sales,
        SUM(s.revenue) AS revenue,
        SUM(s.quantity_sold * p.cost_price) AS total_cost
    FROM products p
    JOIN sales s USING(product_id)
    GROUP BY p.product_id
),

product_profit AS (
    SELECT
        *,
        ROUND(revenue - total_cost) AS profit
    FROM product_sales
),

avg_values AS (
    SELECT
        AVG(revenue) AS avg_revenue,
        AVG(profit) AS avg_profit
    FROM product_profit
)

SELECT 
    pp.*,

    CASE  
        WHEN pp.revenue > av.avg_revenue AND pp.profit > av.avg_profit THEN 'STAR_PRODUCT'
        WHEN pp.revenue > av.avg_revenue AND pp.profit < av.avg_profit THEN 'BAD_PRODUCT'
        WHEN pp.revenue < av.avg_revenue AND pp.profit > av.avg_profit THEN 'OPPORTUNITY'
        ELSE 'NORMAL'
    END AS category

FROM product_profit pp
CROSS JOIN avg_values av;