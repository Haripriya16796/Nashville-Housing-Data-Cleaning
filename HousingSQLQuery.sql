/*
Cleaning Data in SQL Queries
*/

select * from PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDate from PortfolioProject.dbo.NashvilleHousing

Select SaleDate , convert(Date,SaleDate) from PortfolioProject.dbo.NashvilleHousing

--update PortfolioProject.dbo.NashvilleHousing set SaleDate = CONVERT(Date,SaleDate)

alter table PortfolioProject.dbo.NashvilleHousing add SaleDateConverted Date;

update PortfolioProject.dbo.NashvilleHousing set SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted from PortfolioProject.dbo.NashvilleHousing



Select PropertyAddress from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Saperating Address, City, State

select PropertyAddress from PortfolioProject.dbo.NashvilleHousing
select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

--create new columns

--Split Property Address Column

alter table PortfolioProject.dbo.NashvilleHousing add PropertySplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

alter table PortfolioProject.dbo.NashvilleHousing add PropertySplitCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))

select * from PortfolioProject.dbo.NashvilleHousing

select OwnerAddress from PortfolioProject.dbo.NashvilleHousing

--Split Property OwnerAddress Column

select 
PARSENAME(replace(OwnerAddress,',','.'),3)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing add OwnerSplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

alter table PortfolioProject.dbo.NashvilleHousing add OwnerSplitCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

alter table PortfolioProject.dbo.NashvilleHousing add OwnerSplitState Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

select * from PortfolioProject.dbo.NashvilleHousing

-- Change the N and Y in SoldAsVacant to Yes and No

select distinct(SoldAsVacant),count(SoldAsVacant) from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
from PortfolioProject.dbo.NashvilleHousing
				
update PortfolioProject.dbo.NashvilleHousing 
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end

--Remove Duplicates

WITH RowNumCTE as(
select *,
	ROW_NUMBER() over(
	PARTITION by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

select * from RowNumCTE
where row_num > 1

--Delete excess columns

select * from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate





