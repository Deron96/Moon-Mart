BEGIN; -- Start the transaction of populating this database

-- The following commands will allow this script to be run over and over again
DROP TABLE IF EXISTS MoonvilleCitizens CASCADE; -- DROP TABLE/VIEW removes it from the database; CASCADE clears tables' relationships
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Departments CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS SalesTransactions2023 CASCADE;
DROP TABLE IF EXISTS AutomotiveSales CASCADE;
DROP TABLE IF EXISTS LawnAndGardenSales CASCADE;
DROP TABLE IF EXISTS ElectronicsSales CASCADE;
DROP TABLE IF EXISTS GrocerySales CASCADE;
DROP TABLE IF EXISTS HouseholdEssentialsSales CASCADE;
DROP TABLE IF EXISTS ClothingSales CASCADE;
DROP TABLE IF EXISTS AppliancesSales CASCADE;
DROP TABLE IF EXISTS HomeImprovementSales CASCADE;
DROP TABLE IF EXISTS PharmacySales CASCADE;
DROP TABLE IF EXISTS PaidHolidays2023 CASCADE;
DROP TABLE IF EXISTS FirstNames CASCADE;
DROP TABLE IF EXISTS LastNames CASCADE;
DROP VIEW IF EXISTS SalesWithDems;
DROP VIEW IF EXISTS AutomotiveDems;
DROP VIEW IF EXISTS LawnAndGardenDems;
DROP VIEW IF EXISTS ElectronicsDems;
DROP VIEW IF EXISTS GroceryDems;
DROP VIEW IF EXISTS HouseholdEssentialsDems;
DROP VIEW IF EXISTS ClothingDems;
DROP VIEW IF EXISTS AppliancesDems;
DROP VIEW IF EXISTS HomeImprovementDems;
DROP VIEW IF EXISTS PharmacyDems;
DROP VIEW IF EXISTS TransTotal;

-- This table will contain the names of each person in our dataset, as well as some information about each of them
CREATE TABLE IF NOT EXISTS MoonvilleCitizens (
	moonville_id CHAR(5) PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	gender CHAR(1),
	birth_date DATE NOT NULL,
	is_customer CHAR(1),
	is_employee CHAR(1)
); 

-- This table provides a list of customers of Moon-Mart
CREATE TABLE IF NOT EXISTS Customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	moonville_id CHAR(5) REFERENCES MoonvilleCitizens(moonville_id),
	gender CHAR(1),
	age INT
);

-- This table provides info about each of the departments of Moon-Mart
CREATE TABLE IF NOT EXISTS Departments (
	department_id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	employee_count INT
);

-- This table provides info on Moon-Mart's employees
CREATE TABLE IF NOT EXISTS Employees (
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	moonville_id CHAR(5) REFERENCES MoonvilleCitizens(moonville_id),
	gender CHAR(1),
	birth_date DATE NOT NULL,
	department_id INT REFERENCES Departments(department_id),
	start_date DATE NOT NULL,
	salary INT,
	is_supervisor CHAR(1)
);

-- This table provides detail on each transaction in 2023
CREATE TABLE IF NOT EXISTS SalesTransactions2023 (
	transaction_id INT PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	automotive_sales DECIMAL(10, 2),
	lawn_and_garden_sales DECIMAL(10, 2),
	electronics_sales DECIMAL(10, 2),
	grocery_sales DECIMAL(10, 2),
	household_essentials_sales DECIMAL(10, 2),
	clothing_sales DECIMAL(10, 2),
	appliances_sales DECIMAL(10, 2), 
	home_improvement_sales DECIMAL(10, 2),
	pharmacy_sales DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS AutomotiveSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS LawnAndGardenSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS ElectronicsSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS GrocerySales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS HouseholdEssentialsSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS ClothingSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS AppliancesSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS HomeImprovementSales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS PharmacySales (
	id CHAR(10) PRIMARY KEY,
	date DATE NOT NULL,
	customer_id INT REFERENCES Customers(customer_id),
	amount DECIMAL(10, 2)
);

-- This temp table will establish work holiidays
CREATE TEMP TABLE IF NOT EXISTS PaidHolidays2023 (
	holiday_date DATE PRIMARY KEY
);

-- This table will be used to assign each citizen a first_name
CREATE TEMP TABLE IF NOT EXISTS FirstNames (
	year INT,
	name VARCHAR(100),
	gender CHAR(1),
	births INT,
	rank INT
);

-- This table will be used to assign each citizen a last_name

CREATE TEMP TABLE IF NOT EXISTS LastNames (
	name VARCHAR(100),
	rank INT,
	count INT
);

-- Now that a basic foundation has been laid, it's time to populate these first 3 tables
	-- The goal is to produce "randomly" generated data that will tend to be biased in certain directions
		-- Also note that this data should change each time the script is run

-- This CTE exists to provide me with unique IDs
WITH UniqueIDs AS (
    SELECT DISTINCT -- Prevents duplicates
        CHR(FLOOR(RANDOM() * 26 + 65)::INT) || 
        LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0') AS moonville_id
    FROM GENERATE_SERIES(1, 2000) -- Generate more IDs than needed, should be more than 818 unique
    LIMIT 818 -- Take only the required number of IDs 
)

INSERT INTO MoonvilleCitizens (moonville_id, gender, birth_date, is_customer, is_employee)
	SELECT 
    	moonville_id,
    	CASE WHEN RANDOM() < 0.5 THEN 'M' ELSE 'F' END AS gender, -- 50% male, 50% female
    	(CURRENT_DATE - INTERVAL '78 YEARS') +
    	(FLOOR(RANDOM() * (365 * 60 + 1)) || ' days')::INTERVAL AS birth_date, -- Ages should range from 18 to 77
    	CASE WHEN r1 < 0.95 THEN 'Y' ELSE 'N' END AS is_customer,
    	CASE 
        	WHEN r1 > 0.95 THEN 'Y' 
        	WHEN RANDOM() < 0.025 THEN 'Y'
        	ELSE 'N'
    	END AS is_employee
	FROM (
    	SELECT moonville_id, RANDOM() AS r1
    	FROM UniqueIDs
) AS subquery;

-- Check for duplicates of moonville_id
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 -- If any IDs have a count of over 1, a warning will be issued
        FROM MoonvilleCitizens
        GROUP BY moonville_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE NOTICE 'WARNING: Duplicate moonville_id detected!';
    ELSE
        RAISE NOTICE 'SUCCESS: No duplicate moonville_ids found.';
    END IF;
END $$;

-- Age will be a factor in purchasing habits
INSERT INTO Customers (moonville_id, gender, age)
	SELECT
		moonville_id,
		gender,
		EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
	FROM MoonvilleCitizens
	WHERE is_customer = 'Y';

-- Name the 9 departments of Moon-Mart
INSERT INTO Departments (name)
	VALUES
		('Automotive'),
		('Lawn & Garden'),
		('Electronics'),
		('Grocery'),
		('Household Essentials'),
		('Clothing'),
		('Appliances'),
		('Home Improvement'),
		('Pharmacy');

-- Assign customer info
INSERT INTO Employees (moonville_id, gender, birth_date, department_id, start_date)
	SELECT
    	moonville_id,
    	gender,
    	birth_date,
    	CASE
        	WHEN r1 < 0.07 THEN 1 --Automotive
        	WHEN r1 < 0.14 THEN 5 --Household Essentials
        	WHEN r1 < 0.21 THEN 6 --Clothing
        	WHEN r1 < 0.31 THEN 7 --Appliances
        	WHEN r1 < 0.41 THEN 8 --Home Improvement
        	WHEN r1 < 0.51 THEN 2 --Lawn & Garden
        	WHEN r1 < 0.66 THEN 3 --Electronics
        	WHEN r1 < 0.81 THEN 9 --Pharmacy
        	ELSE 4 --Grocery
    	END AS department_id,
    	(CURRENT_DATE - INTERVAL '20 YEARS') + 
    	(FLOOR(RANDOM() * (365 * 20 - 30)) || ' DAYS')::INTERVAL AS start_date -- Generate days between 30 days and 20 years ago
	FROM 
    	(SELECT 
        	moonville_id,
        	gender,
        	birth_date,
        	RANDOM() AS r1
    	FROM MoonvilleCitizens
    	WHERE is_employee = 'Y') AS subquery;

-- Run loops to put a minimum of 5 employees in each department
DO $$
DECLARE
    dept_id INT; -- Declare dept_id as INT
    citizen_id CHAR(5); -- Match the type of moonville_id (CHAR(5))
    citizen_birth_date DATE; -- Variable to store the birth date
BEGIN
    -- Outer loop: Find departments with less than 5 employees
    FOR dept_id IN (
        SELECT department_id
        FROM Employees
        GROUP BY department_id
        HAVING COUNT(employee_id) < 5
    )
    LOOP
        -- Inner loop: Keep adding employees until each department has at least 5
        WHILE (
            SELECT COUNT(employee_id)
            FROM Employees
            WHERE department_id = dept_id
        ) < 5
        LOOP
            -- Step 1: Select a random citizen to become an employee
            UPDATE MoonvilleCitizens
            SET is_employee = 'Y'
            WHERE moonville_id = (
                SELECT moonville_id
                FROM MoonvilleCitizens
                WHERE is_employee = 'N'
                ORDER BY RANDOM()
                LIMIT 1
            )
            RETURNING moonville_id, birth_date INTO citizen_id, citizen_birth_date;

            -- Step 2: Insert this citizen into Employees with other necessary info
            INSERT INTO Employees (employee_id, moonville_id, department_id, birth_date, start_date)
            VALUES (DEFAULT, citizen_id, dept_id, citizen_birth_date, CURRENT_DATE + INTERVAL '30 DAYS');
        END LOOP;
    END LOOP;
END $$;

-- Runs test to ensure that there is now a minimum of 5 employees per department
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Employees
        GROUP BY department_id
        HAVING COUNT(*) < 5
    ) THEN
        RAISE NOTICE 'WARNING: Insufficient staffing levels.';
    ELSE
        RAISE NOTICE 'SUCCESS: Staffing levels acceptable.';
    END IF;
