/*
Clearing Data in SQL Queries

*/
select * from PortfolioProject.dbo.NashvilleHousing
---------------------------------------------------------
--Standardise Data Format

select SaleDateConverted,convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
Set SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted  Date;


update NashvilleHousing
Set SaleDateConverted =CONVERT(Date,SaleDate)

Select SaleDateConverted from NashvilleHousing
---------------------------------------------------------------------------
--Populate Property Address Data

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------------------------------------------------------------------------------
--Breaking out address into individual coloumns(Address,city,State)


select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing 

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress) )as Address

from PortfolioProject.dbo.NashvilleHousing  

ALTER TABLE NashvilleHousing
Add PropertySplitAddress  varchar(255);


update NashvilleHousing
Set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity  varchar(255);


update NashvilleHousing
Set PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select * from NashvilleHousing

select OwnerAddress from NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress  varchar(255);


update NashvilleHousing
Set OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity  varchar(255);


update NashvilleHousing
Set OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState  varchar(255);


update NashvilleHousing
Set OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',','.'),1)



select * from NashvilleHousing

-----------------------------------------------------------------------------------------
--Change Y and N to Yes and No  in 'Sold as Vacant field'

Select 
DISTINCT(SoldAsVacant),COUNT(SoldAsVacant) 
from NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


Select SoldAsVacant
,CASE when SoldAsVacant= 'Y' Then 'Yes'
      when SoldAsVacant= 'N' Then 'No'
      else SoldAsVacant
      END
from NashvilleHousing

UPDATE NashvilleHousing
set SoldAsVacant=CASE when SoldAsVacant= 'Y' Then 'Yes'
      when SoldAsVacant= 'N' Then 'No'
      else SoldAsVacant
      END


-------------------------------------------------------------------------------------------------
--Remove Duplicates
WITH RowNumCTE As(
select *,
ROW_NUMBER()OVER(
PARTITION BY ParcelId,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
Order By UniqueId)row_num
from NashvilleHousing
--order by ParcelId
)
--delete--
select * from RowNumCTE
where row_num >1
--order by PropertyAddress


select * from NashvilleHousing



-------------------------------------------------------------------------------------------------
--Delete Unused  Coloumns

select * from NashvilleHousing

ALTER TABLE  NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress


ALTER TABLE  NashvilleHousing
DROP COLUMN SaleDate