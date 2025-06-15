/* otázka č. 4
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
*/

WITH 
wages AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(avg_wage)::numeric, 2) AS avg_wage
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE indicator_type = 5958
    AND payroll_unit = 200
    AND calculation_method = 200 
    GROUP BY payroll_year
), 
food_prices AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(avg_food_price)::numeric, 2) AS avg_food_price
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE measured_region IS NULL
    GROUP BY payroll_year
),

growths AS (
    SELECT 
        w_curr.year,
        ((w_curr.avg_wage - w_prev.avg_wage) / w_prev.avg_wage) * 100 AS wage_growth_percent,
        ((f_curr.avg_food_price - f_prev.avg_food_price) / f_prev.avg_food_price) * 100 AS food_growth_percent
    FROM wages w_curr
    JOIN wages w_prev ON w_curr.year = w_prev.year + 1
    JOIN food_prices f_curr ON w_curr.year = f_curr.year
    JOIN food_prices f_prev ON f_curr.year = f_prev.year + 1
) -- vypocet rastu mezd a potravin medzi curr a prev year


SELECT 
    year,
    ROUND(wage_growth_percent, 2) AS wage_growth_percent,
    ROUND(food_growth_percent, 2) AS food_growth_percent,
    ROUND(food_growth_percent - wage_growth_percent, 2) AS difference,
    CASE 
        WHEN (food_growth_percent - wage_growth_percent) > 10 THEN 'YES'
        ELSE 'NO'
    END AS is_significantly_higher
FROM growths
ORDER BY year;
