USE [LibertyPower]
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifierDetailsSelect' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_qualifierDetailsSelect];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_qualifierDetailsSelect]
 * PURPOSE:		Selects the Qualifier details based on Campaign Id and group by
 * HISTORY:		
 *******************************************************************************
 * 01/03/2014 - Pradeep Katiyar
 * Created.
 * 08/27/2014 - Pradeep Katiyar
 * Modified. Added one field to check if qualifier can be deleted
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_qualifierDetailsSelect]
	 @p_CampaignID		Int,
	 @p_GroupBy Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
select *,dbo.ufn_GetQualifierFieldIds('SalesChannel',CampaignId,GroupBy) as SalesChannels,
	dbo.ufn_GetQualifierFieldIds('Market',CampaignId,GroupBy) as Markets,
	dbo.ufn_GetQualifierFieldIds('Utility',CampaignId,GroupBy) as Utilities,
	dbo.ufn_GetQualifierFieldIds('AccountType',CampaignId,GroupBy) as Accounttypes,
	dbo.ufn_GetQualifierFieldIds('ProductBrand',CampaignId,GroupBy) as ProductBrands,
	dbo.ufn_GetQualifierFieldIds('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers,
	dbo.ufn_GetQualifierDeleteId(CampaignId,GroupBy) as DeleteQualifierGroupId  from(
select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
	QF.GroupBy 
	from LibertyPower..Qualifier QF  with (NOLock)
		Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
		Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
Where QF.CampaignId=@p_CampaignID and qf.GroupBy=@p_GroupBy ) tbl


Set NOCOUNT OFF;
END
-- Copyright 01/03/2013 Liberty Power



