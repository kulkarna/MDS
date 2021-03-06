USE [Genie]
GO
/****** Object:  StoredProcedure [dbo].[spGenie_UpdateRates]    Script Date: 07/01/2014 10:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[spGenie_UpdateRates]

AS
BEGIN

-- Located on genie

SET NOCOUNT ON

DECLARE @RateExpirationDate DATETIME;

SELECT @RateExpirationDate = MAX(RateExpirationDate) FROM ST_Rates R -- WHERE R.RateExpirationDate < '9000-01-01'

DECLARE @PromptMonth datetime 

SELECT @PromptMonth=PromptMonth FROM LK_PromptMonth WHERE CurrentDate=CONVERT(varchar(10),@RateExpirationDate,101)

DELETE FROM ST_Rates WHERE RateExpirationDate < @RateExpirationDate
DELETE FROM ST_Rates Where FlowStartMonth  < @PromptMonth


DELETE FROM T_TransferPrice
DELETE FROM M_Brand 



-- get AccountTypes

--Commented to prevent setting LPAccountType to default value 1, This never changes.
/*
DELETE FROM LK_AccountType 

UPDATE a  
Set AccountType=b.AccountType, AccountTypeDescription=b.Accounttype
FROM LK_AccountType a inner join
(SELECT distinct AccountTypeID, AccountType FROM ST_Rates) b
on a.AccountTypeID=b.AccountTypeID

INSERT INTO LK_AccountType (AccountTypeID, AccountType, AccountTypeDescription, AccountGroup)
SELECT Distinct AccountTypeID, AccountType, AccountType, '' FROM ST_Rates
WHERE AccountTypeID not in (SELECT AccountTypeID FROM LK_AccountType)
*/
-- get Brands
INSERT INTO LK_Brand (Brand, BrandDescription)
SELECT a.Brand, a.Brand FROM
(SELECT distinct Brand FROM ST_Rates) a
Left join (SELECT Brand FROM LK_Brand) b
on a.Brand=b.Brand
WHERE b.brand is NULL

-- get partnerNames
Insert INTO LK_partner (partnerName, PartnerDescription)
SELECT a.PartnerName, a.partnerName FROM
(SELECT distinct PartnerName FROM ST_Rates) a
left join
LK_Partner b
on a.Partnername=b.Partnername
WHERE b.partnerName is NULL


-- get Zones
INSERT INTO LK_Zone (ISOID,ZoneCode)
SELECT a.ISOID, a.ZoneCode FROM
(SELECT distinct ISOID,ZoneCode   FROM ST_Rates a
inner join
LK_Utility b
on a.UtilityCode =b.UtilityCode 
) a
left join
LK_Zone b
on a.ISOID=b.ISOID and a.ZoneCode=b.ZoneCode 
WHERE b.ISOID is Null 


-- markets/utilities need to be setup manually

--Service Class

INSERT INTO LK_ServiceClass (ServiceClassCode, utilityID)
SELECT a.ServiceClassCode, b.UtilityID 
FROM
(SELECT distinct UtilityCode, ServiceClassCode FROM ST_Rates) a
inner join
LK_Utility b
on a.UtilityCode=b.UtilityCode 
left join
LK_ServiceClass c
	on b.UtilityID=c.UtilityID
and a.ServiceClassCode=c.ServiceClassCode
WHERE c.ServiceClassCode is NULL

-- M_Brand

DELETE FROM m_Brand 
INSERT INTO M_Brand (BrandID, UtilityID, AccountTypeID)
SELECT BrandID, UtilityID, AccountTypeID
FROM
(
	SELECT distinct UtilityCode, Brand ,AccountTypeID 
	FROM ST_Rates
) a
inner join
LK_Utility b
on a.UtilityCode=b.UtilityCode
inner join
LK_Brand c
on a.Brand=c.Brand 



-- Rates

DECLARE @SourceCount INT 
DECLARE @DestCount INT 

SELECT @SourceCount =COUNT(1) FROM ST_Rates

INSERT INTO T_Transferprice
SELECT	rateid, RateSELECTion, ProductSELECTion, b.PartnerID, AccountTypeID, 
		MarketID, d.UtilityID, BrandID, ZoneID 
		, g.ServiceClassID, FlowStartMonth,  ContractTerm, TransferRate
	FROM ST_Rates a
	inner join
	LK_Partner b
	on a.PartnerName=b.PartnerName 
	inner join
	LK_Market c
	on a.MarketCode=c.MarketCode 
	inner join
	LK_Utility d
	on a.UtilityCode=d.UtilityCode 
	inner join
	LK_Brand e
	on a.Brand=e.Brand   
	inner join
	LK_Zone f
	on a.ZoneCode=f.ZoneCode 
	and d.ISOID=f.ISOID
	inner join
	LK_ServiceClass g
	on d.UtilityID=g.UtilityID
	and a.ServiceClassCode=g.ServiceClassCode 
	
	Set @DestCount=@@RowCount

/*	The code was disabled on request of Nakisha and Suresh, with approval by Doug Siebert and Steve Barr 6/20/2012

	if (@SourceCount=@DestCount)
	SELECT 1 as result
	else
	SELECT 0 as result
*/	

/*	The code was added on request of Nakisha and Suresh, with approval by Doug Siebert and Steve Barr 6/20/2012 */

	SELECT 1 as result
	
  
end
