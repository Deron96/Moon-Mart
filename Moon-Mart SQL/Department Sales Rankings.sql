Department Sales Rankings:

-- The Grocery Department is ranked 1 in sales, making up 32.2% of total sales
-- The Home Improvement Deaparment is ranked last in sales, only making up 4.1% of total sales
WITH DepartmentTotals AS (
	SELECT
		SUM(automotive_sales) total_auto,
		SUM(lawn_and_garden_sales) total_lawn,
		SUM(electronics_sales) total_elec,
		SUM(grocery_sales) total_groc,
		SUM(household_essentials_sales) total_house,
		SUM(clothing_sales) total_cloth,
		SUM(appliances_sales) total_appl,
		SUM(home_improvement_sales) total_home,
		SUM(pharmacy_sales) total_pharm
	FROM SalesTransactions2023
),

TotalsPivot AS (
	SELECT
		'Automotive' AS department,
		total_auto AS total_sales
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Lawn & Garden',
		total_lawn
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Electronics',
		total_elec
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Grocery',
		total_groc
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Household Essentials',
		total_house
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Clothing',
		total_cloth
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Appliances',
		total_appl
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Home Improvement',
		total_home
	FROM DepartmentTotals
	UNION ALL
	SELECT
		'Pharmacy',
		total_pharm
	FROM DepartmentTotals
),

AllDeptsTotal AS (
	SELECT SUM(total_sales) AS grand_total
	FROM TotalsPivot
)

SELECT
	*,
	RANK() OVER(ORDER BY total_sales DESC) AS sales_rank,
	ROUND((total_sales / (SELECT grand_total FROM AllDeptsTotal)) * 100, 1) ||
		'%' AS percent_of_sales
FROM TotalsPivot;


Average Transaction Size:

-- The average Automotive transaction totals $65.40, ranked 4th
-- The average Lawn & Garden transaction totals $50.17, ranked 5th
-- The average Electronics transaction totals $164.68, ranked 2nd
-- The average Grocery transaction totals $101.23, ranked 3rd
-- The average Household Essentials transaction totals $25.96, ranked 9th
-- The average Clothing transaction totals $48.94, ranked 6th
-- The average Appliances transaction totals $272.18, ranked 1st
-- The average Home Improvement transaction totals $27.48 ranked 2nd
-- The average Pharmacy transaction totals $41.58, ranked 7th
WITH TransactionSize AS (
	SELECT
		ROUND(AVG(automotive_sales), 2) average_auto,
		ROUND(AVG(lawn_and_garden_sales), 2) average_lawn,
		ROUND(AVG(electronics_sales), 2) average_elec,
		ROUND(AVG(grocery_sales), 2) average_groc,
		ROUND(AVG(household_essentials_sales), 2) average_house,
		ROUND(AVG(clothing_sales), 2) average_cloth,
		ROUND(AVG(appliances_sales), 2) average_appl,
		ROUND(AVG(home_improvement_sales), 2) average_home,
		ROUND(AVG(pharmacy_sales), 2) average_pharm
	FROM SalesTransactions2023
),

TSizePivot AS (
	SELECT
		'Automotive' AS department,
		average_auto AS average_transaction_size
	FROM TransactionSize
	UNION ALL
	SELECT
		'Lawn & Garden',
		average_lawn
	FROM TransactionSize
	UNION ALL
	SELECT
		'Electronics',
		average_elec
	FROM TransactionSize
	UNION ALL
	SELECT
		'Grocery',
		average_groc
	FROM TransactionSize
	UNION ALL
	SELECT
		'Household Essentials',
		average_house
	FROM TransactionSize
	UNION ALL
	SELECT
		'Clothing',
		average_cloth
	FROM TransactionSize
	UNION ALL
	SELECT
		'Appliances',
		average_appl
	FROM TransactionSize
	UNION ALL
	SELECT
		'Home Improvement',
		average_home
	FROM TransactionSize
	UNION ALL
	SELECT
		'Pharmacy',
		average_pharm
	FROM TransactionSize
)

SELECT
	*,
	RANK() OVER(ORDER BY average_transaction_size DESC) AS t_size_rank
FROM TSizePivot;

Busiest Seasons:

-- Automotive sales are much higher in the months May through August
WITH AutoMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
	SUM(amount),
		4
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
	'August',
		SUM(amount),
		8
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM AutomotiveDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM AutoMonthlyPivot
ORDER BY id;

-- Lawn & Garden sales are much higher in the months April through September
WITH LawnMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM LawnAndGardenDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM LawnMonthlyPivot
ORDER BY id;