END $$;

-- Establish employee holidays
INSERT INTO PaidHolidays2023 (holiday_date) 
	VALUES 
		('2023-01-01'), -- New Year's Day
		('2023-04-09'), -- Easter Day
		('2023-07-04'), -- Independence Day
		('2023-11-23'), -- Thanksgiving Day
		('2023-12-25'); -- Christmas Day

-- Insert random transaction dates and customers into SalesTransactions2023
	--These numbers are calculated to fit within certain ranges
WITH RandomCustomerIDs AS (
	SELECT customer_id
	FROM Customers
	CROSS JOIN generate_series(1, 97) AS gs -- 75000 / (818 * 0.95) is 97 when rounded up
	ORDER BY RANDOM()
	LIMIT 75000
),

SalesTransDateAndCustomer AS (
    SELECT
        DATE '2023-01-01' + (RANDOM() * 364)::INT AS date, -- Random date in 2023
        customer_id
	FROM
		RandomCustomerIDs
),

OrderedTransactions AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY date) AS transaction_id, -- Assign chronological transaction IDs
        date,
        customer_id
    FROM SalesTransDateAndCustomer
    WHERE date NOT IN (SELECT holiday_date FROM PaidHolidays2023)
)

INSERT INTO SalesTransactions2023 (transaction_id, date, customer_id)
	SELECT
    	transaction_id,
    	date,
    	customer_id
	FROM OrderedTransactions
	WHERE transaction_id IS NOT NULL;

-- Giving all the transactions a unique ID
WITH TransID AS (
    SELECT 
        transaction_id AS existing_transaction_id, -- Match existing primary key
        ROW_NUMBER() OVER (ORDER BY date) AS new_transaction_id -- Generate new IDs
    FROM SalesTransactions2023
)
UPDATE SalesTransactions2023
SET transaction_id = t.new_transaction_id
FROM TransID AS t
WHERE SalesTransactions2023.transaction_id = t.existing_transaction_id; -- Match existing IDs for update

WITH TransactionsWithDemographics AS (
  SELECT
    s.date,
    s.customer_id,
    s.transaction_id,
    c.gender,
    c.age
  FROM SalesTransactions2023 AS s
  JOIN Customers c
  ON s.customer_id = c.customer_id
),

-- These CTEs will provide factors and probability percentages for calculating sales frequency and amounts in each department per transaction
-- Base Probability currently multiplied by 8 to give higher rate of departments patronized per transaction
-- (Department-specific. Will be followed by All<Name>Factors, then other Department-specific CTEs)
Coefficient AS ( -- This allows for adjustments to total sales and purchase frequency
	SELECT
		4 AS X
),

AutomotiveTrends AS (
	SELECT 
		X * 0.0262 AS bp, -- "Base Probability" -- 2.62% of transactions include an Automotive sale
		0.9 AS mf,  -- "Male Factor" -- 90% of Automotive purchases are made by men
		0.8 AS paf, -- Peak Age Factor" -- 80% of Automotive purchases made by customers between ages 25 and 55
		0.7 AS psf, -- "Peak Season Factor" -- 70% of Automotive purchases made between May and August
		0.5 AS mp, -- "Male Probability" -- 50% of customers are male
		(55 - 25) / (78 - 18)::DECIMAL AS pap, -- "Peak Age Probability" -- Probability of customer being in peak Automotive sales age range
		(4 / 12::DECIMAL) AS psp -- "Peak Season Probability" -- Fraction representing peak season out of whole year
	FROM Coefficient
),

