USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Alter table LibertyPower..PromotionCode add  InActive bit null
go
Alter table LibertyPower..Campaign add  InActive bit null

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * PROCEDURE:	[usp_promocode_ins]
 * PURPOSE:		Add new promotion code details
 * HISTORY:		
 *******************************************************************************
 * 11/22/2013 - Pradeep Katiyar
 * Created.
 * 12/16/2013 - Pradeep Katiyar
 * Updated - Added Inactive logic
 *******************************************************************************

 */
alter proc usp_promocode_ins
(
	@p_PromotionCode	nchar(40),
	@p_Desc				varchar(1000)='',
	@p_MarketingDesc	varchar(1000)='',
	@p_LegalDesc		varchar(1000)='',
	@p_PromotionTypeId	int,
	@p_CreatedBy		int,
	@p_InActive			bit=null	
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..PromotionCode with (NOLock) where code=LTRIM(rtrim(@p_PromotionCode)))
	Begin
	 insert into LibertyPower..PromotionCode(PromotionTypeId, Code, [Description], MarketingDescription, LegalDescription, CreatedBy, CreatedDate,InActive)
		values(@p_PromotionTypeId, @p_PromotionCode, @p_Desc, @p_MarketingDesc, @p_LegalDesc, @p_CreatedBy, getdate(), ISNULL(@p_InActive,0) )	
		select P.* from LibertyPower..PromotionCode P with (NOLock) where P.PromotionCodeId=SCOPE_IDENTITY()
	end
Set NOCOUNT OFF;
End
 
-- Copyright 11/22/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	usp_promocode_update
 * PURPOSE:		To update promotion code details
 * HISTORY:		
 *******************************************************************************
 * 11/23/2013 - Pradeep Katiyar
 * Created.
 * 12/16/2013 - Pradeep Katiyar
 * Updated - Added Inactive logic
 *******************************************************************************

 */
 
Alter proc usp_promocode_update
(
	@p_PromotionId		int,
	@p_PromotionCode	nchar(40),
	@p_Desc				varchar(1000)='',
	@p_MarketingDesc	varchar(1000)='',
	@p_LegalDesc		varchar(1000)='',
	@p_PromotionTypeId	int,
	@p_InActive			bit=null	
	
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..PromotionCode with (NOLock) where code=LTRIM(rtrim(@p_PromotionCode)) and PromotionCodeId<>@p_PromotionId)
	Begin
		update LibertyPower..PromotionCode set Code=@p_PromotionCode, PromotionTypeId=@p_PromotionTypeId, 
			[Description]=@p_Desc,MarketingDescription=@p_MarketingDesc,LegalDescription=@p_LegalDesc,InActive=ISNULL(@p_InActive,0) 
		where PromotionCodeId=@p_PromotionId
		select P.* from LibertyPower..PromotionCode P with (NOLock) where P.PromotionCodeId=@p_PromotionId
	 End
Set NOCOUNT OFF;
End

-- Copyright 11/23/2013 Liberty Power



Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_PromoCodelist]
 * PURPOSE:		Selects the promotionCode Details
 * HISTORY:		 
 *******************************************************************************
 * 11/20/2013 - Pradeep Katiyar
 * Created.
 * 12/16/2013 - Pradeep Katiyar
 * Updated - Added Inactive logic
 *******************************************************************************

 */

