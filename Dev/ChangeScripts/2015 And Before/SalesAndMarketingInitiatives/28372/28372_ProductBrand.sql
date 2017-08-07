--Independence Plan (FIXED)= 1
--Super Saver (FIXED) = 2
--Custom Fixed (FIXED)=8
--Freedom To Save (FIXED)=13
--Fixed IL Wind (GREEN)
--Fixed National Green E (GREEN)
--Fixed CT Green (GREEN)
--Fixed MD Green (GREEN)
--Fixed PA Green (GREEN)

---------------------------------------------------------------------------
--28372: (Phase 3) As a Marketing Manager I need to Update the Product Type filter to be for Product Brand instead 
--so that i can create Promotion codes by products instead of Product types
------------------------------------------------------------------------------
Use LibertyPower
Go
sp_RENAME 'Qualifier.ProductTypeId','ProductBrandId','COLUMN'
Go

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_ProductType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_ProductType]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_ProductBrand] FOREIGN KEY([ProductBrandId])
REFERENCES [dbo].[ProductBrand] ([ProductBrandID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_ProductBrand]
GO
-------------------------------------------------------
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 12/10/2013 10:26:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
*
* PROCEDURE:	[usp_QualifierByPromoCodeandDeterminentsSelect]
*
* DEFINITION:  Selects the list of qualifier records that satisfy the given conditions
*
* RETURN CODE: Returns the Qualifier Information for the given PromoCode and Determinents
*
* REVISIONS:	Sara lakshamanan 9/20/2013
-----------------------------------------------------------------------------------
--Modified: Sara Lakshmanan Oct 29 2013
--modified the term condition to be <=
--Modified: Sara Lakshmanan DEc 10 2013
--modified ProductTypeId to ProductBrandId
---------------------------------------------------------------------------
*/

ALTER PROCEDURE [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]
	 @p_PromotionCode char(20), @p_SignDate datetime, @p_SalesChannelId int= null, @p_MarketId int=null,
	  @p_UtilityId int = null,@p_AccountTypeId int=null,  @p_Term int=null,
 @p_ProductBrandId int=null, @p_PriceTier int=null, @p_ContractStartDate datetime=null  
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Q.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LibertyPower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId
where
Ltrim(Rtrim(P.Code))=Ltrim(Rtrim(@p_PromotionCode)) and
 Q.SignStartDate<=@p_SignDate and Q.SignEndDate>=@p_SignDate
and (Q.SalesChannelId=@p_SalesChannelId or Q.SalesChannelId is Null)
and (Q.MarketID=@p_MarketId or Q.MarketId is Null)
and (Q.UtilityId=@p_UtilityId or Q.UtilityId is Null)
and (Q.AccountTypeId=@p_AccountTypeId or Q.AccountTypeId is Null)
--and (Q.Term=@p_Term or Term is Null)
and (Q.Term<=@p_Term or Term is Null)
and (Q.ProductBrandId=@p_ProductBrandId or Q.ProductBrandId is Null)
and (Q.PriceTierID=@p_PriceTier or Q.PriceTierID is Null)
and ((Q.ContractEffecStartPeriodStartDate<=@p_ContractStartDate and Q.ContractEffecStartPeriodLastDate>=@p_ContractStartDate)
	    or (Q.ContractEffecStartPeriodStartDate is Null and Q.ContractEffecStartPeriodLastDate is Null))


Set NOCOUNT OFF;
END
GO

      
-------------------------------------------------------------------
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 12/10/2013 10:29:15 ******/
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
--------------------------------------------------------------------------
--Modified Dec 10 2013
--Sara -- Change productType to productBrand
-------------------------------------------------------------------------


ALTER PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Q.QualifierId,Q.CampaignId, Q.PromotionCodeId, Q.SalesChannelId, Q.MarketId, Q.UtilityId,Q.AccountTypeId, Q.Term,
Q.ProductBrandId,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
Q.PriceTierId,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
Set NOCOUNT OFF;
END


GO
-----------------------------------------------------------------------------------
--need to validate : usp_qualifierListbyCampaignIdSelect
-----------------------------------------------------------
--Insert data for the other ProductBrands
-----------------------------------------------------------------------------------

If not exists (Select 1 from LIbertypower..Qualifier Q where Q.productBrandId=2)
Begin


Insert into LibertyPower..Qualifier
Select Q.CampaignId,Q.PromotionCodeId,Q.SalesChannelId,Q.MarketId
,Q.UtilityId,Q.AccountTypeId,Q.Term,2,Q.SignStartDate,Q.SignEndDate
,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate
,Q.PriceTierId,Q.AutoApply,Q.CreatedBy,GETDATE(),1

 from LIbertypower..Qualifier Q With (NoLock) where Q.productbrandid=1
 
 END
 
 -------------------------------------------------------------------------
 
 
If not exists (Select 1 from LIbertypower..Qualifier Q where Q.productBrandId=8)
Begin
Insert into LibertyPower..Qualifier
Select Q.CampaignId,Q.PromotionCodeId,Q.SalesChannelId,Q.MarketId
,Q.UtilityId,Q.AccountTypeId,Q.Term,8,Q.SignStartDate,Q.SignEndDate
,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate
,Q.PriceTierId,Q.AutoApply,Q.CreatedBy,GETDATE(),1

 from LIbertypower..Qualifier Q With (NoLock) where Q.productbrandid=1

 END
  ------------------------------------------------------------------------
 
If not exists (Select 1 from LIbertypower..Qualifier Q where Q.productBrandId=13)
Begin 
Insert into LibertyPower..Qualifier
Select Q.CampaignId,Q.PromotionCodeId,Q.SalesChannelId,Q.MarketId
,Q.UtilityId,Q.AccountTypeId,Q.Term,13,Q.SignStartDate,Q.SignEndDate
,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate
,Q.PriceTierId,Q.AutoApply,Q.CreatedBy,GETDATE(),1

 from LIbertypower..Qualifier Q With (NoLock) where Q.productbrandid=1

END
 
 
 -----------------------------------------------------------------------------------


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProductBrandIdGet]    Script Date: 12/10/2013 13:44:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductBrandIdGet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductBrandIdGet]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProductBrandIdGet]    Script Date: 12/10/2013 13:44:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*
*
* PROCEDURE:	[usp_ProductBrandIdGet]
*
* DEFINITION:  Get the product brandid for the product brand name supplied
*
* RETURN CODE: Returns the Product BrandId
*
* REVISIONS:	Sara lakshmanan 12/10/2013
*/

