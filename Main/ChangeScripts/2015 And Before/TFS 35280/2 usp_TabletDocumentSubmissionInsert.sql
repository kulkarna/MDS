USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID(N'[dbo].[usp_TabletDocumentSubmissionInsert]'))
	DROP PROCEDURE [dbo].[usp_TabletDocumentSubmissionInsert]
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/21/2014
-- Description:	Inserts a record into TabletDocumentSubmission
-- =============================================

CREATE PROCEDURE [dbo].[usp_TabletDocumentSubmissionInsert]
	@ContractNumber varchar(50),
    @FileName varchar(150),
    @DocumentTypeID INT,
    @SalesAgentID INT
AS
BEGIN

SET NOCOUNT ON
	
	INSERT INTO [LibertyPower].[dbo].[TabletDocumentSubmission]
           ([ContractNumber]
           ,[FileName]
           ,[DocumentTypeID]
           ,[SalesAgentID]
           ,[ModifiedDate]
           ,[CreatedDate])
     VALUES
           (@ContractNumber
           ,@FileName
           ,@DocumentTypeID
           ,@SalesAgentID
           ,GETDATE()
           ,GETDATE())


SET NOCOUNT OFF
END
