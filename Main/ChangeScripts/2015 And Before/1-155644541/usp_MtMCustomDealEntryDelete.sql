USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealEntryDelete]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealEntryDelete]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************************************************/
 /****************************************** usp_MtMCustomDealEntryDelete *****************************************/
/************************************************************************************************************/

/* **********************************************************************************************
 *	Author:		gmangaroo																			*
 *	Created:	7/19/2013																		*
 *	Descp:		Delete Custom Deal Entry														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMCustomDealEntryDelete]
(
	@ID int
	, @ModifiedBy varchar(50) = null 
) 
				
AS

BEGIN 
SET NOCOUNT ON	
	UPDATE dbo.MtMCustomDealEntry
	SET InActive = 1 , DateModified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE	ID = @ID
SET NOCOUNT OFF		
END 