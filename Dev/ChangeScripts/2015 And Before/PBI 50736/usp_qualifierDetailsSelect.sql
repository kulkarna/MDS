USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_qualifierDetailsSelect]    Script Date: 7/14/2015 11:29:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 * ModifiedBy: Manish Pandey
 * ModifiedDate: 08/14/2015
 * Ticket/PBI: 1-891895781 / 50736
 * Modification: Added IsAssignedToContract field to check if promocode assigned to contract
 
 --------
 Profiler
 exec usp_qualifierDetailsSelect @p_CampaignID=25, @p_GroupBy=1
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_qualifierDetailsSelect]
	 @p_CampaignID		Int,
	 @p_GroupBy Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
	-- added by Manish Pandey
    declare @IsAssignedToContract int =0        
	
	-- added by Manish Pandey
	if exists(select QF.CampaignId from LibertyPower..Qualifier QF  with (NOLock)  
				inner join LibertyPower..ContractQualifier CQ with (NOLock) on QF.QualifierId=CQ.QualifierId
					Where QF.CampaignId=@p_CampaignID and QF.GroupBy=@p_GroupBy)
		set @IsAssignedToContract=1
                                                                                                                 
select *,dbo.ufn_GetQualifierFieldIds('SalesChannel',CampaignId,GroupBy) as SalesChannels,
	dbo.ufn_GetQualifierFieldIds('Market',CampaignId,GroupBy) as Markets,
	dbo.ufn_GetQualifierFieldIds('Utility',CampaignId,GroupBy) as Utilities,
	dbo.ufn_GetQualifierFieldIds('AccountType',CampaignId,GroupBy) as Accounttypes,
	dbo.ufn_GetQualifierFieldIds('ProductBrand',CampaignId,GroupBy) as ProductBrands,
	dbo.ufn_GetQualifierFieldIds('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers,
	dbo.ufn_GetQualifierDeleteId(CampaignId,GroupBy) as DeleteQualifierGroupId ,
	@IsAssignedToContract as IsAssignedToContract -- added by Manish Pandey
	from(select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate, QF.GroupBy 
			from LibertyPower..Qualifier QF  with (NOLock)
				Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
				Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
			Where QF.CampaignId=@p_CampaignID and qf.GroupBy=@p_GroupBy ) tbl


Set NOCOUNT OFF;
END
-- Copyright 01/03/2013 Liberty Power



