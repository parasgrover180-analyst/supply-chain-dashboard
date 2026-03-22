-- ============================================
-- SUPPLIER PERFORMANCE ANALYSIS
-- Objective: Evaluate supplier reliability and contribution
-- ============================================

WITH supply AS (
    SELECT
        sp.supplier_id,
        SUM(p.quantity_purchased) AS total_supply,
        sp.lead_time_days
    FROM purchases p
    JOIN suppliers sp USING(supplier_id)
    GROUP BY sp.supplier_id, sp.lead_time_days
),

avg_supply AS (
    SELECT 
        AVG(total_supply) AS avg_supply
    FROM supply
)

SELECT 
    sd.*,

    CASE 
        WHEN sd.lead_time_days > 7 THEN 'DELAY_RISK'
        WHEN sd.total_supply > a.avg_supply AND sd.lead_time_days <= 4 THEN 'GOOD_SUPPLIER'
        WHEN sd.total_supply < a.avg_supply THEN 'LOW_CONTRIBUTION'
        ELSE 'AVERAGE'
    END AS performance_flag

FROM supply sd
CROSS JOIN avg_supply a;