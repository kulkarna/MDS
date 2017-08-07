USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_calculation_freq_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_calculation_freq_upd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Update vendor calculation freq
**********************************************************************
* 3/2/2012 Gail Mangaroo 
* Added date_end column
**********************************************************************
* Modified: 8/25/2012 Gail Mangaroo 
* Added package id fields
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_calculation_freq_upd]
( @p_freq_id int 
 , @p_vendor_id int 
 , @p_calculation_freq_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_interval float = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_calculation_freq]
	   SET [vendor_id] = @p_vendor_id
		  ,[calculation_freq_id] = @p_calculation_freq_id
		  ,[date_effective] = @p_date_effective
		  ,[date_end] = @p_date_end
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  ,[interval] = @p_interval
	 
	 WHERE freq_id =  @p_freq_id
	 				 
 	RETURN @@ROWCOUNT
	
END
GO


