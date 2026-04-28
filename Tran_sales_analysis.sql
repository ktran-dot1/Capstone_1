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
/*What is the month by month revenue breakdown for the sales territory?*/
-- DATE_FORMAT to get a year and a month. 
SELECT 
	DATE_FORMAT(Transaction_Date, '%Y-%m') AS 'Year-Month' , 
	FORMAT(SUM(Sale_Amount), 2) AS MonthlyRevenue
FROM store_sales
WHERE Store_ID
	BETWEEN 818 AND 823
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m');
-- ************************************************************* --
/*Provide a comparison of total revenue for the specific sales territory 
and the region it belongs to.*/
-- Northeast Region: Maine, Maryland, Massachusetts, and New Jersey
SELECT * FROM store_locations -- Maine: StoreID 818 - 823
WHERE State = 'Maine';
SELECT * FROM store_locations -- Marland: StoreID 731 - 739
WHERE State = 'Maryland';
SELECT * FROM store_locations -- Massachusetts: StoreID 730, 801-817
WHERE State = 'Massachusetts';
SELECT * FROM store_locations -- New Jersey: StoreID 824-839
WHERE State = 'New Jersey';

-- Below is a query to get Maine's total revenue
SELECT
	'Maine' AS Territory,
	FORMAT(SUM(Sale_Amount), 2) AS TotalRevenue,
    MIN(Transaction_Date) AS StartDate,
    MAX(Transaction_Date) AS EndDate
FROM store_sales
WHERE Store_ID BETWEEN 818 AND 823
UNION -- stacks the two queries
-- Below is a query that combines the total revenue for all four territories in the Northeast
SELECT
	'Northeast' AS Territory,
    FORMAT(SUM(Sale_Amount), 2) AS TotalRevenue,
    MIN(Transaction_Date) AS StartDate,
    MAX(Transaction_Date) AS EndDate
FROM store_sales
WHERE
	Store_ID BETWEEN 818 AND 823 -- Maine
	OR Store_ID BETWEEN 731 AND 739 -- Maryland
    OR Store_ID = 730               -- Massachusetts (Outlier)
    OR Store_ID BETWEEN 801 AND 817 -- Massachusetts
    OR Store_ID BETWEEN 824 AND 839; -- New Jersey
    
-- Another version to answer the question using JOINs + UNION
/*SELECT
	DATE_FORMAT(Transaction_Date, '%Y') AS Year,
    sl.State AS Territory,
    FORMAT(SUM(Sale_Amount), 2) AS TotalRevenue
FROM store_sales AS ss
JOIN store_locations AS sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY Territory, Year
UNION
SELECT 
	DATE_FORMAT(Transaction_Date, '%Y') AS Year,
    'Northeast' AS Territory,
    FORMAT(SUM(Sale_Amount), 2) AS TotalRevenue
FROM store_sales AS ss
JOIN store_locations AS sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State IN ('Maine', 'Maryland', 'Massachusetts', 'New Jersey')
GROUP BY Territory, Year
ORDER BY Year;
*/

-- Another Version, using CASE WHEN + subqueries
/*SELECT
	Year,
	Territory,
    TotalRevenue
FROM (
	SELECT
		CASE
			WHEN sl.State = 'Maine' THEN 'Maine'
            ELSE 'Northeast'
		END AS Territory,
        DATE_FORMAT(Transaction_Date, '%Y') AS Year,
        FORMAT(SUM(Sale_Amount), 2) AS TotalRevenue
	FROM store_sales AS ss
    JOIN store_locations AS sl
		ON ss.Store_ID = sl.StoreId
	WHERE sl.State IN ('Maine', 'Maryland', 'Massachusetts', 'New Jersey')
    GROUP BY Territory, Year
    ) AS subquery1
GROUP BY Territory, Year;
*/

-- ************************************************************* --
/*What is the number of transactions per month and average transaction size by product 
category for the sales territory?*/
SELECT
	DATE_FORMAT(Transaction_Date, '%Y-%m') AS 'Year-Month',
    COUNT(Transaction_Date) AS Num_of_Trans,
    ROUND(AVG(Sale_Amount), 2) AS AVG_Trans_Size,
    ic.Category
FROM store_sales
JOIN products ON products.ProdNum = store_sales.Prod_Num
JOIN inventory_categories AS ic
	ON products.Categoryid = ic.Categoryid
WHERE Store_ID
	BETWEEN 818 AND 823
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m'), ic.Category
ORDER BY ic.Category;
    





