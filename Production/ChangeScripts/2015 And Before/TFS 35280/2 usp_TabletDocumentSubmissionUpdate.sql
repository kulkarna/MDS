USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDocumentSubmissionUpdate]'))
	DROP PROCEDURE [dbo].[usp_TabletDocumentSubmissionUpdate]
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/21/2014
-- Description:	Updates a record into TabletDocumentSubmission
-- =============================================

CREATE PROCEDURE [dbo].[usp_TabletDocumentSubmissionUpdate]
    @TabletDocumentSubmissionID INT,
	@ContractNumber varchar(50),
    @FileName varchar(150),
    @DocumentTypeID INT,
    @SalesAgentID INT
AS
BEGIN

SET NOCOUNT ON
	
	UPDATE [LibertyPower].[dbo].[TabletDocumentSubmission]
    SET ContractNumber = @ContractNumber,
	    FileName = @FileName,
        DocumentTypeID = @DocumentTypeID,
		SalesAgentID = @SalesAgentID,
        ModifiedDate = GETDATE()
    WHERE TabletDocumentSubmissionID = @TabletDocumentSubmissionID


SET NOCOUNT OFF
END

GO


