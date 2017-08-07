USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_upd]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 4/10/2012
-- Description:	Select setting setting params
-- =============================================
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_upd]
(	@p_vendor_setting_param_id int 
	, @p_setting_type_id int 
	, @p_setting_id int 
	, @p_param_id int 
	, @p_param_value varchar(150)
	, @p_param_operator int 
	, @p_active bit
	, @p_username varchar(100)
)
AS
BEGIN 
	UPDATE [lp_commissions].[dbo].[vendor_setting_param]
		SET [setting_type_id] = @p_setting_type_id
			,[setting_id] = @p_setting_id
			,[param_id] = @p_param_id
            ,[param_value] = @p_param_value
            ,[param_operator] = @p_param_operator
            ,[active] = @p_active
            ,[date_modified] = getdate()
            ,[modified_by] = @p_username

    WHERE vendor_setting_param_id = @p_vendor_setting_param_id
    
    RETURN @@ROWCOUNT
END 
GO 
