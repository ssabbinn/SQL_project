/*Otazka c.2
 *Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */


WITH 
wages AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(avg_wage)::numeric, 2) AS avg_wage
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE 
        indicator_type = 5958  			-- Priemerná hrubá mzda na zamestnanca
        AND calculation_method = 200 	-- Prepočítaná mzda
        AND payroll_unit = 200 			-- Priemerná mzda v korunách
        AND payroll_year IN (2006, 2018)
    GROUP BY payroll_year
),

prices AS (
    SELECT 
        payroll_year AS year,
        food_category_name,
        ROUND(AVG(avg_food_price)::numeric, 2) AS avg_price
    FROM t_sabina_novotna_project_sql_primary_final
    WHERE 
        measured_region IS NULL 		-- Celorepublikový priemer
        AND food_category_name IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
        AND payroll_year IN (2006, 2018)
    GROUP BY payroll_year, food_category_name
)

SELECT 
    w.year,
    w.avg_wage,
    MAX(CASE WHEN p.food_category_name = 'Mléko polotučné pasterované' THEN p.avg_price END) AS milk_price,
    MAX(CASE WHEN p.food_category_name = 'Chléb konzumní kmínový' THEN p.avg_price END) AS bread_price,
    ROUND(w.avg_wage / MAX(CASE WHEN p.food_category_name = 'Mléko polotučné pasterované' THEN p.avg_price END)) AS liters_of_milk,
    ROUND(w.avg_wage / MAX(CASE WHEN p.food_category_name = 'Chléb konzumní kmínový' THEN p.avg_price END)) AS kilos_of_bread
FROM wages w
JOIN prices p ON w.year = p.year
GROUP BY w.year, w.avg_wage
ORDER BY w.year;



