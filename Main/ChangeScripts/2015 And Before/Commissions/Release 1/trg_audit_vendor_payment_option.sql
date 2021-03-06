USE [lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/12/2010
-- Description:	Create audit record
-- =============================================
* 6/2/2010 Gail Mangaroo 
* Added term field
**********************************************************************
*/
ALTER Trigger [dbo].[trg_audit_vendor_payment_option] ON [dbo].[vendor_payment_option] 
FOR INSERT, UPDATE, DELETE AS 
BEGIN 

	INSERT INTO [lp_commissions].[dbo].[zaudit_vendor_payment_option]
           ([option_id]
           ,[vendor_id]
           ,[payment_option_id]
           ,[date_effective]
           ,[active]
           ,[date_created]
           ,[username]
           ,[date_modified]
           ,[modified_by]
           ,[date_audit]
           , term 
           ,[date_end]
		   ,[package_id]
		   ,[interval_type_id]
           )
     

	SELECT [option_id]
      ,[vendor_id]
      ,[payment_option_id]
      ,[date_effective]
      ,[active]
      ,[date_created]
      ,[username]
      ,[date_modified]
      ,[modified_by]
      ,getdate()
      , term
      ,[date_end]
	  ,[package_id]
	  ,[interval_type_id]
  FROM INSERTED 


END 
GO 