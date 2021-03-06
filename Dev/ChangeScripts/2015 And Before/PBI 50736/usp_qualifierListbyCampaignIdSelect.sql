USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_qualifierListbyCampaignIdSelect]    Script Date: 7/14/2015 12:33:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************

 * PROCEDURE:	[usp_qualifierListbyCampaignIdSelect]
 * PURPOSE:		Selects the Qualifier list based on Campaign Id
 * HISTORY:		To display the qualifier list based on campaign Id
 *******************************************************************************
 * 12/05/2013 - Pradeep Katiyar
 * Created.
 * 01/03/2014 - Pradeep Katiyar
 * Modified.
 * 08/07/2014 - Pradeep Katiyar
 * Modified. Added one field to check if qualifier can be deleted
 *******************************************************************************
 * ModifiedBy: Andre Damasceno
 * ModifiedDate: 06/09/2015
 * Ticket/PBI: 1-1281987331 / 75308
 * Modification: Added 3 new parameters,@p_AllItems,@p_Page and @p_ItemsPerPage, to control the number of rows in the return
 *******************************************************************************
 * ModifiedBy: Manish Pandey
 * ModifiedDate: 08/14/2015
 * Ticket/PBI: 1-891895781 / 50736
 * Modification: Added IsAssignedToContract field to check if promocode assigned to contract
 --------
 Profiler
 exec usp_qualifierListbyCampaignIdSelect @p_CampaignID=25
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_qualifierListbyCampaignIdSelect] 
	 @p_CampaignID		Int,
	 @p_PromotionCode   nchar(40)=null,
	 @p_SignStartDate	datetime=null,
	 @p_SignEndDate		datetime=null,
	 @p_AllItems		bit = 1,
	 @p_Page			int = 0,
	 @p_ItemsPerPage	int = 0
AS
BEGIN

	-- set nocount on and default isolation level
	SET NOCOUNT ON
	Declare @SignStartDate datetime,@SignEndDate datetime
	if @p_SignStartDate is null
		set  @SignStartDate ='1/1/1900'
	else
		set  @SignStartDate =@p_SignStartDate
	if @p_SignEndDate is null
		set @SignEndDate ='12/12/9999'
	else
		set @SignEndDate =@p_SignEndDate
	
	if (@p_AllItems = 0)
	BEGIN
		DECLARE @row_start int
		DECLARE @row_end int
		set @row_start = (@p_ItemsPerPage * (@p_Page	- 1)) + 1
		set @row_end = (@p_ItemsPerPage * @p_Page)
	END
	
	SELECT * FROM (
		select ROW_NUMBER() OVER(order by GroupBy desc) as row_num,
			COUNT(*) OVER() AS Total,
			*,dbo.ufn_GetQualifierFieldValues('SalesChannel',CampaignId,GroupBy) as SalesChannels,
			dbo.ufn_GetQualifierFieldValues('Market',CampaignId,GroupBy) as Markets,
			dbo.ufn_GetQualifierFieldValues('Utility',CampaignId,GroupBy) as Utilities,
			dbo.ufn_GetQualifierFieldValues('AccountType',CampaignId,GroupBy) as Accounttypes,
			dbo.ufn_GetQualifierFieldValues('ProductBrand',CampaignId,GroupBy) as ProductBrands,
			dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers, 
			dbo.ufn_GetQualifierDeleteId(CampaignId,GroupBy) as DeleteQualifierGroupId, --Returns group id if qualifier 
			0 as IsAssignedToContract -- added by Manish Pandey
			from(
					select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
						QF.GroupBy
						from LibertyPower..Qualifier QF  with (NOLock)
							Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
							Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
					Where QF.CampaignId=@p_CampaignID and qf.SignStartDate>=@SignStartDate and qf.SignEndDate<=@SignEndDate 
						and (PC.Code like '%' + LTRIM(rtrim(@p_PromotionCode)) +'%' or LTRIM(rtrim(@p_PromotionCode)) is null) 
				) tbl	
	) as a
	WHERE 1 = 1
	AND (@p_AllItems = 0 AND a.row_num Between @row_start AND @row_end) OR @p_AllItems = 1
	Order by GroupBy Desc


Set NOCOUNT OFF;
END
-- Copyright 8/07/2013 Liberty Power

