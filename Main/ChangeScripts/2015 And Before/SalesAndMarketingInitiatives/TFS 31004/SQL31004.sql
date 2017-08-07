USE LibertyPower
Go

Update LibertyPower..Qualifier set AccountTypeId=AT.ProductAccountTypeID 
from LibertyPower..Qualifier QF join 
	LibertyPower..AccountType AT on AT.ID=QF.AccountTypeId
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifierListbyCampaignIdSelect' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_qualifierListbyCampaignIdSelect;
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
 *******************************************************************************

 */

create PROCEDURE [dbo].[usp_qualifierListbyCampaignIdSelect] 
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
if 	nullif( LTRIM(rtrim(@p_PromotionCode)),'') is null
                                                                                                                         
	select *,dbo.ufn_GetQualifierFieldValues('SalesChannel',CampaignId,GroupBy) as ChannelName,
		dbo.ufn_GetQualifierFieldValues('Market',CampaignId,GroupBy) as MarketCode,
		dbo.ufn_GetQualifierFieldValues('Utility',CampaignId,GroupBy) as UtilityCode,
		dbo.ufn_GetQualifierFieldValues('AccountType',CampaignId,GroupBy) as AccountType,
		dbo.ufn_GetQualifierFieldValues('ProductBrand',CampaignId,GroupBy) as ProductBrand,
		
		dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTier from(
	select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
		QF.GroupBy 
		from LibertyPower..Qualifier QF  with (NOLock)
			Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
			Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
	Where QF.CampaignId=@p_CampaignID and qf.SignStartDate>=@SignStartDate and qf.SignEndDate<=@SignEndDate ) tbl
	order by GroupBy Desc

ELSE
	select *,dbo.ufn_GetQualifierFieldValues('SalesChannel',CampaignId,GroupBy) as ChannelName,
		dbo.ufn_GetQualifierFieldValues('Market',CampaignId,GroupBy) as MarketCode,
		dbo.ufn_GetQualifierFieldValues('Utility',CampaignId,GroupBy) as UtilityCode,
		dbo.ufn_GetQualifierFieldValues('AccountType',CampaignId,GroupBy) as AccountType,
		dbo.ufn_GetQualifierFieldValues('ProductBrand',CampaignId,GroupBy) as ProductBrand,
		
		dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTier from(
	select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
		QF.GroupBy 
		from LibertyPower..Qualifier QF  with (NOLock)
			Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
			Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
	Where QF.CampaignId=@p_CampaignID and qf.SignStartDate>=@SignStartDate and qf.SignEndDate<=@SignEndDate 
			and PC.Code like '%' + LTRIM(rtrim(@p_PromotionCode)) +'%' ) tbl
	order by GroupBy Desc



Set NOCOUNT OFF;
END
-- Copyright 12/05/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_QualifierPromoCodeStartEndDateValidation' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_QualifierPromoCodeStartEndDateValidation;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierPromoCodeStartEndDateValidation] 
 * PURPOSE:		To validate if Promo Code is not assigned to another Campaign which has an overlapping effective period
 * HISTORY:		 
 *******************************************************************************
 * 01/02/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 */

Create PROCEDURE [dbo].[usp_QualifierPromoCodeStartEndDateValidation] 
	@p_CampaignId int,
	@p_PromotionCodeId	int,
	@p_SignStartDate Datetime	=null,
	@p_SignEndDate Datetime	=null,
	@p_GroupBy int=null
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
select top 1 qf.CampaignId from  LibertyPower..Qualifier qf  with (NOLock)
where qf.PromotionCodeId=@p_PromotionCodeId and   
(qf.SignStartDate between @p_SignStartDate and @p_SignEndDate or qf.SignEndDate between @p_SignStartDate and @p_SignEndDate
	or @p_SignStartDate between qf.SignStartDate and qf.SignEndDate and @p_SignEndDate between qf.SignStartDate and qf.SignEndDate
)
and qf.QualifierId not in (select  qf.QualifierId from  LibertyPower..Qualifier qf  with (NOLock) where qf.GroupBy=@p_GroupBy and qf.CampaignId=@p_CampaignId)
and qf.CampaignId=@p_CampaignId

