USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealAccountDeleteByDeal]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealAccountDeleteByDeal]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************************************************/
 /****************************************** usp_MtMCustomDealAccountDeleteByDeal *****************************************/
/************************************************************************************************************/

/* **********************************************************************************************
 *	Author:		gmangaroo																			*
 *	Created:	7/19/2013																		*
 *	Descp:		Delete Custom Deal Account														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMCustomDealAccountDeleteByDeal]
(
	@CustomDealID int
	, @ModifiedBy varchar(50) = null 
) 
				
AS

BEGIN 
SET NOCOUNT ON	
	
	UPDATE dbo.MtMCustomDealAccount
	SET InActive = 1 , DateModified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE	CustomDealID = @CustomDealID

	SELECT	@@ROWCOUNT as RecordCount

SET NOCOUNT OFF		
END 