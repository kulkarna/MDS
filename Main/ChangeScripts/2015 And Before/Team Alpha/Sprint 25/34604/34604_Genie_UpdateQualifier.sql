USE [GENIE]
GO
/****** Object:  StoredProcedure [dbo].[spGenie_UpdateQualifiers]    Script Date: 02/28/2014 11:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Date:     10/24/2013
-- Description: Moving the records from ST_Qualifier to T_Qualifier 

--Modified the Brand Description to fetch from the mapping table
--NOv 8 2013


--Modified : Defaulting to return 1 as in Ujpdate_rates proc. 
--Since the entity framework is not able to get the result based on rowcount
--Feb 28 2014
-- =============================================

ALTER proc [dbo].[spGenie_UpdateQualifiers] as
begin

SET NOCOUNT ON;

DECLARE @DestCount INT 
DECLARE @result INT =0

DELETE FROM T_Qualifier

--Since the AccountType in Libertypower is RES and in Genie Database is RESIDENTIAL
Update ST_Qualifier set AccountTypeDesc='RESIDENTIAL' where AccountTypeDesc='RES'

Insert into T_Qualifier 
(
 PromotionCodeID
,PartnerID
,MarketID
,UtilityID
,AccountTypeID
,ContractTerm
,BrandID
,SignStartDate
,SignEndDate
,ContractEffecStartPeriodStartDate
,ContractEffecStartPeriodLastDate
,ServiceClassID
,AutoApply
)  
Select 
	Q.PromotionCodeID
,	P.PartnerID
,	M.MarketID
,	U.UtilityID
,	A.AccountTypeID
,	Q.ContractTerm
,	B.[GenieBrandId]
,	Q.SignStartDate
,	Q.SignEndDate
,	Q.ContractEffecStartPeriodStartDate
,	Q.ContractEffecStartPeriodLastDate
,	S.ServiceClassID
,	AutoApply
 from Genie..ST_Qualifier Q  With (NoLock)
Inner  join Genie..LK_Partner P  With (NoLock) on  Q.partnerName=P.PartnerName 
LEFT join Genie..LK_Market M  With (NoLock) on Q.MarketName=M.MarketCode
LEFT join Genie..LK_Utility U  With (NoLock) on Q.UtilityName=U.UtilityCode
LEFT Join Genie..LK_AccountType A   With (NoLock) on Q.AccountTypeDesc =A.AccountType   
LEFT Join GENIE..[LK_Genie_LP_Brand_Mapping] B  With (NoLock) on Q.BrandDescription=B.LPBrandDescription 
LEFT Join Genie..LK_ServiceClass S  With (NoLock) on S.ServiceClassCode like '%'+ Q.PriceTierDescription +'%' and S.UtilityID=U.UtilityID
ORDER BY Q.ID

	Set @DestCount=@@RowCount

    --if (@DestCount>0)
    --Set @result=1
    --else
    --Set @result=0

Select 1 as result

SET NOCOUNT OFF;
end
