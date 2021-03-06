USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_sel')
	DROP  Procedure  usp_vendor_grace_period_sel
GO


/*
**********************************************************************
* 6/15/2010 Created
* Gail Mangaroo 
* Get all vendor grace period settings
**********************************************************************
* 8/16/2012 Gail Mangaroo 
* Added package_id 
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_grace_period_sel]
(@p_vendor_id int
 , @p_package_id int = 0 ) 
AS
BEGIN 

	DECLARE @params nvarchar(1000)
	DECLARE @strSQL nvarchar(1000)
	
	SET @params = N' @p_vendor_id int , @p_package_id int  '
	SET @strSQL = '
		SELECT *
	FROM [lp_commissions].[dbo].[vendor_grace_period] (NOLOCK) 
	WHERE active = 1
		AND vendor_id = @p_vendor_id '
	
	IF isnull(@p_package_id,0) <> 0
		SET @strSQL = @strSQL + ' AND package_id = @p_package_id '
  
	EXECUTE sp_executesql  @strSQL, @params , @p_vendor_id = @p_vendor_id , @p_package_id = @p_package_id
END 
GO