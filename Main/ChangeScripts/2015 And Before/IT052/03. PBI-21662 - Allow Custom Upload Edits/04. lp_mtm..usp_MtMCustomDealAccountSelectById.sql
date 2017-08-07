USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealAccountSelectById]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealAccountSelectById]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Gail Mangaroo																	*
 *	Created:	12/16/2013																		*
 *	Descp:		get CustomDealAccounts															*
 *	Modified:	exec usp_MtMCustomDealAccountSelectById 2191									*
 ********************************************************************************************** */
CREATE	PROCEDURE  [dbo].[usp_MtMCustomDealAccountSelectById]
( @ID int )
AS

BEGIN
	SET NOCOUNT ON;

	SELECT	distinct a.*
	FROM	MtMCustomDealAccount a(nolock)
	WHERE	a.ID = @ID
	
	SET NOCOUNT OFF;
END


GO


