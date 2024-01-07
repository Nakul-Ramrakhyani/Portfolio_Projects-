--SETTING UP THE DATABASE AND CREATING OUR OWN TABLE IN WHICH WE IMPORT THE WALMART'S DATA

	CREATE DATABASE salesDataWalmart;

	USE salesDataWalmart;

	CREATE TABLE Sale(
		invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
		branch VARCHAR(5) NOT NULL,
		city VARCHAR(30) NOT NULL,
		customer_type VARCHAR(30) NOT NULL,
		gender VARCHAR(10) NOT NULL,
		product_line VARCHAR(100) NOT NULL,
		unit_price DECIMAL(10, 2) NOT NULL,
		quantity INT NOT NULL,
		VAT DECIMAL(6,4) NOT NULL,
		total DECIMAL(12,4) NOT NULL, 
		Date DATETIME NOT NULL,
		Time TIME NOT NULL,
		Payment_method VARCHAR(15) NOT NULL,
		cogs DECIMAL(10, 2) NOT NULL,
		gross_margin_pct DECIMAL(11,9),
		gross_income DECIMAL(12,4) NOT NULL,
		rating float
		);


	select * from dbo.Sales;
-------------------------------------------------------------------------------------------
--fEATURE ENGINEERING

--# time_of_day

	SELECT
	Time,
	(CASE 
		WHEN [Time] BETWEEN '00:00:00' AND '12:00:00' then 'Morning'
		WHEN [Time] BETWEEN '12:01:00' AND '16:00:00' then 'Afternoon'
		ELSE 'Evening'
		END
	)AS Time_Of_Day

	from Sales;


	ALTER TABLE Sales
		ADD Time_of_Day VARCHAR(20); 

UPDATE Sales
	SET Time_of_Day = (
		CASE 
		WHEN [Time] BETWEEN '00:00:00' AND '12:00:00' then 'Morning'
		WHEN [Time] BETWEEN '12:01:00' AND '16:00:00' then 'Afternoon'
		ELSE 'Evening'
		END
		);


--DAY_NAME

	SELECT 
		DATE,
		FORMAT(Date, 'dddd') AS DayName
		FROM Sales;

	ALTER TABLE Sales
		ADD Day_Name VARCHAR(10);

	UPDATE Sales
		SET Day_Name = FORMAT(Date, 'dddd');

-------------------------------------------------------------------------------------
--MONTH_NAME
	SELECT 
		DATE,
		FORMAT(Date, 'MMMM') AS MonthName
		FROM Sales;


	ALTER TABLE Sales
		ADD Month_Name VARCHAR(15);

	UPDATE Sales
		SET Month_Name = FORMAT(Date, 'MMMM');

--------------------------------------------------------------------------------------------------

--How many unique cities does the data have?	

	SELECt DISTINCT(City) FROM Sales;

--In which city is each branch?

	SELECT DISTINCT(Branch),City FROM Sales;

--How many unique product lines does the data have?
	SELECT COUNT(DISTINCT(Product_line)) from Sales;

--What is the most common payment method?
	SELECT Payment_method, COUNT(Payment_method) AS cnt 
	FROM Sales 
	group by Payment_method ORDER BY cnt DESC;

--What is the most selling product line?
	SELECT Product_line, COUNT(Product_line) AS cnt 
	FROM Sales 
	group by Product_line ORDER BY cnt DESC;

--What is the total revenue by month?

		SELECT Month_Name, SUM(Total)AS Total_Revenue 
		fROM Sales
		GROUP BY Month_Name
		ORDER BY Total_Revenue DESC;

--What month had the largest COGS?

		SELECT Month_Name, SUM(cogs) AS Total_cogs 
		FROM Sales
		GROUP BY Month_Name
		ORDER BY Total_cogs DESC;

--What product line had the largest revenue?
	
		SELECT Product_line, SUM(Total) AS Total_Revenue 
		FROM Sales
		GROUP BY Product_line
		ORDER BY Total_Revenue DESC;

	
--What is the city with the largest revenue?
		
		SELECT City, SUM(Total) AS Total_Revenue 
		FROM Sales
		GROUP BY City
		ORDER BY Total_Revenue DESC;


