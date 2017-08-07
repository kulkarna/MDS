USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_upd]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_upd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_upd]
 * Update [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_upd]
@p_package_id int 
, @p_package_name varchar(150)
, @p_package_descp varchar(max)
, @p_status_id int
, @p_start_date datetime 
, @p_end_date datetime 
, @p_username varchar(150)
 

AS 
BEGIN 

UPDATE [Lp_commissions].[dbo].[compensation_package]
   SET [package_name] = @p_package_name
      ,[package_descp] = @p_package_descp
      ,[status_id] = @p_status_id
      ,[start_date] = @p_start_date
      ,[end_date] = @p_end_date
      
      ,[modified_by] = @p_username
      ,[date_modified] = getdate()
 WHERE package_id = @p_package_id
 
 RETURN @@ROWCOUNT
 END 

GO

