USE sample_sales;
-- Find my manager, region, and territory
SELECT
	Region,
    State,
    SalesManager
FROM management
WHERE SalesManager = 'Erbayne Middleton'; -- Erbayne Middleton, Northeast region, Maine
-- ************************************************************* --
/*What is total revenue overall for sales in the assigned territory, plus the start date 
and end date that tell you what period the data covers?*/
-- Find the stores in Maine (my territory)
SELECT * FROM store_locations -- StoreID 818-823
WHERE State = 'Maine';

SELECT
	FORMAT(SUM(Sale_Amount), 2) AS TotalRevenue,
    MIN(Transaction_Date) AS StartDate,
    MAX(Transaction_Date) AS EndDate
FROM store_sales
WHERE Store_ID IN (818, 819, 820, 821, 822, 823); -- Total Revenue: $1,877,249.75
												  -- From 2022-01-01 to 2025-12-31
-- *********************************************************** --





