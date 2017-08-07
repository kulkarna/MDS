USE [lp_commissions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_ins]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo	
-- Create date: 4/10/2012
-- Description:	Insert setting params
-- =============================================
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_ins]
(	@p_setting_type_id int 
	, @p_setting_id int 
	, @p_param_id int 
	, @p_param_value varchar(150)
	, @p_param_operator int 
	, @p_active bit
	, @p_username varchar(100)
)
AS
BEGIN 
	INSERT INTO [lp_commissions].[dbo].[vendor_setting_param]
           ([setting_type_id]
           ,[setting_id]
           ,[param_id]
           ,[param_value]
           ,[param_operator]
           ,[active]
           ,[date_created]
           ,[username]
          )
     VALUES
           (@p_setting_type_id 
		   ,@p_setting_id
           ,@p_param_id
           ,@p_param_value
           ,@p_param_operator
           ,@p_active
           ,getdate()
           ,@p_username
          ) 
     RETURN ISNULL(Scope_Identity(), 0)
END 
GO 