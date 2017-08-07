/*=============================================================
SCRIPT HEADER

VERSION:   1.01.0005
DATE:      08-22-2012 09:25:11
SERVER:    (local)

DATABASE:	LibertyPower
	Tables:
		AccountEventType, ContractEventType, CustomerEventType


=============================================================*/
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

USE [LibertyPower]
GO
-- BEGINNING TRANSACTION STRUCTURE
PRINT 'Beginning transaction STRUCTURE'
BEGIN TRANSACTION _STRUCTURE_
GO

-- DISABLE FKS FOR EVENTS --
PRINT 'Removing FKs for eventTypes'
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccountEvent_AccountEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccountEvent]'))
	ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_AccountEventType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractEvent_ContractEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractEvent]'))
	ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_ContractEventType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CustomerEvent_CustomerEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomerEvent]'))
	ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_CustomerEventType]
GO


-- Drop Table [dbo].[AccountEventType]
Print 'Drop Table [dbo].[AccountEventType]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[AccountEventType]') AND [type]='U'))
DROP TABLE [dbo].[AccountEventType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Drop Table [dbo].[ContractEventType]
Print 'Drop Table [dbo].[ContractEventType]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[ContractEventType]') AND [type]='U'))
DROP TABLE [dbo].[ContractEventType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Drop Table [dbo].[CustomerEventType]
Print 'Drop Table [dbo].[CustomerEventType]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[CustomerEventType]') AND [type]='U'))
DROP TABLE [dbo].[CustomerEventType]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Create Table [dbo].[CustomerEventType]
Print 'Create Table [dbo].[CustomerEventType]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
CREATE TABLE [dbo].[CustomerEventType] (
		[CustomerEventTypeId]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]                    [varchar](50) NOT NULL,
		[Description]             [varchar](250) NULL,
		[IsActive]                [bit] NOT NULL,
		[DateCreated]             [datetime] NOT NULL
) ON [PRIMARY]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'Events', 'SCHEMA', N'dbo', 'TABLE', N'CustomerEventType', NULL, NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[CustomerEventType]
	ADD
	CONSTRAINT [PK_CustomerEventType]
	PRIMARY KEY
	CLUSTERED
	([CustomerEventTypeId])
	ON [PRIMARY]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[CustomerEventType]
	ADD
	CONSTRAINT [DF_CustomerEventType_DateCreated]
	DEFAULT (getdate()) FOR [DateCreated]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[CustomerEventType]
	ADD
	CONSTRAINT [DF_CustomerEventTypes_IsActive]
	DEFAULT ((1)) FOR [IsActive]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[CustomerEventType] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Create Table [dbo].[ContractEventType]
Print 'Create Table [dbo].[ContractEventType]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
CREATE TABLE [dbo].[ContractEventType] (
		[ContractEventTypeId]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]                    [varchar](50) NOT NULL,
		[Description]             [varchar](250) NULL,
		[IsActive]                [bit] NOT NULL,
		[DateCreated]             [datetime] NOT NULL
) ON [PRIMARY]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'Events', 'SCHEMA', N'dbo', 'TABLE', N'ContractEventType', NULL, NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[ContractEventType]
	ADD
	CONSTRAINT [PK_ContractEventType]
	PRIMARY KEY
	CLUSTERED
	([ContractEventTypeId])
	ON [PRIMARY]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[ContractEventType]
	ADD
	CONSTRAINT [DF_ContractEventType_DateCreated]
	DEFAULT (getdate()) FOR [DateCreated]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[ContractEventType]
	ADD
	CONSTRAINT [DF_ContractEventTypes_IsActive]
	DEFAULT ((1)) FOR [IsActive]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[ContractEventType] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- Create Table [dbo].[AccountEventType]
