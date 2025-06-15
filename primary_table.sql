
CREATE TABLE t_sabina_novotna_project_SQL_primary_final AS
SELECT
	cpc.name AS food_category_name,
	cpr.value AS avg_food_price,
	cpc.price_value AS food_quantity,
	cpc.price_unit AS food_unit,
	date_part('year', cpr.date_from) AS period_for_avg_price,
	cpr.region_code AS measured_region,
	cpib.name AS industry_name,
	cpay.value AS avg_wage,
	cpay.payroll_year AS payroll_year,
	cpay.calculation_code AS calculation_method,
	cpay.unit_code AS payroll_unit,
	cpay.value_type_code AS indicator_type
FROM czechia_price cpr
LEFT JOIN czechia_payroll cpay
	ON cpay.payroll_year = date_part('year', cpr.date_from)
LEFT JOIN czechia_payroll_industry_branch cpib
	ON cpib.code = cpay.industry_branch_code
LEFT JOIN czechia_price_category cpc
	ON cpc.code = cpr.category_code;

