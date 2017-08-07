USE lp_commissions
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_ins')
	DROP  Procedure  usp_vendor_grace_period_ins
GO

/*
**********************************************************************
* 6/11/2010 Created
* Gail Mangaroo 
* Create vendor grace period option
**********************************************************************
* 4/4/2012 // 8/16/2012 Gail Managroo 
* Added end date & package_id 
**********************************************************************
*/

CREATE Procedure usp_vendor_grace_period_ins
( 
 @p_vendor_id int 
 , @p_transaction_type_id int 
 , @p_grace_period float 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_end_date datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_date_option int  = 0 
) 
AS
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[vendor_grace_period]
           ([vendor_id]
           ,[transaction_type_id]
           ,[grace_period]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_end]
           ,[package_id] 
           ,[interval_type_id]
           ,[date_option]
           )
     SELECT 
           @p_vendor_id
           ,@p_transaction_type_id
           ,@p_grace_period
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_end_date
           ,@p_package_id
           ,@p_interval_type_id
           ,@p_date_option
  		 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
END 
GO