Print 'Create Table [dbo].[AccountEventType]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
CREATE TABLE [dbo].[AccountEventType] (
		[AccountEventTypeId]      [int] IDENTITY(1, 1) NOT NULL,
		[Name]                    [varchar](50) NOT NULL,
		[Description]             [varchar](250) NULL,
		[IsUsedForFinancials]     [bit] NOT NULL,
		[IsActive]                [bit] NOT NULL,
		[DateCreated]             [datetime] NOT NULL
) ON [PRIMARY]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'Events', 'SCHEMA', N'dbo', 'TABLE', N'AccountEventType', NULL, NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[AccountEventType]
	ADD
	CONSTRAINT [PK_AccountEventType]
	PRIMARY KEY
	CLUSTERED
	([AccountEventTypeId])
	ON [PRIMARY]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[AccountEventType]
	ADD
	CONSTRAINT [DF_AccountEventType_DateCreated]
	DEFAULT (getdate()) FOR [DateCreated]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[AccountEventType]
	ADD
	CONSTRAINT [DF_AccountEventType_IsUsedForFinancials]
	DEFAULT ((0)) FOR [IsUsedForFinancials]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[AccountEventType]
	ADD
	CONSTRAINT [DF_AccountEventTypes_IsActive]
	DEFAULT ((1)) FOR [IsActive]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
ALTER TABLE [dbo].[AccountEventType] SET (LOCK_ESCALATION = TABLE)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

-- COMMITTING TRANSACTION STRUCTURE
PRINT 'Committing transaction STRUCTURE'
IF @@TRANCOUNT>0
	COMMIT TRANSACTION _STRUCTURE_
GO

SET NOEXEC OFF
GO
-- BEGINNING TRANSACTION DATA
PRINT 'Beginning transaction DATA'
BEGIN TRANSACTION _DATA_
GO
SET NOCOUNT ON
SET ANSI_PADDING ON
GO

-- Deleting from table: AccountEventType
PRINT 'Deleting from table: AccountEventType'
DELETE FROM [dbo].[AccountEventType]
-- Deleting from table: ContractEventType
PRINT 'Deleting from table: ContractEventType'
DELETE FROM [dbo].[ContractEventType]
-- Deleting from table: CustomerEventType
PRINT 'Deleting from table: CustomerEventType'
DELETE FROM [dbo].[CustomerEventType]

-- Insert scripts for table: CustomerEventType
PRINT 'Inserting rows into table: CustomerEventType'
SET IDENTITY_INSERT [dbo].[CustomerEventType] ON

INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (1, 'BadLead', 'Customer Bad Lead', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (2, 'ContactInbound', 'Customer Contact Inbound', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (3, 'ContactOutbound', 'Customer Contact Outbound', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (4, 'Created', 'Customer Created', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (5, 'Emailed', 'Customer Emailed', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (6, 'InformationUpdate', 'Customer Information Update', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (7, 'Lead', 'Customer Lead', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (8, 'LegalConcern', 'Customer Legal Concern', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (9, 'LetterSent', 'Customer Letter Sent', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (10, 'Merge', 'Merge Customer Records', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (11, 'Question', 'Customer Question', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (12, 'Reviewed', 'Customer Reviewed', 1, '20120206 15:57:02')
INSERT INTO [dbo].[CustomerEventType] ([CustomerEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (13, 'StatusChange', 'Customer Status Change', 1, '20120206 15:57:02')

SET IDENTITY_INSERT [dbo].[CustomerEventType] OFF

-- Insert scripts for table: ContractEventType
PRINT 'Inserting rows into table: ContractEventType'
SET IDENTITY_INSERT [dbo].[ContractEventType] ON

INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (1, 'Created', 'New contract was created', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (2, 'UsageAcquired', 'Usage numbers obtained for contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (3, 'CreditCheck', 'Credit worthiness was checked for the entity on the contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (4, 'DocumentsVerified', 'Signed contract reviewed for completeness and accuracy', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (5, 'EnrollmentCancelled', 'Enrollment was cancelled', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (6, 'PostUsageCheckCredit', 'Post-usage credit check was run', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (7, 'ThirdPartyVerification', 'Third-Party Verified a voice contract (a.k.a. TPV)', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (8, 'WelcomeLetterPrinted', 'A welcome letter was printed and sent for the contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (9, 'CheckAccountRun', 'Reviewed contract for previous customer relationship', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (10, 'CustomerAssigned', 'Merged incoming contract with any customer record we already had on file', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (11, 'FinanceReview', 'Finance department reviewed contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (12, 'RateCodeApproved', 'Rate code approved for the contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (13, 'PostUsageMinUsageCheck', 'Contract checked for min usage (post-usage)', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (14, 'PostUsageMaxUsageCheck', 'Contract checked for max usage (post-usage)', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (15, 'PriceValidated', 'Price per KWh for contract was validated', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (16, 'ServiceClassAcquired', 'Service class for contract was acquired', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (17, 'BillingTaxExemption', 'Tax exemption was recorded by Billing department', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (18, 'CustomerCareTaxExemption', 'Tax Exemption was recorded by Customer Care department', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (19, 'DealScreeningComplete', 'Deal screening has been completed', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (20, 'EnrollmentSatisfied', 'All steps in the enrollment process have been completed', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (21, 'CommissionRequirementsSatisfied', 'All requirements needed to pay commissions have been satisfied', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (22, 'SalesChannelChanged', 'Sales channel for the contract was changed', 1, '20120613 13:37:28')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (23, 'SalesRepChanged', 'Sales representative for the contract was changed', 1, '20120613 13:37:56')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (24, 'ContractMerged', 'Contract was merged', 1, '20120821 15:56:04')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (25, 'DealDateChangedManual', 'Deal date was manual changed', 1, '20120821 15:56:33')

SET IDENTITY_INSERT [dbo].[ContractEventType] OFF

-- Insert scripts for table: AccountEventType
PRINT 'Inserting rows into table: AccountEventType'
SET IDENTITY_INSERT [dbo].[AccountEventType] ON

INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (1, 'AccountVerified', 'Account Information Verified (aka CheckAccount)', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (2, 'CommissionCalculated', 'Account Commission Calculated', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (3, 'DeEnrolled', 'Account De-enrolled', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (4, 'DropAcceptanceReceived', 'Account Drop Acceptance Received', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (5, 'Dropped', 'Account Dropped', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (6, 'DropRequestReceived', 'Account Drop Acceptance Received', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (7, 'DropRequestSent', 'Account Drop Request Sent', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (8, 'Enrolled', 'Account Enrolled/Created', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (9, 'RateChangedAutomatic', 'Account Rate Changed Automatically', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (10, 'RateChangedManual', 'Account Rate Changed Manually', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (11, 'RenewalNoticeSent', 'Account Renewal Notice Sent', 0, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (12, 'Renewed', 'Existing Account Renewed', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (13, 'Rollover', 'Account Rollover Occured', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (14, 'UsageUpdatedAutomatic', 'Account Usage Updated Automatically', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (15, 'UsageUpdatedManual', 'Account Usage Updated Manually', 1, 1, '20120206 15:57:02')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (16, 'ProductChangedManual', 'Product was manual changed', 1, 1, '20120821 18:14:41')
INSERT INTO [dbo].[AccountEventType] ([AccountEventTypeId], [Name], [Description], [IsUsedForFinancials], [IsActive], [DateCreated]) VALUES (17, 'RateStartChangedManual', 'Rate Start was manual changed', 1, 1, '20120821 18:15:00')

SET IDENTITY_INSERT [dbo].[AccountEventType] OFF


-- RECREATE FKS FOR EVENTS --
PRINT 'Recreating FKs for eventTypes'
ALTER TABLE [dbo].[AccountEvent]  WITH CHECK ADD  CONSTRAINT [FK_AccountEvent_AccountEventType] FOREIGN KEY([AccountEventTypeId])
REFERENCES [dbo].[AccountEventType] ([AccountEventTypeId])
GO
ALTER TABLE [dbo].[ContractEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContractEvent_ContractEventType] FOREIGN KEY([ContractEventTypeId])
REFERENCES [dbo].[ContractEventType] ([ContractEventTypeId])
GO
ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD  CONSTRAINT [FK_CustomerEvent_CustomerEventType] FOREIGN KEY([CustomerEventTypeId])
REFERENCES [dbo].[CustomerEventType] ([CustomerEventTypeId])
GO


-- COMMITTING TRANSACTION DATA
PRINT 'Committing transaction DATA'
IF @@TRANCOUNT>0
	COMMIT TRANSACTION _DATA_
GO

SET NOEXEC OFF
GO

