-------------------------------------------------------------------------
--SQL Scripts: promoCode
--1.  29441:  Add InActive Logic to promoCode and Campaign screen
-----------------------------------------------------------------------------------


USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if not exists(select  * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PromotionCode' and COLUMN_NAME = 'InActive')
BEGIN
Alter table LibertyPower..PromotionCode add  InActive bit null
END
go
if not exists(select  * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Campaign' and COLUMN_NAME = 'InActive')
BEGIN
Alter table LibertyPower..Campaign add  InActive bit null
END

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_ins]    Script Date: 01/17/2014 14:56:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_promocode_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_promocode_ins]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_ins]    Script Date: 01/17/2014 14:56:53 ******/
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
CREATE proc [dbo].[usp_promocode_ins]
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


GO




USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_update]    Script Date: 01/17/2014 14:56:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_promocode_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_promocode_update]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_update]    Script Date: 01/17/2014 14:56:15 ******/
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
 
CREATE proc [dbo].[usp_promocode_update]
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




GO




USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromoCodelist]    Script Date: 01/17/2014 14:55:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromoCodelist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromoCodelist]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromoCodelist]    Script Date: 01/17/2014 14:55:47 ******/
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
	Set @SQL=@SQL +  ' and pc.Code='''+ @p_PromotionCode +''''
if (@p_InActive is not null)                                                                                                                              
	Set @SQL=@SQL +  ' and isnull(pc.Inactive,0)='+ cast(@p_InActive as varchar(1))
if (ltrim(rtrim(@p_orderby))<>'') 
	Set @SQL=@SQL +  ' order by ' + @p_orderby

exec(@SQL)

Set NOCOUNT OFF;
END
-- Copyright 11/20/2013 Liberty Power


GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodeDelete]    Script Date: 01/17/2014 14:55:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromotionCodeDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromotionCodeDelete]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodeDelete]    Script Date: 01/17/2014 14:55:03 ******/
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



GO




USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromotionCodeIdSelect]    Script Date: 01/17/2014 14:54:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_QualifierByPromotionCodeIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_QualifierByPromotionCodeIdSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromotionCodeIdSelect]    Script Date: 01/17/2014 14:54:20 ******/
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

          

GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_campaigncode_ins]    Script Date: 01/17/2014 14:52:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_campaigncode_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_campaigncode_ins]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_campaigncode_ins]    Script Date: 01/17/2014 14:52:56 ******/
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
CREATE proc [dbo].[usp_campaigncode_ins]
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
         

GO




USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_campaigncode_update]    Script Date: 01/17/2014 14:52:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_campaigncode_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_campaigncode_update]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_campaigncode_update]    Script Date: 01/17/2014 14:52:15 ******/
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
 
CREATE proc [dbo].[usp_campaigncode_update]
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




GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_QualifierByCampaignIdSelect]    Script Date: 01/17/2014 14:51:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_QualifierByCampaignIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_QualifierByCampaignIdSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_QualifierByCampaignIdSelect]    Script Date: 01/17/2014 14:51:16 ******/
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


GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_campaignCode_list]    Script Date: 01/17/2014 14:50:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_campaignCode_list]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_campaignCode_list]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_campaignCode_list]    Script Date: 01/17/2014 14:50:03 ******/
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

        


GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_CampaignCodeDelete]    Script Date: 01/17/2014 14:48:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CampaignCodeDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CampaignCodeDelete]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_CampaignCodeDelete]    Script Date: 01/17/2014 14:48:54 ******/
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
GO

---------------------------------------------------------------------------------------------------------------
--2.  28372:  Add InActive Logic to promoCode and Campaign screen
-----------------------------------------------------------------------------------

--Independence Plan (FIXED)= 1
--Super Saver (FIXED) = 2
--Custom Fixed (FIXED)=8
--Freedom To Save (FIXED)=13
--Fixed IL Wind (GREEN)
--Fixed National Green E (GREEN)
--Fixed CT Green (GREEN)
--Fixed MD Green (GREEN)
--Fixed PA Green (GREEN)

---------------------------------------------------------------------------
--28372: (Phase 3) As a Marketing Manager I need to Update the Product Type filter to be for Product Brand instead 
--so that i can create Promotion codes by products instead of Product types
------------------------------------------------------------------------------
Use LibertyPower
Go
if  exists(select  * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Qualifier' and COLUMN_NAME = 'ProductTypeId')
BEGIN
EXEC sp_RENAME 'Qualifier.ProductTypeId','ProductBrandId','COLUMN'
END
Go

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_ProductType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_ProductType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Qualifier_ProductBrand]') AND parent_object_id = OBJECT_ID(N'[dbo].[Qualifier]'))
ALTER TABLE [dbo].[Qualifier] DROP CONSTRAINT [FK_Qualifier_ProductBrand]
GO

ALTER TABLE [dbo].[Qualifier]  WITH CHECK ADD  CONSTRAINT [FK_Qualifier_ProductBrand] FOREIGN KEY([ProductBrandId])
REFERENCES [dbo].[ProductBrand] ([ProductBrandID])
GO

ALTER TABLE [dbo].[Qualifier] CHECK CONSTRAINT [FK_Qualifier_ProductBrand]
GO
-------------------------------------------------------
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 12/10/2013 10:26:00 ******/
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
--Modified: Sara Lakshmanan DEc 10 2013
--modified ProductTypeId to ProductBrandId
---------------------------------------------------------------------------
*/

ALTER PROCEDURE [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]
	 @p_PromotionCode char(20), @p_SignDate datetime, @p_SalesChannelId int= null, @p_MarketId int=null,
	  @p_UtilityId int = null,@p_AccountTypeId int=null,  @p_Term int=null,
 @p_ProductBrandId int=null, @p_PriceTier int=null, @p_ContractStartDate datetime=null  
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
and (Q.ProductBrandId=@p_ProductBrandId or Q.ProductBrandId is Null)
and (Q.PriceTierID=@p_PriceTier or Q.PriceTierID is Null)
and ((Q.ContractEffecStartPeriodStartDate<=@p_ContractStartDate and Q.ContractEffecStartPeriodLastDate>=@p_ContractStartDate)
	    or (Q.ContractEffecStartPeriodStartDate is Null and Q.ContractEffecStartPeriodLastDate is Null))


Set NOCOUNT OFF;
END
GO

      
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 01/17/2014 16:11:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 01/17/2014 16:11:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[[usp_GetAllValidQualifiersforToday]]
*
* DEFINITION:  Selects the list of Qualifier records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013
*/
--------------------------------------------------------------------------
--Modified Dec 10 2013
--Sara -- Change productType to productBrand
-------------------------------------------------------------------------
--Modified Dec 13 2013
--Sara -- Added InActive Field
-------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Q.QualifierId,Q.CampaignId, Q.PromotionCodeId, Q.SalesChannelId, Q.MarketId, Q.UtilityId,Q.AccountTypeId, Q.Term,
Q.ProductBrandId,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
Q.PriceTierId,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)Inner Join
LibertyPower..Campaign C on C.CampaignId=Q.CampaignId
Inner Join LibertyPower..PromotionCode P with (NoLock) on
P.PromotionCodeId=Q.PromotionCodeId
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
Set NOCOUNT OFF;
END

GO



-----------------------------------------------------------------------------------
--need to validate : usp_qualifierListbyCampaignIdSelect
-----------------------------------------------------------
--Insert data for the other ProductBrands
-----------------------------------------------------------------------------------

If not exists (Select 1 from LIbertypower..Qualifier Q where Q.productBrandId=2)
Begin


Insert into LibertyPower..Qualifier
Select Q.CampaignId,Q.PromotionCodeId,Q.SalesChannelId,Q.MarketId
,Q.UtilityId,Q.AccountTypeId,Q.Term,2,Q.SignStartDate,Q.SignEndDate
,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate
,Q.PriceTierId,Q.AutoApply,Q.CreatedBy,GETDATE(),1

 from LIbertypower..Qualifier Q With (NoLock) where Q.productbrandid=1
 
 END
 
 -------------------------------------------------------------------------
 
 
If not exists (Select 1 from LIbertypower..Qualifier Q where Q.productBrandId=8)
Begin
Insert into LibertyPower..Qualifier
Select Q.CampaignId,Q.PromotionCodeId,Q.SalesChannelId,Q.MarketId
,Q.UtilityId,Q.AccountTypeId,Q.Term,8,Q.SignStartDate,Q.SignEndDate
,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate
,Q.PriceTierId,Q.AutoApply,Q.CreatedBy,GETDATE(),1

 from LIbertypower..Qualifier Q With (NoLock) where Q.productbrandid=1

 END
  ------------------------------------------------------------------------
 
If not exists (Select 1 from LIbertypower..Qualifier Q where Q.productBrandId=13)
Begin 
Insert into LibertyPower..Qualifier
Select Q.CampaignId,Q.PromotionCodeId,Q.SalesChannelId,Q.MarketId
,Q.UtilityId,Q.AccountTypeId,Q.Term,13,Q.SignStartDate,Q.SignEndDate
,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate
,Q.PriceTierId,Q.AutoApply,Q.CreatedBy,GETDATE(),1

 from LIbertypower..Qualifier Q With (NoLock) where Q.productbrandid=1

END
 
 
 -----------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProductBrandIdGet]    Script Date: 01/17/2014 15:05:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductBrandIdGet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductBrandIdGet]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProductBrandIdGet]    Script Date: 01/17/2014 15:05:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 /*
*
* PROCEDURE:	[usp_ProductBrandIdGet]
*
* DEFINITION:  Get the product brandid for the product brand name supplied
*
* RETURN CODE: Returns the Product BrandId
*
* REVISIONS:	Sara lakshmanan 12/10/2013
*/

CREATE PROCEDURE [dbo].[usp_ProductBrandIdGet]  
	@PriceID					BIGINT
AS
BEGIN

SET NoCOUNT ON;
	SELECT 
		ProductBrandID
	FROM [LibertyPower].[dbo].[Price] with (NOLOCK)
	WHERE 
		ID = @PriceID   
		                                                                                                                            
SET NoCOUNT OFF;	
END

GO


USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 01/17/2014 16:12:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenie_GetQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGenie_GetQualifiersforToday]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[spGenie_GetQualifiersforToday]    Script Date: 01/17/2014 16:12:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Date:     10/24/2013
-- Description:	Getting the details from Libertypower Qualifier table and mapping them to the Genie database Qualifier Table requirements  
-- =============================================
-- Date:     12/10/2013
-- Description: Change product Type to productBrand 
-- =============================================
CREATE proc [dbo].[spGenie_GetQualifiersforToday] as
begin

SET NOCOUNT ON

SET ANSI_PADDING ON

Select  Q.PromotionCodeId as PromotionCodeID, S.ChannelName as PartnerName,M.MarketCode as MarketName,
U.UtilityCode as UtilityName,A.AccountType as AccountTypeDesc,Q.Term as ContractTerm,
PB.Name as BrandDescription,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
DPT.Description as PriceTierDescription,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)

LEft  Join LibertyPower..SalesChannel S With (noLock) on Q.SalesChannelId=S.ChannelID
LEft  Join LibertyPower..Market M with (noLock) on Q.MarketId=M.ID 
LEft  Join Libertypower..Utility U with (noLock) on Q.UtilityId= U.ID
LEft  Join LibertyPower..AccountType A with (NoLock) on Q.AccountTypeId=A.ID
--LEft  Join Libertypower..ProductType PT with (noLock) on Q.ProductTypeId=PT.ProductTypeID
LEft  Join Libertypower..ProductBrand PB with (noLock) on Q.ProductBrandId=PB.ProductBrandID
LEft  Join Libertypower..DailyPricingPriceTier DPT with (NOLock) on Q.PriceTierId=DPT.ID
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()


SET NOCOUNT OFF
end

GO

------------------------------------------------------------------------------------------------------------

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetQualifierFieldValues]    Script Date: 12/18/2013 10:16:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetQualifierFieldValues]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_GetQualifierFieldValues]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetQualifierFieldValues]    Script Date: 12/18/2013 10:16:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

* Function:      [ufn_GetQualifierFieldValues]
* PURPOSE:       Returns list of field values for qualifier table based on table name
* HISTORY:       To return the value of fields for qualifier table.
*******************************************************************************
* 12/05/2013 - Pradeep Katiyar
* Created.
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
                  Where  AT.ID in(select QF.AccountTypeId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='ProductBrand')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + PT.Name
                  FROM LibertyPower..ProductBrand PT with (NOLock) 
                  Where PT.ProductBrandID in(select QF.ProductBrandID from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
      if (@TableName ='DailyPricingPriceTier')
            SELECT  @values = COALESCE(@values+'<br/>' ,'') + DP.Name
                  FROM LibertyPower..DailyPricingPriceTier DP with (NOLock) 
                  where DP.ID in(select QF.PriceTierId from  LibertyPower..Qualifier QF  with (NOLock)
                        Where QF.CampaignID=@CampaignID and QF.GroupBy=@GroupBy)
                        
      
RETURN @values
END

-- Copyright 12/05/2013 Liberty Power
GO
----------------------------------------------------------------------------------------------------------
--3.  28374:  Max LImit Logic on PromoCode
-----------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_HasCampaignReachedMaxLimit]    Script Date: 12/13/2013 11:10:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_HasCampaignReachedMaxLimit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_HasCampaignReachedMaxLimit]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_HasCampaignReachedMaxLimit]    Script Date: 12/13/2013 11:10:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_HasCampaignReachedMaxLimit]
*
* DEFINITION:  Finds if the given Qualifier has hit the max limit given in the Campaign Table
*
* RETURN CODe:
*
* REVISIONS:	Sara lakshamanan 12/12/2013

exec [usp_HasCampaignReachedMaxLimit] 159
*/

CREATE PROCEDURE [dbo].[usp_HasCampaignReachedMaxLimit]
	 @p_QualifierId int
AS
BEGIN


-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF
Declare @result bit=0;
Declare @w_noofContracts int;

Declare @w_CampaignId int;
Set @w_CampaignId=(Select CampaignId from Libertypower..Qualifier with (NoLock) where QualifierId=@p_QualifierId)

If exists (Select C.MaxEligible  from Libertypower..Campaign C with (NoLock) where C.CampaignId=@w_CampaignId and C.MaxEligible is Not Null)
Begin

Set @w_noofContracts =(Select Distinct Count(CQ.ContractId) from Libertypower..ContractQualifier CQ  with (NoLock)
Inner Join LibertyPower..Qualifier Q with (NoLock) on Q.QualifierId= CQ.QualifierId
Inner Join Libertypower..Campaign C  with (NoLock) on C.CampaignId=Q.CampaignId
Where C.CampaignId =@w_CampaignId)

If (@w_noofContracts>=(Select C.MaxEligible  from Libertypower..Campaign C with (NoLock) where C.CampaignId=@w_CampaignId  ))
    Select @result=1   
END

  Select @result;  
  
Set NOCOUNT OFF;
END


GO

----------------------------------------------------------------------------------
--Scripts to get the Description for all the respective Id's provided
--SalesChannel, Market, Utility, AccountType,Product Brand and Price Tier
-------------------------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetSalesChannelName]    Script Date: 12/26/2013 16:29:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetSalesChannelName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetSalesChannelName]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetSalesChannelName]    Script Date: 12/26/2013 16:29:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

		 
	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the salesChannel NAME for the given sales channelID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetSalesChannelName]
	@p_salesChannelId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		ChannelName
	From 
		LibertyPower.dbo.SalesChannel with (nolock)		
	Where 
		ChannelID=@p_salesChannelId
		
	SET NOCOUNT OFF;
END

GO


-----------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMarketCode]    Script Date: 12/26/2013 16:30:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetMarketCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetMarketCode]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMarketCode]    Script Date: 12/26/2013 16:30:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the market CODE for the given marketID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetMarketCode]
	@p_marketId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		MarketCode
	From 
		LibertyPower.dbo.Market with (nolock)		
	Where 
		ID=@p_marketId
		
	SET NOCOUNT OFF;
END

GO


--------------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUtilityCode]    Script Date: 12/26/2013 16:30:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUtilityCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUtilityCode]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetUtilityCode]    Script Date: 12/26/2013 16:30:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the Utility CODE for the given utility
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetUtilityCode]
	@p_utlityId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		UtilityCode
	From 
		LibertyPower.dbo.Utility with (nolock)		
	Where 
		ID=@p_utlityId
		
	SET NOCOUNT OFF;
END

GO


-----------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountTypeDescription]    Script Date: 12/26/2013 16:33:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAccountTypeDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAccountTypeDescription]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAccountTypeDescription]    Script Date: 12/26/2013 16:33:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the AccoumntType CODE for the given AccountTypeID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetAccountTypeDescription]
	@p_AccountTypeId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		AccountType
	From 
		LibertyPower.dbo.AccountType with (nolock)		
	Where 
		ID=@p_AccountTypeId
		
	SET NOCOUNT OFF;
END

GO


----------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetproductBrandDescription]    Script Date: 12/26/2013 16:34:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetproductBrandDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetproductBrandDescription]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetproductBrandDescription]    Script Date: 12/26/2013 16:34:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the Product Brand name for the given ProductBrandID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetproductBrandDescription]
	@p_ProductBrandId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		Name
	From 
		LibertyPower.dbo.ProductBrand with (nolock)		
	Where 
		ProductBrandId=@p_ProductBrandId
		
	SET NOCOUNT OFF;
END

GO


----------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetPriceTierDescription]    Script Date: 12/26/2013 16:34:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetPriceTierDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetPriceTierDescription]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetPriceTierDescription]    Script Date: 12/26/2013 16:34:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




	-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/26/2013
-- Description:Get the PriceTier Desc for the given PriceTierID
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetPriceTierDescription]
	@p_PriceTierId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	

    Select 
		Description
	From 
		LibertyPower.dbo.DailyPricingPriceTier with (nolock)		
	Where 
		ID=@p_PriceTierId
		
	SET NOCOUNT OFF;
END

GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 01/17/2014 16:13:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidPromotionCodesforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidPromotionCodesforToday]    Script Date: 01/17/2014 16:13:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_GetAllValidPromotionCodesforToday]
*
* DEFINITION:  Selects the list of PromotionCodes records that are valid as of today
*
* RETURN CODE: Returns the PromotionCodes Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013

--Dec 13 2012 Added InActive Column in where clause Sara
*/

CREATE PROCEDURE [dbo].[usp_GetAllValidPromotionCodesforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Distinct Q.PromotionCodeId,P.PromotionTypeId,P.Code,P.Description,
P.MarketingDescription,P.LegalDescription,P.CreatedBy,P.CreatedDate
 from LibertyPower..Qualifier  Q with (NoLock) inner Join LIbertypower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId  
Inner Join LIbertyPower..Campaign C With (NoLock) on C.CampaignId=Q.CampaignId
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
 and P.InActive=0 and C.InActive=0
Set NOCOUNT OFF;
END

GO




USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]    Script Date: 12/13/2013 11:19:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[usp_GetAllValidQualifiersandPromoCodeforToday]
*
* DEFINITION:  Selects the list of Qualifier and PromotionCode records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information and Promotion code 
*
* REVISIONS:	Sara lakshmanan 9/30/2013
--Added InActive column to where clause Dec 13 2013
*/

ALTER PROCEDURE [dbo].[usp_GetAllValidQualifiersandPromoCodeforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Q.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LIbertypower..Campaign C With (NoLock)
 on Q.CampaignId=C.CampaignId 
 Inner Join LibertyPower..PromotionCode P with (NOLock) on Q.PromotionCodeId=P.PromotionCodeId

where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
Set NOCOUNT OFF;
END
GO
      

-----------------------------------------------------------------
USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 01/17/2014 16:13:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllValidQualifiersforToday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllValidQualifiersforToday]    Script Date: 01/17/2014 16:13:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
*
* PROCEDURE:	[[usp_GetAllValidQualifiersforToday]]
*
* DEFINITION:  Selects the list of Qualifier records that are valid as of today
*
* RETURN CODE: Returns the Qualifier Information 
*
* REVISIONS:	Sara lakshmanan 10/18/2013
*/
--------------------------------------------------------------------------
--Modified Dec 10 2013
--Sara -- Change productType to productBrand
-------------------------------------------------------------------------
--Modified Dec 13 2013
--Sara -- Added InActive Field
-------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_GetAllValidQualifiersforToday]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
                                                                                                                                       
Select Q.QualifierId,Q.CampaignId, Q.PromotionCodeId, Q.SalesChannelId, Q.MarketId, Q.UtilityId,Q.AccountTypeId, Q.Term,
Q.ProductBrandId,Q.SignStartDate,Q.SignEndDate,Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,
Q.PriceTierId,Q.AutoApply from LibertyPower..Qualifier  Q with (NoLock)Inner Join
LibertyPower..Campaign C on C.CampaignId=Q.CampaignId
Inner Join LibertyPower..PromotionCode P with (NoLock) on
P.PromotionCodeId=Q.PromotionCodeId
where
Q.SignStartDate<=GETDATE() and Q.SignEndDate>=GETDATE()
and C.InActive=0
and P.InActive=0
Set NOCOUNT OFF;
END

GO




--------------------------------------------------------------------------------------------------
USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]    Script Date: 12/13/2013 13:05:00 ******/
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
--Modified: Sara Lakshmanan DEc 10 2013
--modified ProductTypeId to ProductBrandId
--Modified: Sara Lakshmanan DEc 13 2013
-- Added InActive field to Where Clause
---------------------------------------------------------------------------
*/

ALTER PROCEDURE [dbo].[usp_QualifierByPromoCodeandDeterminentsSelect]
	 @p_PromotionCode char(20), @p_SignDate datetime, @p_SalesChannelId int= null, @p_MarketId int=null,
	  @p_UtilityId int = null,@p_AccountTypeId int=null,  @p_Term int=null,
 @p_ProductBrandId int=null, @p_PriceTier int=null, @p_ContractStartDate datetime=null  
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
--SET NO_BROWSETABLE OFF


                                                                                                                                       
Select Q.* from LibertyPower..Qualifier  Q with (NoLock) Inner Join LibertyPower..PromotionCode P with (NoLock)
on Q.PromotionCodeId=P.PromotionCodeId
Inner Join LibertyPower..Campaign C On Q.CampaignId=C.CampaignId
where
P.InActive=0 and C.InActive=0 and
Ltrim(Rtrim(P.Code))=Ltrim(Rtrim(@p_PromotionCode)) and
 Q.SignStartDate<=@p_SignDate and Q.SignEndDate>=@p_SignDate
and (Q.SalesChannelId=@p_SalesChannelId or Q.SalesChannelId is Null)
and (Q.MarketID=@p_MarketId or Q.MarketId is Null)
and (Q.UtilityId=@p_UtilityId or Q.UtilityId is Null)
and (Q.AccountTypeId=@p_AccountTypeId or Q.AccountTypeId is Null)
--and (Q.Term=@p_Term or Term is Null)
and (Q.Term<=@p_Term or Term is Null)
and (Q.ProductBrandId=@p_ProductBrandId or Q.ProductBrandId is Null)
and (Q.PriceTierID=@p_PriceTier or Q.PriceTierID is Null)
and ((Q.ContractEffecStartPeriodStartDate<=@p_ContractStartDate and Q.ContractEffecStartPeriodLastDate>=@p_ContractStartDate)
	    or (Q.ContractEffecStartPeriodStartDate is Null and Q.ContractEffecStartPeriodLastDate is Null))


Set NOCOUNT OFF;
END
GO
---------------------------------------------------------------------------------------------


If Exists (Select * from Libertypower..PromotionCode where InActive is Null)
Begin
Update LIbertypower..PromotionCode Set InActive=0 where InActive is Null
End

GO


If Exists (Select * from Libertypower..Campaign where InActive is Null)
Begin
Update LIbertypower..Campaign Set InActive=0 where InActive is Null
End

GO
-------------------------------------------------------------------------------------------------------------------
--4. 27420. create and manage the qualifying criteria for a promo campaign code through an administration screen.
---------------------------------------------------------------------------------------------------------------------
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
GO


