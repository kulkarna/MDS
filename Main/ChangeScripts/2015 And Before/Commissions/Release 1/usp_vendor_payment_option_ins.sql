USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 4/8/2010 Created
* Gail Mangaroo 
* Create vendor payment option
**********************************************************************
* 6/2/2010 Gail Mangaroo 
* Added term field
**********************************************************************
* Modified: 4/25/2012 - 8/25/2012 Gail Mangaroo 
* Added end date and group id fields
**********************************************************************
*/


CREATE Procedure [dbo].[usp_vendor_payment_option_ins]
( 
 @p_vendor_id int 
 , @p_payment_option_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_term float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_payment_option]
           ([vendor_id]
           ,[payment_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[term] 
           ,[date_end]
           ,[package_id]
           ,[interval_type_id]
           )
           
     SELECT 
           @p_vendor_id
           ,@p_payment_option_id
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_term
           ,@p_date_end
           ,@p_package_id
           ,@p_interval_type_id
   					 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 

GO

