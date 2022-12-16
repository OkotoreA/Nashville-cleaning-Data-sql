/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio project database].[dbo].[Nashville housing]


  ---- CLEANING DATA IN SQL 

  Select * from dbo.[Nashville housing]

  ---- standardizer data time format
  select SaleDate, Convert(Date, SaleDate) from dbo.[Nashville housing]
 

  Alter table [Nashville housing]
  Add  SaleDateC2 Date;
  
  update [Nashville housing]
  Set SaleDateC2= convert(Date,SaleDate)

  ----- POPULATE  PROPERTY ADDRESS
  Select PropertyAddress from dbo.[Nashville housing]
  --where PropertyAddress is Null
  order by (ParcelID)

  Select a.ParcelID, a.PropertyAddress, b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  from dbo.[Nashville housing]a
  join dbo.[Nashville housing]b
  on a.ParcelID=b.ParcelID
  AND a.[UniqueID]<>b.[UniqueID]
  where a.PropertyAddress is Null

  update a
  SET PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
  from dbo.[Nashville housing]a
  join dbo.[Nashville housing]b
  on a.ParcelID=b.ParcelID
  AND a.[UniqueID]<>b.[UniqueID]
  where a.PropertyAddress is Null

  ----Breaking out Address into the individual column (Address, city, state )

  Select
  Substring( PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
  ,Substring( PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len (PropertyAddress)) as Address
   
  from dbo.[Nashville housing]

    ----- POPULATE  PROPERTY ADDRESS
  Select PropertyAddress from dbo.[Nashville housing]
  --where PropertyAddress is Null
  order by (ParcelID)




 Alter TABLE dbo.[Nashville housing]
 ADD PropertySplitAddress Nvarchar(255);

  update dbo.[Nashville housing] 
  set PropertySplitAddress= Substring( PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

  Alter TABLE dbo.[Nashville housing]
  ADD PropertySplitCity NvarChar(255);

  update dbo.[Nashville housing]
  Set PropertySplitCity = Substring( PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len (PropertyAddress))


  Select * from dbo.[Nashville housing]

  Select OwnerAddress
  from DBO.[Nashville housing]

    Select OwnerAddress
  from DBO.[Nashville housing]

  Select 
  PARSENAME(Replace(OwnerAddress, ',', ',') , 3)
   ,PARSENAME(Replace (OwnerAddress, ',', ',') , 3)
    ,PARSENAME(Replace(OwnerAddress, ',', ',') , 3)
From dbo.[Nashville housing]


Alter TABLE dbo.[Nashville housing]
 ADD OwnerSplitAddress Nvarchar(255);

  update dbo.[Nashville housing] 
  set OwnerSplitAddress= PARSENAME(Replace(OwnerAddress, ',', ',') , 3)
 
 Alter TABLE dbo.[Nashville housing]
  ADD OwnerSplitCity NvarChar(255);

  update dbo.[Nashville housing]
  Set OwnerSplitCity =PARSENAME(Replace(OwnerAddress, ',', ',') , 3)


  Select Distinct(SoldAsVacant), count(SoldAsVacant)
  from dbo.[Nashville housing]
  Group by SoldAsVacant
  order by 2



  Select SoldAsVacant,
  Case When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
	   from dbo.[Nashville housing]

Update dbo.[Nashville housing]
	   SET SoldAsVacant = CASE When SoldAsVacant= 'Y' THEN 'YES'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
	   from dbo.[Nashville housing]


	   ----- Remove Duplicate 

	   Select *, 
	   Row_Number() OVER (
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					LegalReference
					Order By 
					UniqueID) row_num

from dbo.[Nashville housing]
---order by ParcelID)

Using CTE 
WITH RowNumCTE AS(
  Select *, 
	   Row_Number() OVER (
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					LegalReference
					Order By 
					UniqueID) row_num

from dbo.[Nashville housing] )
---order by ParcelID)

Select* From RowNumCTE
where row_num >1
Order by propertyAddress


---Using Delete Unused Columns
Select* from dbo.[Nashville housing]
Alter Table dbo.[Nashville housing]
drop column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate
