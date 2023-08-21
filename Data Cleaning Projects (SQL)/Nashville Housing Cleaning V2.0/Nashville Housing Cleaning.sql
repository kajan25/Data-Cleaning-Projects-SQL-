SELECT * FROM Data_Cleaning_Projects..Nashville

--Change Data type of Sale Date to YYYY-MM-DD
ALTER TABLE data_Cleaning_Projects..Nashville
ALTER COLUMN [Sale Date] DATE

---Checking to see if there are any duplicates 
WITH duplicatetable AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY F1 ORDER BY F1) AS duplicate
FROM Data_Cleaning_Projects..Nashville
)
SELECT *,duplicate
FROM duplicatetable 
WHERE duplicate>1


--Checking to see if Parcel ID duplicates are actually duplicates or if they are similar based on the property address and other key attributes such as Legal Reference and UniqueID are all unique
WITH duplicatetable2 AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY [Parcel ID] ORDER BY [Parcel ID]) AS duplicate2
FROM Data_Cleaning_Projects..Nashville
)
SELECT * 
FROM duplicatetable2
WHERE duplicate2 >1


--Another way to check if theres any duplicate 
SELECT *, COUNT(*)
FROM Data_Cleaning_Projects..Nashville
GROUP BY F1, [Unnamed: 0], [Parcel ID], [Land Use], [Property Address], [Suite/ Condo   #], [Property City], [Sale Date], [Sale Price], [Legal Reference], [Sold As Vacant], [Multiple Parcels Involved in Sale], [Owner Name], Address, City, State, [Acreage], [Tax District], Neighborhood, image, [Land Value], [Building Value], [Total Value], [Finished Area], [Foundation Type], [Year Built], [Exterior Wall], Grade, Bedrooms, [Full Bath], [Half Bath]
HAVING COUNT(*)>1

-- Confirming if Columns "F1" and "Unnamed: 0" are exact duplicates 
SELECT DISTINCT a.F1, a.[Unnamed: 0]
FROM Data_Cleaning_Projects..Nashville	a
INNER JOIN Data_Cleaning_Projects..Nashville b
ON a.F1 <> b.F1 AND b.[Unnamed: 0] <> b.[Unnamed: 0]

--Remove "Unnamed: 0" column since its an exact duplicate of F1. 
ALTER TABLE Data_Cleaning_Projects..Nashville
DROP COLUMN [Unnamed: 0]



SELECT * FROM Data_Cleaning_Projects..Nashville
WHERE [Property Address] is null

--Populate Property Address to Address 

SELECT a.[Parcel ID], a.[Property Address], b.[Parcel ID], b.[Property Address], ISNULL(b.[Property Address],a.[Property Address]) AS "Property Address"
FROM Data_Cleaning_Projects..Nashville a
JOIN Data_Cleaning_Projects..Nashville b
ON a.[Parcel ID] = b.[Parcel ID] AND a.UniqueID <> b.UniqueID
WHERE a.[Property Address] is null
ORDER BY a.[Parcel ID]

UPDATE a
SET [Property Address] = ISNULL(a.[Property Address],b.[Property Address])
FROM Data_Cleaning_Projects..Nashville a
JOIN Data_Cleaning_Projects..Nashville b
ON a.[Parcel ID] = b.[Parcel ID] AND a.UniqueID <> b.UniqueID
WHERE a.[Property Address] is null

---Changing property address values to "N/A" where they are null or '0' as I do not have more information available at this time to correct it
SELECT [Property Address] 
FROM Data_Cleaning_Projects..Nashville
WHERE [Property Address] = '0'

UPDATE Data_Cleaning_Projects..Nashville
SET [Property Address] = 'N/A'
WHERE [Property Address] is null OR [Property Address] ='0'

--Removing any leading spaces 
UPDATE Data_Cleaning_Projects..Nashville
SET [Property Address] = LTRIM([Property Address])

SELECT [Suite/ Condo   #], [Land Use]
FROM Data_Cleaning_Projects..Nashville
WHERE [Suite/ Condo   #] is null
--Changing data type of suite/condo column and replacing null with "N/A"
ALTER TABLE Data_Cleaning_Projects..Nashville
ALTER COLUMN [Suite/ Condo   #] nvarchar(100)

UPDATE Data_Cleaning_Projects..Nashville
SET [Suite/ Condo   #] = 'N/A'
WHERE [Suite/ Condo   #] is null

SELECT *
FROM Data_Cleaning_Projects..Nashville


--Owner Name fixing null values

SELECT a.[Parcel ID], a.[Owner Name], b.[Parcel ID], b.[Owner Name], ISNULL(a.[Owner Name], b.[Owner Name])
FROM Data_Cleaning_Projects..Nashville a
JOIN Data_Cleaning_Projects..Nashville b
ON a.[Parcel ID] = b.[Parcel ID] AND a.UniqueID <> b.UniqueID
WHERE a.[Owner Name] is null

UPDATE Data_Cleaning_Projects..Nashville
SET [Owner Name] ='N/A' 
WHERE [Owner Name] is null


--Changing Sold As Vacant and Multiple Parcels Involved in sale scolumn from Yes and No to "Y/N" 

SELECT DISTINCT [Sold As Vacant]
FROM Data_Cleaning_Projects..Nashville

SELECT CASE
		WHEN [Sold As Vacant] = 'No' THEN 'N' ELSE 'Y' END AS "Sold As Vacant"
FROM Data_Cleaning_Projects..Nashville

UPDATE Data_Cleaning_Projects..Nashville
SET [Sold As Vacant] = CASE
		WHEN [Sold As Vacant] = 'No' THEN 'N' ELSE 'Y' END 
FROM Data_Cleaning_Projects..Nashville

SELECT DISTINCT [Multiple Parcels Involved in Sale]
FROM Data_Cleaning_Projects..Nashville

SELECT CASE
		WHEN [Multiple Parcels Involved in Sale] = 'No' THEN 'N' ELSE 'Y' END AS "Multiple Parcels Invovled in Sale"
FROM Data_Cleaning_Projects..Nashville

UPDATE Data_Cleaning_Projects..Nashville
SET [Multiple Parcels Involved in Sale] = CASE
		WHEN [Multiple Parcels Involved in Sale] = 'No' THEN 'N' ELSE 'Y' END 
FROM Data_Cleaning_Projects..Nashville


SELECT 
SUBSTRING([Property Address], 1, CHARINDEX(',',[Property Address]) -1) as Address,
SUBSTRING([Property Address], CHARINDEX(',', [Property Address]) +1, LEN([Property Address])) as Address
FROM Data_Cleaning_Projects..Nashville



SELECT [Property Address]
FROM Data_Cleaning_Projects..Nashville