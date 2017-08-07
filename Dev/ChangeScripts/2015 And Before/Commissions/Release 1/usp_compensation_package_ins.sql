USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_compensation_package_ins]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_compensation_package_ins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_compensation_package_ins]
 * Insert row into [compensation_package] table.
 * History
 *******************************************************************************
 * 10/2012 Gail Mangaroo.
 * Created.
 *******************************************************************************
 */
CREATE PROC [dbo].[usp_compensation_package_ins] 

@p_package_name varchar(150)
, @p_package_descp varchar(max)
, @p_status_id int
, @p_start_date datetime 
, @p_end_date datetime 
, @p_username varchar(150)
 

AS 
BEGIN 

	INSERT INTO [Lp_commissions].[dbo].[compensation_package]
           ([package_name]
           ,[package_descp]
           ,[status_id]
           ,[start_date]
           ,[end_date]
           ,[username]
           ,[date_created]
         )
     
     SELECT
           @p_package_name
			, @p_package_descp
			, @p_status_id
			, @p_start_date
			, @p_end_date
			, @p_username 
			, GETDATE()
			
	RETURN ISNULL(Scope_Identity(), 0)

END 

GO

