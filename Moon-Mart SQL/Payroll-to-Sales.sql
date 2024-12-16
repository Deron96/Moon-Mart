-- Our Payroll Expenses are 25.62% of our Total Sales, falling nicely into the desired 15 - 30% range
WITH DepartmentSales AS (
			SELECT
				SUM(automotive_sales) AS a,
				SUM(lawn_and_garden_sales) AS b,
				SUM(electronics_sales) AS c,
				SUM(grocery_sales) AS d,
				SUM(household_essentials_sales) AS e,
				SUM(clothing_sales) AS f,
				SUM(appliances_sales) AS g,
				SUM(home_improvement_sales) AS h,
				SUM(pharmacy_sales) AS i
			FROM SalesTransactions2023
		),
		
		Connector1 AS (		
			SELECT 
				a + b + c + d + e + f + g + h + i AS total_sales,
				1 AS connector
			FROM DepartmentSales
		),

		Connector2 AS (
			SELECT 
				SUM(salary) AS total_payroll,
				1 AS connector
			FROM Employees
		)

		SELECT 
			ROUND((c2.total_payroll / c1.total_sales) * 100, 2) || '%'
		FROM Connector1 c1
		JOIN Connector2 c2
		ON c1.connector = c2.connector