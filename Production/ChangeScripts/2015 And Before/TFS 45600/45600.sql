USE [LibertyPower]
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'ufn_GetQualifierDeleteId' AND type_desc = 'SQL_SCALAR_FUNCTION')
DROP Function [ufn_GetQualifierDeleteId];
GO
/*******************************************************************************

 * Function:	[ufn_GetQualifierDeleteId]
 * PURPOSE:		Returns groupbyId if qualifier can be deleted else returns 0
 * HISTORY:		
 *******************************************************************************
 * 8/07/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
Create FUNCTION [dbo].[ufn_GetQualifierDeleteId] (@CampaignID Int, @GroupBy Int ) 
RETURNS int 
AS 
BEGIN 
	DECLARE @groupById int
	Set @groupById=0
	if not exists (select 1 from 
					LibertyPower..Qualifier QF  with (NOLock)
					join LibertyPower..ContractQualifier CQ  with (NOLock) on CQ.QualifierId=QF.QualifierId
					Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
		Set @groupById=	@GroupBy				
	
RETURN @groupById
END
-- Copyright 8/07/2014 Liberty Power

GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifierListbyCampaignIdSelect' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_qualifierListbyCampaignIdSelect];
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

 */


Create PROCEDURE [dbo].[usp_qualifierListbyCampaignIdSelect] 
	 @p_CampaignID		Int,
	 @p_PromotionCode   nchar(40)=null,
	 @p_SignStartDate	datetime=null,
	 @p_SignEndDate		datetime=null
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

	select *,dbo.ufn_GetQualifierFieldValues('SalesChannel',CampaignId,GroupBy) as SalesChannels,
		dbo.ufn_GetQualifierFieldValues('Market',CampaignId,GroupBy) as Markets,
		dbo.ufn_GetQualifierFieldValues('Utility',CampaignId,GroupBy) as Utilities,
		dbo.ufn_GetQualifierFieldValues('AccountType',CampaignId,GroupBy) as Accounttypes,
		dbo.ufn_GetQualifierFieldValues('ProductBrand',CampaignId,GroupBy) as ProductBrands,
		dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers, 
		dbo.ufn_GetQualifierDeleteId(CampaignId,GroupBy) as DeleteQualifierGroupId --Returns group id if qualifier 
		from(
				select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
					QF.GroupBy
					from LibertyPower..Qualifier QF  with (NOLock)
						Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
						Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
				Where QF.CampaignId=@p_CampaignID and qf.SignStartDate>=@SignStartDate and qf.SignEndDate<=@SignEndDate 
					and (PC.Code like '%' + LTRIM(rtrim(@p_PromotionCode)) +'%' or LTRIM(rtrim(@p_PromotionCode)) is null) 
			) tbl
	order by GroupBy Desc



Set NOCOUNT OFF;
END
-- Copyright 8/07/2013 Liberty Power

GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_QualifierDelete' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_QualifierDelete];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierDelete]
 * PURPOSE:		Deletes Qualifier for specified Campaign Code Id
 * HISTORY:		 
 *******************************************************************************
 * 8/7/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_QualifierDelete]
	@p_CampaignId	int,
	@p_GroupById	int
AS
BEGIN
    SET NOCOUNT ON;
	if not exists (select 1 from 
					LibertyPower..Qualifier QF  with (NOLock)
					join LibertyPower..ContractQualifier CQ  with (NOLock) on CQ.QualifierId=QF.QualifierId
					Where QF.CampaignID=@p_CampaignId and QF.GroupBy=@p_GroupById)
	Begin
		DELETE FROM	LibertyPower..Qualifier 
		Where CampaignID=@p_CampaignId and GroupBy=@p_GroupById
	End
    SET NOCOUNT OFF;
END
-- Copyright 8/07/2013 Liberty Power