Set NOCOUNT OFF;
END
-- Copyright 01/02/2013 Liberty Power


Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_QualifierInUse' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_QualifierInUse;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierInUse] 
 * PURPOSE:		To validate if Qualifier is in use.
 * HISTORY:		 
 *******************************************************************************
 * 01/22/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 */

Create PROCEDURE [dbo].[usp_QualifierInUse]
	@p_CampaignId int,
	@p_PromotionCodeId	int,
	@p_GroupBy int=null
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF 
select top 1 1 from  LibertyPower..Qualifier qf  with (NOLock)
	Join LibertyPower..ContractQualifier cq with (NOLock) on qf.QualifierId=cq.QualifierId
where qf.PromotionCodeId=@p_PromotionCodeId    
and qf.CampaignId=@p_CampaignId
and qf.GroupBy=@p_GroupBy

Set NOCOUNT OFF;
END
-- Copyright 01/22/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_AllPromotionCodelist' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_AllPromotionCodelist;
GO


/*******************************************************************************

 * PROCEDURE:	[usp_AllPromotionCodelist]
 * PURPOSE:		Selects all valid Promotion Codes
 * HISTORY:		 
 *******************************************************************************
 * 12/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_AllPromotionCodelist] 
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF


Select  pc.PromotionCodeId,pc.Code,*
	from  LibertyPower..PromotionCode pc with (NOLock)
	where isnull(pc.InActive,0)<>1
	order by pc.Code 
		
Set NOCOUNT OFF;
END
-- Copyright 12/18/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifierListbyCampaignIdSelect' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_qualifierListbyCampaignIdSelect;
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
 *******************************************************************************

 */

create PROCEDURE [dbo].[usp_qualifierListbyCampaignIdSelect] 
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
if 	nullif( LTRIM(rtrim(@p_PromotionCode)),'') is null
                                                                                                                         
	select *,dbo.ufn_GetQualifierFieldValues('SalesChannel',CampaignId,GroupBy) as SalesChannels,
		dbo.ufn_GetQualifierFieldValues('Market',CampaignId,GroupBy) as Markets,
		dbo.ufn_GetQualifierFieldValues('Utility',CampaignId,GroupBy) as Utilities,
		dbo.ufn_GetQualifierFieldValues('AccountType',CampaignId,GroupBy) as Accounttypes,
		dbo.ufn_GetQualifierFieldValues('ProductBrand',CampaignId,GroupBy) as ProductBrands,
		dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers from(
	select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
		QF.GroupBy 
		from LibertyPower..Qualifier QF  with (NOLock)
			Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
			Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
	Where QF.CampaignId=@p_CampaignID and qf.SignStartDate>=@SignStartDate and qf.SignEndDate<=@SignEndDate ) tbl
	order by GroupBy Desc

ELSE
	select *,dbo.ufn_GetQualifierFieldValues('SalesChannel',CampaignId,GroupBy) as SalesChannels,
		dbo.ufn_GetQualifierFieldValues('Market',CampaignId,GroupBy) as Markets,
		dbo.ufn_GetQualifierFieldValues('Utility',CampaignId,GroupBy) as Utilities,
		dbo.ufn_GetQualifierFieldValues('AccountType',CampaignId,GroupBy) as Accounttypes,
		dbo.ufn_GetQualifierFieldValues('ProductBrand',CampaignId,GroupBy) as ProductBrands,
		dbo.ufn_GetQualifierFieldValues('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers from(
	select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
		QF.GroupBy 
		from LibertyPower..Qualifier QF  with (NOLock)
			Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
			Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
	Where QF.CampaignId=@p_CampaignID and qf.SignStartDate>=@SignStartDate and qf.SignEndDate<=@SignEndDate 
			and PC.Code like '%' + LTRIM(rtrim(@p_PromotionCode)) +'%' ) tbl
	order by GroupBy Desc



