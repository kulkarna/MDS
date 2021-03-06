USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 10/29/2013 11:20:19 ******/
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

---------------------------------------------------------------------------
*/

ALTER PROCEDURE [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]
	 @p_PromotionCode char(20), @p_SignDate datetime, @p_SalesChannelId int= null, @p_MarketId int=null,
	  @p_UtilityId int = null,@p_AccountTypeId int=null,  @p_Term int=null,
 @p_ProductTypeId int=null, @p_PriceTier int=null, @p_ContractStartDate datetime=null  
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
and (Q.ProductTypeId=@p_ProductTypeId or Q.ProductTypeId is Null)
and (Q.PriceTierID=@p_PriceTier or Q.PriceTierID is Null)
and ((Q.ContractEffecStartPeriodStartDate<=@p_ContractStartDate and Q.ContractEffecStartPeriodLastDate>=@p_ContractStartDate)
	    or (Q.ContractEffecStartPeriodStartDate is Null and Q.ContractEffecStartPeriodLastDate is Null))


Set NOCOUNT OFF;
END
      
