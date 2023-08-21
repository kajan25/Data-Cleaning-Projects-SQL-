SELECT * FROM PortfolioProject..NashvilleHousing

/* 
Cleaning Data in SQL Queriers

*/

---------------------------------------------

-- Standardize Date Format

ALTER TABLE PortfolioProject..NashvilleHousing
ALTER Column SaleDate Date

SELECT * FROM PortfolioProject..NashvilleHousing

---------------------------------------------

-- Populate Property Address Data

SELECT * 
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


---------------------------------------------
--Breaking out Address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing
 
ALTER TABLE PortfolioProject..Nashvillehousing
Add PropertyStAddress NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertyStAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE PortfolioProject..Nashvillehousing
Add PropertyCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
SELECT*FROM PortfolioProject..NashvilleHousing

--ALTER TABLE PortfolioProject..NashvilleHousing
----DROP COLUMN OwnerStAddress, OwnerCity, OwnerState, City

-- USING PARSENAME TO split a column into multiple columns

SELECT OwnerAddress 
FROM PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3) as OwnderStAddress,
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2) as OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1) as OwnerState
FROM PortfolioProject..NashvilleHousing

--SELECT PropertyAddress 
--FROM PortfolioProject..NashvilleHousing

--SELECT
--PARSENAME(REPLACE(PropertyAddress, ',' ,'.'), 2),
--PARSENAME(REPLACE(PropertyAddress, ',' ,'.'), 1)
--FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..Nashvillehousing
Add OwnerStAddress NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerStAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)

ALTER TABLE PortfolioProject..Nashvillehousing
Add OwnerCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)


ALTER TABLE PortfolioProject..Nashvillehousing
Add OwnerState NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)


SELECT*FROM PortfolioProject..NashvilleHousing


---------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
Order by 2


SELECT SoldAsVacant, 
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


------------------------------------------------------------------------------------------------
--Remove Duplicates
-- ALways Store your duplicate data within a temporary table before removing .... For precautionary reasons. 
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) as row_num
FROM PortfolioProject..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num >1

-- Delete Unneccessary Columns
SELECT * FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict
