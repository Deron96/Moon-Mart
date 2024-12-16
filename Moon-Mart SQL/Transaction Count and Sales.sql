-- This iteration of the database has generated over 69,000 transactions and nearly $13.4M in sales:
SELECT COUNT(*)
FROM SalesTransactions2023;

SELECT SUM(trans_total)
FROM TransTotal;