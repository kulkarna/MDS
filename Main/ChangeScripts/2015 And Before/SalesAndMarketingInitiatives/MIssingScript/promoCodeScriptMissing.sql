USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromoCodelist]    Script Date: 12/17/2013 17:57:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PromoCodelist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PromoCodelist]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_PromoCodelist]    Script Date: 12/17/2013 17:57:25 ******/
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

create PROCEDURE [dbo].[usp_PromoCodelist] 
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


