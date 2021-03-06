USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealEntryDeleteByDeal]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealEntryDeleteByDeal]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************************************************/
 /****************************************** usp_MtMCustomDealEntryDeleteByDeal *****************************************/
/************************************************************************************************************/

/* **********************************************************************************************
 *	Author:		gmangaroo																			*
 *	Created:	7/19/2013																		*
 *	Descp:		Delete Custom Deal Entry														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMCustomDealEntryDeleteByDeal]
(
	@CustomDealID int
	, @ModifiedBy varchar(50) = null 
) 
				
AS

BEGIN 
SET NOCOUNT ON	
	UPDATE dbo.MtMCustomDealEntry
	SET InActive = 1 , DateModified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE	CustomDealID = @CustomDealID
SET NOCOUNT OFF		
END 