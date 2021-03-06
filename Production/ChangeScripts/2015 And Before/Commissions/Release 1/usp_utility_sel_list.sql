USE [lp_Commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_utility_sel_list]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_utility_sel_list]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/5/2012
-- Description:	Get List of utilities.
-- =============================================
CREATE PROC [dbo].[usp_utility_sel_list]
AS 
BEGIN 

	SELECT [ID]
      ,[UtilityCode]
      ,[FullName]
      ,[ShortName]
      ,[MarketID]
     
	FROM [Libertypower].[dbo].[Utility] (NOLOCK) 
  
END 
GO 