-- Electronics sales are higher in November, and they skyrocket in December
WITH ElecMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM ElectronicsDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
	FROM ElecMonthlyPivot
	ORDER BY id;

-- Grocery sales are slightly higher in November and December, pretty steady all year
WITH GrocMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM GroceryDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM GrocMonthlyPivot
ORDER BY id;

-- Household Essentials sales levels are steady throughout the year
WITH HouseMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM HouseholdEssentialsDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM HouseMonthlyPivot
ORDER BY id;

-- Clothing sales peak May and June
WITH ClothMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM ClothingDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM ClothMonthlyPivot
ORDER BY id;

-- Appliances sales are slightly higher in November (on account of Black Friday), and they peak in December
WITH ApplMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM AppliancesDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM ApplMonthlyPivot
ORDER BY id;

-- Home Improvement sales are very low during January, February, March, and December, and level the rest of the year
WITH HomeMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM HomeImprovementDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM HomeMonthlyPivot
ORDER BY id;

-- Pharmacy sales are steady year-round
WITH PharmMonthlyPivot AS (
	SELECT
		'January' AS month,
		SUM(amount) AS total,
		1 AS id
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-01-01' AND '2023-01-31'
	UNION ALL
	SELECT
		'February',
		SUM(amount),
		2
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-02-01' AND '2023-02-28'
	UNION ALL
	SELECT
		'March',
		SUM(amount),
		3
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-03-01' AND '2023-03-31'
	UNION ALL
	SELECT
		'April',
		SUM(amount),
		4
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-04-01' AND '2023-04-30'
	UNION ALL
	SELECT
		'May',
		SUM(amount),
		5
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-05-01' AND '2023-05-31'
	UNION ALL
	SELECT
		'June',
		SUM(amount),
		6
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-06-01' AND '2023-06-30'
	UNION ALL
	SELECT
		'July',
		SUM(amount),
		7
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-07-01' AND '2023-07-31'
	UNION ALL
	SELECT
		'August',
		SUM(amount),
		8
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-08-01' AND '2023-08-31'
	UNION ALL
	SELECT
		'September',
		SUM(amount),
		9
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-09-01' AND '2023-09-30'
	UNION ALL
	SELECT
		'October',
		SUM(amount),
		10
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-10-01' AND '2023-10-31'
	UNION ALL
	SELECT
		'November',
		SUM(amount),
		11
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-11-01' AND '2023-11-30'
	UNION ALL
	SELECT
		'December',
		SUM(amount),
		12
	FROM PharmacyDems
	WHERE DATE BETWEEN '2023-12-01' AND '2023-12-31'
)

SELECT
	month,
	total
FROM PharmMonthlyPivot
ORDER BY id;

Age Categories:

WITH AgeCategories AS (
	SELECT
		customer_id,
		CASE
			WHEN age BETWEEN 18 AND 22 THEN '18 - 22'
			WHEN age BETWEEN 23 AND 27 THEN '23 - 27'
			WHEN age BETWEEN 28 AND 32 THEN '28 - 32'
			WHEN age BETWEEN 33 AND 37 THEN '33 - 37'
			WHEN age BETWEEN 38 AND 42 THEN '38 - 42'
			WHEN age BETWEEN 43 AND 47 THEN '43 - 47'
			WHEN age BETWEEN 48 AND 52 THEN '48 - 52'
			WHEN age BETWEEN 53 AND 57 THEN '53 - 57'
			WHEN age BETWEEN 58 AND 62 THEN '58 - 62'
			WHEN age BETWEEN 63 AND 67 THEN '63 - 67'
			WHEN age BETWEEN 68 AND 72 THEN '68 - 72'
			WHEN age BETWEEN 73 AND 77 THEN '73 - 77'
			ELSE 'Other'
		END AS age_group,
		automotive_sales AS auto,
		lawn_and_garden_sales AS lawn,
		electronics_sales AS elec,
		grocery_sales AS groc,
		household_essentials_sales AS house,
		clothing_sales AS cloth,
		appliances_sales AS appl,
		home_improvement_sales AS home,
		pharmacy_sales AS pharm
	FROM SalesWithDems
)

SELECT
	age_group,
	SUM(auto) auto,
	SUM(lawn) lawn,
	SUM(elec) elec,
	SUM(groc) groc,
	SUM(house) house,
	SUM(cloth) cloth,
	SUM(appl) appl,
	SUM(home) home,
	SUM(pharm) pharm
FROM AgeCategories
GROUP BY age_group
ORDER BY age_group;

