/* otázka č. 5
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, 
pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
*/


WITH base_data AS (
    SELECT 
        curr.country,
        curr.year,
        ROUND((((curr.gdp::numeric - prev.gdp::numeric) / NULLIF(prev.gdp::numeric, 0)) * 100)::numeric, 2) AS gdp_pct,
        ROUND((((curr.avg_wage::numeric - prev.avg_wage::numeric) / NULLIF(prev.avg_wage::numeric, 0)) * 100)::numeric, 2) AS wage_pct,
        ROUND((((curr.avg_food_price::numeric - prev.avg_food_price::numeric) / NULLIF(prev.avg_food_price::numeric, 0)) * 100)::numeric, 2) AS food_pct
    FROM T_SABINA_NOVOTNA_PROJECT_SQL_SECONDARY_FINAL curr
    JOIN T_SABINA_NOVOTNA_PROJECT_SQL_SECONDARY_FINAL prev 
      ON curr.year = prev.year + 1
     AND curr.country = prev.country
)

SELECT 
    country,
    year,
    gdp_pct,
    CASE 
        WHEN gdp_pct > 0 THEN 'nárast'
        WHEN gdp_pct < 0 THEN 'pokles'
        ELSE 'žiadna zmena'
    END AS gdp_trend,
    
    wage_pct,
    CASE 
        WHEN wage_pct > 0 THEN 'nárast'
        WHEN wage_pct < 0 THEN 'pokles'
        ELSE 'žiadna zmena'
    END AS wage_trend,

    food_pct,
    CASE 
        WHEN food_pct > 0 THEN 'nárast'
        WHEN food_pct < 0 THEN 'pokles'
        ELSE 'žiadna zmena'
    END AS food_trend

FROM base_data 
WHERE country = 'Czech Republic'
	AND YEAR BETWEEN 2006 AND 2018
ORDER BY year;