-- Department-specific. Follows <Name>Trends
AllAutomotiveFactors AS (
  SELECT
    t.*,
    a.*
  FROM TransactionsWithDemographics AS t,
  AutomotiveTrends AS a
),

-- After fixing bug that was causing some transactions to become null (NULLIF), the avg. # of departments per transaction fell out of 3 - 4 range
-- Will fix by changing leading coefficient before bp's
LawnAndGardenTrends AS (
	SELECT
		X * 0.0567 AS bp, -- "Base Probability" -- 5.67% of transactions include a Lawn & Garden sale
		0.7 AS mf, -- "Male Factor" -- 70% of Lawn & Garden purchases are made by men
		0.9 AS paf, -- "Peak Age Factor" -- 90% of Lawn & Garden purchases are made by customers age 35+
		0.8 AS psf, -- "Peak Season Factor" -- 80% of Lawn & Garden purchases made between April and September
		0.5 AS mp, -- "Male Probability" -- 50% of customers are male
		(78 - 35) / (78 - 18)::DECIMAL AS pap, -- "Peak Age Probability" -- Probability of customer being in peak Lawn & Garden sales age range
		(6 / 12::DECIMAL) AS psp -- "Peak Season Probability" -- Fraction representing peak season out of whole year
	FROM Coefficient
),

AllLawnAndGardenFactors AS (
  SELECT
    t.*,
    l.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN LawnAndGardenTrends AS l
),

ElectronicsTrends AS (
	SELECT
		X * 0.0446 AS bp, -- "Base Probability" -- 4.46% of transactions include an Electronics sale
		0.7 AS paf1, -- "Peak Age Factor 1" -- 70% of Electronics purchases are made by customers between ages 35 and 55
		0.2 AS paf2, -- "Peak Age Factor 2" -- 20% of Electronics purchases are made by customers between ages 25 and 34
		0.05 AS psf1, -- "Peak Season Factor 1" -- 5%% of Electronics purchases are made on Black Friday (11/24 in 2023)
		0.25 AS psf2, -- "Peak Season Factor 2" -- 25% of Electronics purchases are made between Black Friday and Christmas (exclusive)
		(55 - 35) / (78 - 18)::DECIMAL AS pap1, -- "Peak Age Probability 1" -- Probability of customer being in primary peak Electronics sales age range
		(34 - 25) / (78 - 18)::DECIMAL AS pap2, -- "Peak Age Probability 2" -- Probability of customer being in secondary peak Electronics sales age range
		(1 / 360::DECIMAL) AS psp1, -- "Peak Season Probability 1" -- Fraction representing a peak season out of whole year
		(30 / 360::DECIMAL) AS psp2 -- "Peak Season Probability 2" -- Fraction representing a peak season out of whole year
	FROM Coefficient
),

AllElectronicsFactors AS (
  SELECT
    t.*,
    e.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN ElectronicsTrends AS e
),

GroceryTrends AS (
	SELECT
		X * 0.1963 AS bp, -- "Base Probability" -- 19.63% of transactions include a Grocery sale
		0.8 AS ff, -- "Female Factor" -- 80% of Grocery purchases are made by women
		0.8 AS paf, -- "Peak Age Factor" -- 80% of Grocery purchases are made by customers between ages 25 and 65
		0.05 AS psf1, -- "Peak Season Factor 1" -- 5% of Grocery purchases made in the week before Christmas
    	0.05 AS psf2, -- "Peak Season Factor 2" -- 5% of Grocery purchases made in the week before Independence Day
    	0.08 AS psf3, -- "Peak Season Factor 3" -- 8% of Grocery purchases made in the week before Thanksgiving
		0.5 AS fp, -- "Female Probability" -- 50% of customers are female
		(65 - 25) / (78 - 18)::DECIMAL AS pap, -- "Peak Age Probability" -- Probability of customer being in peak Grocery sales age range
		(7 / 360::DECIMAL) AS psp1, -- "Peak Season Probability 1" -- Fraction representing Christmas week out of whole year
    	(7 / 360::DECIMAL) AS psp2, -- "Peak Season Probability 2" -- Fraction representing Independence Day week out of whole year
    	(7 / 360::DECIMAL) AS psp3 -- "Peak Season Probability 3" -- Fraction representing Thanksgiving week out of whole year
	FROM Coefficient
),

AllGroceryFactors AS (
  SELECT
    t.*,
    g.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN GroceryTrends AS g
),

HouseholdEssentialsTrends AS (
	SELECT 
		X * 0.3269 AS bp, -- "Base Probability" -- 32.69% of transactions include a Household Essentials sale
		0.75 AS ff,  -- "Female Factor" -- 75% of Pharmacy purchases are made by women
		0.5 AS fp -- "Male Probability" -- 50% of customers are male
	FROM Coefficient
),

AllHouseholdEssentialsFactors AS (
  SELECT
    t.*,
    h.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN HouseholdEssentialsTrends AS h
),

ClothingTrends AS (
	SELECT
		X * 0.1388 AS bp, -- "Base Probability" -- 13.88% of transactions include a Clothing sale
		0.8 AS ff, -- "Female Factor" -- 80% of Clothing purchases are made by women
		0.8 AS paf, -- "Peak Age Factor" -- 80% of Clothing purchases are made by customers between ages 25 and 55
		0.35 AS psf1, -- "Peak Season Factor 1" -- 35% of Clothing purchases made between May and June
    	0.15 AS psf2, -- "Peak Season Factor 2" -- 15% of Clothing purchases made between Black Friday and Christmas
		0.5 AS fp, -- "Female Probability" -- 50% of customers are female
		(55 - 25) / (78 - 18)::DECIMAL AS pap, -- "Peak Age Probability" -- Probability of customer being in peak Clothing sales age range
		(60 / 360::DECIMAL) AS psp1, -- "Peak Season Probability 1" -- Fraction representing May and June out of whole year
    	(30 / 360::DECIMAL) AS psp2 -- "Peak Season Probability 2" -- Fraction representing between Black Friday and Christmas out of whole year
	FROM Coefficient
),

AllClothingFactors AS (
  SELECT
    t.*,
    c.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN ClothingTrends AS c
),

AppliancesTrends AS (
	SELECT 
		X * 0.0063 AS bp, -- "Base Probability" -- 0.63% of transactions include an Appliances sale
		0.6 AS ff,  -- "Female Factor" -- 60% of Appliances purchases are made by women
		0.5 AS paf, -- Peak Age Factor" -- 50% of Appliances purchases made by customers between ages 30 and 44
		0.2 AS psf, -- "Peak Season Factor" -- 20% of Appliances purchases made between Black Friday and Christmas
		0.5 AS fp, -- "Female Probability" -- 50% of customers are female
		(44 - 30) / (78 - 18)::DECIMAL AS pap, -- "Peak Age Probability" -- Probability of customer being in peak Appliances sales age range
		(1 / 12::DECIMAL) AS psp -- "Peak Season Probability" -- Fraction representing peak season out of whole year
	FROM Coefficient
),

