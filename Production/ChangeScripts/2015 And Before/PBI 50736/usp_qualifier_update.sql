USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_qualifier_update]    Script Date: 7/14/2015 11:33:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************

 * PROCEDURE:	[usp_qualifier_update] 
 * PURPOSE:		update the qualifier
 * HISTORY:		 
 *******************************************************************************
 * 01/03/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 * ModifiedBy: Manish Pandey
 * ModifiedDate: 08/13/2015
 * Ticket/PBI: 1-891895781 / 50736
 * Modification: To To allow to change signed date and contract date.
 -----------------------
 Profiler
 Begin tran 
	exec usp_qualifier_update
	@p_CampaignCodeId=5,
	@p_PromotionCodeId=15,
	@p_salesChannelIds='11',
	@p_MarketIds='8',	
	@p_UtilityIds='1',
	@p_AccountTypeIds='1',
	@p_Term=12,
	@p_ProductBrandIds='1',
	@p_SignStartDate='6/19/2015 12:00:00 AM',
	@p_SignEndDate='6/19/2015 12:00:00 AM',
	@p_ContractStartDate=null,
	@p_ContractEndDate=null,
	@p_PriceTierIds='',
	@p_CreatedBy=4464,
	@p_GroupBy=186

Rollback

 *******************************************************************************
 */

ALTER proc [dbo].[usp_qualifier_update]
(
	@p_CampaignCodeId	int,
	@p_PromotionCodeId	int,
	@p_salesChannelIds varchar(4000)	=null,
	@p_MarketIds varchar(500)	=null,
	@p_UtilityIds varchar(500)	=null,
	@p_AccountTypeIds varchar(500)	=null,
	@p_Term	int 	=null,
	@p_ProductBrandIds varchar(500)	=null,
	@p_SignStartDate Datetime	=null,
	@p_SignEndDate Datetime	=null,
	@p_ContractStartDate Datetime	=null,
	@p_ContractEndDate Datetime	=null,
	@p_PriceTierIds varchar(500)	=null,
	@p_CreatedBy		int,
	@p_GroupBy		int,
	@p_IsDateOnlyChanged int=null	
)
as
Begin
SET NOCOUNT ON


	DECLARE @salesChannelId int, @MarketId int, @UtilityId int, @GroupBy int

	--Check if date got changed.if true update the date
	if (ISNULL(@p_IsDateOnlyChanged,0)=1) 
	BEGIN
		UPDATE  LibertyPower..Qualifier 
				SET SignStartDate=@p_SignStartDate,
					SignEndDate=@p_SignEndDate,
					ContractEffecStartPeriodStartDate=@p_ContractStartDate,
					ContractEffecStartPeriodLastDate=@p_ContractEndDate,
					ModifiedBy=@p_CreatedBy,
					ModifiedDate=GETDATE()
			where CampaignId=@p_CampaignCodeId and PromotionCodeId=@p_PromotionCodeId and GroupBy=@p_GroupBy
	END
	ELSE
	BEGIN
		delete  from  LibertyPower..Qualifier where CampaignId=@p_CampaignCodeId and GroupBy=@p_GroupBy
		exec usp_qualifier_ins @p_CampaignCodeId,@p_PromotionCodeId,@p_salesChannelIds,@p_MarketIds,@p_UtilityIds,@p_AccountTypeIds,@p_Term,@p_ProductBrandIds,@p_SignStartDate,@p_SignEndDate,@p_ContractStartDate,@p_ContractEndDate,@p_PriceTierIds,@p_CreatedBy,@p_GroupBy
	END



Select  Groupby from  LibertyPower..Qualifier  with (NOLock) where QualifierId=SCOPE_IDENTITY()
Set NOCOUNT OFF;
End
-- Copyright 01/03/2014 Liberty Power