Alter PROCEDURE [dbo].[usp_PromoCodelist] 
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
	Set @SQL=@SQL +  ' and pc.Code='''+ @p_PromotionCode +''''
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

/*******************************************************************************

 * PROCEDURE:	[usp_PromotionCodeDelete]
 * PURPOSE:		Deletes Promotion Code  for specified Promotion Code Id
 * HISTORY:		 
 *******************************************************************************
 * 12/13/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_PromotionCodeDelete]
	@p_PromotionCodeId	int
AS
BEGIN
    SET NOCOUNT ON;
if not exists( select 1 from LibertyPower..Qualifier QF  with (NOLock) where qf.PromotionCodeId=@p_PromotionCodeId)   
    DELETE FROM	PromotionCode
	WHERE		PromotionCodeId = @p_PromotionCodeId

    SET NOCOUNT OFF;
END
-- Copyright 12/13/2013 Liberty Power


Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierByPromotionCodeIdSelect]
 * PURPOSE:		To check if Promotion code linked in contract qualifier based on promotion code ID
 * HISTORY:		
 *******************************************************************************
 * 12/16/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_QualifierByPromotionCodeIdSelect]
	 @p_PromotionCodeID		Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
select 1 from LibertyPower..Qualifier QF  with (NOLock) where qf.PromotionCodeId=@p_PromotionCodeID


Set NOCOUNT OFF;
END
-- Copyright 12/16/2013 Liberty Power

          
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	[usp_campaigncode_ins]
 * PURPOSE:		Add new Campaign code details
 * HISTORY:		
 *******************************************************************************
 * 11/29/2013 - Pradeep Katiyar
 * Created.
 * 12/16/2013 - Pradeep Katiyar
 * Updated - Added Inactive logic
 *******************************************************************************

 */
alter proc usp_campaigncode_ins
(
	@p_CampaignCode		nchar(40),
	@p_Desc				varchar(1000)='',
	@p_StartDate		Datetime,
	@p_EndDate			Datetime,
	@p_MaxEligible		int=null,
	@p_CreatedBy		int,
	@p_InActive			bit=null	
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..Campaign with (NOLock) where code=LTRIM(rtrim(@p_CampaignCode)))
	Begin
	 insert into LibertyPower..Campaign(Code, [Description], StartDate, EndDate,MaxEligible, CreatedBy, CreatedDate, InActive)
		values(@p_CampaignCode,@p_Desc, @p_StartDate, @p_EndDate,@p_MaxEligible, @p_CreatedBy, getdate(), @p_InActive)	
		select C.* from LibertyPower..Campaign C with (NOLock) where C.CampaignId=SCOPE_IDENTITY()
	end
Set NOCOUNT OFF;
End
 
-- Copyright 11/29/2013 Liberty Power
         
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

 * PROCEDURE:	usp_campaigncode_update
 * PURPOSE:		To update Campaign code details
 * HISTORY:		
 *******************************************************************************
 * 11/29/2013 - Pradeep Katiyar
 * Created.
 * 12/16/2013 - Pradeep Katiyar
 * Updated - Added Inactive logic
 *******************************************************************************

 */
 
alter proc usp_campaigncode_update
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
		select C.* from LibertyPower..Campaign C with (NOLock) where C.CampaignId=@p_CampaignId
	 End
Set NOCOUNT OFF;
End

-- Copyright 11/29/2013 Liberty Power



Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 

/*******************************************************************************

 * PROCEDURE:	[usp_QualifierByCampaignIdSelect]
 * PURPOSE:		To check if Campaign code linked in contract qualifier based on campaign code ID
 * HISTORY:		
 *******************************************************************************
 * 12/16/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_QualifierByCampaignIdSelect]
	 @p_CampaignID		Int
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
select 1 from LibertyPower..Qualifier QF  with (NOLock) where qf.CampaignId=@p_CampaignID


Set NOCOUNT OFF;
END
-- Copyright 12/16/2013 Liberty Power

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************

 * PROCEDURE:	[usp_campaignCode_list]
 * PURPOSE:		Selects the CampaignCode Details
 * HISTORY:		
 *******************************************************************************
 * 11/28/2013 - Pradeep Katiyar
 * Created.
 * 12/16/2013 - Pradeep Katiyar
 * Updated - Added Inactive logic
 *******************************************************************************

 */

alter PROCEDURE [dbo].[usp_campaignCode_list] 
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
			where c.Code=@p_CampaignCode and ISNULL(c.InActive,0)= @p_InActive
		else
			Select distinct c.CampaignId,c.Code,c.[Description] ,c.StartDate,c.EndDate,c.MaxEligible, u.Firstname + ' ' + u.Lastname as CreatedBy,c.CreatedDate,
			case isnull(c.Inactive,0) when 0 then 'No' else 'Yes' end Inactive,
					 isnull(qf.CampaignId,0) QualifierCampaignId  
			from  LibertyPower..Campaign c with (NOLock)	
				join LibertyPower..[User] u with (NOLock) on c.CreatedBy=u.UserID 
				left outer join LibertyPower..Qualifier QF  with (NOLock) on qf.CampaignId=c.CampaignId 
			where c.Code=@p_CampaignCode
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

/*******************************************************************************

 * PROCEDURE:	[usp_CampaignCodeDelete]
 * PURPOSE:		Deletes Campaign Code  for specified Campaign Code Id
 * HISTORY:		 
 *******************************************************************************
 * 12/13/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_CampaignCodeDelete]
	@p_CampaignId	int
AS
BEGIN
    SET NOCOUNT ON;
if not exists( select 1 from LibertyPower..Qualifier QF  with (NOLock) where qf.CampaignId=@p_CampaignId)   
    DELETE FROM	Campaign
	WHERE		CampaignId = @p_CampaignId

    SET NOCOUNT OFF;
END
-- Copyright 12/13/2013 Liberty Power