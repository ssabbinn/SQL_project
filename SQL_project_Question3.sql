/*Otazka c.3
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
 */

WITH 
food_prices AS (
    SELECT 
        payroll_year,
        food_category_name,
        ROUND(AVG(avg_food_price)::numeric, 2) AS avg_price
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE 
        measured_region IS NULL 		-- Celorepublikový priemer
        AND food_category_name IS NOT NULL
    GROUP BY payroll_year, food_category_name
),

price_diffs AS (
    SELECT 
        curr.food_category_name,
        curr.payroll_year,
        curr.avg_price,
        prev.avg_price AS prev_price,
        ROUND(((curr.avg_price - prev.avg_price) / prev.avg_price) * 100, 2) AS percent_growth
    FROM food_prices curr
    JOIN food_prices prev 
        ON curr.food_category_name = prev.food_category_name
       AND curr.payroll_year = prev.payroll_year + 1
)

SELECT 
    food_category_name,
    ROUND(AVG(percent_growth), 2) AS avg_percent_growth
FROM price_diffs
GROUP BY food_category_name
ORDER BY avg_percent_growth ASC
LIMIT 1;
