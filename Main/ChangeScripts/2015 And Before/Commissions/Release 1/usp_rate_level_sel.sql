USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_rate_level_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_rate_level_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/18/2012
-- Description:	Returns list of rate levels
-- =============================================
CREATE PROCEDURE [dbo].[usp_rate_level_sel] 

AS
BEGIN
	SELECT [rate_level_id]
		  ,[rate_level_code]
		  ,[rate_level_descp]
	 FROM [lp_commissions].[dbo].[rate_level] (NOLOCK)
END
GO


