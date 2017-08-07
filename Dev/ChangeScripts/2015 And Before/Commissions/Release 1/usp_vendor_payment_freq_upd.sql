USE [lp_commissions]
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_payment_freq_upd')
	DROP  Procedure  usp_vendor_payment_freq_upd
GO

/*
**********************************************************************
* 4/27/2010 Created
* Gail Mangaroo 
* Update vendor payment freq
**********************************************************************
* 8/16/2012 // 4/3/2012 - Gail Mangaroo 
* Added end date & package id 
*********************************************************************
*/

CREATE Procedure usp_vendor_payment_freq_upd
( @p_freq_id int 
 , @p_vendor_id int 
 , @p_payment_freq_id int 
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

	UPDATE [lp_commissions].[dbo].[vendor_payment_freq]
	SET [vendor_id] = @p_vendor_id
		  ,[payment_freq_id] = @p_payment_freq_id
		  ,[date_effective] = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[date_end] = @p_date_end
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  ,[interval] = @p_interval
		  
	WHERE freq_id =  @p_freq_id
					 
 	RETURN @@ROWCOUNT
	
END
GO