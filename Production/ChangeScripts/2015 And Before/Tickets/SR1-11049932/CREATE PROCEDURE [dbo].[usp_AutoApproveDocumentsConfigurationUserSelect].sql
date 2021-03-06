USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]    Script Date: 05/17/2012 12:03:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Check if a Liberty Power Employee has "auto approval documents step" configured
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]
	@UserID INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT 
		*
	FROM 
		[LibertyPower]..[WorkflowAutoComplete] WAC
	WHERE 
		WAC.UserID = @UserID
END
