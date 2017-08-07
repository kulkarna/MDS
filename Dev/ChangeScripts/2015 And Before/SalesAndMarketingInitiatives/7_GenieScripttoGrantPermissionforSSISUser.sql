--Script to Grant permission to SSIS User for SSISAccess Role for the newly created Tables and procedures in Genie db
--Nov 5 2013
USE Genie


GRANT SELECT ON  GENIE..LK_PromotionCode TO SSISACCESS
GRANT INSERT ON  GENIE..LK_PromotionCode TO SSISACCESS
GRANT DELETE ON  GENIE..LK_PromotionCode TO SSISACCESS
GRANT UPDATE ON  GENIE..LK_PromotionCode TO SSISACCESS

GRANT SELECT ON  GENIE..ST_Qualifier TO SSISACCESS
GRANT INSERT ON  GENIE..ST_Qualifier TO SSISACCESS
GRANT DELETE ON  GENIE..ST_Qualifier TO SSISACCESS
GRANT UPDATE ON  GENIE..ST_Qualifier TO SSISACCESS

GRANT SELECT ON  GENIE..T_Qualifier TO SSISACCESS
GRANT INSERT ON  GENIE..T_Qualifier TO SSISACCESS
GRANT DELETE ON  GENIE..T_Qualifier TO SSISACCESS
GRANT UPDATE ON  GENIE..T_Qualifier TO SSISACCESS


GRANT Execute ON  GENIE..SPGenie_UpdateQualifiers TO SSISACCESS
GO

USE [GENIE]
GO

----------------------
--Update the LK_Brand table for Descriptions

If exists (Select * from LK_Brand where BrandDescription is Null)
Begin
    Update LK_Brand Set BrandDescription=Brand  where BrandDescription is Null;
End

If exists (Select * from LK_Brand where BrandDescription ='SUPERSAVER')
Begin
    Update LK_Brand Set BrandDescription='SUPER SAVER'  where BrandDescription ='SUPERSAVER';
End

If exists (Select * from LK_Brand where BrandDescription ='SUPERSAVER (ABC)')
Begin
    Update LK_Brand Set BrandDescription='SUPER SAVER (ABC)'  where BrandDescription ='SUPERSAVER (ABC)';
End


GO


--------------------------------------------------------------------------------------------------------------------
-- ALter SP spGenie_UpdateQualifiers
---------------------------------------------------------------------------------------------------------------------
USE [GENIE]
GO

-- =============================================
-- Date:     10/24/2013
-- Description: Moving the records from ST_Qualifier to T_Qualifier 
-- Modified: Nov 7 2013
-- Changed the brand description to look for like than =
-- =============================================

ALTER proc [dbo].[spGenie_UpdateQualifiers] as
begin


SET NOCOUNT ON

DECLARE @DestCount INT 
DECLARE @result INT =0

Truncate Table T_Qualifier

--Since the AccountType in Libertypower is RES and in Genie Database is RESIDENTIAL
Update ST_Qualifier set AccountTypeDesc='RESIDENTIAL' where AccountTypeDesc='RES'

Insert into T_Qualifier     
Select Q.PromotionCodeID,P.PartnerID,M.MarketID,U.UtilityID,A.AccountTypeID,Q.ContractTerm,B.BrandID,Q.SignStartDate,Q.SignEndDate,
Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,S.ServiceClassID,AutoApply
 from Genie..ST_Qualifier Q  With (NoLock)
Inner  join Genie..LK_Partner P  With (NoLock) on  Q.partnerName=P.PartnerName 
LEFT join Genie..LK_Market M  With (NoLock) on Q.MarketName=M.MarketCode
LEFT join Genie..LK_Utility U  With (NoLock) on Q.UtilityName=U.UtilityCode
LEFT Join Genie..LK_AccountType A   With (NoLock) on Q.AccountTypeDesc =A.AccountType   
LEFT Join GENIE..LK_Brand B  With (NoLock) on B.BrandDescription like '%'+ Q.BrandDescription +'%' -- Modified to Like NOv 7 2013
LEFT Join Genie..LK_ServiceClass S  With (NoLock) on S.ServiceClassCode like '%'+ Q.PriceTierDescription +'%' and S.UtilityID=U.UtilityID

	Set @DestCount=@@RowCount
	
	if (@DestCount>0)
	Set @result=1
	else
	Set @result=0

Select @result as result

SET NOCOUNT OFF
end




GO
