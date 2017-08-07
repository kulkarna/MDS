USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_param_operator_sel_list]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_param_operator_sel_list]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 9/18/2012
-- Description:	Return list of interval types.
-- =============================================
CREATE PROC [dbo].[usp_param_operator_sel_list] 
AS 
BEGIN 

	SELECT [param_operator_id]
		  ,[param_operator_code]
		  ,[param_operator_descp]
	FROM [Lp_commissions].[dbo].[param_operator] (NOLOCK) 

END 

GO


