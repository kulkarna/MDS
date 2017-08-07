USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_report_date_option_sel_by_vendor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_report_date_option_sel_by_vendor]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 8/28/2012 Created
* Gail Mangaroo 
* Get all vendor report date option
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_report_date_option_sel_by_vendor]
(@p_vendor_id int
, @p_package_id int = 0 ) 
AS
BEGIN 

	DECLARE @strParams nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @strParams = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
			FROM [lp_commissions].[dbo].[vendor_report_date_option] (NOLOCK)
			WHERE active = 1
				AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL
		, @strParams 
		, @p_vendor_id = @p_vendor_id
		, @p_package_id = @p_package_id
		
END 
GO


