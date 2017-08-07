
-----------------------------------------------------------------------------------------------------
--28366: As a Contract Submission API I need a client identification package added to my structure to accomodate the refactored tablet API
--Scripts to identify the Client Application that is submitting the contract
--1/16/2014 
------------------------------------------------------------------------------------------------------

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ClientApplicationType]    Script Date: 02/03/2014 10:24:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientApplicationType]') AND type in (N'U'))
DROP TABLE [dbo].[ClientApplicationType]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ClientApplicationType]    Script Date: 02/03/2014 10:24:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClientApplicationType](
	[ClientApplicationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ClientApplicationType] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ClientApplicationType] PRIMARY KEY CLUSTERED 
(
	[ClientApplicationTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO


-------------------------------

USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ClientSubmitApplicationKey_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ClientSubmitApplicationKey] DROP CONSTRAINT [DF_ClientSubmitApplicationKey_Active]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ClientSubmitApplicationKey]    Script Date: 02/03/2014 10:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientSubmitApplicationKey]') AND type in (N'U'))
DROP TABLE [dbo].[ClientSubmitApplicationKey]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[ClientSubmitApplicationKey]    Script Date: 02/03/2014 10:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClientSubmitApplicationKey](
	[ClientSubApplicationKeyId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationKey] [uniqueidentifier] NOT NULL,
	[ClientApplicationTypeId] [int] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_ClientSubmitApplicationKey] PRIMARY KEY CLUSTERED 
