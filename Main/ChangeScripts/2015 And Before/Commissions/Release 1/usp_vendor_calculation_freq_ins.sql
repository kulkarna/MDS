USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_calculation_freq_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_calculation_freq_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Create vendor calculation freq
**********************************************************************
* 3/2/2012 - 8/25/2012 Gail Mangaroo 
* Added end date and package id fields
**********************************************************************
*/

CREATE Procedure [dbo].[usp_vendor_calculation_freq_ins]
( 
 @p_vendor_id int 
 , @p_calculation_freq_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_interval float = 0 
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_calculation_freq]
           ([vendor_id]
           ,[calculation_freq_id]
           ,[date_effective]
           ,[date_end] 
           ,[active]
           ,[date_created]
           ,[username]
           ,[interval]
           ,[package_id] 
		   ,[interval_type_id]
           )
     SELECT 
           @p_vendor_id
           ,@p_calculation_freq_id
           ,@p_date_effective
           ,@p_date_end
           ,@p_active
           ,getdate()
           ,@p_username
    	   ,@p_interval
		   ,@p_package_id
    	   ,@p_interval_type_id	 
    	   
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO


