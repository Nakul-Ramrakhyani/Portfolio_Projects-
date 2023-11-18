use project_portfolio;

--cleaning data in SQL queries,
select * from nashvillehousing;

---------------------------------------------------------------------------------------------------------------
--standardize Date format
ALTER TABLE nashvillehousing
ADD SaleDateConverted DATE;

UPDATE nashvillehousing
SET SaleDateConverted = CONVERT(date,SaleDate);

---------------------------------------------------------------------------------------------------------------

--Populate property address data

select * from nashvillehousing
--where propertyaddress is null;
order by parcelID

SELECT a.[UniqueID ],a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, 
ISNULL(b.PropertyAddress,a.PropertyAddress) 
FROM nashvillehousing a
JOIN nashvillehousing b
ON a.ParcelID = b.ParcelID 
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE b.PropertyAddress is null;


UPDATE b
SET propertyaddress = ISNULL(b.PropertyAddress,a.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
ON a.ParcelID = b.ParcelID 
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE b.PropertyAddress is null;

---------------------------------------------------------------------------------------------------------------
--breaking out address into individual column(address,city,state)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) + 1, LEN(propertyaddress)) AS city
FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD propertysplitaddress nvarchar(255);

UPDATE nashvillehousing
SET propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) - 1);
 
ALTER TABLE nashvillehousing
ADD propertysplitcity nvarchar(255);

UPDATE nashvillehousing
SET propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) + 1, LEN(propertyaddress));


select owneraddress from nashvillehousing;

select 
PARSENAME(REPLACE(owneraddress, ',' , '.'),3),
PARSENAME(REPLACE(owneraddress, ',' , '.'),2),
PARSENAME(REPLACE(owneraddress, ',' , '.'),1)
from nashvillehousing;



ALTER TABLE nashvillehousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',' , '.'),3);
 
ALTER TABLE nashvillehousing
ADD OwnerSplitCity nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',' , '.'),2);

ALTER TABLE nashvillehousing
ADD OwnerSplitState nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',' , '.'),1);

---------------------------------------------------------------------------------------------------------------

-- change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvillehousing
group by SoldAsVacant
order by 2;

Select SoldAsVacant, 
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
FROM nashvillehousing

UPDATE nashvillehousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
				   when SoldAsVacant = 'N' then 'No'
				   else SoldAsVacant
				   end
---------------------------------------------------------------------------------------------------------------

--Remove Duplicates
 select * ,
 ROW_NUMBER() OVER (PARTITION BY ParcelID,
					propertyaddress,
					salePrice,
					SaleDate,
					LegalReference
					ORDER BY UniqueID)
					AS ROW_NUM
					from nashvillehousing;

WITH duplicateCTE AS
(
 select * ,
 ROW_NUMBER() OVER (PARTITION BY ParcelID,
					propertyaddress,
					salePrice,
					SaleDate,
					LegalReference
					ORDER BY UniqueID)
					AS ROW_NUM
					from nashvillehousing
)
DELETE FROM duplicateCTE WHERE ROW_NUM > 1



---------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
select * from nashvillehousing

alter table nashvillehousing
drop column  Owneraddress, taxdistrict


---------------------------------------------------------------------------------------------------------------