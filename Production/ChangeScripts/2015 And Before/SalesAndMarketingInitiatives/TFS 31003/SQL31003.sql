USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_PromoCodelist' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_PromoCodelist;
GO
/*******************************************************************************

 * PROCEDURE:	[usp_PromoCodelist]
 * PURPOSE:		Selects the promotionCode Details
 * HISTORY:		To display the promotion code list 
 *******************************************************************************
 * 11/20/2013 - Pradeep Katiyar
 * Created.
 * 1/15/2014 - Pradeep Katiyar
 * Modified. To make the promocode searchable with contain also not only exact word.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_PromoCodelist] 
	@p_PromotionCode		 nchar(40) = '', 
	@p_orderby				varchar(50)='CreatedDate desc',
	@p_InActive				bit=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

Declare @SQL as varchar(1000)
Set @SQL='Select distinct pc.PromotionCodeId,pc.Code,pt.[Description] as PromotionType,pc.[Description],pc.MarketingDescription,pc.LegalDescription,
			u.Firstname + '' '' + u.Lastname as CreatedBy,pc.CreatedDate,case isnull(pc.Inactive,0) when 0 then ''No'' else ''Yes'' end Inactive,
			 isnull(qf.PromotionCodeId,0) QualifierPromoId 
	from  LibertyPower..PromotionCode pc with (NOLock)
		join LibertyPower..PromotionType pt with (NOLock) on pc.PromotionTypeId=pt.PromotionTypeId	
		join LibertyPower..[User] u with (NOLock) on pc.CreatedBy=u.UserID 
		left outer join LibertyPower..Qualifier QF  with (NOLock) on qf.PromotionCodeId=pc.PromotionCodeId 
		where 1=1 '
	
if (ltrim(rtrim(@p_PromotionCode))<>'')                                                                                                                              
	Set @SQL=@SQL +  ' and pc.Code like ''%'+ rtrim(ltrim(@p_PromotionCode)) +'%'''
if (@p_InActive is not null)                                                                                                                              
	Set @SQL=@SQL +  ' and isnull(pc.Inactive,0)='+ cast(@p_InActive as varchar(1))
if (ltrim(rtrim(@p_orderby))<>'') 
	Set @SQL=@SQL +  ' order by ' + @p_orderby

exec(@SQL)

Set NOCOUNT OFF;
END
-- Copyright 11/20/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_campaignCode_list' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_campaignCode_list;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_campaignCode_list]
 * PURPOSE:		Selects the CampaignCode Details
 * HISTORY:		To display the Campaign code list 
 *******************************************************************************
 * 11/28/2013 - Pradeep Katiyar
 * Created.
 * 1/16/2014 - Pradeep Katiyar
 * 
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_campaignCode_list]
	@p_CampaignCode		 nchar(40) = '',
	@p_InActive				bit=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
	
if (ltrim(rtrim(@p_CampaignCode))<>'')
	begin
		if (@p_InActive is not null)                                                                                                                              
			Select distinct c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate,
			case isnull(c.Inactive,0) when 0 then 'No' else 'Yes' end Inactive,
					 isnull(qf.CampaignId,0) QualifierCampaignId  
			from  LibertyPower..Campaign c with (NOLock)	
				join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
				left outer join LibertyPower..Qualifier QF  with (NOLock) on qf.CampaignId=c.CampaignId 
			where c.Code like '%' + ltrim(rtrim(@p_CampaignCode)) + '%' and ISNULL(c.InActive,0)= @p_InActive
		else
			Select distinct c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate,
			case isnull(c.Inactive,0) when 0 then 'No' else 'Yes' end Inactive,
					 isnull(qf.CampaignId,0) QualifierCampaignId  
			from  LibertyPower..Campaign c with (NOLock)	
				join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
				left outer join LibertyPower..Qualifier QF  with (NOLock) on qf.CampaignId=c.CampaignId 
			where c.Code like '%' + ltrim(rtrim(@p_CampaignCode)) + '%'
	End
else
	Begin
	if (@p_InActive is not null) 
		Select distinct c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate,
		case isnull(c.Inactive,0) when 0 then 'No' else 'Yes' end Inactive,
				 isnull(qf.CampaignId,0) QualifierCampaignId  
		from  LibertyPower..Campaign c with (NOLock)	
			join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
			left outer join LibertyPower..Qualifier QF  with (NOLock) on qf.CampaignId=c.CampaignId 
		where ISNULL(c.InActive,0)= @p_InActive
	else
		Select distinct c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate,
		case isnull(c.Inactive,0) when 0 then 'No' else 'Yes' end Inactive,
				 isnull(qf.CampaignId,0) QualifierCampaignId  
		from  LibertyPower..Campaign c with (NOLock)	
			join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
			left outer join LibertyPower..Qualifier QF  with (NOLock) on qf.CampaignId=c.CampaignId 
	End
Set NOCOUNT OFF;
END
-- Copyright 11/28/2013 Liberty Power    

