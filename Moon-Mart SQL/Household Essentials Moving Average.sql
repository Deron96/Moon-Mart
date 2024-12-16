-- 7-day moving average for Household Essentials Department:
WITH DailySales AS (
	SELECT 
		date,
		SUM(amount) AS daily_total
	FROM HouseholdEssentialsSales
	GROUP BY date
)
SELECT 
	date,
	daily_total,
	ROUND(AVG(daily_total) OVER (ORDER BY date
		ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING), 2)
	AS day7_moving_average
FROM DailySales;