CREATE PROCEDURE [dbo].[usp_ProductBrandIdGet]  
	@PriceID					BIGINT
AS
SET NoCOUNT ON;
	SELECT 
		ProductBrandID
	FROM [LibertyPower].[dbo].[Price] (NOLOCK)
	WHERE 
		ID = @PriceID   
		                                                                                                                            
SET NoCOUNT OFF;	


GO

------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 12/10/2013 14:44:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Date:     10/24/2013
-- Description:	Getting the details from Libertypower Qualifier table and mapping them to the Genie database Qualifier Table requirements  
-- =============================================
-- Date:     12/10/2013
-- Description: Change product Type to productBrand 
-- =============================================
ALTER proc [dbo].[spGenie_GetQualifiersforToday] as
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
--LEft  Join Libertypower..ProductType PT with (noLock) on Q.ProductTypeId=PT.ProductTypeID
LEft  Join Libertypower..ProductBrand PB with (noLock) on Q.ProductBrandId=PB.ProductBrandID
LEft  Join Libertypower..DailyPricingPriceTier DPT with (NOLock) on Q.PriceTierId=DPT.ID
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()


SET NOCOUNT OFF
end
GO
------------------------------------------------------------------------------------------------------------

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetQualifierFieldValues]    Script Date: 12/18/2013 10:16:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetQualifierFieldValues]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_GetQualifierFieldValues]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetQualifierFieldValues]    Script Date: 12/18/2013 10:16:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

* Function:      [ufn_GetQualifierFieldValues]
* PURPOSE:       Returns list of field values for qualifier table based on table name
* HISTORY:       To return the value of fields for qualifier table.
*******************************************************************************
* 12/05/2013 - Pradeep Katiyar
* Created.
*******************************************************************************

*/
CREATE FUNCTION [dbo].[ufn_GetQualifierFieldValues] ( @TableName Varchar(30), @CampaignID Int, @GroupBy Int ) 
RETURNS Varchar(Max) 
AS 
BEGIN 
      DECLARE @values Varchar(Max)
      if (@TableName ='SalesChannel')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + SC.ChannelName
                  FROM LibertyPower..SalesChannel SC  with (NOLock)
                        where SC.ChannelID in(select QF.SalesChannelId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='Market')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + MA.RetailMktDescp 
                  FROM LibertyPower..Market MA with (NOLock) 
                  Where MA.ID in(select QF.MarketId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='Utility')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + UT.FullName
                  FROM LibertyPower..Utility UT with (NOLock) 
                  where  UT.ID in(select QF.UtilityId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='AccountType')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + AT.AccountType
                  FROM LibertyPower..AccountType AT with (NOLock) 
                  Where  AT.ID in(select QF.AccountTypeId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='ProductBrand')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + PT.Name
                  FROM LibertyPower..ProductBrand PT with (NOLock) 
                  Where PT.ProductBrandID in(select QF.ProductBrandID from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='DailyPricingPriceTier')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + DP.Name
                  FROM LibertyPower..DailyPricingPriceTier DP with (NOLock) 
                  where DP.ID in(select QF.PriceTierId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
                        
      
RETURN @values
END

-- Copyright 12/05/2013 Liberty Power
GO
-----------------------------------------------------------------


