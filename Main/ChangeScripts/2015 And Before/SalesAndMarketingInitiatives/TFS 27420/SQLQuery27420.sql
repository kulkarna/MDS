USE LibertyPower
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


Select  pc.PromotionCodeId,pc.Code
	from  LibertyPower..PromotionCode pc with (NOLock)
	order by pc.Code 
		
Set NOCOUNT OFF;
END
-- Copyright 12/18/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_AllSalesChannelslist' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_AllSalesChannelslist;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_AllSalesChannelslist]
 * PURPOSE:		Selects all valid sales channels
 * HISTORY:		 
 *******************************************************************************
 * 12/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_AllSalesChannelslist] 
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

select sc.ChannelID,sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
where sc.Inactive=0 and sc.SalesStatus=2
order by sc.ChannelName
		
Set NOCOUNT OFF;
END
-- Copyright 12/18/2013 Liberty Power

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
		  ORDER BY m.retail_mkt_descp		  
		  
		
Set NOCOUNT OFF;
END
-- Copyright 12/23/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_MarketUtilityList' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_MarketUtilityList;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_MarketUtilityList] 
 * PURPOSE:		Selects all Utilities for selected Markets
 * HISTORY:		 
 *******************************************************************************
 * 12/23/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_MarketUtilityList] 
@p_MarketIds varchar(500)	=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

if ISNULL(@p_MarketIds,'')=''
	select u.ID,u.FullName as UtilityDesc from 	LibertyPower..Utility u WITH (NOLOCK)
	JOIN LibertyPower..Market m WITH (NOLOCK) ON u.MarketID = m.ID	
	order by u.FullName
else
	select u.ID,u.FullName as UtilityDesc from 	LibertyPower..Utility u WITH (NOLOCK)
	JOIN LibertyPower..Market m WITH (NOLOCK) ON u.MarketID = m.ID	
	where u.MarketID in (select * from dbo.Split(@p_MarketIds,','))	
	order by u.FullName
Set NOCOUNT OFF;
END
-- Copyright 12/23/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_AccountList' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_AccountList;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_AccountList] 
 * PURPOSE:		Selects all account
 * HISTORY:		 
 *******************************************************************************
 * 12/24/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_AccountList] 
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

select ProductAccountTypeID as ID,AccountType from  LibertyPower..AccountType   with (NOLock)
order by AccountType
Set NOCOUNT OFF;
END
-- Copyright 12/24/2013 Liberty Power


Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_ProductBrandList' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_ProductBrandList;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_ProductBrandList] 
 * PURPOSE:		Selects all product brand
 * HISTORY:		 
 *******************************************************************************
 * 12/24/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_ProductBrandList] 
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

select pb.ProductBrandID,pb.Name from  LibertyPower..ProductBrand pb  with (NOLock)
where pb.Active=1
order by pb.Name

Set NOCOUNT OFF;
END
-- Copyright 12/24/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_PriceTierList' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_PriceTierList;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_PriceTierList] 
 * PURPOSE:		Selects all price tiers
 * HISTORY:		 
 *******************************************************************************
 * 12/24/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_PriceTierList] 
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

select pt.ID,pt.[Description] from  LibertyPower..DailyPricingPriceTier pt  with (NOLock)
where pt.IsActive=1
order by pt.SortOrder

Set NOCOUNT OFF;
END
-- Copyright 12/24/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifier_ins' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_qualifier_ins;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_qualifier_ins] 
 * PURPOSE:		Add a new qualifier
 * HISTORY:		 
 *******************************************************************************
 * 12/26/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
usp_qualifier_ins 1,1,'30,31,32,33,34,35,36,37,38,39','2,3,4,5,6,7,8,9,10','1','',10,'','10/10/2013','10/10/2013','10/10/2013','10/10/2013','',12
usp_qualifier_ins 1,2,'1163','','11,14,17,18','1',10,'8','01/01/2014','01/31/2014','01/31/2014','01/31/2014','',2103
 */