Set NOCOUNT OFF;
END
-- Copyright 12/05/2013 Liberty Power
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifierDetailsSelect' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_qualifierDetailsSelect;
GO


/*******************************************************************************

 * PROCEDURE:	[usp_qualifierDetailsSelect]
 * PURPOSE:		Selects the Qualifier details based on Campaign Id and group by
 * HISTORY:		
 *******************************************************************************
 * 01/03/2014 - Pradeep Katiyar
 * Created.
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
	dbo.ufn_GetQualifierFieldIds('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTiers from(
select distinct QF.PromotionCodeId,PC.Code,QF.CampaignId,Term,SignStartDate,SignEndDate,ContractEffecStartPeriodStartDate,ContractEffecStartPeriodLastDate,
	QF.GroupBy 
	from LibertyPower..Qualifier QF  with (NOLock)
		Join LibertyPower..Campaign C  with (NOLock) on QF.CampaignId=C.CampaignId
		Join LibertyPower..PromotionCode PC  with (NOLock) on QF.PromotionCodeId=PC.PromotionCodeId
Where QF.CampaignId=@p_CampaignID and qf.GroupBy=@p_GroupBy ) tbl


Set NOCOUNT OFF;
END
-- Copyright 01/03/2013 Liberty Power


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

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_SalesChannelMarketlist' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_SalesChannelMarketlist;
GO


/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelMarketlist] 
 * PURPOSE:		Selects all markets for selected sales channels
 * HISTORY:		 
 *******************************************************************************
 * 12/23/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_SalesChannelMarketlist] 
@p_salesChannelIds varchar(4000)	=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

if (isnull(@p_salesChannelIds,'')='')
		SELECT	DISTINCT  m.ID, m.retail_mkt_descp AS MarketDesc
		FROM	lp_common..common_retail_market m with (NOLock)
		JOIN	lp_security..security_role_retail_mkt s with (NOLock) ON m.retail_mkt_id = s.retail_mkt_id
		JOIN	lp_portal..Roles r with (NOLock) ON r.RoleName = s.role_name		
		JOIN	lp_portal..UserRoles ur with (NOLock) ON r.RoleID = ur.RoleID
		JOIN	lp_portal..Users u with (NOLock) ON ur.userid = u.userid
		WHERE	u.Username in( select 'libertypower\'+sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
									where sc.Inactive=0 and sc.SalesStatus=2)
		  AND   s.role_name <> 'All Utility Access'
		  and m.ID = (SELECT MAX(b.ID) FROM lp_common..common_retail_market b WITH (NOLOCK) 
						WHERE m.retail_mkt_id  = b.retail_mkt_id )
		  ORDER BY m.retail_mkt_descp	
else
		SELECT	DISTINCT  m.ID, m.retail_mkt_descp AS MarketDesc
		FROM	lp_common..common_retail_market m with (NOLock)
		JOIN	lp_security..security_role_retail_mkt s with (NOLock) ON m.retail_mkt_id = s.retail_mkt_id
		JOIN	lp_portal..Roles r with (NOLock) ON r.RoleName = s.role_name		
		JOIN	lp_portal..UserRoles ur with (NOLock) ON r.RoleID = ur.RoleID
		JOIN	lp_portal..Users u with (NOLock) ON ur.userid = u.userid
		WHERE	u.Username in( select 'libertypower\'+sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
									where sc.Inactive=0 and sc.SalesStatus=2 and sc.ChannelID in (select * from dbo.split(@p_salesChannelIds,',')))
		  AND   s.role_name <> 'All Utility Access'
		   and m.ID = (SELECT MAX(b.ID) FROM lp_common..common_retail_market b WITH (NOLOCK) 
						WHERE m.retail_mkt_id  = b.retail_mkt_id )
		  ORDER BY m.retail_mkt_descp		  
		  
		
Set NOCOUNT OFF;
END
-- Copyright 12/23/2013 Liberty Power


  

