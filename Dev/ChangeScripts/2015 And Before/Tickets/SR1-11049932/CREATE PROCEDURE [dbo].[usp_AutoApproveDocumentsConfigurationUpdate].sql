USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationUpdate]    Script Date: 05/17/2012 15:16:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Updates an "auto approval documents step" configuration for one user
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationUpdate]
	@UserID INT,
	@AutoApprove BIT
AS
BEGIN

	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	UPDATE [LibertyPower]..[WorkflowAutoComplete]
		SET AutoApproveDocument = @AutoApprove
	WHERE
		UserID = @UserID
		
END
