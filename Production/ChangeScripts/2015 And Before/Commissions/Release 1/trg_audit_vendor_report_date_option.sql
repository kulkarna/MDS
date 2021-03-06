USE [lp_commissions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/12/2010
-- Description:	Create vendor_report_date_option audit
-- =============================================
-- Modified 12/10/2010 Gail Mangaroo 
-- added contract_group_id, grace_period
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_report_date_option] ON [dbo].[vendor_report_date_option] 
FOR INSERT, UPDATE, DELETE AS 
BEGIN 


	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_report_date_option]
           ([option_id]
           ,[vendor_id]
           ,[report_date_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           
           , contract_group_id
           , grace_period 
           
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
           )
     
     SELECT [option_id]
      ,[vendor_id]
      ,[report_date_option_id]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      , getdate()

      , contract_group_id
      , grace_period 

	  ,[date_end]
	  ,[package_id]
	  ,[interval_type_id]
		   
  FROM INSERTED 

END 
GO 