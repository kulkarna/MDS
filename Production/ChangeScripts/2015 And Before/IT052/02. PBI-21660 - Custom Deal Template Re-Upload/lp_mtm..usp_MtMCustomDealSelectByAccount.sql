USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealSelectByAccount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealSelectByAccount]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *																								*
 *	Author:		gmangaroo																		*
 *	Created:	11/20/2013																		*
 *	Descp:																						*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMCustomDealSelectByAccount]
( @accountNumber varchar(30)
 , @utilityCode varchar(30)
 , @ActiveOnly bit  = 0 
)

AS 
BEGIN 
	SET NOCOUNT ON;
	
	SELECT DISTINCT cdh.* 
	FROM lp_mtm..MtMCustomDealHeader cdh (NOLOCK) 
		JOIN lp_mtm..MtMCustomDealAccount cda (NOLOCK) 
			ON cda.CustomDealID = cdh.ID
	WHERE cda.AccountNumber  = @accountNumber 
		AND cda.Utility = @utilityCode
		AND (@ActiveOnly = 0 OR cdh.InActive = 0  ) 

	SET NOCOUNT OFF;
END 