create proc usp_qualifier_ins
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
	@p_GroupBy int =null	
)
as
Begin
SET NOCOUNT ON


DECLARE @salesChannelId int, @MarketId int, @UtilityId int, @GroupBy int
if @p_GroupBy is not null
	Set @GroupBy=@p_GroupBy
else
select @GroupBy=MAX(QF.GroupBy)+1  from  LibertyPower..Qualifier QF  with (NOLock) 
	where QF.CampaignId=@p_CampaignCodeId 
	
declare @saleschannelcursor as cursor 
declare 
    @vsql        as nvarchar(max)
    if (isnull(@p_salesChannelIds,'')='')
		set @vsql = 'select -1'
	else
		set @vsql = 'select * from dbo.split(''' + @p_salesChannelIds + ''','','')'
set @vsql = 'set @cursor = cursor fast_forward for ' + @vsql + ' open @cursor;'

exec sys.sp_executesql
    @vsql
    ,N'@cursor cursor output'
    ,@saleschannelcursor output
 
fetch next from @saleschannelcursor into @salesChannelId
while (@@fetch_status = 0)
begin
    
    
    declare @marketcursor as cursor 

		if (isnull(@p_MarketIds,'')='')
			set @vsql = 'select -1'
		else
			begin
			 if (@salesChannelId = -1)
				set @vsql='select * from dbo.split(''' + @p_MarketIds + ''','','')'
			else
				Begin
				if exists(SELECT	DISTINCT  m.ID
						FROM	lp_common..common_retail_market m  with (NOLock)
						JOIN	lp_security..security_role_retail_mkt s  with (NOLock) ON m.retail_mkt_id = s.retail_mkt_id
						JOIN	lp_portal..Roles r  with (NOLock) ON r.RoleName = s.role_name		
						JOIN	lp_portal..UserRoles ur  with (NOLock) ON r.RoleID = ur.RoleID
						JOIN	lp_portal..Users u  with (NOLock) ON ur.userid = u.userid
						WHERE	u.Username in( select 'libertypower\'+sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
													where sc.Inactive=0 and sc.SalesStatus=2 and sc.ChannelID=@salesChannelId
									and sc.ChannelID=@salesChannelId  )
						  AND   s.role_name <> 'All Utility Access' and m.id in (select * from dbo.split( @p_MarketIds,',')))
				  

						set @vsql = ' SELECT	DISTINCT  m.ID
						FROM	lp_common..common_retail_market m  with (NOLock)
						JOIN	lp_security..security_role_retail_mkt s  with (NOLock) ON m.retail_mkt_id = s.retail_mkt_id
						JOIN	lp_portal..Roles r  with (NOLock) ON r.RoleName = s.role_name		
						JOIN	lp_portal..UserRoles ur  with (NOLock) ON r.RoleID = ur.RoleID
						JOIN	lp_portal..Users u  with (NOLock) ON ur.userid = u.userid
						WHERE	u.Username in( select ''libertypower\''+sc.ChannelName from  LibertyPower..SalesChannel sc  with (NOLock)
													where sc.Inactive=0 and sc.SalesStatus=2 and sc.ChannelID='+ cast(@salesChannelId as varchar) + ' 
							and sc.ChannelID='+ cast(@salesChannelId as varchar) + ' )
						  AND   s.role_name <> ''All Utility Access'' and m.id in (select * from dbo.split(''' + @p_MarketIds + ''','',''))'
				else
					set @vsql = 'select -1'
				End
			end
			set @vsql = 'set @cursor = cursor fast_forward for ' + @vsql + ' open @cursor;'
		--print @vsql
		exec sys.sp_executesql
			@vsql
			,N'@cursor cursor output'
			,@marketcursor output
		 
		fetch next from @marketcursor into @MarketId
		while (@@fetch_status = 0)
		begin
			
			 declare @utilitycursor as cursor 
			 
				if (isnull(@p_UtilityIds,'')='')
					set @vsql = 'select -1'
				else
					if @MarketId = -1
						set @vsql = 'select * from dbo.split(''' + @p_UtilityIds + ''','','')'
					else
						begin
							if exists(select u.ID from 	LibertyPower..Utility u WITH (NOLOCK)
								JOIN LibertyPower..Market m WITH (NOLOCK) ON u.MarketID = m.ID	
								where u.MarketID = @MarketId  and u.ID in (select * from dbo.split(@p_UtilityIds ,',')))
								
								set @vsql ='select u.ID from 	LibertyPower..Utility u WITH (NOLOCK)
								JOIN LibertyPower..Market m WITH (NOLOCK) ON u.MarketID = m.ID	
								where u.MarketID = '+cast(@MarketId as varchar) +' and u.ID in (select * from dbo.split(''' + @p_UtilityIds + ''','',''))'
							else
								set @vsql = 'select -1'
							
						End
				set @vsql = 'set @cursor = cursor fast_forward for ' + @vsql + ' open @cursor;'
				--print @vsql
				exec sys.sp_executesql
				@vsql
				,N'@cursor cursor output'
				,@utilitycursor output
		 
				fetch next from @utilitycursor into @UtilityId
				while (@@fetch_status = 0)
				begin
				
				insert into LibertyPower..Qualifier(CampaignId, PromotionCodeId,SalesChannelId, MarketId, UtilityId,
					  AccountTypeId, Term, ProductBrandId, SignStartDate, SignEndDate, ContractEffecStartPeriodStartDate,
					  ContractEffecStartPeriodLastDate, PriceTierId, CreatedBy, CreatedDate, GroupBy)
				select @p_CampaignCodeId,@p_PromotionCodeId, nullif(@salesChannelId,-1), nullif(@MarketId,-1), nullif(@UtilityId,-1),
					nullif(AccountTypeId,0),@p_Term, nullif(ProductBrandId,0), @p_SignStartDate, @p_SignEndDate, @p_ContractStartDate, 
					@p_ContractEndDate, nullif(PriceTierId,0), @p_CreatedBy,GETDATE(), isnull(@GroupBy,1)
				from
				(select items as AccountTypeId  from dbo.Split(isnull(nullif(@p_AccountTypeIds,''),'0'),',')) as tblAccountType , 
				(select items as ProductBrandId from dbo.Split(isnull(nullif(@p_ProductBrandIds,''),'0'),',')) as tblProductBrand,
				(select items as PriceTierId from dbo.Split(isnull(nullif(@p_PriceTierIds,''),'0'),',')) as tblPriceTier
				--print cast(@salesChannelId as varchar) + '--' + cast(@MarketId as varchar) 
					fetch next from @utilitycursor into @UtilityId
				end
				 
				close @utilitycursor
				deallocate @utilitycursor
		
			fetch next from @marketcursor into @MarketId
		end
		 
		close @marketcursor
		deallocate @marketcursor
   
    fetch next from @saleschannelcursor into @salesChannelId
end
 
close @saleschannelcursor
deallocate @saleschannelcursor
Select  Groupby from  LibertyPower..Qualifier  with (NOLock) where QualifierId=SCOPE_IDENTITY()
Set NOCOUNT OFF;
End
-- Copyright 12/26/2013 Liberty Power

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

create PROCEDURE [dbo].[usp_QualifierPromoCodeStartEndDateValidation] 
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


Set NOCOUNT OFF;
END
-- Copyright 01/02/2013 Liberty Power





Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_QualifierCampaignStartEndDateValidation' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_QualifierCampaignStartEndDateValidation;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierCampaignStartEndDateValidation] 
 * PURPOSE:		To validate qualifier sign start and end date is between campaign start and end date
 * HISTORY:		 
 *******************************************************************************
 * 01/02/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

Create PROCEDURE [dbo].[usp_QualifierCampaignStartEndDateValidation] 
	@p_CampaignId	int,
	@p_SignStartDate Datetime	=null,
	@p_SignEndDate Datetime	=null
	
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

select c.CampaignId from  LibertyPower..Campaign c  with (NOLock)
where c.CampaignId=@p_CampaignId and @p_SignStartDate between c.StartDate and c.EndDate and @p_SignEndDate between c.StartDate and c.EndDate


Set NOCOUNT OFF;
END
-- Copyright 01/02/2013 Liberty Power

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
	 @p_CampaignID		Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
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
Where QF.CampaignId=@p_CampaignID ) tbl
order by GroupBy Desc


Set NOCOUNT OFF;
END
-- Copyright 12/05/2013 Liberty Power
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'ufn_GetQualifierFieldIds' AND type_desc = 'SQL_SCALAR_FUNCTION')
DROP Function ufn_GetQualifierFieldIds;
GO
/*******************************************************************************

 * Function:	[ufn_GetQualifierFieldIds]
 * PURPOSE:		Returns list of field Ids for qualifier table based on table name
 * HISTORY:		
 *******************************************************************************
 * 1/03/2014 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
create FUNCTION [dbo].[ufn_GetQualifierFieldIds] ( @TableName Varchar(30), @CampaignID Int, @GroupBy Int ) 
RETURNS Varchar(Max) 
AS 
BEGIN 
	DECLARE @values Varchar(Max)
	if (@TableName ='SalesChannel')
		SELECT  @values = COALESCE(@values+',' ,'') + cast(SC.ChannelID as varchar)
			FROM LibertyPower..SalesChannel SC  with (NOLock)
				where SC.ChannelID in(select QF.SalesChannelId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='Market')
		SELECT  @values = COALESCE(@values+',' ,'') + cast(MA.ID  as varchar)
			FROM LibertyPower..Market MA with (NOLock) 
			Where MA.ID in(select QF.MarketId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='Utility')
		SELECT  @values = COALESCE(@values+',' ,'') + cast(UT.ID as varchar)
			FROM LibertyPower..Utility UT with (NOLock) 
			where  UT.ID in(select QF.UtilityId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='AccountType')
		SELECT  @values = COALESCE(@values+',' ,'') + cast(AT.ProductAccountTypeID  as varchar)
			FROM LibertyPower..AccountType AT with (NOLock) 
			Where  AT.ProductAccountTypeID in(select QF.AccountTypeId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='ProductBrand')
		SELECT  @values = COALESCE(@values+',' ,'') + cast(PT.ProductBrandID  as varchar)
			FROM LibertyPower..ProductBrand PT with (NOLock) 
			Where PT.ProductBrandID in(select QF.ProductBrandID from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='DailyPricingPriceTier')
		SELECT  @values = COALESCE(@values+',' ,'') + cast(DP.ID  as varchar)
			FROM LibertyPower..DailyPricingPriceTier DP with (NOLock) 
			where DP.ID in(select QF.PriceTierId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
				
	
RETURN @values
END
-- Copyright 1/03/2014 Liberty Power


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
                                                                                                                                       
select *,dbo.ufn_GetQualifierFieldIds('SalesChannel',CampaignId,GroupBy) as ChannelIds,
	dbo.ufn_GetQualifierFieldIds('Market',CampaignId,GroupBy) as MarketIds,
	dbo.ufn_GetQualifierFieldIds('Utility',CampaignId,GroupBy) as UtilityIds,
	dbo.ufn_GetQualifierFieldIds('AccountType',CampaignId,GroupBy) as AccountIds,
	dbo.ufn_GetQualifierFieldIds('ProductBrand',CampaignId,GroupBy) as ProductBrandIds,
	dbo.ufn_GetQualifierFieldIds('DailyPricingPriceTier',CampaignId,GroupBy) as PriceTierIds from(
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
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_qualifier_update' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_qualifier_update;
GO
/*******************************************************************************

 * PROCEDURE:	[usp_qualifier_update] 
 * PURPOSE:		update the qualifier
 * HISTORY:		 
 *******************************************************************************
 * 01/03/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************
 */

create proc usp_qualifier_update
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
	@p_GroupBy		int	
)
as
Begin
SET NOCOUNT ON


DECLARE @salesChannelId int, @MarketId int, @UtilityId int, @GroupBy int

delete  from  LibertyPower..Qualifier where CampaignId=@p_CampaignCodeId and GroupBy=@p_GroupBy
exec usp_qualifier_ins @p_CampaignCodeId,@p_PromotionCodeId,@p_salesChannelIds,@p_MarketIds,@p_UtilityIds,@p_AccountTypeIds,@p_Term,@p_ProductBrandIds,@p_SignStartDate,@p_SignEndDate,@p_ContractStartDate,@p_ContractEndDate,@p_PriceTierIds,@p_CreatedBy,@p_GroupBy

Select  Groupby from  LibertyPower..Qualifier  with (NOLock) where QualifierId=SCOPE_IDENTITY()
Set NOCOUNT OFF;
End
-- Copyright 01/03/2014 Liberty Power


Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_campaigncode_update' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_campaigncode_update;
GO


/*******************************************************************************

 * PROCEDURE:	usp_campaigncode_update
 * PURPOSE:		To update Campaign code details
 * HISTORY:		To update Campaign code details
 *******************************************************************************
 * 11/29/2013 - Pradeep Katiyar
 * Created.
 * 1/6/2014 - Pradeep Katiyar
 * Modified. To update the qualifier sign end if campaign end date preponded
 *******************************************************************************

 */
 
CREATE proc usp_campaigncode_update
(
	@p_CampaignId		int,
	@p_CampaignCode	nchar(40),
	@p_Desc				varchar(1000)='',
	@p_StartDate		Datetime,
	@p_EndDate			Datetime,
	@p_MaxEligible		int=null,
	@p_InActive			bit=null
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..Campaign with (NOLock) where code=LTRIM(rtrim(@p_CampaignCode)) and CampaignId<>@p_CampaignId)
	Begin
		update LibertyPower..Campaign set Code=@p_CampaignCode, [Description]=@p_Desc,StartDate=@p_StartDate,EndDate=@p_EndDate,
				MaxEligible=@p_MaxEligible, InActive=@p_InActive
		where CampaignId=@p_CampaignId
		update LibertyPower..Qualifier set SignEndDate=@p_EndDate where SignEndDate> @p_EndDate and CampaignId=@p_CampaignId
		select C.* from LibertyPower..Campaign C with (NOLock) where C.CampaignId=@p_CampaignId

	 End
Set NOCOUNT OFF;
End
-- Copyright 12/05/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'ufn_GetQualifierFieldValues' AND type_desc = 'SQL_SCALAR_FUNCTION')
DROP Function ufn_GetQualifierFieldValues;
GO

/*******************************************************************************

 * Function:	[ufn_GetQualifierFieldValues]
 * PURPOSE:		Returns list of field values for qualifier table based on table name
 * HISTORY:		To return the value of fields for qualifier table.
 *******************************************************************************
 * 12/05/2013 - Pradeep Katiyar
 * Created.
 * 1/6/2014 - Pradeep Katiyar
 * Modified. to get the account type based on product account type id instead of account type id
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
			Where  AT.ProductAccountTypeID in(select QF.AccountTypeId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='ProductBrand')
		SELECT  @values = COALESCE(@values+'<br/>' ,'') + PT.Name
			FROM LibertyPower..ProductBrand PT with (NOLock) 
			Where PT.ProductBrandID in(select QF.ProductBrandID from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
	if (@TableName ='DailyPricingPriceTier')
		SELECT  @values = COALESCE(@values+'<br/>' ,'') + DP.[Description]
			FROM LibertyPower..DailyPricingPriceTier DP with (NOLock) 
			where DP.ID in(select QF.PriceTierId from  LibertyPower..Qualifier QF  with (NOLock)
				Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
				
	
RETURN @values
END
-- Copyright 12/05/2013 Liberty Power