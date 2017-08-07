USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDocumentSubmissionSelect]'))
	DROP PROCEDURE [dbo].[usp_TabletDocumentSubmissionSelect]
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/21/2014
-- Description:	Selects the records from TabletDocumentSubmission by ContractNumber
-- =============================================

CREATE PROCEDURE [dbo].[usp_TabletDocumentSubmissionSelect]
	@ContractNumber varchar(50)
AS
BEGIN

SET NOCOUNT ON
	
	SELECT  [TabletDocumentSubmissionID]
		   ,[ContractNumber]
           ,[FileName]
           ,[DocumentTypeID]
           ,[SalesAgentID]
           ,[ModifiedDate]
           ,[CreatedDate]
	FROM [LibertyPower].[dbo].[TabletDocumentSubmission] (NOLOCK)
    WHERE ContractNumber = @ContractNumber


SET NOCOUNT OFF
END

GO


