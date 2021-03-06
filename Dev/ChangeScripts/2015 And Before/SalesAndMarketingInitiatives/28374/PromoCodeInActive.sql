USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 12/13/2013 12:54:15 ******/
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

--Dec 13 2012 Added InActive Column in where clause Sara
*/

ALTER PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Distinct Q.PromotionCodeId,P.PromotionTypeId,P.Code,P.Description,
P.MarketingDescription,P.LegalDescription,P.CreatedBy,P.CreatedDate
 from LibertyPower..Qualifier  Q with (NoLock) inner Join LIbertypower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId  
Inner Join LIbertyPower..Campaign C With (NoLock) on C.CampaignId=Q.CampaignId
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
 and P.InActive=0 and C.InActive=0
Set NOCOUNT OFF;
END
GO      
-------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]    Script Date: 12/13/2013 11:19:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_GetAllValidQualifiersandPromoCodeforToday]
*
* DEFINITION:  Selects the list of Qualifier and PromotionCode records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information and Promotion code 
*
* REVISIONS:	Sara lakshmanan 9/30/2013
--Added InActive column to where clause Dec 13 2013
*/

ALTER PROCEDURE [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Q.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LIbertypower..Campaign C With (NoLock)
 on Q.CampaignId=C.CampaignId 
 Inner Join LibertyPower..PromotionCode P with (NOLock) on Q.PromotionCodeId=P.PromotionCodeId

where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
Set NOCOUNT OFF;
END
GO
      

-----------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 12/13/2013 12:57:27 ******/
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
--Modified Dec 13 2013
--Sara -- Added InActive Field
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
Q.PriceTierId,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)Inner Join
LibertyPower..Campaign C on C.CampaignId=Q.CampaignId
Inner Join LibertyPower..PromotionCode P with (NoLock) on
P.PromotionCodeId=Q.PromotionCodeId
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
Set NOCOUNT OFF;
END
GO


--------------------------------------------------------------------------------------------------
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 12/13/2013 13:05:00 ******/
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
--Modified: Sara Lakshmanan DEc 13 2013
-- Added InActive field to Where Clause
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
Inner Join LibertyPower..Campaign C On Q.CampaignId=C.CampaignId
where
P.InActive=0 and C.InActive=0 and
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
---------------------------------------------------------------------------------------------


If Exists (Select * from Libertypower..PromotionCode where InActive is Null)
Begin
Update LIbertypower..PromotionCode Set InActive=0 where InActive is Null
End

GO


If Exists (Select * from Libertypower..Campaign where InActive is Null)
Begin
Update LIbertypower..Campaign Set InActive=0 where InActive is Null
End

GO
