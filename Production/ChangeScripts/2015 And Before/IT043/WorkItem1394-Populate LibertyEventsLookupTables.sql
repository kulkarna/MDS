/*=============================================================
SCRIPT HEADER

VERSION:   1.01.0001
DATE:      06-07-2012 15:39:36
SERVER:    (local) rrusson

DATABASE:	LibertyPower
	Tables: AccountEventType, ContractEventType, CustomerEventType, EventDomain, EventStatus


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
-- BEGINNING TRANSACTION DATA
PRINT 'Beginning transaction DATA'
BEGIN TRANSACTION _DATA_
GO
SET NOCOUNT ON
SET ANSI_PADDING ON
GO

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

-- Insert scripts for table: EventDomain
PRINT 'Inserting rows into table: EventDomain'
SET IDENTITY_INSERT [dbo].[EventDomain] ON

INSERT INTO [dbo].[EventDomain] ([EventDomainId], [Name], [Description], [IsActive], [DateCreated]) VALUES (1, 'AccountEvent', 'Events affecting Accounts', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventDomain] ([EventDomainId], [Name], [Description], [IsActive], [DateCreated]) VALUES (2, 'ContractEvent', 'Events affecting Contracts', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventDomain] ([EventDomainId], [Name], [Description], [IsActive], [DateCreated]) VALUES (3, 'CustomerEvent', 'Events affecting Customers', 1, '20120206 15:57:02')

SET IDENTITY_INSERT [dbo].[EventDomain] OFF

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

SET IDENTITY_INSERT [dbo].[AccountEventType] OFF

-- Insert scripts for table: ContractEventType
PRINT 'Inserting rows into table: ContractEventType'
SET IDENTITY_INSERT [dbo].[ContractEventType] ON

INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (1, 'Created', 'New Contract was created', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (2, 'UsageAcquired', 'Usage numbers obtained for contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (3, 'CreditCheck', 'Check the Credit for entity on the Contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (4, 'DocumentsVerified', 'Signed contract reviewed for completeness and accuracy', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (5, 'EnrollmentCancelled', 'Enrollment Cancelation', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (6, 'PostUsageCheckCredit', 'Post-Usage Credit Check run', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (7, 'ThirdPartyVerification', 'Third-Party Verified a voice contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (8, 'WelcomeLetterPrinted', 'Print a Welcome Letter', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (9, 'CheckAccountRun', 'Reviewed customer for previous relationship', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (10, 'CustomerAssigned', 'Merged incoming contract with any Customer record we already had on file', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (11, 'FinanceReview', 'Finance department reviewed contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (12, 'RateCodeApproved', 'Rate Code Approved for the contract', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (13, 'PostUsageMinUsageCheck', 'Contract checked for Min Usage (Post-Usage)', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (14, 'PostUsageMaxUsageCheck', 'Contract checked for Max Usage (Post-Usage)', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (15, 'PriceValidated', 'Price per KwH for contract was Validated', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (16, 'ServiceClassAcquired', 'Service Class for contract was Acquired', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (17, 'BillingTaxExemption', 'Tax Exemption was recorded by Billing department', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (18, 'CustomerCareTaxExemption', 'Tax Exemption was recorded by Customer Care department', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (19, 'DealScreeningComplete', 'Deal Screening has been completed', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (20, 'EnrollmentSatisfied', 'All steps in the Enrollment process have been completed', 1, '20120607 15:10:14')
INSERT INTO [dbo].[ContractEventType] ([ContractEventTypeId], [Name], [Description], [IsActive], [DateCreated]) VALUES (21, 'CommissionRequirementsSatisfied', 'All Requirements needed to pay Commissions have been satisfied', 1, '20120607 15:10:14')

SET IDENTITY_INSERT [dbo].[ContractEventType] OFF

PRINT 'Inserting rows into table: EventStatus'
SET IDENTITY_INSERT [dbo].[EventStatus] ON

INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (1, 'Active', 'Event is active for processing, but not in progress', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (2, 'Cancelled', 'Event was cancelled', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (3, 'Closed', 'Event is closed', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (4, 'Complete', 'Event is complete', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (5, 'Created', 'Initial creation status', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (6, 'ErrorOccurred', 'An Error occurred during event execution', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (7, 'InProgress', 'Event is in progress, but not complete', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (8, 'Pending', 'Event is pending another event or process', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (9, 'Reactivated', 'Event was suspended, but has been resumed', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (10, 'Rescheduled', 'Event was rescheduled to a later execution time', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (11, 'Suspended', 'Event has been suspended, must be reactivated to continue', 1, '20120206 15:57:02')
INSERT INTO [dbo].[EventStatus] ([EventStatusId], [Name], [Description], [IsActive], [DateCreated]) VALUES (12, 'Voided', 'Event was accidentally created and is void', 1, '20120206 15:57:02')

SET IDENTITY_INSERT [dbo].[EventStatus] OFF

-- COMMITTING TRANSACTION DATA
PRINT 'Committing transaction DATA'
IF @@TRANCOUNT>0
	COMMIT TRANSACTION _DATA_
GO

SET NOEXEC OFF
GO

