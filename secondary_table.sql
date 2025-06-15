-- secondary table

CREATE TABLE t_sabina_novotna_project_sql_secondary_final AS
WITH 
wages AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(avg_wage)::numeric, 2) AS avg_wage
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE indicator_type = 5958
    AND calculation_method = 200
    AND payroll_unit = 200
    GROUP BY payroll_year
), 
food_prices AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(avg_food_price)::numeric, 2) AS avg_food_price
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE 
        measured_region IS NULL
    GROUP BY payroll_year
)
SELECT 
    e.country,
    e.year,
    e.gdp, 
    e.gini,
    e.population,
    
 CASE WHEN e.country = 'Czech Republic' THEN w.avg_wage ELSE NULL END AS avg_wage,
 CASE WHEN e.country = 'Czech Republic' THEN f.avg_food_price ELSE NULL END AS avg_food_price

FROM economies e 
LEFT JOIN wages w ON e.year = w.year
LEFT JOIN food_prices f ON e.year = f.YEAR
LEFT JOIN COUNTRIES C ON e.country = c.COUNTRY 
WHERE e.year BETWEEN 2006 AND 2018
AND c.CONTINENT = 'Europe'
ORDER BY e.COUNTRY, e.year;

