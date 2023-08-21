/*  
	1.Convert the height and weight columns to numerical forms
	2.Remove the unnecessary newline characters from all columns that have them.
	3.Based on the 'Joined' column, check which players have been playing at a club for more than 10 years!
	4.'Value', 'Wage' and "Release Clause' are string columns. Convert them to numbers. For eg, "M" in value column is Million, so multiply the row values by 1,000,000, etc.
	5.Some columns have 'star' characters. Strip those columns of these stars and make the columns numerical
	6.Which players are highly valuable but still underpaid (on low wages)? (hint: scatter plot between wage and value)   
*/
--DROP photoURL and playerURl
ALTER TABLE DATA_Cleaning_projects..FIFA21
DROP COLUMN [photoUrl]

ALTER TABLE DATA_Cleaning_projects..FIFA21
DROP COLUMN [playerUrl]

SELECT * FROM Data_Cleaning_Projects..FIFA21

--Convert the height and weight columns to numerical forms

SELECT [Weight(kg)] FROM Data_Cleaning_Projects..FIFA21


SELECT REPLACE([Weight(kg)],SUBSTRING([Weight(kg)],CHARINDEX('k', [Weight(kg)]),2),'') AS "Weight (kg)"
FROM Data_Cleaning_Projects..FIFA21


UPDATE Data_Cleaning_Projects..FIFA21
SET [Weight(kg)] = RTRIM(REPLACE([Weight(kg)],SUBSTRING([Weight(kg)],CHARINDEX('k', [Weight(kg)]),2),''))
FROM Data_Cleaning_Projects..FIFA21


SELECT [Height(cm)] FROM Data_Cleaning_Projects..FIFA21

SELECT RTRIM(REPLACE([Height(cm)],SUBSTRING([Height(cm)],CHARINDEX('c', [Height(cm)]),2),'')) AS "Height (cm)"
FROM Data_Cleaning_Projects..FIFA21


UPDATE Data_Cleaning_Projects..FIFA21
SET [Height(cm)] = RTRIM(REPLACE([Height(cm)],SUBSTRING([Height(cm)],CHARINDEX('c', [Height(cm)]),2),''))
FROM Data_Cleaning_Projects..FIFA21

--Remove the unnecessary newline characters from all columns that have them.

SELECT * FROM Data_Cleaning_Projects..FIFA21

SELECT REPLACE(REPLACE(Name, CHAR(195), ''),CHAR(169),'e') AS NameFixed 
FROM Data_Cleaning_Projects..FIFA21

SELECT *
FROM Data_Cleaning_Projects..FIFA21
WHERE CHARINDEX(CHAR(10), ID)>0

SELECT *
FROM Data_Cleaning_Projects..FIFA21
WHERE CHARINDEX(CHAR(10), Name)>0

SELECT *
FROM Data_Cleaning_Projects..FIFA21
WHERE CHARINDEX(CHAR(10), LongName)>0

SELECT *
FROM Data_Cleaning_Projects..FIFA21
WHERE CHARINDEX(CHAR(10), photoUrl)>0

SELECT *
FROM Data_Cleaning_Projects..FIFA21
WHERE CHARINDEX(CHAR(10), playerUrl)>0

SELECT *
FROM Data_Cleaning_Projects..FIFA21
WHERE CHARINDEX(CHAR(10), Nationality)>0

--The statement above is done for all columns to find any newline characters 

--Based on the 'Joined' column, check which players have been playing at a club for more than 10 years!
ALTER TABLE Data_Cleaning_Projects..FIFA21
ALTER COLUMN Joined DATE


WITH YearsPlayed AS
(
SELECT Name, Joined, DATEDIFF(year, Joined, CAST(GETDATE() AS DATE)) AS Years
FROM Data_Cleaning_Projects..FIFA21
)
SELECT Name, Joined, Years  
FROM YearsPlayed
WHERE Years >10
ORDER BY Years DESC


-- 'Value', 'Wage' and "Release Clause' are string columns. Convert them to numbers. For eg, "M" in value column is Million, so multiply the row values by 1,000,000, etc.
/* VALUES */
SELECT Value, Wage, [Release Clause]
FROM Data_Cleaning_Projects..FIFA21


SELECT Value 
FROM Data_Cleaning_Projects..FIFA21

SELECT LTRIM(REPLACE(REPLACE(REPLACE(Value,CHAR(226),''),CHAR(172),''),CHAR(130),'')) AS ValueFixed
FROM Data_Cleaning_Projects..FIFA21

UPDATE Data_Cleaning_Projects..FIFA21
SET Value =LTRIM(REPLACE(REPLACE(REPLACE(Value,CHAR(226),''),CHAR(172),''),CHAR(130),'')) 

SELECT CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float) as FixedValue
FROM Data_Cleaning_Projects..FIFA21


SELECT Value, REPLACE(Value,SUBSTRING(Value,CHARINDEX('K', Value),1),'') as FixedValue
FROM Data_Cleaning_Projects..FIFA21

SELECT CASE	
			WHEN Value LIKE '%K' THEN CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float)*1000
			ELSE CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float)*1000000
			END AS FixedValue
FROM Data_Cleaning_Projects..FIFA21


--Backup table to check the update statement..everything seems good!!
/* SELECT * INTO Data_Cleaning_Projects..FIFA21Backup1 FROM Data_Cleaning_Projects..FIFA21


SELECT Value 
FROM Data_Cleaning_Projects..FIFA21Backup1

UPDATE Data_Cleaning_Projects..FIFA21Backup1
SET Value =  CASE	
			WHEN Value LIKE '%K' THEN CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float)*1000
			ELSE CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float)*1000000
			END 
FROM Data_Cleaning_Projects..FIFA21Backup1

ALTER TABLE Data_Cleaning_Projects..FIFA21Backup1
ALTER COLUMN Value float */ 

