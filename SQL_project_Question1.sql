/*Otazka c.1
 *Rostou v prubehu let mzdy ve vsech odvetvich, nebo v nekterych klesaji?
 */


-- Výpočet priemernej mzdy podľa odvetvia a roka
WITH wages_per_year AS (
    SELECT 
        payroll_year,
        industry_name,
        ROUND(AVG(avg_wage)) AS average_wage
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE 
        calculation_method = 200          -- Prepočítaná mzda
        AND indicator_type = 5958         -- Priemerná hrubá mzda na zamestnanca
        AND payroll_unit = 200            -- Priemerná mzda v korunách
        AND industry_name IS NOT NULL
    GROUP BY 
        payroll_year, 
        industry_name
)

-- Porovnanie priemernej mzdy medzi dvoma po sebe idúcimi rokmi
SELECT 
    curr.industry_name,
    curr.payroll_year AS year,
    curr.average_wage AS current_year_wage,
    prev.average_wage AS previous_year_wage,
    curr.average_wage - prev.average_wage AS wage_difference,
    CASE 
        WHEN curr.average_wage > prev.average_wage THEN 'Rástla'
        WHEN curr.average_wage < prev.average_wage THEN 'Klesla'
        ELSE 'Nezmenila sa'
    END AS wage_trend
FROM 
    wages_per_year curr
JOIN 
    wages_per_year prev 
    ON curr.industry_name = prev.industry_name
   AND curr.payroll_year = prev.payroll_year + 1
ORDER BY 
    curr.industry_name, 
    curr.payroll_year;