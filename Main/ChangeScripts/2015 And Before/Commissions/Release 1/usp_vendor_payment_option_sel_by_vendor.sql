USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_sel_by_vendor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_sel_by_vendor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
**********************************************************************
* 4/7/2010 Created
* Gail Mangaroo 
* Get vendor payment options
**********************************************************************
* Modified 8/11/2011 Gail Mangaroo 
* Added order by 
**********************************************************************

*/
CREATE Procedure [dbo].[usp_vendor_payment_option_sel_by_vendor]
( @p_vendor_id int
 , @p_option_type_id int = 0 
 , @p_package_id int = 0 ) 
AS
BEGIN 
	
  	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int , @p_option_type_id int '
	SET @strSQL = '
		SELECT *
		  FROM [lp_commissions].[dbo].[vendor_payment_option] vp (NOLOCK)
			LEFT JOIN lp_commissions..payment_option po (NOLOCK) ON vp.payment_option_id= po.payment_option_id 
		  WHERE vp.active = 1 
			AND vp.vendor_id = @p_vendor_id  '
			
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND vp.package_id = @p_package_id '
  
	IF ISNULL(@p_option_type_id, 0) <> 0
		SET @strSQL = @strSQL + ' AND po.payment_option_type_id = @p_option_type_id '
		
	SET @strSQL = @strSQL + ' ORDER BY date_effective  '
		 
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id 
		, @p_option_type_id = @p_option_type_id 
		
	
END 
GO
