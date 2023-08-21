SELECT * FROM Data_Cleaning_Projects..BikeSales

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Data_Cleaning_Projects..BikeSales'


--Checking for empty/null values 
SELECT * 
FROM Data_Cleaning_Projects..BikeSales
WHERE "Sales_Order #" IS NULL OR Date IS NULL OR Day IS NULL OR Month IS NULL OR Year IS NULL OR Customer_Age IS NULL OR Age_Group IS NULL OR Customer_Gender IS NULL OR Country IS NULL OR State IS NULL OR Product_Category IS NULL OR Sub_Category IS NULL OR Product_Description IS NULL OR Order_Quantity IS NULL OR Unit_Cost IS NULL OR Unit_Price IS NULL OR Profit IS NULL OR Cost IS NULL OR Revenue IS NULL

SELECT *,COUNT(*) 
FROM Data_Cleaning_Projects..BikeSales
GROUP BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue
HAVING [Sales_Order #]='000261704'

UPDATE Data_Cleaning_Projects..BikeSales
SET Day = DAY(Date)
WHERE [Sales_Order #]='000261704'


SELECT *,COUNT(*) 
FROM Data_Cleaning_Projects..BikeSales
GROUP BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue
HAVING [Sales_Order #]='000261709'

UPDATE Data_Cleaning_Projects..BikeSales
SET Age_Group ='Adults (35-64)'
WHERE [Sales_Order #]='000261709' AND Age_Group is NULL


SELECT *,COUNT(*) AS Duplicate
FROM Data_Cleaning_Projects..BikeSales
GROUP BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue
HAVING [Sales_Order #]='000261715' AND State='Oregon'

UPDATE Data_Cleaning_Projects..BikeSales
SET Product_Description ='N/A'
WHERE [Sales_Order #]='000261715' AND Product_Description is NULL

SELECT *,COUNT(*) AS Duplicate
FROM Data_Cleaning_Projects..BikeSales
GROUP BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue
HAVING [Sales_Order #]='000261716'

UPDATE Data_Cleaning_Projects..BikeSales
SET Order_Quantity = 1
WHERE [Sales_Order #] ='000261716' AND Order_Quantity IS NULL

----Fixing Cost, Profit, Revenue where there is zero values 
SELECT *, COUNT(*)
FROM Data_Cleaning_Projects..BikeSales
WHERE Profit = 0.00 OR Cost =0.00 OR Revenue = 0.00 OR [Unit_Cost ]=0.00
GROUP BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue

UPDATE Data_Cleaning_Projects..BikeSales
SET [Cost ] = Revenue - [Profit ] 
WHERE [Sales_Order #]='000261699' AND [Cost ]=0.00

UPDATE Data_Cleaning_Projects..BikeSales
SET [Unit_Cost ] = [Cost ]/Order_Quantity 
WHERE [Sales_Order #]='000261699' AND [Unit_Cost ]=0.00

SELECT * FROM Data_Cleaning_Projects..BikeSales
WHERE [Sales_Order #]='000261702'

UPDATE Data_Cleaning_Projects..BikeSales
SET Revenue = [Cost ] + [Profit ]
WHERE [Sales_Order #]='000261702' AND Revenue=0.00

UPDATE Data_Cleaning_Projects..BikeSales
SET [Unit_Price ] = [Profit ] / Order_Quantity
WHERE [Sales_Order #]='000261702' AND [Unit_Price ]=0.00


SELECT * FROM Data_Cleaning_Projects..BikeSales
WHERE [Sales_Order #]='000261716'

UPDATE Data_Cleaning_Projects..BikeSales
SET [Cost ] = 295.00
WHERE [Sales_Order #]='000261716' AND [Cost ]=0.00

UPDATE Data_Cleaning_Projects..BikeSales
SET Revenue = [Profit ]+[Cost ]
WHERE [Sales_Order #]='000261716' AND Revenue=0.00


--- Removing any duplicates in the data.
SELECT *,COUNT(*) AS DuplicateCount
FROM Data_Cleaning_Projects..BikeSales
GROUP BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue
HAVING COUNT(*)>1 

SELECT [Sales_Order #], COUNT(*)
FROM Data_Cleaning_Projects..BikeSales
GROUP BY [Sales_Order #]
HAVING [Sales_Order #] ='000261701' AND COUNT(*)>1

-- USING CTE and ROW_NUMBER() to remove duplicate records.
WITH CTEte AS (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY "Sales_Order #", Date, Day, Month, Year, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product_Description, Order_Quantity, Unit_Cost , Unit_Price , Profit , Cost , Revenue 
									ORDER BY [Sales_Order #]) AS DuplicateCount
	FROM Data_Cleaning_Projects..BikeSales
	)
DELETE FROM CTEte
WHERE DuplicateCount >1


----- Ensuring that Sales_Order # is unique, could not have any duplicates. 

WITH CTE2 AS(
SELECT *, ROW_NUMBER() OVER ( PARTITION BY [Sales_Order #] ORDER BY [Sales_Order #] ) DuplicateCount
FROM Data_Cleaning_Projects..BikeSales
)
UPDATE CTE2
SET [Sales_Order #] ='000261696'
WHERE DuplicateCount >1 AND [Sales_Order #] = '000261695'

SELECT * FROM Data_Cleaning_Projects..BikeSales

WITH CTE2 AS(
SELECT *, ROW_NUMBER() OVER ( PARTITION BY [Sales_Order #] ORDER BY [Sales_Order #] ) DuplicateCount
FROM Data_Cleaning_Projects..BikeSales
)
SELECT * FROM CTE2 


---Checking and updating any spelling mistakes.

SELECT * FROM Data_Cleaning_Projects..BikeSales

SELECT DISTINCT Month 
FROM Data_Cleaning_Projects..BikeSales

UPDATE Data_Cleaning_Projects..BikeSales
SET Month = 'December'
WHERE Month ='Decmber'

SELECT DISTINCT Country
FROM Data_Cleaning_Projects..BikeSales

UPDATE Data_Cleaning_Projects..BikeSales
SET Country = LTRIM(country)

-- To replace middle values/spaces you can use REPLACE(column_name(SUBSTRING()) statement

UPDATE Data_Cleaning_Projects..BikeSales
SET Country = REPLACE(Country,SUBSTRING(Country,7,1),'') 
WHERE Country = 'United  States'

SELECT DISTINCT Product_Category,Sub_Category,Product_Description FROM Data_Cleaning_Projects..BikeSales

SELECT * FROM Data_Cleaning_Projects..BikeSales