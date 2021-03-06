USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
* 5/11/2010 Created
* Gail Mangaroo 
* Create vendor report date option
**********************************************************************
* 11/4/2010 Modified - Gail Mangaroo
* Added contract_group_id and grace_period fields
**********************************************************************
* 4/3/2012 Modified - Gail Mangaroo
* Added end date
**********************************************************************
* 8/28/2012 Modified - Gail Mangaroo 
* Added fields and optimized
**********************************************************************
* Modified: 12/11/2013 Sadiel Jarvis 
* Added ForBonusTransaction field
**********************************************************************
*/

ALTER Procedure [dbo].[usp_vendor_report_date_option_ins]
( 
 @p_vendor_id int 
 , @p_report_date_option_id int 
 , @p_date_effective datetime 
 , @p_username varchar(100) 
 , @p_active bit = 0 
 , @p_contract_group_id int = 0 
 , @p_grace_period float = 0 
 , @p_date_end datetime = null 
 , @p_package_id int = 0 
 , @p_interval_type_id int = 0 
 , @p_ForBonusTransaction bit = 0
) 
AS
BEGIN 

	SET NOCOUNT ON

	INSERT INTO [lp_commissions].[dbo].[vendor_report_date_option]
           ([vendor_id]
           ,[report_date_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[contract_group_id] 
           ,[grace_period]
           ,[date_end]
           ,[package_id] 
		   ,[interval_type_id]
		   ,[ForBonusTransaction]
           )
     SELECT 
           @p_vendor_id
           ,@p_report_date_option_id
           ,@p_date_effective
           ,@p_active
           ,getdate()
           ,@p_username
           ,@p_contract_group_id
		   ,@p_grace_period
		   ,@p_date_end
		   ,@p_package_id
    	   ,@p_interval_type_id
		   ,@p_ForBonusTransaction
    					 
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
	
	SET NOCOUNT OFF
	
END 
