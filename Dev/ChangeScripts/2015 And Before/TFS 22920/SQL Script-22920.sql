USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromoCodelist]    Script Date: 12/18/2013 09:39:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromoCodelist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromoCodelist]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromoCodelist]    Script Date: 12/18/2013 09:39:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	[usp_Promo_Code_list]
 * PURPOSE:		Selects the promotionCode Details
 * HISTORY:		To display the promotion code list 
 *******************************************************************************
 * 11/20/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_PromoCodelist] 
	@p_PromotionCode		 nchar(40) = '', 
	@p_orderby				varchar(50)='CreatedDate desc'
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF

Declare @SQL as varchar(1000)
Set @SQL='Select pc.PromotionCodeId,pc.Code,pt.[Description] as PromotionType,pc.[Description],pc.MarketingDescription,pc.LegalDescription,
			u.Firstname + '' '' + u.Lastname as CreatedBy,pc.CreatedDate 
	from  LibertyPower..PromotionCode pc with (NOLock)
		join LibertyPower..PromotionType pt with (NOLock) on pc.PromotionTypeId=pt.PromotionTypeId	
		join LibertyPower..[User] u with (NOLock) on pc.CreatedBy=u.UserID '
	
if (ltrim(rtrim(@p_PromotionCode))<>'')                                                                                                                              
	Set @SQL=@SQL +  ' where pc.Code='''+ @p_PromotionCode +''''
if (ltrim(rtrim(@p_orderby))<>'') 
	Set @SQL=@SQL +  ' order by ' + @p_orderby
exec(@SQL)

Set NOCOUNT OFF;
END
-- Copyright 11/20/2013 Liberty Power

         

GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyCodeAndIdSelect]    Script Date: 12/18/2013 09:39:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromotionCodebyCodeAndIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromotionCodebyCodeAndIdSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromotionCodebyCodeAndIdSelect]    Script Date: 12/18/2013 09:39:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	[usp_PromotionCodebyCodeAndIdSelect]
 * PURPOSE:		Selects the promotionCode Details based on promotion code and ID
 * HISTORY:		To check if promotion code  exists in case of promotion code update 
 *******************************************************************************
 * 11/22/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_PromotionCodebyCodeAndIdSelect]
	 @p_PromotionID		Int,
	 @p_PromotionCode char(20)
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
Select P.* from  LibertyPower..PromotionCode P with (NOLock)

where
P.Code=@p_PromotionCode and p.PromotionCodeId<>@p_PromotionID


Set NOCOUNT OFF;
END
-- Copyright 11/22/2013 Liberty Power

         

GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_ins]    Script Date: 12/18/2013 09:40:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_promocode_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_promocode_ins]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_ins]    Script Date: 12/18/2013 09:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	[usp_promocode_ins]
 * PURPOSE:		Add new promotion code details
 * HISTORY:		Add new promotion code details
 *******************************************************************************
 * 11/22/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
CREATE proc [dbo].[usp_promocode_ins]
(
	@p_PromotionCode	nchar(40),
	@p_Desc				varchar(1000)='',
	@p_MarketingDesc	varchar(1000)='',
	@p_LegalDesc		varchar(1000)='',
	@p_PromotionTypeId	int,
	@p_CreatedBy		int	
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..PromotionCode with (NOLock) where code=LTRIM(rtrim(@p_PromotionCode)))
	Begin
	 insert into LibertyPower..PromotionCode(PromotionTypeId, Code, [Description], MarketingDescription, LegalDescription, CreatedBy, CreatedDate)
		values(@p_PromotionTypeId, @p_PromotionCode, @p_Desc, @p_MarketingDesc, @p_LegalDesc, @p_CreatedBy, getdate())	
		select P.* from LibertyPower..PromotionCode P with (NOLock) where P.PromotionCodeId=SCOPE_IDENTITY()
	end
Set NOCOUNT OFF;
End
 
-- Copyright 11/22/2013 Liberty Power

         

GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllPromotionType]    Script Date: 12/18/2013 09:40:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetAllPromotionType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllPromotionType]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllPromotionType]    Script Date: 12/18/2013 09:40:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	[usp_GetAllPromotionType]
 * PURPOSE:		To select all promotion types
 * HISTORY:		Get the all promotion types to add or update promotion code detials
 *******************************************************************************
 * 11/23/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_GetAllPromotionType]	
AS
BEGIN

-- set nocount on and default isolation level
SET NOCOUNT ON
                                                                                                                                       
Select P.PromotionTypeId,p.Code from LibertyPower..PromotionType  P with (NoLock)
order by p.Code
Set NOCOUNT OFF;
END
    
-- Copyright 11/23/2013 Liberty Power

         

GO



USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_update]    Script Date: 12/18/2013 09:41:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_promocode_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_promocode_update]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_promocode_update]    Script Date: 12/18/2013 09:41:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************

 * PROCEDURE:	usp_promocode_update
 * PURPOSE:		To update promotion code details
 * HISTORY:		To update promotion code details
 *******************************************************************************
 * 11/23/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */
 
CREATE proc [dbo].[usp_promocode_update]
(
	@p_PromotionId		int,
	@p_PromotionCode	nchar(40),
	@p_Desc				varchar(1000)='',
	@p_MarketingDesc	varchar(1000)='',
	@p_LegalDesc		varchar(1000)='',
	@p_PromotionTypeId	int
	
)
as
Begin
SET NOCOUNT ON
if not exists(select code from LibertyPower..PromotionCode with (NOLock) where code=LTRIM(rtrim(@p_PromotionCode)) and PromotionCodeId<>@p_PromotionId)
	Begin
		update LibertyPower..PromotionCode set Code=@p_PromotionCode, PromotionTypeId=@p_PromotionTypeId, 
			[Description]=@p_Desc,MarketingDescription=@p_MarketingDesc,LegalDescription=@p_LegalDesc
		where PromotionCodeId=@p_PromotionId
		select P.* from LibertyPower..PromotionCode P with (NOLock) where P.PromotionCodeId=@p_PromotionId
	 End
Set NOCOUNT OFF;
End

-- Copyright 11/23/2013 Liberty Power
GO


