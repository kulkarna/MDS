USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
**********************************************************************
*5/11/2010 Created
* Gail Mangaroo 
* Update vendor report date
**********************************************************************
* 11/4/2010 Modified - Gail Mangaroo
* Added contract_group_id and grace_period fields
**********************************************************************
* 4/3/2012 Modified - Gail Mangaroo
* Added end date
**********************************************************************
* 8/28/2012 Modified - Gail Mangaroo 
* Added fields
**********************************************************************
* Modified: 12/11/2013 Sadiel Jarvis 
* Added ForBonusTransaction field
**********************************************************************
*/

ALTER Procedure [dbo].[usp_vendor_report_date_option_upd]
( @p_option_id int 
 , @p_vendor_id int 
 , @p_report_date_option_id int 
 , @p_date_effective datetime 
 , @p_active bit
 , @p_username varchar(100) 
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

	UPDATE [lp_commissions].[dbo].[vendor_report_date_option]
	   SET [vendor_id] = @p_vendor_id
		  ,[report_date_option_id] = @p_report_date_option_id
		  ,[date_effective] = @p_date_effective
		  ,[active] = @p_active
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username
		  ,[contract_group_id] = @p_contract_group_id
		  ,[grace_period] = @p_grace_period
		  ,[date_end] = @p_date_end
		  ,[package_id] = @p_package_id
		  ,[interval_type_id] = @p_interval_type_id
		  ,[ForBonusTransaction] = @p_ForBonusTransaction
		  
	WHERE option_id =  @p_option_id
	 						 
 	RETURN @@ROWCOUNT
	
	SET NOCOUNT OFF
	
END
