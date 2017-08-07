USE [lp_commissions]
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_payment_freq_ins')
	DROP  Procedure  usp_vendor_payment_freq_ins
GO

/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Create vendor payment freq
**********************************************************************
* 8/16/2012 //  4/3/2012 - Gail Mangaroo 
* Added end date & package id
*********************************************************************
*/

CREATE Procedure usp_vendor_payment_freq_ins
( 
 @p_vendor_id int 
 , @p_payment_freq_id int 
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

	INSERT INTO [lp_commissions].[dbo].[vendor_payment_freq]
           ([vendor_id]
           ,[payment_freq_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_end]
           ,[interval]
           ,[package_id] 
		   ,[interval_type_id]
           )
     SELECT 
           @p_vendor_id
           ,@p_payment_freq_id
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_date_end
           ,@p_interval
		   ,@p_package_id
    	   ,@p_interval_type_id
					 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO
