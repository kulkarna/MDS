USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_date_interval_type_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_date_interval_type_sel]
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
CREATE PROCEDURE [dbo].[usp_date_interval_type_sel] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [interval_id]
      ,[interval_code]
      ,[interval_description]

	FROM [Lp_commissions].[dbo].[date_interval] (NOLOCK)

END
GO