AllAppliancesFactors AS (
  SELECT
    t.*,
    a.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN AppliancesTrends AS a
),

HomeImprovementTrends AS (
	SELECT
		X * 0.0824 AS bp, -- "Base Probability" -- 8.24% of transactions include a Home Improvement sale
		0.85 AS mf, -- "Male Factor" -- 85% of Home Improvement purchases are made by men
		0.75 AS paf, -- "Peak Age Factor" -- 75% of Home Improvement purchases are made by customers between ages 30 and 55
		0.7 AS psf1, -- "Peak Season Factor 1" -- 70% of Home Improvement purchases made between April and September
   	 	0.25 AS psf2, -- "Peak Season Factor 2" -- 25% of Home Improvement purchases made between October and November
		0.5 AS mp, -- "Male Probability" -- 50% of customers are Male
		(55 - 30) / (78 - 18)::DECIMAL AS pap, -- "Peak Age Probability" -- Probability of customer being in peak Home Improvement sales age range
		(6 / 12::DECIMAL) AS psp1, -- "Peak Season Probability 1" -- Fraction representing April and September out of whole year
    	(2 / 12::DECIMAL) AS psp2 -- "Peak Season Probability 2" -- Fraction representing between October and November out of whole year
	FROM Coefficient
),

AllHomeImprovementFactors AS (
  SELECT
    t.*,
    h.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN HomeImprovementTrends AS h
),

PharmacyTrends AS (
	SELECT 
		X * 0.1218 AS bp, -- "Base Probability" -- 12.18% of transactions include a Pharmacy sale
		0.15 AS paf1,  -- "Peak Age Factor 1" -- 15% of Pharmacy purchases are made by ages 60 to 65
    	0.4 AS paf2, -- "Peak Age Factor 2" -- 40% of Pharmacy purchases are made by individuals older than 65
    	(65 - 60) / (78 - 18)::DECIMAL AS pap1, -- "Peak Age Probability 1" -- Probability of customer being in 60 to 65 age range
    	(78 - 65) / (78 - 18)::DECIMAL AS pap2 -- "Peak Age Probability 2" -- Probability of customer being older than 65
	FROM Coefficient
),

AllPharmacyFactors AS (
  SELECT
    t.*,
    p.*
  FROM TransactionsWithDemographics AS t
  CROSS JOIN PharmacyTrends AS p
),

AutomotiveTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Automotive department fall between $10 and $120
			-- Male customers between 25 and 55 during peak season
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 110 + 10

			-- Male customers between 25 and 55 during off-season
			WHEN gender = 'M' 
				AND age BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 110 + 10

			-- Male customers not between 25 and 55 during peak season
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 110 + 10

			-- Male customers not between 25 and 55 during off-season
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 110 + 10

			-- Female customers between 25 and 55 during peak season
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 110 + 10

			-- Female customers between 25 and 55 during off-season
			WHEN gender = 'F' 
				AND age BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 110 + 10

			-- Female customers not between 25 and 55 during peak season
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 110 + 10

			-- Female customers not between 25 and 55 during off-season
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-08-31'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 110 + 10

			ELSE NULL
		END AS automotive_transactions
	FROM AllAutomotiveFactors
),

LawnAndGardenTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Lawn & Garden department fall between $10 and $90
			-- Male customers over 35 during peak season
			WHEN gender = 'M'
				AND age >= 35
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 80 + 10

			-- Male customers >= 35 during off-season
			WHEN gender = 'M' 
				AND age >= 35
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 80 + 10

			-- Male customers under 35 during peak season
			WHEN gender = 'M'
				AND age < 35
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 80 + 10

			-- Male customers under 35 during off-season
			WHEN gender = 'M'
				AND age < 35
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 80 + 10

			-- Female customers under 35 during peak season
			WHEN gender = 'F'
				AND age < 35
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 80 + 10

			-- Female customers under 35 during off-season
			WHEN gender = 'F' 
				AND age < 35
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 80 + 10

			-- Female customers 35 during peak season
			WHEN gender = 'F'
				AND age < 35
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 80 + 10

			-- Female customers < 35 during off-season
			WHEN gender = 'F'
				AND age < 35
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 80 + 10

			ELSE NULL
		END AS lawn_and_garden_transactions
	FROM AllLawnAndGardenFactors
),

ElectronicsTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Electronics department fall between $30 and $300
			-- Customers between ages 35 and 55 on Black Friday
			WHEN age BETWEEN 35 AND 55
        		AND date = DATE '2023-11-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * (paf1 / NULLIF(pap1, 0)) * (psf1 / NULLIF(psp1, 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers between ages 35 and 55 during Christmas season
			WHEN age BETWEEN 35 AND 55
        		AND date BETWEEN DATE '2023-11-25' AND DATE '2023-12-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * (paf1 / NULLIF(pap1, 0)) * (psf2 / NULLIF(psp2, 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers between ages 35 and 55 during off-season
			WHEN age BETWEEN 35 AND 55
        		AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * (paf1 / NULLIF(pap1, 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers between ages 25 and 34 on Black Friday
			WHEN age BETWEEN 25 AND 34
        		AND date = DATE '2023-11-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * (paf2 / NULLIF(pap2, 0)) * (psf1 / NULLIF(psp1, 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers between ages 25 and 34 during Christmas season
			WHEN age BETWEEN 25 AND 34
        		AND date BETWEEN DATE '2023-11-25' AND DATE '2023-12-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * (paf2 / NULLIF(pap2, 0)) * (psf2 / NULLIF(psp2, 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers between ages 25 and 34 during off-season
			WHEN age BETWEEN 25 AND 34
        		AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * (paf2 / NULLIF(pap2, 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers not between ages 25 and 55 on Black Friday
			WHEN age NOT BETWEEN 25 AND 55
        		AND date = '2023-11-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * ((1 - paf1 - paf2) / NULLIF((1 - pap1 - pap2), 0)) * (psf1 / NULLIF(psp1, 0)))
      		THEN RANDOM() * 270 + 30

			-- Customers not between ages 25 and 55 during Christmas season
			WHEN age NOT BETWEEN 25 AND 55
        		AND date BETWEEN DATE '2023-11-25' AND DATE '2023-12-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * ((1 - paf1 - paf2) / NULLIF((1 - pap1 - pap2), 0)) * (psf2 / NULLIF(psp2, 0)))
      		THEN RANDOM() * 270 + 30

     -- Customers not between ages 25 and 55 during off-season
			WHEN age NOT BETWEEN 25 AND 55
        		AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
        		-- Probability adjusted to account for demographics and seasonality
        		AND RANDOM() < (bp * ((1 - paf1 - paf2) / NULLIF((1 - pap1 - pap2), 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
      		THEN RANDOM() * 270 + 30 

			ELSE NULL
		END AS electronics_transactions
	FROM AllElectronicsFactors
),

GroceryTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Grocery department fall between $2 and $200
			-- Female customers between 25 and 65 the week before Christmas
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 198 + 2

    	-- Female customers between 25 and 65 the week before Independence Day
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 198 + 2

      	-- Female customers between 25 and 65 the week before Christmas
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * (psf3 / NULLIF(psp3, 0)))
			THEN RANDOM() * 198 + 2

      	-- Female customers between 25 and 65 the week before Christmas
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 65
				AND date NOT BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
            AND date NOT BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
            AND date NOT BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * ((1 -psf1 - psf2 - psf3) / NULLIF((1 - psp1 - psp2 - psp3), 0)))
			THEN RANDOM() * 198 + 2

      -- Female customers not between 25 and 65 the week before Christmas
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 198 + 2

    	-- Female customers not between 25 and 65 the week before Independence Day
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 198 + 2

      	-- Female customers not between 25 and 65 the week before Thanksgiving
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf3 / NULLIF(psp3, 0)))
			THEN RANDOM() * 198 + 2

      	-- Female customers not between 25 and 65 during non-peak seasons
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 65
				AND date NOT BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
            AND date NOT BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
            AND date NOT BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 -psf1 - psf2 - psf3) / NULLIF((1 - psp1 - psp2 - psp3), 0)))
			THEN RANDOM() * 198 + 2 

      -- Male customers between 25 and 65 the week before Christmas
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 198 + 2

    	-- Male customers between 25 and 65 the week before Independence Day
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 198 + 2

      	-- Male customers between 25 and 65 the week before Thanksgiving
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * (psf3 / NULLIF(psp3, 0)))
			THEN RANDOM() * 198 + 2

      	-- Male customers between 25 and 65 during non-peak seasons
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 65
				AND date NOT BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
            AND date NOT BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
            AND date NOT BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * ((1 -psf1 - psf2 - psf3) / NULLIF((1 - psp1 - psp2 - psp3), 0)))
			THEN RANDOM() * 198 + 2

      -- Male customers not between 25 and 65 the week before Christmas
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 198 + 2

    	-- Male customers not between 25 and 65 the week before Independence Day
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 198 + 2

      	-- Male customers not between 25 and 65 the week before Thanksgiving
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 65
				AND date BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf3 / NULLIF(psp3, 0)))
			THEN RANDOM() * 198 + 2

      	-- Male customers not between 25 and 65 during non-peak seasons
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 65
				AND date NOT BETWEEN DATE '2023-12-18' AND DATE '2023-12-24'
            AND date NOT BETWEEN DATE '2023-06-27' AND DATE '2023-07-03'
            AND date NOT BETWEEN DATE '2023-11-16' AND DATE '2023-11-22'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 -psf1 - psf2 - psf3) / NULLIF((1 - psp1 - psp2 - psp3),0)))
			THEN RANDOM() * 198 + 2

			ELSE NULL
		END AS grocery_transactions
	FROM AllGroceryFactors
),

HouseholdEssentialsTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Household Essentials department fall between $2 and $50
			-- Female customer purchases
			WHEN gender = 'F'
        		AND RANDOM() < (bp * (ff / NULLIF(fp, 0)))
      		THEN RANDOM() * 48 + 2

      		-- Male customer purchases
      		WHEN gender = 'M'
       			AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)))
      		THEN RANDOM() * 48 + 2

			ELSE NULL
		END AS household_essentials_transactions
	FROM AllHouseholdEssentialsFactors
),

ClothingTransactions AS(
	SELECT
		transaction_id,
		CASE -- Purchases from the Clothing department fall between $8 and $90
			-- Female customers between 25 and 55 in the months of May and June
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 82 + 8

    	-- Female customers between 25 and 55 between Black Friday and Christmas
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 82 + 8

      	-- Female customers between 25 and 55 during non-peak season
			WHEN gender = 'F'
				AND age BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
        AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 82 + 8

      -- Female customers not between 25 and 55 in the months of May and June
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 82 + 8

    	-- Female customers not between 25 and 55 between Black Friday and Christmas
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 82 + 8

      	-- Female customers not between 25 and 55 during non-peak season
			WHEN gender = 'F'
				AND age NOT BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
        AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 82 + 8

      -- Male customers between 25 and 55 in the months of May and Jun
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 82 + 8

    	-- Male customers between 25 and 55 between Black Friday and Christmas
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 82 + 8

      	-- Male customers between 25 and 55 during non-peak season
			WHEN gender = 'M'
				AND age BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
        AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 82 + 8

      -- Male customers not between 25 and 55 in the months of May and Jun
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 82 + 8

    	-- Male customers not between 25 and 55 between Black Friday and Christmas
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 55
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 82 + 8

      	-- Male customers not between 25 and 55 during non-peak season
			WHEN gender = 'M'
				AND age NOT BETWEEN 25 AND 55
				AND date NOT BETWEEN DATE '2023-05-01' AND DATE '2023-06-30'
        AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 82 + 8

			ELSE NULL
		END AS clothing_transactions
	FROM AllClothingFactors
),

AppliancesTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Appliances department fall between $40 and $500
			-- Female customers between 30 and 44 during peak season
			WHEN gender = 'F'
				AND age BETWEEN 30 and 44
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 460 + 40

			-- Female customers between 30 and 44 during off-season
			WHEN gender = 'F' 
				AND age BETWEEN 30 and 44
				AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 460 + 40

			-- Female customers not between 30 and 44 during peak season
			WHEN gender = 'F'
				AND age NOT BETWEEN 30 and 44
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 460 + 40

			-- Female customers not between 30 and 44 during off-season
			WHEN gender = 'F'
				AND age NOT BETWEEN 30 and 44
				AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (ff / NULLIF(fp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 460 + 40

			-- Male customers between 30 and 44 during peak season
			WHEN gender = 'M'
				AND age BETWEEN 30 and 44
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 460 + 40

			-- Male customers between 30 and 44 during off-season
			WHEN gender = 'M' 
				AND age BETWEEN 30 and 44
				AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf) / NULLIF((1 - psp), 0)))
			THEN RANDOM() * 460 + 40

			-- Male customers not between 30 and 44 during peak season
			WHEN gender = 'M'
				AND age NOT BETWEEN 30 and 44
				AND date BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 460 + 40

			-- Male customers not between 30 and 44 during off-season
			WHEN gender = 'M'
				AND age NOT BETWEEN 30 and 44
				AND date NOT BETWEEN DATE '2023-11-24' AND DATE '2023-12-24'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - ff) / NULLIF((1 - fp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf / NULLIF(psp, 0)))
			THEN RANDOM() * 460 + 40

			ELSE NULL
		END AS appliances_transactions
	FROM AllAppliancesFactors
),

HomeImprovementTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Home Improvement department fall between $5 and $50
			-- Male customers between 30 and 55 in the months of April and September
      		WHEN gender = 'M'
				AND age BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 45 + 5

    		-- Male customers between 30 and 55 between October and November
			WHEN gender = 'M'
				AND age BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 45 + 5

      		-- Male customers between 30 and 55 during non-peak season
			WHEN gender = 'M'
				AND age BETWEEN 30 and 55
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
        	AND date NOT BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 45 + 5

      		-- Male customers not between 30 and 55 in the months of April and September
      		WHEN gender = 'M'
				AND age NOT BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 45 + 5

    		-- Male customers not between 30 and 55 between October and November
			WHEN gender = 'M'
				AND age NOT BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 45 + 5

      		-- Male customers not between 30 and 55 during non-peak season
			WHEN gender = 'M'
				AND age NOT BETWEEN 30 and 55
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
        		AND date NOT BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * (mf / NULLIF(mp, 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 45 + 5

      		-- Female customers between 30 and 55 in the months of April and September
      		WHEN gender = 'F'
				AND age BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF((1 - mp), 0)) * (paf / NULLIF(pap, 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 45 + 5

    		-- Female customers between 30 and 55 between October and November
			WHEN gender = 'F'
				AND age BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF((1 - mp), 0)) * (paf / NULLIF(pap, 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 45 + 5

      	-- Female customers between 30 and 55 during non-peak season
			WHEN gender = 'F'
				AND age BETWEEN 30 and 55
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
        AND date NOT BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF((1 - mp), 0)) * (paf / NULLIF(pap, 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 45 + 5

     	 -- Female customers not between 30 and 55 in the months of April and September
     	 WHEN gender = 'F'
				AND age NOT BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF((1 - mp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf1 / NULLIF(psp1, 0)))
			THEN RANDOM() * 45 + 5

    	-- Female customers not between 30 and 55 between October and November
			WHEN gender = 'F'
				AND age NOT BETWEEN 30 and 55
				AND date BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF((1 - mp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * (psf2 / NULLIF(psp2, 0)))
			THEN RANDOM() * 45 + 5

      	-- Female customers not between 30 and 55 during non-peak season
			WHEN gender = 'F'
				AND age NOT BETWEEN 30 and 55
				AND date NOT BETWEEN DATE '2023-04-01' AND DATE '2023-09-30'
        AND date NOT BETWEEN DATE '2023-10-01' AND DATE '2023-11-30'
				-- Probability adjusted to account for demographics and seasonality
				AND RANDOM() < (bp * ((1 - mf) / NULLIF((1 - mp), 0)) * ((1 - paf) / NULLIF((1 - pap), 0)) * ((1 - psf1 - psf2) / NULLIF((1 - psp1 - psp2), 0)))
			THEN RANDOM() * 45 + 5

			ELSE NULL
		END AS home_improvement_transactions
	FROM AllHomeImprovementFactors
),

PharmacyTransactions AS (
	SELECT
		transaction_id,
		CASE -- Purchases from the Pharmacy department fall between $3 and $80
			-- Ages 60 - 65
			WHEN age BETWEEN 60 AND 65
        		AND RANDOM() < (bp * (paf1 / NULLIF(pap1, 0)))
      		THEN RANDOM() * 77 + 3

      -- Ages over 65
			WHEN age > 65
        		AND RANDOM() < (bp * (paf2 / NULLIF(pap2, 0)))
      		THEN RANDOM() * 77 + 3

      -- Ages under 60
			WHEN age < 60
        		AND RANDOM() < (bp * ((1 - paf1 - paf2) / NULLIF((1 - pap1 - pap2), 0)))
      		THEN RANDOM() * 77 + 3

			ELSE NULL
		END AS pharmacy_transactions
	FROM AllPharmacyFactors
),

CombinedTransactions AS(
	SELECT
		au.transaction_id,
		au.automotive_transactions,
		l.lawn_and_garden_transactions,
		e.electronics_transactions,
		g.grocery_transactions,
		he.household_essentials_transactions,
		c.clothing_transactions,
		ap.appliances_transactions,
		hi.home_improvement_transactions,
		p.pharmacy_transactions
	FROM AutomotiveTransactions AS au
	LEFT JOIN LawnAndGardenTransactions AS l
	ON au.transaction_id = l.transaction_id
	LEFT JOIN ElectronicsTransactions AS e
	ON au.transaction_id = e.transaction_id
	LEFT JOIN GroceryTransactions AS g
	ON au.transaction_id = g.transaction_id
	LEFT JOIN HouseholdEssentialsTransactions AS he
	ON au.transaction_id = he.transaction_id
	LEFT JOIN ClothingTransactions AS c
	ON au.transaction_id = c.transaction_id
	LEFT JOIN AppliancesTransactions AS ap
	ON au.transaction_id = ap.transaction_id
	LEFT JOIN HomeImprovementTransactions AS hi
	ON au.transaction_id = hi.transaction_id
	LEFT JOIN PharmacyTransactions AS p
	ON au.transaction_id = p.transaction_id
)

-- Plug the contents of the <Department>Transactions 
UPDATE SalesTransactions2023 AS s
SET 
	automotive_sales = c.automotive_transactions,
	lawn_and_garden_sales = c.lawn_and_garden_transactions,
	electronics_sales = c.electronics_transactions,
	grocery_sales = c.grocery_transactions,
	household_essentials_sales = c.household_essentials_transactions,
	clothing_sales = c.clothing_transactions,
	appliances_sales = c.appliances_transactions,
	home_improvement_sales = c.home_improvement_transactions,
	pharmacy_sales = c.pharmacy_transactions
FROM CombinedTransactions c
WHERE s.transaction_id = c.transaction_id;

DELETE FROM SalesTransactions2023
WHERE
	automotive_sales IS NULL
	AND lawn_and_garden_sales IS NULL
	AND electronics_sales IS NULL
	AND grocery_sales IS NULL
	AND household_essentials_sales IS NULL
	AND clothing_sales IS NULL
	AND appliances_sales IS NULL
	AND home_improvement_sales IS NULL
	AND pharmacy_sales IS NULL;

-- Check for null transactions
DO $$
BEGIN
    IF EXISTS (
		SELECT 1
		FROM SalesTransactions2023
		WHERE
			automotive_sales IS NULL
			AND lawn_and_garden_sales IS NULL
			AND electronics_sales IS NULL
			AND grocery_sales IS NULL
			AND household_essentials_sales IS NULL
			AND clothing_sales IS NULL
			AND appliances_sales IS NULL
			AND home_improvement_sales IS NULL
			AND pharmacy_sales IS NULL
    ) THEN
        RAISE NOTICE 'WARNING: Null transactions detected!';
    ELSE
        RAISE NOTICE 'SUCCESS: All transactions validated.';
    END IF;
END $$;

COPY FirstNames(year, name, gender, births, rank)
FROM '/Users/gregorylester/Documents/Moon-Mart/Moon-Mart Names/first_names.csv'
DELIMITER ',' CSV HEADER;

COPY LastNames(name, rank, count)
FROM '/Users/gregorylester/Documents/Moon-Mart/Moon-Mart Names/last_names.csv'
DELIMITER ',' CSV HEADER;

WITH RandomizedNames AS (
    SELECT 
        mc.moonville_id,
        fn.name
    FROM 
        (SELECT moonville_id, ROW_NUMBER() OVER () AS rn FROM MoonvilleCitizens WHERE gender = 'M') mc
    JOIN (
        SELECT name, ROW_NUMBER() OVER (ORDER BY random()) AS rn
        FROM FirstNames
        WHERE rank <= 100 AND gender = 'M'
    ) fn
    ON mc.rn = fn.rn
)

UPDATE MoonvilleCitizens
SET first_name = rn.name
FROM RandomizedNames rn
WHERE MoonvilleCitizens.moonville_id = rn.moonville_id;

WITH RandomizedNames AS (
    SELECT 
        mc.moonville_id,
        fn.name
    FROM 
        (SELECT moonville_id, ROW_NUMBER() OVER () AS rn FROM MoonvilleCitizens WHERE gender = 'F') mc
    JOIN (
        SELECT name, ROW_NUMBER() OVER (ORDER BY random()) AS rn
        FROM FirstNames
        WHERE rank <= 100 AND gender = 'F'
    ) fn
    ON mc.rn = fn.rn
)

UPDATE MoonvilleCitizens
SET first_name = rn.name
FROM RandomizedNames rn
WHERE MoonvilleCitizens.moonville_id = rn.moonville_id;

WITH NamePool AS (
    SELECT 
        UPPER(SUBSTR(name, 1, 1)) || LOWER(SUBSTR(name, 2, LENGTH(name) - 1)) AS name,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM LastNames
    CROSS JOIN GENERATE_SERIES(1, CEIL(818.0 / 50.0)::INT) AS gs
    WHERE rank <= 100
),
CitizenRowNumbers AS (
    SELECT 
        moonville_id,
        ROW_NUMBER() OVER (ORDER BY moonville_id) AS rn
    FROM MoonvilleCitizens
),
RandomizedNames AS (
    SELECT 
        crn.moonville_id,
        np.name AS random_name
    FROM CitizenRowNumbers crn
    JOIN NamePool np ON crn.rn = np.rn
)

UPDATE MoonvilleCitizens
SET last_name = rn.random_name
FROM RandomizedNames rn
WHERE MoonvilleCitizens.moonville_id = rn.moonville_id;

UPDATE Customers c
SET first_name = mc.first_name
FROM MoonvilleCitizens mc
WHERE c.moonville_id = mc.moonville_id;

UPDATE Customers c
SET last_name = mc.last_name
FROM MoonvilleCitizens mc
WHERE c.moonville_id = mc.moonville_id;

UPDATE Employees e
SET first_name = mc.first_name
FROM MoonvilleCitizens mc
WHERE e.moonville_id = mc.moonville_id;

UPDATE Employees e
SET last_name = mc.last_name
FROM MoonvilleCitizens mc
WHERE e.moonville_id = mc.moonville_id;

WITH TotalSalesPivot AS (
	SELECT
		'Automotive' AS department,
		SUM(automotive_sales) AS total_sales
	FROM SalesTransactions2023
	UNION ALL
	SELECT
		'Lawn & Garden',
		SUM(lawn_and_garden_sales)
	FROM SalesTransactions2023
	UNION ALL
	SELECT
		'Electronics',
		SUM(electronics_sales)
	FROM SalesTransactions2023
	UNION ALL
	SELECT
		'Grocery',
		SUM(grocery_sales)
	FROM SalesTransactions2023
	UNION ALL
	SELECT
		'Household Essentials',
		SUM(household_essentials_sales)
	FROM SalesTransactions2023
	UNION ALL
	SELECT
		'Clothing',
		SUM(clothing_sales)
	FROM SalesTransactions2023
	UNION ALL
	SELECT
		'Appliances',
		SUM(appliances_sales)
	FROM SalesTransactions2023
	UNION ALL 
	SELECT
		'Home Improvement',
		SUM(home_improvement_sales)
	FROM SalesTransactions2023
	UNION ALL
	SELECT 
		'Pharmacy',
		SUM(pharmacy_sales)
	FROM SalesTransactions2023
),

SalesRank AS (
	SELECT
		department,
		total_sales, 
		RANK() OVER (ORDER BY total_sales DESC) AS dept_rank
	FROM TotalSalesPivot
),

EmployeeFactors AS (
	SELECT
		e.employee_id,
		FLOOR((CURRENT_DATE - e.start_date) / 365) AS years_with_company,
		s.dept_rank
	FROM SalesRank s
	JOIN Departments d
	ON s.department = d.name
	JOIN Employees e
	ON d.department_id = e.department_id
)

UPDATE Employees
SET salary = FLOOR(RANDOM() * 2000 + 30000 + (years_with_company * 750) + ((9 - dept_rank) * 2500))
FROM EmployeeFactors e
WHERE Employees.employee_id = e.employee_id;


-- The highest earning employee in each department should be the supervisor
WITH RankedSalaries AS (
    SELECT
        employee_id,
        department_id,
        salary,
        RANK() OVER (PARTITION BY department_id ORDER BY salary DESC, start_date) AS rank
    FROM Employees
	WHERE salary IS NOT NULL -- To prevent nulls from being ranked "1"
)

UPDATE Employees
SET is_supervisor = CASE
    WHEN employee_id IN (
        SELECT employee_id
        FROM RankedSalaries
        WHERE rank = 1
    )
    THEN 'Y'
    ELSE 'N'
END;

-- Ensure there is exactly one supervisor per department
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Employees
		WHERE is_supervisor = 'Y'
        GROUP BY department_id
        HAVING 
			COUNT(*) > 1
			OR COUNT(*) = 0
    ) THEN
        RAISE NOTICE 'WARNING: Improper management staffing!';
    ELSE
        RAISE NOTICE 'SUCCESS: A supervisor is assigned to each department.';
    END IF;
END $$;

-- Check to ensure average number of departments involved per transaction falls in range 3 - 4
DO $$
BEGIN
    IF (
		(WITH DeptFreq AS (
	SELECT 
		COUNT(automotive_sales) auto,
		COUNT(lawn_and_garden_sales) lawn,
		COUNT(electronics_sales) elec,
		COUNT(grocery_sales) groc,
		COUNT(household_essentials_sales) house,
		COUNT(clothing_sales) cloth,
		COUNT(appliances_sales) appl,
		COUNT(home_improvement_sales) home,
		COUNT(pharmacy_sales) pharm
	FROM SalesTransactions2023
)

	SELECT 
		ROUND((auto + lawn + elec + groc + house + cloth + appl + home + pharm) 
		/ (SELECT COUNT(*) FROM SalesTransactions2023)::DECIMAL, 2)
		AS avg_depts_per_trans
	FROM DeptFreq) NOT BETWEEN 3 AND 4 
    ) THEN
        RAISE NOTICE 'WARNING: Average departments per transaction outside of desired range!';
    ELSE
        RAISE NOTICE 'SUCCESS: Average departments per transaction within the desired range.';
    END IF;
END $$;

-- Check to see if the payroll is within range of 15 - 30% of total sales
DO $$
BEGIN
    IF (
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
			ROUND(c2.total_payroll / c1.total_sales, 2)
		FROM Connector1 c1
		JOIN Connector2 c2
		ON c1.connector = c2.connector
    ) NOT BETWEEN 0.15 AND 0.3
	THEN
        RAISE NOTICE 'WARNING: Payroll-to-Sales ratio is outside desired range!';
    ELSE
        RAISE NOTICE 'SUCCESS: Payroll-to-Sales ratio within desired range.';
    END IF;
END $$;

WITH EmployeeCount AS (
	SELECT
		department_id,
		COUNT(*) AS employee_count
	FROM Employees
	GROUP BY department_id
)

UPDATE Departments
SET employee_count = e.employee_count
FROM EmployeeCount e
WHERE Departments.department_id = e.department_id;


UPDATE Employees
SET salary = salary + 10000
WHERE is_supervisor = 'Y';


INSERT INTO AutomotiveSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '1' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	automotive_sales
FROM SalesTransactions2023
WHERE automotive_sales IS NOT NULL;

INSERT INTO LawnAndGardenSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '2' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	lawn_and_garden_sales
FROM SalesTransactions2023
WHERE lawn_and_garden_sales IS NOT NULL;

INSERT INTO ElectronicsSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '3' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	electronics_sales
FROM SalesTransactions2023
WHERE electronics_sales IS NOT NULL;

INSERT INTO GrocerySales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '4' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	grocery_sales
FROM SalesTransactions2023
WHERE grocery_sales IS NOT NULL;

INSERT INTO HouseholdEssentialsSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '5' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	household_essentials_sales
FROM SalesTransactions2023
WHERE household_essentials_sales IS NOT NULL;

INSERT INTO ClothingSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '6' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	clothing_sales
FROM SalesTransactions2023
WHERE clothing_sales IS NOT NULL;

INSERT INTO AppliancesSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '7' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	appliances_sales
FROM SalesTransactions2023
WHERE appliances_sales IS NOT NULL;

INSERT INTO HomeImprovementSales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '8' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	home_improvement_sales
FROM SalesTransactions2023
WHERE home_improvement_sales IS NOT NULL;

INSERT INTO PharmacySales (id, date, customer_id, amount)
SELECT
	TO_CHAR(date, 'YYMMDD') 
		|| '9' || -- department_id
			LPAD(ROW_NUMBER() OVER (PARTITION BY date ORDER BY date)::TEXT, 3, 'X')::TEXT,
	date,
	customer_id,
	pharmacy_sales
FROM SalesTransactions2023
WHERE pharmacy_sales IS NOT NULL;


-- After setting up the design for everything, let's add in some views for easy access of the data
CREATE VIEW SalesWithDems AS (
	SELECT 
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		s.*
	FROM SalesTransactions2023 s
	LEFT JOIN Customers c
	ON s.customer_id = c.customer_id
);

CREATE VIEW AutomotiveDems AS (
	SELECT 
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		a.*
	FROM AutomotiveSales a
	LEFT JOIN Customers c
	ON a.customer_id = c.customer_id
);

CREATE VIEW LawnAndGardenDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		l.*
	FROM LawnAndGardenSales l
	LEFT JOIN Customers c
	ON l.customer_id = c.customer_id
);

CREATE VIEW ElectronicsDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		e.*
	FROM ElectronicsSales e
	LEFT JOIN Customers c
	ON e.customer_id = c.customer_id
);

CREATE VIEW GroceryDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		g.*
	FROM GrocerySales g
	LEFT JOIN Customers c
	ON g.customer_id = c.customer_id
);

CREATE VIEW HouseholdEssentialsDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		h.*
	FROM HouseholdEssentialsSales h
	LEFT JOIN Customers c
	ON h.customer_id = c.customer_id
);

