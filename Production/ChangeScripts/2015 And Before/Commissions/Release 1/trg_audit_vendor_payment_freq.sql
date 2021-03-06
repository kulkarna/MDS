USE [lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/12/2010
-- Description:	Create vendor payment freq audit
-- =============================================
ALTER Trigger [dbo].[trg_audit_vendor_payment_freq] ON [dbo].[vendor_payment_freq] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_payment_freq]
           ([freq_id]
           ,[vendor_id]
           ,[payment_freq_id]
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
		   ,[interval]
		   )

	SELECT [freq_id]
      ,[vendor_id]
      ,[payment_freq_id]
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
	   ,[interval]
  
  FROM INSERTED



END 
GO