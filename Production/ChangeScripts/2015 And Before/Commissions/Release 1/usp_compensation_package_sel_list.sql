USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_sel_list]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_sel_list] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_sel_list]
 * Get all rows from [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_sel_list] 
AS 
BEGIN

 SELECT [package_id]
      ,[package_name]
      ,[package_descp]
      ,[status_id]
      ,[start_date]
      ,[end_date]
      ,[username]
      ,[date_created]
      ,[modified_by]
      ,[date_modified]
  FROM [Lp_commissions].[dbo].[Compensation_Package] (NOLOCK) 
  
END 

GO


