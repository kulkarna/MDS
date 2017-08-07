/* ------------------------------------------------------------
DESCRIPTION: Schema Synchronization Script 
    procedures:
        [dbo].[usp_TabletDocumentSubmissionInsert], [dbo].[usp_TabletDocumentSubmissionSelect], [dbo].[usp_TabletDocumentSubmissionUpdate]
    tables:
        [dbo].[TabletDocumentSubmission]
   AUTHOR:	Jaime Forero
   DATE:	10/9/2014 11:10:47 AM
   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [Libertypower]
GO

-- BEGIN TRAN _CHANGEGAS_

BEGIN TRAN
GO

-- Add Column IsGasFile to [dbo].[TabletDocumentSubmission]
Print 'Add Column IsGasFile to [dbo].[TabletDocumentSubmission]'
GO
ALTER TABLE [dbo].[TabletDocumentSubmission]
	ADD [IsGasFile] [bit] NOT NULL
	CONSTRAINT [DF_TabletDocumentSubmission_IsGasFile] DEFAULT ((0))
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_TabletDocumentSubmissionInsert]
Print 'Alter Procedure [dbo].[usp_TabletDocumentSubmissionInsert]'
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/21/2014
-- Description:	Inserts a record into TabletDocumentSubmission
-- =============================================
-- Author:		Jaime Forero
-- Create date:	10/09/2014
-- Description:	Added new flag for Natural Gas Files
-- =============================================

ALTER PROCEDURE [dbo].[usp_TabletDocumentSubmissionInsert]
	@ContractNumber varchar(50),
    @FileName varchar(150),
    @DocumentTypeID INT,
    @SalesAgentID INT,
    @IsGasFile BIT
AS
BEGIN

SET NOCOUNT ON
	
	INSERT INTO [LibertyPower].[dbo].[TabletDocumentSubmission]
           ([ContractNumber]
           ,[FileName]
           ,[DocumentTypeID]
           ,[SalesAgentID]
           ,[ModifiedDate]
           ,[CreatedDate]
		 ,[IsGasFile])
     VALUES
           (@ContractNumber
           ,@FileName
           ,@DocumentTypeID
           ,@SalesAgentID
           ,GETDATE()
           ,GETDATE()
		 ,@IsGasFile)


SET NOCOUNT OFF
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_TabletDocumentSubmissionUpdate]
Print 'Alter Procedure [dbo].[usp_TabletDocumentSubmissionUpdate]'
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/21/2014
-- Description:	Updates a record into TabletDocumentSubmission
-- =============================================
-- Author:		Jaime Forero
-- Create date:	10/09/2014
-- Description:	Added new flag for Natural Gas Files
-- =============================================

ALTER PROCEDURE [dbo].[usp_TabletDocumentSubmissionUpdate]
    @TabletDocumentSubmissionID INT,
	@ContractNumber varchar(50),
    @FileName varchar(150),
    @DocumentTypeID INT,
    @SalesAgentID INT,
    @IsGasFile BIT
AS
BEGIN

SET NOCOUNT ON
	
    UPDATE [LibertyPower].[dbo].[TabletDocumentSubmission]
    SET ContractNumber = @ContractNumber,
	    FileName = @FileName,
        DocumentTypeID = @DocumentTypeID,
		SalesAgentID = @SalesAgentID,
        ModifiedDate = GETDATE(),
	   IsGasFile = @IsGasFile
    WHERE TabletDocumentSubmissionID = @TabletDocumentSubmissionID


SET NOCOUNT OFF
END

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_TabletDocumentSubmissionSelect]
Print 'Alter Procedure [dbo].[usp_TabletDocumentSubmissionSelect]'
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/21/2014
-- Description:	Selects the records from TabletDocumentSubmission by ContractNumber
-- =============================================
-- Author:		Jaime Forero
-- Create date:	10/09/2014
-- Description:	Added new flag for Natural Gas Files
-- =============================================

ALTER PROCEDURE [dbo].[usp_TabletDocumentSubmissionSelect]
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
	      ,[IsGasFile]
	FROM [LibertyPower].[dbo].[TabletDocumentSubmission] (NOLOCK)
    WHERE ContractNumber = @ContractNumber


SET NOCOUNT OFF
END

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

-- ROLLBACK 
--COMMIT _CHANGEGAS_