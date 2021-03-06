USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/8/2010 Created
* Gail Mangaroo 
* Update vendor payment option
**********************************************************************
* 6/2/2010 Gail Mangaroo 
* Added term field
**********************************************************************
* Modified: 4/25/2012 - 8/25/2012 Gail Mangaroo 
* Added end date and package id fields
**********************************************************************
* Modified: 12/13/2013 Sadiel Jarvis 
* Added ForBonusTransaction field
**********************************************************************
*/

ALTER Procedure [dbo].[usp_vendor_payment_option_upd]
( @p_option_id int 
 , @p_vendor_id int 
 , @p_payment_option_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_term float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0    
 , @p_ForBonusTransaction bit = 0
 )  
AS
BEGIN 

	SET NOCOUNT ON

	UPDATE [lp_commissions].[dbo].[vendor_payment_option]
	   SET [vendor_id] = @p_vendor_id
		  ,[payment_option_id] = @p_payment_option_id
		  , date_effective = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username		  
		  ,[term] = @p_term
		  ,[date_end] = @p_date_end
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  ,[ForBonusTransaction] = @p_ForBonusTransaction
		  
	 WHERE option_id =  @p_option_id
	 						 
 	 RETURN @@ROWCOUNT
	 
	 SET NOCOUNT OFF
	
END
