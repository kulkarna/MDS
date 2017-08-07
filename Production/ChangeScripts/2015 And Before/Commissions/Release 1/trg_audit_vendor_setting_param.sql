USE [lp_commissions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 11/29/2012
-- Description:	Create vendor setting param audit
-- =============================================
CREATE Trigger [dbo].[trg_audit_vendor_setting_param] ON [dbo].[vendor_setting_param] 
FOR INSERT, UPDATE, DELETE AS 

BEGIN 

	INSERT INTO [Lp_commissions].[dbo].[zaudit_vendor_setting_param]
           ([vendor_setting_param_id]
           ,[setting_type_id]
           ,[setting_id]
           ,[param_id]
           ,[param_value]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[param_operator]
           ,[date_audit]
           )
    
	SELECT [vendor_setting_param_id]
      ,[setting_type_id]
      ,[setting_id]
      ,[param_id]
      ,[param_value]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,[param_operator]
      ,getdate()

  FROM INSERTED
END 
GO



