USE [lp_commissions]
GO
/****** Object:  Trigger [dbo].[trg_audit_vendor_grace_period]    Script Date: 11/29/2012 01:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 6/11/2010
-- Description:	Insert audit record
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_grace_period] ON [dbo].[vendor_grace_period] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_grace_period]
           ([option_id]
           ,[vendor_id]
           ,[transaction_type_id]
           ,[grace_period]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
		   ,[date_option]
		  )
     
     SELECT [option_id]
      ,[vendor_id]
      ,[transaction_type_id]
      ,[grace_period]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,getdate()
	  ,[date_end]
      ,[package_id]
      ,[interval_type_id]
      ,[date_option]
  
  
 	FROM INSERTED

END
GO