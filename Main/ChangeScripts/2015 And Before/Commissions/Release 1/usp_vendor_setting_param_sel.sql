USE [lp_commissions]
GO 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_setting_param_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_setting_param_sel]
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
CREATE PROCEDURE [dbo].[usp_vendor_setting_param_sel]
	@p_vendor_setting_param_id int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM [lp_commissions].[dbo].[vendor_setting_param] (NOLOCK) 
	WHERE vendor_setting_param_id = @p_vendor_setting_param_id 
	
END
GO
