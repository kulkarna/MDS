USE lp_commissions
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_upd')
	DROP  Procedure  usp_vendor_grace_period_upd
GO

/*
**********************************************************************
* 6/11/2010 Created
* Gail Mangaroo 
* Update vendor grace period update
**********************************************************************
* 4/4/2012 // 8/16/2012 Gail Managroo 
* Added end date & package_id 
**********************************************************************
*/

CREATE Procedure usp_vendor_grace_period_upd
( @p_option_id int 
 , @p_vendor_id int 
 , @p_transaction_type_id int 
 , @p_grace_period float 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
 , @p_end_date datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_date_option int = 0 
 )  
AS
BEGIN 

	UPDATE [lp_commissions].[dbo].[vendor_grace_period]
	   SET [vendor_id] = @p_vendor_id
	      ,[transaction_type_id] = @p_transaction_type_id
		  ,[grace_period] = @p_grace_period
		  ,[date_effective] = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[date_end] = @p_end_date
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id 
		  ,[date_option] = @p_date_option
		  
	WHERE option_id =  @p_option_id
	 						 
 	RETURN @@ROWCOUNT
	
END
GO
