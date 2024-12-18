-- Calculate daily sales:
WITH DailySales AS (
	SELECT 
		date,
		SUM(amount) AS daily_total
	FROM AutomotiveSales
	GROUP BY date
),
-- Generate a moving average of the previous 7 days:
MovingAverage AS (
	SELECT 
		date,
		daily_total,
		ROUND(AVG(daily_total) OVER (ORDER BY date
			ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING), 2)
		AS day7_moving_average
	FROM DailySales
),
-- Calculate daily discrepancy between moving average and actual sales:
DailyError AS (
	SELECT ABS(
		(daily_total - day7_moving_average) / daily_total) * 
			100 AS daily_error
	FROM MovingAverage
)
-- Calculate Mean Absolute Percentage Error:
SELECT ROUND(AVG(daily_error), 2) AS mape
FROM DailyError;

-- MAPE = 26.55%