--What product line had the largest VAT?
		
		SELECT Product_line, AVG(VAT) AS AVG_VAT 
		FROM Sales
		GROUP BY Product_line
		ORDER BY AVG_VAT DESC;

--Fetch each product line and add a column to those product line showing "Good", "Bad".
-- Good if its greater than average sales

		SELECT 
		Product_line,
		round(AVG(Total),2) AS Avg_Sales,
		(
		CASE
			WHEN AVG(Total) > (SELECT AVG(Total) from Sales) then 'GOOD'
		else 'BAD'
		END)
		FROM Sales
		GROUP  BY Product_line
		
--Which branch sold more products than average product sold?

		SELECT  Branch,SUM(Quantity) AS qty
		FROM Sales
		GROUP BY Branch
		HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM Sales);


--What is the most common product line by gender?

		SELECT 
		Gender,
		Product_line,
		count(Gender) as total_cnt 
		FROM Sales
		GROUP BY Gender,Product_line
		ORDER BY total_cnt desc;

--What is the average rating of each product line?

	SELECT Product_line,ROUND(AVG(Rating),2) AS Avg_rating FROM Sales
	group by Product_line
	ORDER BY Avg_rating DESC;


------------------------------------------SALES---------------------------------------------------

--Number of sales made in each time of the day per weekday
	SELECT 
	Time_of_Day,
	COUNT(*) AS Total_sales
	FROM Sales
	WHERE Day_Name = 'Monday'
	GROUP BY Time_of_Day
	ORDER BY Total_sales DESC;

--Which of the customer types brings the most revenue?

	SELECT 
	Customer_type,
	SUM(Total) AS Total_Revenue 
	FROM Sales
	GROUP BY Customer_type
	ORDER BY Total_Revenue DESC;

--Which city has the largest tax percent/ VAT (Value Added Tax)?

	SELECT
	city,
	AVG(VAT) AS VAT 
	FROM Sales
	GROUP BY City
	ORDER BY VAT DESC;

	
--Which customer type pays the most in VAT?

	SELECT 
	Customer_type,
	AVG(VAT) AS VAT
	FROM Sales
	GROUP BY Customer_type;

------------------------------------CUSTOMER-----------------------------------------------------------

--How many unique customer types does the data have?
	SELECT DISTINCT(Customer_type) FROM Sales;

--How many unique payment methods does the data have?
	SELECT DISTINCT(Payment_method) FROM Sales;

--Which customer type buys the most?

	SELECT Customer_type,
	COUNT(*) AS cstm_cnt
	FROM Sales
	GROUP BY Customer_type;

--What is the gender of most of the customers?

	SELECT Gender,
	COUNT(*) AS Gender_cnt
	FROM Sales
	GROUP BY Gender;

--What is the gender distribution per branch?

	SELECT
	Gender,
	COUNT(*) AS Gender_cnt
	FROM Sales
	WHERE Branch = 'B'
	GROUP BY Gender;

--Which time of the day do customers give most ratings?

	SELECT 
	Time_of_Day,
	ROUND(AVG(Rating),2) AS MOST_RATING
	FROM Sales
	GROUP BY Time_of_Day
	ORDER BY MOST_RATING DESC;

--Which time of the day do customers give most ratings per branch?

	SELECT 
	Time_of_Day,
	ROUND(AVG(Rating),2) AS MOST_RATING
	FROM Sales
	WHERE Branch = 'B'
	GROUP BY Time_of_Day
	ORDER BY MOST_RATING DESC;


--Which day of the week has the best avg ratings?
	SELECT 
	Day_Name,
	ROUND(AVG(Rating),2) AS AVG_RATING 
	FROM Sales
	GROUP BY Day_Name
	ORDER BY AVG_RATING DESC;

--Which day of the week has the best average ratings per branch?

	SELECT 
	Day_Name,
	ROUND(AVG(Rating),2) AS AVG_RATING 
	FROM Sales
	WHERE Branch = 'B'
	GROUP BY Day_Name
	ORDER BY AVG_RATING DESC;


