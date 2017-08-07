

---------------------------------------------------------------------------------
--LibertyPowerDatabase
--1. usp_GetAllValidPromotionCodesforToday
--2. usp_GetAllValidQualifiersforToday
-------------------------------------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 10/25/2013 15:32:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidPromotionCodesforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 10/25/2013 15:32:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_GetAllValidPromotionCodesforToday]
*
* DEFINITION:  Selects the list of PromotionCodes records that are valid as of today
*
* RETURN CODE: Returns the PromotionCodes Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013
*/

CREATE PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Distinct Q.PromotionCodeId,P.PromotionTypeId,P.Code,P.Description,P.MarketingDescription,P.LegalDescription,P.CreatedBy,P.CreatedDate
 from LibertyPower..Qualifier  Q with (NoLock) inner Join LIbertypower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId  
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END
      
GO

------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 10/25/2013 15:48:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 10/25/2013 15:48:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[[usp_GetAllValidQualifiersforToday]]
*
* DEFINITION:  Selects the list of Qualifier records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013
*/

CREATE PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Q.QualifierId,Q.CampaignId, Q.PromotionCodeId, Q.SalesChannelId, Q.MarketId, Q.UtilityId,Q.AccountTypeId, Q.Term,
Q.ProductTypeId,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
Q.PriceTierId,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END

GO


  
---------------------------------------------------------------------------
--Lp_Deal_Capture Database
--1. spGenie_GetQualifiersforToday
----------------------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

SET ANSI_PADDING ON

--/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 10/25/2013 15:38:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenie_GetQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGenie_GetQualifiersforToday]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 10/25/2013 15:38:19 ******/
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Date:     10/24/2013
-- Description:	Getting the details from Libertypower Qualifier table and mapping them to the Genie database Qualifier Table requirements  
-- =============================================
Create proc [dbo].[spGenie_GetQualifiersforToday] as
begin

SET NOCOUNT ON

SET ANSI_PADDING ON

Select  Q.PromotionCodeId as PromotionCodeID, S.ChannelName as PartnerName,M.MarketCode as MarketName,
U.UtilityCode as UtilityName,A.AccountType as AccountTypeDesc,Q.Term as ContractTerm,
PB.Name as BrandDescription,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
DPT.Description as PriceTierDescription,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)

LEft  Join LibertyPower..SalesChannel S With (noLock) on Q.SalesChannelId=S.ChannelID
LEft  Join LibertyPower..Market M with (noLock) on Q.MarketId=M.ID 
LEft  Join Libertypower..Utility U with (noLock) on Q.UtilityId= U.ID
LEft  Join LibertyPower..AccountType A with (NoLock) on Q.AccountTypeId=A.ID
LEft  Join Libertypower..ProductType PT with (noLock) on Q.ProductTypeId=PT.ProductTypeID
LEft  Join Libertypower..ProductBrand PB with (noLock) on PT.ProductTypeID=PB.ProductTypeID
LEft  Join Libertypower..DailyPricingPriceTier DPT with (NOLock) on Q.PriceTierId=DPT.ID
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()


SET NOCOUNT OFF
end


GO


-----------------------------------------------------------------------------------------------------------------------------------------
      

