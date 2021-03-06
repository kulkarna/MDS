USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationInsert]    Script Date: 05/17/2012 12:02:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Inserts an "auto approval documents step" configuration for an user
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationInsert]
	@UserID INT,
	@AutoApprove BIT
AS
BEGIN

	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	INSERT INTO [LibertyPower]..[WorkflowAutoComplete]
		(UserID, AutoApproveDocument)
	VALUES
		(@UserID, @AutoApprove)
		
	SELECT SCOPE_IDENTITY() AS NewConfiguration

END
