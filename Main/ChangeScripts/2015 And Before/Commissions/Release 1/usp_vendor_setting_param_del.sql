USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_del]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_del]
GO


/*
**********************************************************************
* 4/10/2012 Created
* Gail Mangaroo 
* Delete /De-Activate parameter
**********************************************************************

*/

CREATE Procedure [dbo].[usp_vendor_setting_param_del]
( @p_vendor_setting_param_id int 
 , @p_username varchar(50) 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_setting_param]
	   SET [active] = 0 
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
	 
	 WHERE vendor_setting_param_id =  @p_vendor_setting_param_id
	 	 					 
 	RETURN @@ROWCOUNT

END
GO