(
	[ClientSubApplicationKeyId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ClientSubmitApplicationKey] ADD  CONSTRAINT [DF_ClientSubmitApplicationKey_Active]  DEFAULT ((1)) FOR [Active]
GO


---------------------------------



-------------------------------------------------------------------------------------
--Insert Data Scripts
---------------------------------------------------------------------------------------

USE [LibertyPower]
GO
If Not exists (Select * from  [ClientApplicationType])
BEGIN


/****** Object:  Table [dbo].[ClientApplicationType]    Script Date: 01/16/2014 14:22:35 ******/
SET IDENTITY_INSERT [dbo].[ClientApplicationType] ON
INSERT [dbo].[ClientApplicationType] ([ClientApplicationTypeId], [ClientApplicationType], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, N'SubmitClosedDeals', N'Submission through DealCapture web Application', 1982, CAST(0x0000A2B400000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientApplicationType] ([ClientApplicationTypeId], [ClientApplicationType], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (2, N'BatchUpload', N'Submission through Batch Upload Pager', 1982, CAST(0x0000A2B400000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientApplicationType] ([ClientApplicationTypeId], [ClientApplicationType], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (3, N'ContractPrepopulation', N'Submission through ContractPrepopulation', 1982, CAST(0x0000A2B400000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientApplicationType] ([ClientApplicationTypeId], [ClientApplicationType], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (4, N'OnlineEnrollment', N'Submission through Online Enrollment', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientApplicationType] ([ClientApplicationTypeId], [ClientApplicationType], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (5, N'Tablet', N'Submission through Tablet', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientApplicationType] ([ClientApplicationTypeId], [ClientApplicationType], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (6, N'Thirdparty', N'Submission through some third parties', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[ClientApplicationType] OFF
/****** Object:  Table [dbo].[ClientSubmitApplicationKey]    Script Date: 01/16/2014 14:22:35 ******/
SET IDENTITY_INSERT [dbo].[ClientSubmitApplicationKey] ON
INSERT [dbo].[ClientSubmitApplicationKey] ([ClientSubApplicationKeyId], [ApplicationKey], [ClientApplicationTypeId], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, N'05553978-8ee9-46fe-9e9e-f3071b6c5556', 1, N'Submit closed deals', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientSubmitApplicationKey] ([ClientSubApplicationKeyId], [ApplicationKey], [ClientApplicationTypeId], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (2, N'72c0feaf-fed5-4580-89d2-d24f77e91934', 2, N'Submit through batch Upload', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientSubmitApplicationKey] ([ClientSubApplicationKeyId], [ApplicationKey], [ClientApplicationTypeId], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (3, N'b011637f-fb7e-479b-8afa-c37bc3973b49', 3, N'Submit through Contract prepopulation', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientSubmitApplicationKey] ([ClientSubApplicationKeyId], [ApplicationKey], [ClientApplicationTypeId], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (4, N'bda11d91-7ade-4da1-855d-24adfe39d174', 4, N'Submit through Online Enrollment', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
INSERT [dbo].[ClientSubmitApplicationKey] ([ClientSubApplicationKeyId], [ApplicationKey], [ClientApplicationTypeId], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (5, N'460ad6f3-8216-469f-9b1c-52cffa5d812c', 4, N'Submit through Online Enrollment', 1982, CAST(0x0000A2B500000000 AS DateTime), 1982, CAST(0x0000A2B500000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[ClientSubmitApplicationKey] OFF

END
GO

---------------------------------------------------------------------------------





-------------------------------------------------------------------------
--Contract Scripts
--------------------------------------------------------------------------------
BEGIN TRANSACTION T1
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'Contract' 
           AND  COLUMN_NAME = 'ClientSubmitApplicationKeyId')
BEGIN
ALTER TABLE dbo.Contract ADD
	ClientSubmitApplicationKeyId int NULL;
ALTER TABLE dbo.Contract SET (LOCK_ESCALATION = TABLE);
END

COMMIT 
-----------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ContractInsert]    Script Date: 10/29/2013 16:19:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_ContractInsert]
*
* DEFINITION:  Selects record  from Contract
*
* RETURN CODE: 
*
* REVISIONS:	6/21/2011
8/29/2011	Jaime Forero
10/29/2013	Satchi Jena   Added Logic for inserting AffinityCode.
1/31/2014  Sara lakshmanan Added ClientSubmitApplicationKeyId
*/


ALTER PROCEDURE [dbo].[usp_ContractInsert]
	@Number VARCHAR(50),
	@ContractTypeID INT,
	@ContractDealTypeID INT,
	@ContractStatusID INT,
	@ContractTemplateID INT,
	@ReceiptDate DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@SignedDate DATETIME,
	@SubmitDate DATETIME,
	@SalesChannelID INT,
	@SalesRep VARCHAR(64),
	@SalesManagerID INT,
	@PricingTypeID INT = NULL,
	@DigitalSignature varchar(100) = null,
	@ModifiedBy INT,
	@CreatedBy INT, -- This is here for migration purposes only, in reality both modified and created by should be the same when inserting new records
	@IsSilent BIT = 0,
	@EstimatedAnnualUsage int = NULL,
	@AffinityCode varchar(50) = NULL,
	@ClientSubmitApplicationKeyId int=NULL
AS
BEGIN

-- set nocount on and default isolation level
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF
	
	DECLARE @ContractID INT;
	-- DATA CLEANUP
	SET @SalesRep	= lp_account.dbo.ufn_strip_special_characters(@SalesRep);	
	
	INSERT INTO [LibertyPower].[dbo].[Contract]
           ([Number]
           ,[ContractTypeID]
           ,[ContractDealTypeID]
           ,[ContractStatusID]
           ,[ContractTemplateID]
           ,[ReceiptDate]
           ,[StartDate]
           ,[EndDate]
           ,[SignedDate]
           ,[SubmitDate]
           ,[CreatedBy]
           ,[SalesChannelID]
           ,[SalesRep]
           ,[SalesManagerID]
           ,[PricingTypeID]
           ,[DigitalSignature]
           ,[ModifiedBy]
           ,[Modified]
           ,[DateCreated]
		 ,[EstimatedAnnualUsage]
		 ,[AffinityCode]
		 ,[ClientSubmitApplicationKeyId]
)
     VALUES
           (@Number,
			@ContractTypeID,
			@ContractDealTypeID,
			@ContractStatusID,
			@ContractTemplateID,
			@ReceiptDate,
			@StartDate,
			@EndDate,
			@SignedDate,
			@SubmitDate,
			@CreatedBy,
			@SalesChannelID,
			@SalesRep,
			@SalesManagerID,
			@PricingTypeID,
			@DigitalSignature,
			@ModifiedBy,
			GETDATE(),
			GETDATE(),
			ISNULL(@EstimatedAnnualUsage, 0),
			@AffinityCode,
			@ClientSubmitApplicationKeyId
			)
	

	SET @ContractID = SCOPE_IDENTITY();	

	IF @IsSilent = 0
	begin
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
	end
	
	RETURN @ContractID;
	
END	
GO
------------------------------------------------------


USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ContractUpdate]    Script Date: 10/29/2013 16:29:23 ******/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
*
* PROCEDURE:	[usp_ContractUpdate]
*
* DEFINITION:  Updates a record on the contract table.
*
* RETURN CODE: 
*
* REVISIONS:	10/29/2013       Added AffinityCode.
1/13/2014 Added 
*/


ALTER PROCEDURE [dbo].[usp_ContractUpdate]
	@ContractID INT
   ,@Number VARCHAR(50)
   ,@ContractTypeID INT
   ,@ContractDealTypeID INT
   ,@ContractStatusID INT
   ,@ContractTemplateID INT
   ,@ReceiptDate DATETIME
   ,@StartDate DATETIME
   ,@EndDate DATETIME
   ,@SignedDate DATETIME
   ,@SubmitDate DATETIME
   ,@SalesChannelID INT = NULL
   ,@SalesRep VARCHAR(64)
   ,@SalesManagerID INT= NULL
   ,@PricingTypeID INT = NULL
   ,@ModifiedBy INT = NULL
   ,@IsSilent BIT = 0
   ,@MigrationComplete BIT = 0
   ,@EstimatedAnnualUsage int = NULL
   ,@DigitalSignature varchar(100) = null
   ,@AffinityCode varchar(50) = null
   ,@ClientSubmitApplicationKeyId int = NULL
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF
	
	-- DATA CLEANUP
	SET @SalesRep	= lp_account.dbo.ufn_strip_special_characters(@SalesRep);	

	UPDATE [LibertyPower].[dbo].[Contract]
	SET  [Number] = @Number
		,[ContractTypeID] = @ContractTypeID
		,[ContractDealTypeID] = @ContractDealTypeID
		,[ContractStatusID] = @ContractStatusID
		,[ContractTemplateID] = @ContractTemplateID
		,[ReceiptDate] = @ReceiptDate
		,[StartDate] = @StartDate
		,[EndDate] = @EndDate
		,[SignedDate] = @SignedDate
		,[SubmitDate] = @SubmitDate	
		,[SalesChannelID] = @SalesChannelID
		,[SalesRep] = @SalesRep
		,[SalesManagerID] = @SalesManagerID
		,[PricingTypeID] = @PricingTypeID
		,[DigitalSignature] = Isnull(@DigitalSignature, [DigitalSignature])
		,[ModifiedBy] = @ModifiedBy
		,[Modified] = GETDATE()
		,[MigrationComplete] = @MigrationComplete
		,[EstimatedAnnualUsage] = ISNULL(@EstimatedAnnualUsage, 0)
		,[AffinityCode] = @AffinityCode 
		,[ClientSubmitApplicationKeyId]=@ClientSubmitApplicationKeyId
	WHERE  ContractID = @ContractID
	;
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
	
	RETURN @ContractID;
	
END
GO

-------------------------------------------------------------------

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
USE LIBERTYPOWER
GO

IF not Exists (Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'zAuditContract' and COLUMN_NAME = 'ClientSubmitApplicationKeyId')
BEGIN

ALTER TABLE dbo.zAuditContract ADD
	ClientSubmitApplicationKeyId int NULL;
	
END
GO

ALTER TABLE dbo.zAuditContract SET (LOCK_ESCALATION = AUTO)
GO

----------------------------------------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditContractDelete]    Script Date: 10/30/2013 15:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
-- =============================================================
-- Modify		: Satchi Jena 
-- Create date	: 10/30/2013
-- Description	: Added logic for additional columns [EstimatedAnnualUsage] ,[ExternalNumber],[DigitalSignature],[AffinityCode]
-- =============================================================
-- Modify		: Sara lakshmanan 
-- Create date	: 1/31/2014
-- Description	: Added logic for additional columns ClientSubmitApplicationKeyId
-- =============================================================

ALTER TRIGGER [dbo].[zAuditContractDelete]
	ON  [dbo].[Contract]
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditContract] (
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
        ,[ClientSubmitApplicationKeyId]
		)
	SELECT 
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,'DEL'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
        ,[ClientSubmitApplicationKeyId]
	FROM deleted
	
	SET NOCOUNT OFF;
END
GO
-------------------------------------------------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditContractInsert]    Script Date: 10/30/2013 15:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
-- =============================================================
-- Modify		: Satchi Jena 
-- Create date	: 10/30/2013
-- Description	: Added logic for additional columns [EstimatedAnnualUsage] ,[ExternalNumber],[DigitalSignature],[AffinityCode]
-- =============================================================
-- =============================================================
-- Modify		: Sara Lakshmanan
-- Create date	: 1/31/2014
-- Description	: Added logic for additional columns [ClientSubmitApplicationKeyId]
-- =============================================================

ALTER TRIGGER [dbo].[zAuditContractInsert]
	ON  [dbo].[Contract]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[zAuditContract] (
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
        ,[ClientSubmitApplicationKeyId]
		)
	SELECT 
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,'INS'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,''							-- [ColumnsUpdated]
		,''							-- [ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
        ,[ClientSubmitApplicationKeyId]
	FROM inserted
	
	SET NOCOUNT OFF;
END
GO

-------------------------------------------------------------------------------------------

USE [LibertyPower]
GO
/****** Object:  Trigger [dbo].[zAuditContractUpdate]    Script Date: 10/30/2013 15:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 10/31/2011
-- Description	: Insert audit row into audit table zAuditContract
-- =============================================================
-- Modify		: Jose Munoz - SWCS
-- Create date	: 09/03/2013
-- Description	: RCR - 18097 (Contractstatusid = 2 not updating accountcontract status)
--                in contract table, whencontractstatusid is updated = 2, this means the contract was rejected. 
--				  The accountcontract status in the accountstatus table needs to be updated to reflect 999999-10
-- =============================================================
-- =============================================================
-- Modify		: Satchi Jena 
-- Create date	: 10/30/2013
-- Description	: Added logic for additional columns [EstimatedAnnualUsage] ,[ExternalNumber],[DigitalSignature],[AffinityCode]
-- =============================================================
-- =============================================================
-- Modify		: Sara lakshmanan
-- Create date	: 1/31/2014
-- Description	: Added logic for additional columns [ClientSubmitApplicationKeyId]
-- =============================================================


ALTER TRIGGER [dbo].[zAuditContractUpdate]
	ON  [dbo].[Contract]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ColumnID				INT
			,@Columns				NVARCHAR(max)
			,@ObjectID				INT
			,@ColumnName			NVARCHAR(max)
			,@LastColumnID			INT
			,@ColumnsUpdated		VARCHAR(max)
			,@strQuery				VARCHAR(max)
			
			
	SET @ObjectID					= (SELECT object_id FROM sys.objects with (nolock) WHERE name='Contract')
	SET @LastColumnID				= (SELECT MAX(column_id) FROM sys.columns with (nolock) WHERE object_id=@ObjectID)
	SET @ColumnID					= 1
	
	WHILE @ColumnID <= @LastColumnID 
	BEGIN
		
		IF (SUBSTRING(COLUMNS_UPDATED(),(@ColumnID - 1) / 8 + 1, 1)) &
		POWER(2, (@ColumnID - 1) % 8) = POWER(2, (@ColumnID - 1) % 8)
		begin
			SET @Columns = ISNULL(@Columns + ',', '') + COL_NAME(@ObjectID, @ColumnID)
		end
		set @ColumnID = @ColumnID + 1
	END
		
	SET @ColumnsUpdated = @Columns
	
	IF @ColumnsUpdated  IS NULL
		SET @ColumnsUpdated = ''

	INSERT INTO [dbo].[zAuditContract] (
		[ContractID] 
		,[Number] 
		,[ContractTypeID] 
		,[ContractDealTypeID] 
		,[ContractStatusID] 
		,[ContractTemplateID] 
		,[ReceiptDate] 
		,[StartDate] 
		,[EndDate] 
		,[SignedDate] 
		,[SubmitDate] 
		,[SalesChannelID] 
		,[SalesRep] 
		,[SalesManagerID] 
		,[PricingTypeID] 
		,[Modified] 
		,[ModifiedBy] 
		,[DateCreated] 
		,[CreatedBy] 
		,[IsFutureContract]
		,[MigrationComplete]
		,[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,[ColumnsUpdated]
		,[ColumnsChanged]
		,[EstimatedAnnualUsage]
        ,[ExternalNumber]
        ,[DigitalSignature]
        ,[AffinityCode]
        ,[ClientSubmitApplicationKeyId]
		)
	SELECT 
		a.[ContractID] 
		,a.[Number] 
		,a.[ContractTypeID] 
		,a.[ContractDealTypeID] 
		,a.[ContractStatusID] 
		,a.[ContractTemplateID] 
		,a.[ReceiptDate] 
		,a.[StartDate] 
		,a.[EndDate] 
		,a.[SignedDate] 
		,a.[SubmitDate] 
		,a.[SalesChannelID] 
		,a.[SalesRep] 
		,a.[SalesManagerID] 
		,a.[PricingTypeID] 
		,a.[Modified] 
		,a.[ModifiedBy] 
		,a.[DateCreated] 
		,a.[CreatedBy] 
		,a.[IsFutureContract]
		,a.[MigrationComplete]
		,'UPD'						--[AuditChangeType]
		--,[AuditChangeDate]		Default Value in SQLServer
		--,[AuditChangeBy]			Default Value in SQLServer
		--,[AuditChangeLocation]	Default Value in SQLServer
		,@ColumnsUpdated			-- [ColumnsUpdated]
		,CASE WHEN ISNULL(a.[ContractID],0) <> ISNULL(b.[ContractID],0) THEN 'ContractID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Number],'') <> ISNULL(b.[Number],'') THEN 'Number' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractTypeID],0) <> ISNULL(b.[ContractTypeID],0) THEN 'ContractTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractDealTypeID],0) <> ISNULL(b.[ContractDealTypeID],0) THEN 'ContractDealTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractStatusID],0) <> ISNULL(b.[ContractStatusID],0) THEN 'ContractStatusID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ContractTemplateID],0) <> ISNULL(b.[ContractTemplateID],0) THEN 'ContractTemplateID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ReceiptDate],'') <> ISNULL(b.[ReceiptDate],'') THEN 'ReceiptDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[StartDate],'') <> ISNULL(b.[StartDate],'') THEN 'StartDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EndDate],'') <> ISNULL(b.[EndDate],'') THEN 'EndDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SignedDate],'') <> ISNULL(b.[SignedDate],'') THEN 'SignedDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SubmitDate],'') <> ISNULL(b.[SubmitDate],'') THEN 'SubmitDate' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SalesChannelID],0) <> ISNULL(b.[SalesChannelID],0) THEN 'SalesChannelID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SalesRep],'') <> ISNULL(b.[SalesRep],'') THEN 'SalesRep' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[SalesManagerID],0) <> ISNULL(b.[SalesManagerID],0) THEN 'SalesManagerID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[PricingTypeID],0) <> ISNULL(b.[PricingTypeID],0) THEN 'PricingTypeID' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[Modified],'') <> ISNULL(b.[Modified],'') THEN 'Modified' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ModifiedBy],0) <> ISNULL(b.[ModifiedBy],0) THEN 'ModifiedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DateCreated],'') <> ISNULL(b.[DateCreated],'') THEN 'DateCreated' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[CreatedBy],0) <> ISNULL(b.[CreatedBy],0) THEN 'CreatedBy' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[IsFutureContract],0) <> ISNULL(b.[IsFutureContract],0) THEN 'IsFutureContract' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[MigrationComplete],0) <> ISNULL(b.[MigrationComplete],0) THEN 'MigrationComplete' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[EstimatedAnnualUsage],0) <> ISNULL(b.[EstimatedAnnualUsage],0) THEN 'EstimatedAnnualUsage' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[ExternalNumber],0) <> ISNULL(b.[ExternalNumber],0) THEN 'ExternalNumber' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[DigitalSignature],0) <> ISNULL(b.[DigitalSignature],0) THEN 'DigitalSignature' + ',' ELSE '' END
			+ CASE WHEN ISNULL(a.[AffinityCode],0) <> ISNULL(b.[AffinityCode],0) THEN 'AffinityCode' + ',' ELSE '' END     
			+ CASE WHEN ISNULL(a.[ClientSubmitApplicationKeyId],0) <> ISNULL(b.[ClientSubmitApplicationKeyId],0) THEN ' ClientSubmitApplicationKeyId ' + ',' ELSE '' END  
        ,a.[EstimatedAnnualUsage]
        ,a.[ExternalNumber]
        ,a.[DigitalSignature]
        ,a.[AffinityCode]
        ,a.[ClientSubmitApplicationKeyId]
	FROM inserted a
	INNER JOIN deleted b
	on b.[ContractID]		= a.[ContractID]
	
	/* RCR - 18097 001 Begin*/
	UPDATE Libertypower..AccountStatus
	SET [Status]			= '999999'
		,[SubStatus]		= '10'
	FROM Libertypower..AccountStatus ST WITH (NOLOCK)
	INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
	ON AC.AccountContractId		= ST.AccountContractID
	INNER JOIN INSERTED I
	ON I.ContractId				= AC.ContractID
	WHERE I.ContractStatusID	= 2 
	/* RCR - 18097 001 End*/
	
	
	SET NOCOUNT OFF;
END
GO

------------------------------------------------------------------------------------

