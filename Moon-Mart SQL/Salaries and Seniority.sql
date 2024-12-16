-- The following suggests that seniority is correlated with salary
-- Supervisors tend to earn significantly more than their employees within thier departments:

-- Automotive
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Automotive'
ORDER BY salary DESC;

-- Lawn & Garden
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Lawn & Garden'
ORDER BY salary DESC;

-- Electronics
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Electronics'
ORDER BY salary DESC;

-- Grocery
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Grocery'
ORDER BY salary DESC;

-- Household Essentials
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Household Essentials'
ORDER BY salary DESC;

-- Clothing
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Clothing'
ORDER BY salary DESC;

-- Appliances
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Appliances'
ORDER BY salary DESC;

-- Home Improvement
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Home Improvement'
ORDER BY salary DESC;

-- Pharmacy
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	d.name AS department,
	e.start_date,
	e.salary,
	e.is_supervisor
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.name = 'Pharmacy'
ORDER BY salary DESC;