CREATE VIEW ClothingDems AS (
	SELECT
		cus.first_name,
		cus.last_name,
		cus.gender,
		cus.age,
		clo.*
	FROM ClothingSales clo
	LEFT JOIN Customers cus
	ON clo.customer_id = cus.customer_id
);

CREATE VIEW AppliancesDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		a.*
	FROM AppliancesSales a
	LEFT JOIN Customers c
	ON a.customer_id = c.customer_id
);

CREATE VIEW HomeImprovementDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		h.*
	FROM HomeImprovementSales h
	LEFT JOIN Customers c
	ON h.customer_id = c.customer_id
);

CREATE VIEW PharmacyDems AS (
	SELECT
		c.first_name,
		c.last_name,
		c.gender,
		c.age,
		p.*
	FROM PharmacySales p
	LEFT JOIN Customers c
	ON p.customer_id = c.customer_id
);

CREATE VIEW TransTotal AS
SELECT
    customer_id,
    gender,
    age,
    transaction_id,
    date,
    COALESCE(automotive_sales, 0) +
        COALESCE(lawn_and_garden_sales, 0) +
        COALESCE(electronics_sales, 0) +
        COALESCE(grocery_sales, 0) +
        COALESCE(household_essentials_sales, 0) +
        COALESCE(clothing_sales, 0) +
        COALESCE(appliances_sales, 0) +
        COALESCE(home_improvement_sales, 0) +
        COALESCE(pharmacy_sales, 0) AS trans_total
FROM SalesWithDems;

-- This block was implemented upon discovering an employee who started on Christmas day...
DO $$
BEGIN
    -- Adjust start_dates that fall on specific holidays
    UPDATE Employees
    SET start_date = start_date - INTERVAL '1 DAY'
    WHERE TO_CHAR(start_date, 'MM-DD') IN ('01-01', '04-09', '07-04', '11-23', '12-25'); -- List of holidays
END $$;

COMMIT;