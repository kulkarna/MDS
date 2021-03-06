USE [LibertyPower]
GO
/****** Object:  Table [dbo].[ComplaintCategory]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintCategory](
	[ComplaintCategoryID] [int] NOT NULL,
	[Name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ComplaintCategory] PRIMARY KEY CLUSTERED 
(
	[ComplaintCategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintType]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintType](
	[ComplaintTypeID] [int] NOT NULL,
	[Name] [varchar](60) NOT NULL,
	[ComplaintCategoryID] [int] NOT NULL,
 CONSTRAINT [PK_ComplaintType] PRIMARY KEY CLUSTERED 
(
	[ComplaintTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintStatus]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintStatus](
	[ComplaintStatusID] [int] NOT NULL,
	[Name] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ComplaintStatus] PRIMARY KEY CLUSTERED 
(
	[ComplaintStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintIssueType]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintIssueType](
	[ComplaintIssueTypeID] [int] NOT NULL,
	[Name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ComplaintIssueType] PRIMARY KEY CLUSTERED 
(
	[ComplaintIssueTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintContactedTeam]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintContactedTeam](
	[ComplaintContactedTeamID] [int] NOT NULL,
	[Name] [varchar](60) NOT NULL,
 CONSTRAINT [PK_ComplaintContactedTeam] PRIMARY KEY CLUSTERED 
(
	[ComplaintContactedTeamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintAccount]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintAccount](
	[ComplaintAccountID] [int] IDENTITY(1,1) NOT NULL,
	[AccountName] [varchar](300) NULL,
	[UtilityAccountNumber] [varchar](30) NULL,
	[UtilityID] [int] NULL,
	[MarketCode] [char](2) NULL,
	[SalesAgent] [varchar](64) NULL,
	[SalesChannelID] [int] NULL,
	[Address] [nvarchar](150) NULL,
	[City] [nvarchar](100) NULL,
	[Zip] [char](10) NULL,
	[Phone] [varchar](50) NULL,
 CONSTRAINT [PK_ComplaintAccount] PRIMARY KEY CLUSTERED 
(
	[ComplaintAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Complaint]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Complaint](
	[ComplaintID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NULL,
	[ComplaintAccountID] [int] NULL,
	[ComplaintRegulatoryAuthorityID] [int] NULL,
	[ComplaintStatusID] [int] NOT NULL,
	[ComplaintIssueTypeID] [int] NOT NULL,
	[ComplaintantName] [varchar](150) NULL,
	[OpenDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[AcknowledgeDate] [datetime] NULL,
	[ClosedDate] [datetime] NULL,
	[LastContactDate] [datetime] NULL,
	[CasePrimeID] [int] NULL,
	[ControlNumber] [varchar](50) NULL,
	[ComplaintTypeID] [int] NULL,
	[IsFormal] [bit] NULL,
	[PrimaryDescription] [varchar](max) NULL,
	[SecondaryDescription] [varchar](max) NULL,
	[InboundCalls] [int] NULL,
	[TeamContactedID] [int] NULL,
	[ContractReviewDate] [datetime] NULL,
	[SalesMgrNotified] [datetime] NULL,
	[ValidContract] [bit] NULL,
	[DisputeOutcomeID] [int] NULL,
	[Waiver] [money] NULL,
	[Credit] [money] NULL,
	[ResolutionDescription] [varchar](max) NULL,
	[InternalFindings] [varchar](max) NULL,
	[Comments] [varchar](max) NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](200) NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [varchar](200) NULL,
	[ContractID] [int] NULL,
	[ComplaintLegacyID] [int] NULL,
 CONSTRAINT [PK_Complaint] PRIMARY KEY CLUSTERED 
(
	[ComplaintID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_Complaint] ON [dbo].[Complaint] 
(
	[AccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Complaint_1] ON [dbo].[Complaint] 
(
	[ComplaintAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComplaintDocument]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintDocument](
	[ComplaintDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[ComplaintID] [int] NOT NULL,
	[DocumentTypeID] [int] NOT NULL,
	[FileGuid] [uniqueidentifier] NOT NULL,
	[FileName] [varchar](250) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[AllowPublicView] [bit] NOT NULL,
	[UploadedOn] [datetime] NULL,
 CONSTRAINT [PK_ComplaintDocument] PRIMARY KEY CLUSTERED 
(
	[ComplaintDocumentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ComplaintDocumentSave]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates a complaint-specific document
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintDocumentSave]
	@ComplaintID int,
	@ComplaintDocumentTypeID int,
	@FileGuid uniqueidentifier,
	@FileName varchar(200), 
	@AllowPublicView bit,
	@UploadedOn datetime = NULL
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO ComplaintDocument(ComplaintID, DocumentTypeID, FileGuid, [FileName], AllowPublicView, UploadedOn)
	VALUES(@ComplaintID, @ComplaintDocumentTypeID, @FileGuid, @FileName, @AllowPublicView, @UploadedOn)
  
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintDocumentDelete]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Deletes a complaint-specific document
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintDocumentDelete]
	@FileGuid uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON

	DELETE ComplaintDocument WHERE FileGuid = @FileGuid
  
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintImportFromLegacy]    Script Date: 11/29/2012 16:25:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create date: 2012-11-27
-- Description:	Creates a new complaint and assigns it the legacy id
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintImportFromLegacy] 
	@ComplaintID int,
	@LegacyID int = NULL,
    @AccountID int = NULL,
    @ComplaintAccountID int = NULL,
    @RegulatoryAuthorityID int,
    @StatusID int,
    @IssueTypeID int,
    @ComplaintantName varchar(200) = NULL,
    @OpenDate datetime = NULL,
    @DueDate datetime = NULL,
    @AcknowledgeDate datetime = NULL,
    @ClosedDate datetime = NULL,
    @LastContactDate datetime = NULL,
    @CasePrimeID int,
    @ControlNumber varchar(50) = NULL,
    @ComplaintTypeID int,
    @IsFormal bit = 0,
    @InboundCalls int = NULL,
    @TeamContactedID int,
    @ContractReviewDate datetime = NULL,
    @SalesMgrNotified datetime = NULL,
    @ValidContract bit = 0,
    @DisputeOutcomeID int,
    @Waiver money = NULL,
    @Credit money = NULL,
    @PrimaryDescription varchar(MAX) = NULL,
    @SecondaryDescription varchar(MAX) = NULL,
    @ResolutionDescription varchar(MAX) = NULL,
    @InternalFindings varchar(MAX) = NULL,
    @Comments varchar(MAX) = NULL,
    @CreatedBy  varchar(200) = NULL,
    @LastModifiedBy varchar(200) = NULL
AS

BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT [dbo].[Complaint] ON
    
	INSERT INTO Complaint(ComplaintID,
						ComplaintLegacyID,
						AccountID,
						ComplaintAccountID,
						ComplaintRegulatoryAuthorityID,
						ComplaintStatusID,
						ComplaintIssueTypeID,
						ComplaintantName,
						OpenDate,
						DueDate,
						AcknowledgeDate,
						ClosedDate,
						LastContactDate,
						CasePrimeID,
						ControlNumber,
						ComplaintTypeID,
						IsFormal,
						PrimaryDescription,
						SecondaryDescription,
						InboundCalls,
						TeamContactedID,
						ContractReviewDate,
						SalesMgrNotified,
						ValidContract,
						DisputeOutcomeID,
						Waiver,
						Credit,
						ResolutionDescription,
						InternalFindings,
						Comments,
						CreationDate,
						CreatedBy,
						LastModifiedDate,
						LastModifiedBy)
	VALUES (
						@ComplaintID,
						@LegacyID,
						@AccountID,
						@ComplaintAccountID,
						@RegulatoryAuthorityID,
						@StatusID,
						@IssueTypeID,
						@ComplaintantName,
						@OpenDate,
						@DueDate,
						@AcknowledgeDate,
						@ClosedDate,
						@LastContactDate,
						@CasePrimeID,
						@ControlNumber,
						@ComplaintTypeID,
						@IsFormal,
						@PrimaryDescription,
						@SecondaryDescription,
						@InboundCalls,
						@TeamContactedID,
						@ContractReviewDate,
						@SalesMgrNotified,
						@ValidContract,
						@DisputeOutcomeID,
						@Waiver,
						@Credit,
						@ResolutionDescription,
						@InternalFindings,
						@Comments,
						GETDATE(),
						@CreatedBy,
						GETDATE(),
						@LastModifiedBy
			)
		
		SET IDENTITY_INSERT [dbo].[Complaint] OFF
		
		SELECT @ComplaintID as ComplaintID
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintCreateOrUpdate]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates a new complaint or updates an existing one
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintCreateOrUpdate] 
	@ComplaintID int,
	@LegacyID int = NULL,
    @AccountID int = NULL,
    @ComplaintAccountID int = NULL,
    @RegulatoryAuthorityID int,
    @StatusID int,
    @IssueTypeID int,
    @ComplaintantName varchar(200) = NULL,
    @OpenDate datetime = NULL,
    @DueDate datetime = NULL,
    @AcknowledgeDate datetime = NULL,
    @ClosedDate datetime = NULL,
    @LastContactDate datetime = NULL,
    @CasePrimeID int,
    @ControlNumber varchar(50) = NULL,
    @ComplaintTypeID int,
    @IsFormal bit = 0,
    @InboundCalls int = NULL,
    @TeamContactedID int,
    @ContractReviewDate datetime = NULL,
    @SalesMgrNotified datetime = NULL,
    @ValidContract bit = 0,
    @DisputeOutcomeID int,
    @Waiver money = NULL,
    @Credit money = NULL,
    @PrimaryDescription varchar(MAX) = NULL,
    @SecondaryDescription varchar(MAX) = NULL,
    @ResolutionDescription varchar(MAX) = NULL,
    @InternalFindings varchar(MAX) = NULL,
    @Comments varchar(MAX) = NULL,
    @CreatedBy  varchar(200) = NULL,
    @LastModifiedBy varchar(200) = NULL
AS

BEGIN
	SET NOCOUNT ON

    IF (@ComplaintID > 0)
		UPDATE Complaint SET
			AccountID = @AccountID,
			ComplaintAccountID = @ComplaintAccountID,
			ComplaintRegulatoryAuthorityID = @RegulatoryAuthorityID,
			ComplaintStatusID = @StatusID,
			ComplaintIssueTypeID = @IssueTypeID,
			ComplaintantName = @ComplaintantName,
			OpenDate = @OpenDate,
			DueDate = @DueDate,
			AcknowledgeDate = @AcknowledgeDate,
			ClosedDate = @ClosedDate,
			LastContactDate = @LastContactDate,
			CasePrimeID = @CasePrimeID,
			ControlNumber = @ControlNumber,
			ComplaintTypeID = @ComplaintTypeID,
			IsFormal = @IsFormal,
			PrimaryDescription = @PrimaryDescription,
			SecondaryDescription = @SecondaryDescription,
			InboundCalls = @InboundCalls,
			TeamContactedID = @TeamContactedID,
			ContractReviewDate = @ContractReviewDate,
			SalesMgrNotified = @SalesMgrNotified,
			ValidContract = @ValidContract,
			DisputeOutcomeID = @DisputeOutcomeID,
			Waiver = @Waiver,
			Credit = @Credit,
			ResolutionDescription = @ResolutionDescription,
			InternalFindings = @InternalFindings,
			Comments = @Comments,
			LastModifiedDate = GETDATE(),
			LastModifiedBy = @LastModifiedBy
		WHERE ComplaintID = @ComplaintID
    ELSE
		BEGIN
			INSERT INTO Complaint(
								ComplaintLegacyID,
								AccountID,
								ComplaintAccountID,
								ComplaintRegulatoryAuthorityID,
								ComplaintStatusID,
								ComplaintIssueTypeID,
								ComplaintantName,
								OpenDate,
								DueDate,
								AcknowledgeDate,
								ClosedDate,
								LastContactDate,
								CasePrimeID,
								ControlNumber,
								ComplaintTypeID,
								IsFormal,
								PrimaryDescription,
								SecondaryDescription,
								InboundCalls,
								TeamContactedID,
								ContractReviewDate,
								SalesMgrNotified,
								ValidContract,
								DisputeOutcomeID,
								Waiver,
								Credit,
								ResolutionDescription,
								InternalFindings,
								Comments,
								CreationDate,
								CreatedBy,
								LastModifiedDate,
								LastModifiedBy)
			VALUES (
								@LegacyID,
								@AccountID,
								@ComplaintAccountID,
								@RegulatoryAuthorityID,
								@StatusID,
								@IssueTypeID,
								@ComplaintantName,
								@OpenDate,
								@DueDate,
								@AcknowledgeDate,
								@ClosedDate,
								@LastContactDate,
								@CasePrimeID,
								@ControlNumber,
								@ComplaintTypeID,
								@IsFormal,
								@PrimaryDescription,
								@SecondaryDescription,
								@InboundCalls,
								@TeamContactedID,
								@ContractReviewDate,
								@SalesMgrNotified,
								@ValidContract,
								@DisputeOutcomeID,
								@Waiver,
								@Credit,
								@ResolutionDescription,
								@InternalFindings,
								@Comments,
								GETDATE(),
								@CreatedBy,
								GETDATE(),
								@LastModifiedBy
					)
					
			SET @ComplaintID = SCOPE_IDENTITY()
		END
		
		SELECT @ComplaintID as ComplaintID
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintContractsByAccountIdSelect]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of contracts related to an account
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintContractsByAccountIdSelect]
(
	@accountID int
)
As

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DISTINCT ContractID
INTO #Contracts
FROM AccountContract
WHERE ContractID = @accountID

SELECT	c.ContractID,
		c.Number AS ContractNumber,
		c.ContractTypeID, 
		ct.Type AS ContractType, 
		c.ContractStatusID, 
		cs.Descp AS ContractStatus, 
		c.StartDate, 
		c.EndDate, 
		c.SalesChannelID,
		sc.ChannelName,
		c.SalesRep
FROM	dbo.Contract c
		INNER JOIN dbo.ContractType ct ON c.ContractTypeID = ct.ContractTypeID 
        INNER JOIN dbo.ContractStatus cs ON c.ContractStatusID = cs.ContractStatusID 
        INNER JOIN dbo.SalesChannel sc ON c.SalesChannelID = sc.ChannelID
WHERE c.ContractID IN (SELECT ContractID FROM #Contracts)


DROP TABLE #Contracts
GO
/****** Object:  StoredProcedure [dbo].[ComplaintContractsByAccountNumberSelect]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of contracts related to an account
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintContractsByAccountNumberSelect] 
	@accountNumber varchar(30)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @accountID int
	SET @accountID = (SELECT TOP 1 AccountID FROM Account (nolock) WHERE AccountNumber = @accountNumber)

    EXEC [dbo].[ComplaintContractsByAccountIdSelect] @accountID = @accountID
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintDocumentsGet]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of complaint-specific documents
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintDocumentsGet]
	@ComplaintID int
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT cd.ComplaintDocumentID
      ,cd.ComplaintID
      ,cd.DocumentTypeID
      ,cdt.document_type_name As ComplaintDocumentTypeName
      ,cd.FileGuid
      ,cd.FileName
      ,cd.CreatedOn
      ,cd.AllowPublicView
  FROM [LibertyPower].[dbo].[ComplaintDocument] cd 
		INNER JOIN [LP_documents].[dbo].[document_type] cdt ON cd.DocumentTypeID = cdt.document_type_id
  WHERE cd.ComplaintID = @ComplaintID
  
END
GO
/****** Object:  Table [dbo].[ComplaintDisputeOutcome]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintDisputeOutcome](
	[ComplaintDisputeOutcomeID] [int] NOT NULL,
	[Name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ComplaintDisputeOutcome] PRIMARY KEY CLUSTERED 
(
	[ComplaintDisputeOutcomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintDataMigrationErrorLog]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintDataMigrationErrorLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LegacyComplaintID] [int] NOT NULL,
	[ComplaintID] [int] NULL,
	[ErrorDescription] [varchar](1000) NULL,
 CONSTRAINT [PK_ComplaintDataMigrationErrorLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintRegulatoryAuthority]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintRegulatoryAuthority](
	[ComplaintRegulatoryAuthorityID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[RequiredDaysForResolution] [int] NOT NULL,
	[MarketCode] [char](2) NULL,
	[IsActive] [bit] NOT NULL,
	[CalendarType] [varchar](10) NULL,
	[LegacyID] [int] NULL,
 CONSTRAINT [PK_RegulatoryAuthority] PRIMARY KEY CLUSTERED 
(
	[ComplaintRegulatoryAuthorityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComplaintDocumentTypeMapping]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComplaintDocumentTypeMapping](
	[LegacyDocTypeName] [varchar](70) NOT NULL,
	[DocumentTypeID] [int] NULL,
 CONSTRAINT [PK_ComplaintsLegacyDocumentTypeMapping] PRIMARY KEY CLUSTERED 
(
	[LegacyDocTypeName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ComplaintSearch]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Searches complaints based on parametric values
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintSearch]
	@ComplaintID int = 0,
	@AccountNumber varchar(30) = NULL,
    @ControlNumber varchar(30) = NULL,
    @ContractNumber varchar(30) = NULL,
    @AccountName varchar(30) = NULL,
    @UtilityID int = 0,
    @CasePrimeID int = 0,
    @MarketCode char(2) = NULL,
    @SalesChannelID int = 0,
    @SubmitDate datetime = NULL,
    @OpenDate datetime = NULL,
    @StatusID int = -1,
    @FirstRecord int = 1,
    @PageSize int = 50,
    @SortBy varchar(50) = 'DueDays',
    @SortByDirection varchar(5) = ''
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF @SortBy = ''
		SET @SortBy = 'DueDays'

	DECLARE @searchScript NVARCHAR(Max)
	SET @searchScript = N'SELECT	c.ComplaintID, c.ComplaintLegacyID As LegacyID, a.AccountNumber, n.Name As AccountName, c.ComplaintStatusID AS StatusID, c.OpenDate, c.DueDate, cn.Number AS ContractNumber, '
	SET @searchScript = @searchScript + N'				cn.SalesChannelID, sc.ChannelName, cn.SalesRep AS SalesAgent, ct.Name AS ComplaintTypeName, '
	SET @searchScript = @searchScript + N'				DATEDIFF(dd,GETDATE(), c.DueDate) AS DueDays '
			
	SET @searchScript = @searchScript + N'		FROM	dbo.ComplaintType ct '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Name n '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Account a '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Market m ON a.RetailMktID = m.ID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Complaint c ON a.AccountID = c.AccountID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Contract cn ON a.CurrentContractID = cn.ContractID ON n.NameID = a.AccountNameID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.SalesChannel sc ON cn.SalesChannelID = sc.ChannelID ON ct.ComplaintTypeID = c.ComplaintTypeID '
	SET @searchScript = @searchScript + N'		WHERE	c.ComplaintID = c.ComplaintID '
	IF @ComplaintID > 0
		SET @searchScript = @searchScript + N'		AND c.ComplaintID = @ComplaintID '
	IF @ControlNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND c.ControlNumber = @ControlNumber '
	IF @AccountNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND a.AccountNumber = @AccountNumber '
	IF @ContractNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND cn.Number = @ContractNumber '
	IF @AccountName IS NOT NULL
		SET @searchScript = @searchScript + N'		AND n.Name LIKE ''%@AccountName%'' '
	IF @UtilityID > 0
		SET @searchScript = @searchScript + N'		AND	a.UtilityID = @UtilityID' 
	IF @CasePrimeID > 0
		SET @searchScript = @searchScript + N'		AND	c.CasePrimeID = @CasePrimeID '
	IF @MarketCode IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	m.MarketCode = @MarketCode '
	IF @SalesChannelID > 0
		SET @searchScript = @searchScript + N'		AND	cn.SalesChannelID = @SalesChannelID '
	IF @SubmitDate IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	cn.SubmitDate = @SubmitDate '
	IF @OpenDate IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	c.OpenDate = @OpenDate '
	IF @StatusID > -1
		SET @searchScript = @searchScript + N'		AND	c.ComplaintStatusID = @StatusID '
			
	SET @searchScript = @searchScript + N'		UNION '
		    
	SET @searchScript = @searchScript + N'		SELECT  c.ComplaintID, c.ComplaintLegacyID As LegacyID, a.UtilityAccountNumber AS AccountNumber, a.AccountName, c.ComplaintStatusID AS StatusID, c.OpenDate, c.DueDate, '''' AS ContractNumber, '
	SET @searchScript = @searchScript + N'				 a.SalesChannelID, sc.ChannelName, a.SalesAgent, ct.Name AS ComplaintTypeName, '
	SET @searchScript = @searchScript + N'				 DATEDIFF(dd,GETDATE(), c.DueDate) AS DueDays '
	SET @searchScript = @searchScript + N'		FROM    dbo.ComplaintAccount a '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Complaint c ON a.ComplaintAccountID = c.ComplaintAccountID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.ComplaintType ct ON c.ComplaintTypeID = ct.ComplaintTypeID '
	SET @searchScript = @searchScript + N'				LEFT OUTER JOIN dbo.SalesChannel sc ON a.SalesChannelID = sc.ChannelID '
	SET @searchScript = @searchScript + N'		WHERE	c.ComplaintID = c.ComplaintID '
	IF @ComplaintID > 0
		SET @searchScript = @searchScript + N'		AND c.ComplaintID = @ComplaintID '
	IF @ControlNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND c.ControlNumber = @ControlNumber '
	IF @AccountNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND a.UtilityAccountNumber = @AccountNumber '
	IF @AccountName IS NOT NULL
		SET @searchScript = @searchScript + N'		AND a.AccountName LIKE ''%@AccountName%'' '
	IF @UtilityID > 0
		SET @searchScript = @searchScript + N'		AND	a.UtilityID = @UtilityID '
	IF @CasePrimeID > 0
		SET @searchScript = @searchScript + N'		AND	c.CasePrimeID = @CasePrimeID '
	IF @SalesChannelID > 0
		SET @searchScript = @searchScript + N'		AND	a.SalesChannelID = @SalesChannelID '
	IF @OpenDate IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	c.OpenDate = @OpenDate '
	IF @StatusID > -1
		SET @searchScript = @searchScript + N'		AND	c.ComplaintStatusID = @StatusID '

print @searchScript
	
	CREATE TABLE #tempResults (ComplaintID int, 
							   LegacyID int, 
							   AccountNumber nvarchar(100),
							   AccountName nvarchar(100), 
							   StatusID int, 
							   OpenDate datetime, 
							   DueDate datetime,
							   ContractNumber nvarchar(100),
							   SalesChannelID int, 
							   ChannelName nvarchar(150), 
							   SalesAgent nvarchar(100), 
							   ComplaintTypeName nvarchar(50), 
							   DueDays int
							   )

	DECLARE @searchParamDef NVARCHAR(Max)
	SET @searchParamDef = N'@ComplaintID int,@AccountNumber varchar(30),@ControlNumber varchar(30),@ContractNumber varchar(30),@AccountName varchar(30),@UtilityID int,@CasePrimeID int,@MarketCode char(2),@SalesChannelID int, @SubmitDate datetime, @OpenDate datetime, @StatusID int';
	
	
	INSERT INTO #tempResults 
	EXEC sp_executesql @searchScript, @searchParamDef, @ComplaintID = @ComplaintID, 
													   @AccountNumber = @AccountNumber,
													   @ControlNumber = @ControlNumber, 
													   @ContractNumber = @ContractNumber, 
													   @AccountName = @AccountName, 
													   @UtilityID = @UtilityID, 
													   @CasePrimeID = @CasePrimeID, 
													   @MarketCode = @MarketCode, 
													   @SalesChannelID = @SalesChannelID, 
													   @SubmitDate = @SubmitDate,
													   @OpenDate = @OpenDate,
													   @StatusID = @StatusID

    
	SELECT COUNT(*) as TotalResults, @FirstRecord as FirstRecord, (@FirstRecord + @PageSize) as LastRecord FROM #tempResults


	DECLARE @Script NVARCHAR(Max);
	DECLARE @ParmDefinition NVARCHAR(500);
    
    SET @ParmDefinition = N'@FirstRecord int,@PageSize int';
    
    SET @Script = N'SELECT * '
    SET @Script = @Script + N'FROM (SELECT *, ROW_NUMBER() OVER(ORDER BY ' + @SortBy + ' ' + @SortByDirection + ') AS RowNumber FROM #tempResults) as SearchResults '
    SET @Script = @Script + N'WHERE RowNumber >= @FirstRecord AND RowNumber < (@FirstRecord + @PageSize) '
    SET @Script = @Script + N'ORDER BY ' + @SortBy + ' ' + @SortByDirection
    
    print @Script
    print @SortBy + ' ' + @SortByDirection
    
    EXECUTE sp_executesql @Script, @ParmDefinition, @FirstRecord = @FirstRecord, @PageSize = @PageSize
    
    DROP TABLE #tempResults

END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintSelect]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	SReturns a specific complaint
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintSelect] 
	@ComplaintID int
AS

BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT	c.ComplaintID,
			c.AccountID,
			c.ComplaintAccountID,
			c.ComplaintRegulatoryAuthorityID,
			cra.RequiredDaysForResolution,
			c.ComplaintStatusID,
			c.ComplaintIssueTypeID,
			c.ComplaintantName,
			c.OpenDate,
			c.DueDate,
			c.AcknowledgeDate,
			c.ClosedDate,
			c.LastContactDate,
			c.CasePrimeID,
			c.ControlNumber,
			ct.ComplaintCategoryID,
			ct.ComplaintTypeID,
			c.IsFormal,
			c.PrimaryDescription,
			c.SecondaryDescription,
			c.InboundCalls,
			c.TeamContactedID,
			c.ContractReviewDate,
			c.SalesMgrNotified,
			c.ValidContract,
			c.DisputeOutcomeID,
			c.Waiver,
			c.Credit,
			c.ResolutionDescription,
			c.InternalFindings,
			c.Comments,
			c.CreationDate,
			c.CreatedBy,
			c.LastModifiedDate,
			c.LastModifiedBy
	FROM	Complaint c
			LEFT JOIN ComplaintRegulatoryAuthority cra ON c.ComplaintRegulatoryAuthorityID = cra.ComplaintRegulatoryAuthorityID 
			INNER JOIN ComplaintType ct ON c.ComplaintTypeID = ct.ComplaintTypeID
	WHERE	c.ComplaintID = @ComplaintID


END
GO
/****** Object:  Table [dbo].[ComplaintRegulatoryAuthorityLegacyMap]    Script Date: 11/28/2012 10:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComplaintRegulatoryAuthorityLegacyMap](
	[ComplaintRegulatoryAuthorityID] [int] NOT NULL,
	[LegacyID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintRegulatoryAuthorityDelete]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Deletes a regulatory authority
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintRegulatoryAuthorityDelete]
	@RegulatoryAuthorityID int
AS
BEGIN

	UPDATE ComplaintRegulatoryAuthority SET
		IsActive = 0
	WHERE ComplaintRegulatoryAuthorityID = @RegulatoryAuthorityID

END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintRegulatoryAuthorityCreateOrUpdate]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates or updates a regulatory authority
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintRegulatoryAuthorityCreateOrUpdate]
	@RegulatoryAuthorityID int,
	@Name varchar(255),
	@MarketCode char(2),
	@RequiredDaysForResolution int,
	@CalendarType varchar(10)
AS
BEGIN

	IF @RegulatoryAuthorityID > 0
		UPDATE ComplaintRegulatoryAuthority SET
			Name = @Name,
			MarketCode = @MarketCode,
			RequiredDaysForResolution = @RequiredDaysForResolution,
			CalendarType = @CalendarType
		WHERE ComplaintRegulatoryAuthorityID = @RegulatoryAuthorityID
	ELSE
		BEGIN
			INSERT INTO ComplaintRegulatoryAuthority(Name, MarketCode, RequiredDaysForResolution, CalendarType)
			VALUES (@Name, @MarketCode, @RequiredDaysForResolution, @CalendarType)
			
			SET @RegulatoryAuthorityID = SCOPE_IDENTITY()
		END
		
	SELECT @RegulatoryAuthorityID As RegulatoryAuthorityID

END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountDocumentsGet]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of documents related to an exisitng LP account
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountDocumentsGet] 
	@AccountID varchar(50) = null ,
 	@ContractNumber varchar(50) = null,   
 	@UserName varchar(100) = '' 
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [Lp_documents].[dbo].[usp_document_history_sel_by_acct_con]
								@p_account_id = @AccountID,
 								@p_contract_nbr = @ContractNumber,   
 								@p_user_name = @UserName
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountCreateOrUpdate]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates an account that filed a complaint and never was an LP customer.
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountCreateOrUpdate] 
    @AccountID int,
    @UtilityAccountNumber varchar(30) = NULL,
    @AccountName varchar(200) = NULL,
    @UtilityID int = NULL,
    @MarketCode char(2),
    @Address nvarchar(150) = NULL,
    @City nvarchar(100) = NULL,
    @Zip char(10) = NULL,
    @SalesAgent varchar(64) = NULL,
    @SalesChannelID int = NULL
AS

BEGIN
	SET NOCOUNT ON;

    IF (@AccountID > 0)
		UPDATE ComplaintAccount SET
			UtilityAccountNumber = @UtilityAccountNumber,
			AccountName = @AccountName,
			UtilityID = @UtilityID,
			MarketCode = @MarketCode,
			[Address] = @Address,
			City = @City,
			Zip = @Zip,
			SalesAgent = @SalesAgent,
			SalesChannelID = @SalesChannelID
		WHERE ComplaintAccountID = @AccountID
    ELSE
		BEGIN
			INSERT INTO ComplaintAccount(
					UtilityAccountNumber,
					AccountName,
					UtilityID,
					MarketCode,
					[Address],
					City,
					Zip,
					SalesAgent,
					SalesChannelID
					)
			VALUES (
					@UtilityAccountNumber,
					@AccountName,
					@UtilityID,
					@MarketCode,
					@Address,
					@City,
					@Zip,
					@SalesAgent,
					@SalesChannelID
					)
					
			SET @AccountID = SCOPE_IDENTITY()
		END
		
		SELECT @AccountID as AccountID
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns an account that filed a complaint and is never was an LP customer.
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountByIdSelect]
(
	@ComplaintAccountID int
)
As

SET NOCOUNT ON

SELECT ca.ComplaintAccountID
      ,ca.AccountName
      ,ca.UtilityAccountNumber
      ,ca.UtilityID
      ,ca.MarketCode
      ,ca.SalesAgent
      ,ca.SalesChannelID
      ,ca.[Address]
      ,ca.City
      ,ca.Zip
  FROM [dbo].[ComplaintAccount] ca (nolock)
  WHERE ca.ComplaintAccountID = @ComplaintAccountID
GO
/****** Object:  StoredProcedure [dbo].[ComplaintReport]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Generates a list of complaints
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintReport]
    @MarketCode varchar(2) = NULL,
    @FromOpenDate datetime = NULL,
    @ToOpenDate datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT	c.ComplaintID AS ComplaintID, 
			m.MarketCode, 
			c.OpenDate, 
			c.ClosedDate, 
			con.SubmitDate, 
			cra.Name AS RegulatoryAuthorityName, 
			sc.ChannelName, 
			con.SalesRep AS SalesAgent, 
			at.AccountType, 
			a.AccountNumber, 
			n.Name AS AccountName, 
			cc.Name AS ComplaintCategoryName, 
			ct.Name AS ComplaintTypeName, 
			c.PrimaryDescription, 
			c.SecondaryDescription, 
			cit.Name AS IssueTypeName, 
			c.InboundCalls, 
			c.InternalFindings, 
			c.ResolutionDescription, 
			c.DueDate, 
			c.Waiver, 
			c.Credit, 
			cdo.Name AS DisputeOutcomeName, 
			u.FullName AS UtilityFullName, 
			cont.[Type] AS ContractType, 
			acr.Term, 
			acr.Rate, 
			au.AnnualUsage
	FROM	dbo.AccountContract ac 
			INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID 
			INNER JOIN dbo.Name n ON a.AccountNameID = n.NameID 
			INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID 
			INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
			INNER JOIN dbo.Market m ON a.RetailMktID = m.ID 
			INNER JOIN dbo.AccountStatus ast ON ac.AccountContractID = ast.AccountContractID 
			INNER JOIN dbo.[Contract] con ON ac.ContractID = con.ContractID AND a.CurrentContractID = con.ContractID 
			INNER JOIN dbo.Complaint c ON a.AccountID = c.AccountID 
			INNER JOIN dbo.ComplaintIssueType cit ON c.ComplaintIssueTypeID = cit.ComplaintIssueTypeID 
			INNER JOIN dbo.ComplaintStatus cs ON c.ComplaintStatusID = cs.ComplaintStatusID 
			INNER JOIN dbo.ComplaintType ct ON c.ComplaintTypeID = ct.ComplaintTypeID 
			INNER JOIN dbo.ComplaintCategory cc ON ct.ComplaintCategoryID = cc.ComplaintCategoryID 
			INNER JOIN dbo.ComplaintRegulatoryAuthority cra ON c.ComplaintRegulatoryAuthorityID = cra.ComplaintRegulatoryAuthorityID 
			INNER JOIN dbo.SalesChannel sc ON con.SalesChannelID = sc.ChannelID 
			INNER JOIN dbo.ComplaintDisputeOutcome cdo ON c.DisputeOutcomeID = cdo.ComplaintDisputeOutcomeID 
			INNER JOIN dbo.ContractType cont ON con.ContractTypeID = cont.ContractTypeID 
			LEFT OUTER JOIN dbo.AccountUsage au ON a.AccountID = au.AccountID AND au.EffectiveDate = con.StartDate 
			LEFT OUTER JOIN dbo.AccountLatestService als ON a.AccountID = als.AccountID 
			LEFT OUTER JOIN dbo.AccountContractRate acr ON ac.AccountContractID = acr.AccountContractID AND acr.IsContractedRate = 0
	WHERE	(@MarketCode IS NULL OR (@MarketCode IS NOT NULL AND m.MarketCode = @MarketCode))
	AND		(@FromOpenDate IS NULL OR (@FromOpenDate IS NOT NULL AND c.OpenDate >= @FromOpenDate))
	AND		(@ToOpenDate IS NULL OR (@ToOpenDate IS NOT NULL AND c.OpenDate <= @ToOpenDate))
	
UNION

    SELECT  c.ComplaintID AS ComplaintID, 
			m.MarketCode, 
			c.OpenDate, 
			c.ClosedDate, 
			NULL AS SubmitDate, 
			cra.Name AS RegulatoryAuthorityName, 
			sc.ChannelName, 
			ca.SalesAgent, 
			NULL AS AccountType, 
			ca.UtilityAccountNumber, 
			ca.AccountName, 
			cc.Name AS ComplaintCategoryName, 
			ct.Name AS ComplaintTypeName, 
			c.PrimaryDescription, 
			c.SecondaryDescription, 
			cit.Name AS IssueTypeName, 
			c.InboundCalls, 
			c.InternalFindings, 
			c.ResolutionDescription, 
			c.DueDate, 
			c.Waiver, 
			c.Credit, 
			cdo.Name AS DisputeOutcomeName, 
			u.FullName AS UtilityFullName, 
			NULL AS ContractType, 
			0 As Term, 
			NULL AS Rate, 
			0 AS AnnualUsage
	FROM    dbo.ComplaintAccount ca
			INNER JOIN dbo.Utility u ON ca.UtilityID = u.ID 
			INNER JOIN dbo.Market m ON ca.MarketCode = m.MarketCode 
			INNER JOIN dbo.Complaint c ON ca.ComplaintAccountID = c.ComplaintAccountID 
			INNER JOIN dbo.ComplaintType ct ON c.ComplaintTypeID = ct.ComplaintTypeID 
			INNER JOIN dbo.ComplaintCategory cc ON ct.ComplaintCategoryID = cc.ComplaintCategoryID 
			INNER JOIN dbo.ComplaintIssueType cit ON c.ComplaintIssueTypeID = cit.ComplaintIssueTypeID 
			INNER JOIN dbo.ComplaintStatus cs ON c.ComplaintStatusID = cs.ComplaintStatusID 
			INNER JOIN dbo.ComplaintRegulatoryAuthority cra ON c.ComplaintRegulatoryAuthorityID = cra.ComplaintRegulatoryAuthorityID 
			INNER JOIN dbo.SalesChannel sc ON ca.SalesChannelID = sc.ChannelID 
			INNER JOIN dbo.ComplaintDisputeOutcome cdo ON c.DisputeOutcomeID = cdo.ComplaintDisputeOutcomeID
    WHERE	(@MarketCode IS NULL OR (@MarketCode IS NOT NULL AND ca.MarketCode = @MarketCode))
	AND		(@FromOpenDate IS NULL OR (@FromOpenDate IS NOT NULL AND c.OpenDate >= @FromOpenDate))
	AND		(@ToOpenDate IS NULL OR (@ToOpenDate IS NOT NULL AND c.OpenDate <= @ToOpenDate))
    
END
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountsSearch]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Searches for LP accounts, or non-LP accounts who filed a complaint
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountsSearch]
(
	@AccountID int,
	@AccountNumber varchar(30) = NULL,
	@AccountAddress varchar(200) = NULL,
	@AccountPhone varchar(30) = NULL,
	@IsLP bit = NULL
)
As

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT  a.AccountID,
		a.AccountIdLegacy, 
		a.AccountNumber,
		a.CurrentContractID,
		ac.ContractID,
		ac.AccountContractID,
		c.Number As ContractNumber,
		c.SubmitDate As SubmitDate,
		a.AccountTypeID,
		at.AccountType As AccountTypeCode,
		at.Description AS AccountTypeName, 
        --a.RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp, 
        dbo.Name.Name, 
        ad.Address1,
        ad.City,
        ad.[State],
        ad.Zip,
        '' AS Phone,
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		acr.AccountContractRateID, 
		dbo.AccountUsage.AnnualUsage,
		--[dbo].[ufn_GetLegacyAccountStatus](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus) AS EnrollmentStatus,
		(st.status_descp + ' - ' + st.sub_status_descp) As EnrollmentStatus,
		[dbo].[ufn_GetLegacyFlowStartDate](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus, dbo.AccountLatestService.StartDate) as FlowStartDate,
		AccountLatestService.EndDate As DeenrollmentDate,
		(SELECT COUNT(*) FROM dbo.Account a1 WHERE a1.CurrentContractID = a.CurrentContractID) As NumberOfAccounts,
		acr.Term,
		acr.Rate, 
		dbo.AccountStatus.Status, 
		dbo.AccountStatus.SubStatus,
		c.SalesChannelID,
		c.SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	dbo.AccountContract ac 
		INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID AND a.CurrentContractID = ac.ContractID 
		LEFT JOIN dbo.Name ON a.AccountNameID = dbo.Name.NameID 
		INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID 
		LEFT JOIN dbo.[Address] ad ON a.ServiceAddressID = ad.AddressID 
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
		INNER JOIN dbo.Market m ON a.RetailMktID = m.ID 
		LEFT JOIN dbo.AccountStatus ON ac.AccountContractID = dbo.AccountStatus.AccountContractID 
		INNER JOIN dbo.[Contract] c ON ac.ContractID = c.ContractID AND a.CurrentContractID = c.ContractID 
		LEFT OUTER JOIN dbo.AccountUsage ON a.AccountID = dbo.AccountUsage.AccountID AND dbo.AccountUsage.EffectiveDate = c.StartDate 
		LEFT OUTER JOIN dbo.AccountLatestService ON a.AccountID = dbo.AccountLatestService.AccountID 
		LEFT OUTER JOIN dbo.AccountContractRate acr ON ac.AccountContractID = acr.AccountContractID AND acr.IsContractedRate = 1 
		INNER JOIN dbo.SalesChannel ON c.SalesChannelID = SalesChannel.ChannelID 
		INNER JOIN (SELECT ss.[status]
						  ,ss.[sub_status]
						  ,s.[status_descp]
						  ,ss.[sub_status_descp]
					 FROM [Lp_Account].[dbo].[enrollment_status] s
					 JOIN  [Lp_Account].[dbo].[enrollment_sub_status] ss on s.status = ss.status
					 ) As st ON dbo.AccountStatus.[Status] = st.status AND dbo.AccountStatus.SubStatus = st.sub_status
WHERE	(@IsLP = 1 OR @IsLP IS NULL)
AND		(
			(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.AccountNumber = @AccountNumber) OR
			(@AccountID > 0 AND a.AccountID = @AccountID)
		)

UNION

SELECT	a.ComplaintAccountID AS AccountID, 
		'' AS AccountIdLegacy, 
		a.UtilityAccountNumber As AccountNumber,
		0 AS CurrentContractID,
		0 AS ContractID,
		0 AS AccountContractID,
		'' AS ContractNumber,
		NULL AS ContractDate,
		-1 AS AccountTypeID,
		'NOLP' As AccountTypeCode,
		'Non-Liberty Power Account' AS AccountTypeName, 
        --a.MarketID AS RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp,
        a.AccountName As Name, 
        a.Address As Address1,
        a.City,
        m.MarketCode AS [State],
        a.Zip,
        a.Phone,
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		0 AS AccountContractRateID, 
		0 AS AnnualUsage,
		'' AS EnrollmentStatus,
		NULL as FlowStartDate,
		NULL AS DeenrollmentDate,
		0 As NumberOfAccounts,
		0 AS Term,
		0 AS Rate, 
		NULL AS Status, 
		NULL AS SubStatus,
		a.SalesChannelID,
		a.SalesAgent As SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	ComplaintAccount a 
		INNER JOIN dbo.Market m ON a.MarketCode = m.MarketCode
		LEFT JOIN dbo.Utility u ON a.UtilityID = u.ID 
		LEFT JOIN dbo.SalesChannel ON a.SalesChannelID = SalesChannel.ChannelID
WHERE	(@IsLP = 0 OR @IsLP IS NULL)
AND		(
			(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.UtilityAccountNumber = @AccountNumber) OR
			(@AccountID > 0 AND a.ComplaintAccountID = @AccountID)
		)

ORDER BY AccountNumber
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountsByNumberOrIDSelect]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of accounts, either customers of LP, or non-customers who filed a complaint
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountsByNumberOrIDSelect]
(
	@AccountNumber varchar(30) = NULL,
	@AccountID int
)
As

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT  a.AccountID, 
		a.AccountIdLegacy, 
		a.AccountNumber,
		a.CurrentContractID,
		ac.ContractID,
		ac.AccountContractID,
		c.Number As ContractNumber,
		c.SignedDate As ContractDate,
		a.AccountTypeID,
		at.AccountType As AccountTypeCode,
		at.Description AS AccountTypeName, 
        a.RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp, 
        dbo.Name.Name, 
        ad.Address1,
        ad.City,
        ad.[State],
        ad.Zip,
        '' AS Phone,
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		dbo.AccountContractRate.AccountContractRateID, 
		dbo.AccountUsage.AnnualUsage,
		[dbo].[ufn_GetLegacyAccountStatus](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus) AS EnrollmentStatus,
		[dbo].[ufn_GetLegacyFlowStartDate](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus, dbo.AccountLatestService.StartDate) as FlowStartDate,
		[dbo].[ufn_GetLegacyDateDeenrollment](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus, dbo.AccountLatestService.EndDate) AS DeenrollmentDate,
		(SELECT COUNT(*) FROM dbo.Account a1 WHERE a1.CurrentContractID = a.CurrentContractID) As NumberOfAccounts,
		AccountContractRate.Term,
		AccountContractRate.Rate, 
		dbo.AccountStatus.Status, 
		dbo.AccountStatus.SubStatus,
		c.SalesChannelID,
		c.SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	dbo.AccountContract ac 
		INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID 
		INNER JOIN dbo.Name ON a.AccountNameID = dbo.Name.NameID
		INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID
		INNER JOIN dbo.Address ad ON a.ServiceAddressID = ad.AddressID
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID
		INNER JOIN dbo.Market m ON a.RetailMktID = m.ID
		INNER JOIN dbo.AccountStatus ON ac.AccountContractID = dbo.AccountStatus.AccountContractID
		INNER JOIN dbo.Contract c ON ac.ContractID = c.ContractID AND a.CurrentContractID = c.ContractID
		LEFT OUTER JOIN dbo.AccountUsage ON a.AccountID = dbo.AccountUsage.AccountID AND dbo.AccountUsage.EffectiveDate = c.StartDate
		LEFT OUTER JOIN dbo.AccountLatestService ON a.AccountID = dbo.AccountLatestService.AccountID
		LEFT OUTER JOIN dbo.AccountContractRate ON ac.AccountContractID = dbo.AccountContractRate.AccountContractID AND dbo.AccountContractRate.IsContractedRate = 0
		INNER JOIN dbo.SalesChannel ON c.SalesChannelID = SalesChannel.ChannelID
WHERE	(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.AccountNumber = @AccountNumber)
OR		(@AccountID > 0 AND a.AccountID = @AccountID)

UNION

SELECT	0 AS AccountID, 
		'' AS AccountIdLegacy, 
		a.UtilityAccountNumber,
		0 AS CurrentContractID,
		0 AS ContractID,
		0 AS AccountContractID,
		'' AS ContractNumber,
		NULL AS ContractDate,
		0 AS AccountTypeID,
		'' As AccountTypeCode,
		'' AS AccountTypeName, 
        m.ID AS RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp,
        a.AccountName As Name, 
        a.Address As Address1,
        a.City,
        m.MarketCode AS [State],
        a.Zip,
        a.Phone,
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		0 AS AccountContractRateID, 
		0 AS AnnualUsage,
		'' AS EnrollmentStatus,
		NULL as FlowStartDate,
		NULL AS DeenrollmentDate,
		0 As NumberOfAccounts,
		0 AS Term,
		0 AS Rate, 
		NULL AS Status, 
		NULL AS SubStatus,
		a.SalesChannelID,
		a.SalesAgent As SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	ComplaintAccount a 
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
		INNER JOIN dbo.Market m ON a.MarketCode = m.MarketCode
		LEFT JOIN dbo.SalesChannel ON a.SalesChannelID = SalesChannel.ChannelID
WHERE	(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.UtilityAccountNumber = @AccountNumber)


ORDER BY AccountNumber
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountsByContractIdSelect]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of accounts related to a contract
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountsByContractIdSelect]
(
	@ContractID int
)
As

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT  a.AccountID, 
		a.AccountIdLegacy, 
		a.AccountNumber,
		a.CurrentContractID,
		ac.ContractID,
		ac.AccountContractID,
		c.Number As ContractNumber,
		a.AccountTypeID,
		at.AccountType As AccountTypeCode,
		at.Description AS AccountTypeName, 
        a.RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp, 
        dbo.Name.Name, 
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		acr.AccountContractRateID, 
		dbo.AccountUsage.AnnualUsage,
		[dbo].[ufn_GetLegacyAccountStatus](acs.[Status], acs.SubStatus) AS EnrollmentStatus,
		[dbo].[ufn_GetLegacyFlowStartDate](acs.[Status], acs.SubStatus, als.StartDate) as FlowStartDate,
		als.EndDate As DeenrollmentDate,
		acr.Term,
		acr.Rate, 
		acs.[Status], 
		acs.SubStatus
FROM	dbo.AccountContract ac 
		INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID AND a.CurrentContractID = ac.ContractID 
		LEFT JOIN dbo.Name ON a.AccountNameID = dbo.Name.NameID 
		INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID 
		LEFT JOIN dbo.Address ad ON a.ServiceAddressID = ad.AddressID 
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
		INNER JOIN dbo.Market as m ON a.RetailMktID = m.ID 
		LEFT JOIN dbo.AccountStatus acs ON ac.AccountContractID = acs.AccountContractID 
		INNER JOIN dbo.Contract c ON ac.ContractID = c.ContractID AND a.CurrentContractID = c.ContractID 
		LEFT OUTER JOIN dbo.AccountUsage ON a.AccountID = dbo.AccountUsage.AccountID AND dbo.AccountUsage.EffectiveDate = c.StartDate 
		LEFT OUTER JOIN dbo.AccountLatestService als ON a.AccountID = als.AccountID 
		LEFT OUTER JOIN dbo.AccountContractRate as acr ON ac.AccountContractID = acr.AccountContractID AND acr.IsContractedRate = 1 
		INNER JOIN dbo.SalesChannel ON c.SalesChannelID = SalesChannel.ChannelID
WHERE	ac.ContractID = @ContractID
ORDER BY a.AccountNumber
GO
/****** Object:  Default [DF_Complaint_CreationDate]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint] ADD  CONSTRAINT [DF_Complaint_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
/****** Object:  Default [DF_Complaint_LastModifiedDate]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint] ADD  CONSTRAINT [DF_Complaint_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
/****** Object:  Default [DF_ComplaintDocument_CreatedOn]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintDocument] ADD  CONSTRAINT [DF_ComplaintDocument_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ComplaintDocument_AllowPublicView]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintDocument] ADD  CONSTRAINT [DF_ComplaintDocument_AllowPublicView]  DEFAULT ((0)) FOR [AllowPublicView]
GO
/****** Object:  Default [DF_ComplaintRegulatoryAuthority_IsActive]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintRegulatoryAuthority] ADD  CONSTRAINT [DF_ComplaintRegulatoryAuthority_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
/****** Object:  Check [CK_Either_AccountID]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH CHECK ADD  CONSTRAINT [CK_Either_AccountID] CHECK  (([AccountID] IS NULL AND [ComplaintAccountID] IS NOT NULL OR [AccountID] IS NOT NULL AND [ComplaintAccountID] IS NULL))
GO
ALTER TABLE [dbo].[Complaint] CHECK CONSTRAINT [CK_Either_AccountID]
GO
/****** Object:  ForeignKey [FK_Complaint_Account]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH NOCHECK ADD  CONSTRAINT [FK_Complaint_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([AccountID])
GO
ALTER TABLE [dbo].[Complaint] NOCHECK CONSTRAINT [FK_Complaint_Account]
GO
/****** Object:  ForeignKey [FK_Complaint_ComplaintAccount]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH NOCHECK ADD  CONSTRAINT [FK_Complaint_ComplaintAccount] FOREIGN KEY([ComplaintAccountID])
REFERENCES [dbo].[ComplaintAccount] ([ComplaintAccountID])
GO
ALTER TABLE [dbo].[Complaint] NOCHECK CONSTRAINT [FK_Complaint_ComplaintAccount]
GO
/****** Object:  ForeignKey [FK_Complaint_ComplaintContactedTeam]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH CHECK ADD  CONSTRAINT [FK_Complaint_ComplaintContactedTeam] FOREIGN KEY([TeamContactedID])
REFERENCES [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID])
GO
ALTER TABLE [dbo].[Complaint] CHECK CONSTRAINT [FK_Complaint_ComplaintContactedTeam]
GO
/****** Object:  ForeignKey [FK_Complaint_ComplaintIssueType]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH CHECK ADD  CONSTRAINT [FK_Complaint_ComplaintIssueType] FOREIGN KEY([ComplaintIssueTypeID])
REFERENCES [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID])
GO
ALTER TABLE [dbo].[Complaint] CHECK CONSTRAINT [FK_Complaint_ComplaintIssueType]
GO
/****** Object:  ForeignKey [FK_Complaint_ComplaintStatus]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH CHECK ADD  CONSTRAINT [FK_Complaint_ComplaintStatus] FOREIGN KEY([ComplaintStatusID])
REFERENCES [dbo].[ComplaintStatus] ([ComplaintStatusID])
GO
ALTER TABLE [dbo].[Complaint] CHECK CONSTRAINT [FK_Complaint_ComplaintStatus]
GO
/****** Object:  ForeignKey [FK_Complaint_ComplaintType]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH CHECK ADD  CONSTRAINT [FK_Complaint_ComplaintType] FOREIGN KEY([ComplaintTypeID])
REFERENCES [dbo].[ComplaintType] ([ComplaintTypeID])
GO
ALTER TABLE [dbo].[Complaint] CHECK CONSTRAINT [FK_Complaint_ComplaintType]
GO
/****** Object:  ForeignKey [FK_Complaint_Contract]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[Complaint]  WITH NOCHECK ADD  CONSTRAINT [FK_Complaint_Contract] FOREIGN KEY([ContractID])
REFERENCES [dbo].[Contract] ([ContractID])
GO
ALTER TABLE [dbo].[Complaint] NOCHECK CONSTRAINT [FK_Complaint_Contract]
GO
/****** Object:  ForeignKey [FK_ComplaintDocument_Complaint]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintDocument]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintDocument_Complaint] FOREIGN KEY([ComplaintID])
REFERENCES [dbo].[Complaint] ([ComplaintID])
GO
ALTER TABLE [dbo].[ComplaintDocument] CHECK CONSTRAINT [FK_ComplaintDocument_Complaint]
GO
/****** Object:  ForeignKey [FK_ComplaintDocument_FileContext]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintDocument]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintDocument_FileContext] FOREIGN KEY([FileGuid])
REFERENCES [dbo].[FileContext] ([FileGuid])
GO
ALTER TABLE [dbo].[ComplaintDocument] CHECK CONSTRAINT [FK_ComplaintDocument_FileContext]
GO
/****** Object:  ForeignKey [FK_ComplaintRegulatoryAuthorityLegacyMap_ComplaintRegulatoryAuthority]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintRegulatoryAuthorityLegacyMap]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintRegulatoryAuthorityLegacyMap_ComplaintRegulatoryAuthority] FOREIGN KEY([ComplaintRegulatoryAuthorityID])
REFERENCES [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID])
GO
ALTER TABLE [dbo].[ComplaintRegulatoryAuthorityLegacyMap] CHECK CONSTRAINT [FK_ComplaintRegulatoryAuthorityLegacyMap_ComplaintRegulatoryAuthority]
GO
/****** Object:  ForeignKey [FK_ComplaintType_ComplaintCategory]    Script Date: 11/28/2012 10:08:27 ******/
ALTER TABLE [dbo].[ComplaintType]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintType_ComplaintCategory] FOREIGN KEY([ComplaintCategoryID])
REFERENCES [dbo].[ComplaintCategory] ([ComplaintCategoryID])
GO
ALTER TABLE [dbo].[ComplaintType] CHECK CONSTRAINT [FK_ComplaintType_ComplaintCategory]
GO