---Actual table updating 
SELECT Value 
FROM Data_Cleaning_Projects..FIFA21

UPDATE Data_Cleaning_Projects..FIFA21
SET Value =  CASE	
			WHEN Value LIKE '%K' THEN CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float)*1000
			ELSE CAST(REPLACE(Value,SUBSTRING(Value,PATINDEX('%[MK]%', Value),1),'') AS float)*1000000
			END 
FROM Data_Cleaning_Projects..FIFA21

ALTER TABLE Data_Cleaning_Projects..FIFA21
ALTER COLUMN Value float

/* Wage */

SELECT Wage
FROM Data_Cleaning_Projects..FIFA21

SELECT LTRIM(REPLACE(REPLACE(REPLACE(Wage,CHAR(226),''),CHAR(172),''),CHAR(130),'')) AS WageFixed
FROM Data_Cleaning_Projects..FIFA21

UPDATE Data_Cleaning_Projects..FIFA21
SET Wage =LTRIM(REPLACE(REPLACE(REPLACE(Wage,CHAR(226),''),CHAR(172),''),CHAR(130),'')) 

SELECT CAST(REPLACE(Wage,SUBSTRING(Wage,PATINDEX('%[MK]%', Wage),1),'') AS float) as FixedValue
FROM Data_Cleaning_Projects..FIFA21


SELECT CASE	
			WHEN Wage LIKE '%K' THEN CAST(REPLACE(Wage,SUBSTRING(Wage,PATINDEX('%[MK]%', Wage),1),'') AS float)*1000
			ELSE CAST(REPLACE(Wage,SUBSTRING(Wage,PATINDEX('%[MK]%', Wage),1),'') AS float)
			END AS FixedWage
FROM Data_Cleaning_Projects..FIFA21

UPDATE Data_Cleaning_Projects..FIFA21
SET Wage = CASE	
			WHEN Wage LIKE '%K' THEN CAST(REPLACE(Wage,SUBSTRING(Wage,PATINDEX('%[MK]%', Wage),1),'') AS float)*1000
			ELSE CAST(REPLACE(Wage,SUBSTRING(Wage,PATINDEX('%[MK]%', Wage),1),'') AS float)
			END 
FROM Data_Cleaning_Projects..FIFA21

ALTER TABLE Data_Cleaning_Projects..FIFA21
ALTER COLUMN Wage float


/* Release Clause */

SELECT [Release Clause]
FROM Data_Cleaning_Projects..FIFA21

SELECT LTRIM(REPLACE(REPLACE(REPLACE([Release Clause],CHAR(226),''),CHAR(172),''),CHAR(130),'')) AS ReleaseClauseFixed
FROM Data_Cleaning_Projects..FIFA21

UPDATE Data_Cleaning_Projects..FIFA21
SET [Release Clause] =LTRIM(REPLACE(REPLACE(REPLACE([Release Clause],CHAR(226),''),CHAR(172),''),CHAR(130),'')) 

SELECT CAST(REPLACE([Release Clause],SUBSTRING([Release Clause],PATINDEX('%[MK]%', [Release Clause]),1),'') AS float) as ReleaseClauseFixed
FROM Data_Cleaning_Projects..FIFA21


SELECT CASE	
			WHEN [Release Clause] LIKE '%K' THEN CAST(REPLACE([Release Clause],SUBSTRING([Release Clause],PATINDEX('%[MK]%', [Release Clause]),1),'') AS float)*1000
			ELSE CAST(REPLACE([Release Clause],SUBSTRING([Release Clause],PATINDEX('%[MK]%', [Release Clause]),1),'') AS float)*1000000
			END AS ReleaseClause
FROM Data_Cleaning_Projects..FIFA21

UPDATE Data_Cleaning_Projects..FIFA21
SET [Release Clause] = CASE
			WHEN [Release Clause] LIKE '%K' THEN CAST(REPLACE([Release Clause],SUBSTRING([Release Clause],PATINDEX('%[MK]%', [Release Clause]),1),'') AS float)*1000
			ELSE CAST(REPLACE([Release Clause],SUBSTRING([Release Clause],PATINDEX('%[MK]%', [Release Clause]),1),'') AS float) * 1000000
			END
FROM Data_Cleaning_Projects..FIFA21

ALTER TABLE Data_Cleaning_Projects..FIFA21
ALTER COLUMN [Release Clause] float

SELECT Value, Wage, [Release Clause]
FROM Data_Cleaning_Projects..FIFA21

--Some columns have 'star' characters. Strip those columns of these stars and make the columns numerical


SELECT * FROM Data_Cleaning_Projects..FIFA21


CREATE FUNCTION showASCII(@string VARCHAR(100))
returns varchar(100)
AS
BEGIN
   DECLARE @length smallint = LEN(@string)
   DECLARE @position smallint = 0
   DECLARE @codes varchar(max) = ''
 
   WHILE @length >= @position
   BEGIN
      SELECT @codes = @codes + CONCAT(ASCII(SUBSTRING(@string,@position,1)),',')
      SELECT @position = @position + 1
   END
 
   SELECT @codes = SUBSTRING(@codes,2,LEN(@codes)-2)
   RETURN @codes
END

SELECT Name, dbo.showASCII(Name) AS codes
FROM Data_Cleaning_Projects..FIFA21


--Which players are highly valuable but still underpaid (on low wages)?

SELECT Name, Value, Wage 
FROM Data_Cleaning_Projects..FIFA21
WHERE VALUE <> 0 and WAGE <>0
ORDER BY WAGE ASC, VALUE DESC


