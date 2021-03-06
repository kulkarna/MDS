use [LibertyPower]

delete [dbo].[ComplaintDocument]
delete [dbo].[ComplaintAccount]
delete [dbo].[Complaint]
delete [dbo].[ComplaintDataMigrationErrorLog]

DELETE [dbo].[ComplaintRegulatoryAuthority]
DELETE [dbo].[ComplaintIssueType]
DELETE [dbo].[ComplaintType]
DELETE [dbo].[ComplaintCategory]
DELETE [dbo].[ComplaintStatus]
DELETE [dbo].[ComplaintDisputeOutcome]
DELETE [dbo].[ComplaintDocumentTypeMapping]



--************************************************************************
-- COMPLAINT STATUS
INSERT INTO [dbo].[ComplaintStatus](ComplaintStatusID, Name) VALUES(0, 'OPEN')
INSERT INTO [dbo].[ComplaintStatus](ComplaintStatusID, Name) VALUES(1, 'CLOSED')
--************************************************************************


--************************************************************************
-- COMPLAINT DISPUTE OUTCOME
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (0, N'')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (1, N'Account Service Issue')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (2, N'Confirmed')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (3, N'Disputed')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (4, N'Pending')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (5, N'Resolved')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (6, N'Undetermined')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (7, N'Violation')
INSERT [dbo].[ComplaintDisputeOutcome] ([ComplaintDisputeOutcomeID], [Name]) VALUES (8, N'Pending Materials from SCM')
--************************************************************************


--************************************************************************
-- COMPLAINT CONTACTED TEAM
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (0, N'')
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (1, N'Collections')
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (2, N'Customer Care')
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (3, N'Inside Sales')
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (4, N'N/A')
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (5, N'T2R')
INSERT [dbo].[ComplaintContactedTeam] ([ComplaintContactedTeamID], [Name]) VALUES (6, N'Talk2Rep')
--************************************************************************


--************************************************************************
-- ISSUE TYPES
INSERT [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID], [Name]) VALUES (0, N'')
INSERT [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID], [Name]) VALUES (1, N'Attorney Letter')
INSERT [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID], [Name]) VALUES (2, N'Legal')
INSERT [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID], [Name]) VALUES (3, N'Other')
INSERT [dbo].[ComplaintIssueType] ([ComplaintIssueTypeID], [Name]) VALUES (4, N'Regulatory')
--************************************************************************


--************************************************************************
-- REGULATORY AUTHORITIES
--DELETE [dbo].[ComplaintRegulatoryAuthorityLegacyMap]
SET IDENTITY_INSERT [dbo].[ComplaintRegulatoryAuthority] ON
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (694, N'Commerce Commission', 14, N'IL', 1, N'Calendar', 225)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (695, N'Public Service Commission', 14, N'NY', 1, N'Calendar', 227)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (696, N'Public Utility Commission', 21, N'TX', 1, N'Calendar', 228)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (697, N'Board of Public Utilities', 5, N'NJ', 1, N'Business', 229)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (698, N'Department of Public Utilities', 14, N'MA', 1, N'Calendar', 250)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (699, N'Public Utility Commission', 10, N'CT', 1, N'Calendar', 326)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (700, N'Better Business Bureau', 14, N'IL', 1, N'Calendar', 328)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (701, N'Office of Attorney General', 21, N'IL', 1, N'Calendar', 331)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (702, N'Office of Consumer Advocate', 10, N'PA', 1, N'Calendar', 343)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (703, N'Better Business Bureau', 14, N'NY', 1, N'Calendar', 344)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (704, N'Public Service Commission', 7, N'MD', 1, N'Business', 346)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (705, N'Better Business Bureau', 14, N'MD', 1, N'Calendar', 347)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (706, N'Better Business Bureau', 14, N'NJ', 1, N'Calendar', 348)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (707, N'Public Service Commission', 14, N'DC', 1, N'Calendar', 349)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (708, N'Public Utility Commission', 14, N'PA', 1, N'Calendar', 350)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (709, N'Office of Attorney General', 21, N'PA', 1, N'Calendar', 351)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (710, N'Public Service Commission', 14, N'DE', 1, N'Calendar', 352)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (711, N'Better Business Bureau', 14, N'DC', 1, N'Business', 353)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (713, N'Better Business Bureau', 14, N'TX', 1, N'Calendar', 356)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (714, N'Better Business Bureau', 14, N'PA', 1, N'Calendar', 357)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (715, N'Public Utility Commission', 14, N'ME', 1, N'Calendar', 358)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (716, N'Division of Public Utilities', 10, N'RI', 1, N'Calendar', 359)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (717, N'Office of Attorney General', 10, N'RI', 1, N'Calendar', 360)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (718, N'Florida Department of Agriculture and Consumer Services', 30, N'FL', 1, N'Calendar', 361)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (719, N'Better Business Bureau', 14, N'CT', 1, N'Calendar', 362)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (720, N'PeopleClaim.com', 10, N'DC', 1, N'Calendar', 363)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (721, N'Better Business Bureau', 14, N'RI', 1, N'Calendar', 364)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (722, N'ComEd', 0, N'IL', 1, NULL, 365)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (724, N'Public Utility Commission', 0, N'CA', 1, NULL, 368)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (725, N'Office of Attorney General', 7, N'NY', 1, N'Business', 369)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (726, N'Office of Attorney General', 10, N'CT', 1, N'Business', 370)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (729, N'Website', 14, N'NY', 1, N'Calendar', 373)
INSERT [dbo].[ComplaintRegulatoryAuthority] ([ComplaintRegulatoryAuthorityID], [Name], [RequiredDaysForResolution], [MarketCode], [IsActive], [CalendarType], [LegacyID]) VALUES (730, N'Department of State', 14, N'NY', 1, N'Calendar', 374)
SET IDENTITY_INSERT [dbo].[ComplaintRegulatoryAuthority] OFF

INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (694, 225)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (695, 227)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (696, 228)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (697, 229)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (698, 250)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (699, 326)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (700, 328)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (701, 331)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (702, 343)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (703, 344)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (704, 346)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (705, 347)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (706, 348)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (707, 349)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (708, 350)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (709, 351)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (710, 352)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (711, 353)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (708, 354)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (713, 356)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (714, 357)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (715, 358)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (716, 359)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (717, 360)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (718, 361)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (719, 362)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (720, 363)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (721, 364)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (722, 365)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (694, 367)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (724, 368)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (725, 369)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (726, 370)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (696, 371)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (704, 372)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (729, 373)
INSERT [dbo].[ComplaintRegulatoryAuthorityLegacyMap] ([ComplaintRegulatoryAuthorityID], [LegacyID]) VALUES (730, 374)
--************************************************************************



--************************************************************************
-- COMPLAINT TYPES
INSERT [dbo].[ComplaintCategory] ([ComplaintCategoryID], [Name]) VALUES (0, N'')
INSERT [dbo].[ComplaintCategory] ([ComplaintCategoryID], [Name]) VALUES (1, N'Service Practice')
INSERT [dbo].[ComplaintCategory] ([ComplaintCategoryID], [Name]) VALUES (2, N'Sales Practice')

INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (0, N'', 0)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (1, N'Aggressive Sales Tacticts', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (2, N'Alleged Slamming', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (3, N'Billing Issues', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (4, N'Customer Service', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (5, N'Difficulty Cancelling', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (6, N'Disconnection of Service', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (7, N'Disputing Delivery Charges', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (8, N'Do Not Call', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (9, N'Early Termination Fee', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (10, N'Enrollment Issues', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (11, N'Flow Start Date', 1)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (12, N'Fraudulent Acquisition', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (13, N'Marketing Practices', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (14, N'Misrepresentation', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (15, N'Misrepresentation of Savings', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (16, N'Misrepresentation of Seller', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (17, N'Questionable Marketing Practices', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (18, N'Sales Practices', 2)
INSERT [dbo].[ComplaintType] ([ComplaintTypeID], [Name], [ComplaintCategoryID]) VALUES (19, N'TDSP Charges', 1)
--************************************************************************




--************************************************************************
-- COMPLAINT-SPECIFIC DOC TYPES
DECLARE @docType int


SET @docType = (SELECT TOP 1 [document_type_id] FROM [Lp_documents].[dbo].[document_type] WHERE [document_type_name] = 'Billing Letters')
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Bill', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Closing Letter', N'Closing Letter')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Closing Letter', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Communication Log', N'Communication Log')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Communication Log', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Complaint', N'Complaint')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Complaint', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Call', N'Call')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Customer Care Call', @docType)
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Sales Call', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Other', N'Other')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Other', @docType)
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Email', @docType)
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Final Packet', @docType)
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Packet', @docType)
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Rebuttal', @docType)


SET @docType = (SELECT TOP 1 [document_type_id] FROM [Lp_documents].[dbo].[document_type] WHERE [document_type_name] = 'ETF Notification')
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'ETF', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Formal Complaint', N'Formal Complaint')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Formal', @docType)


SET @docType = (SELECT TOP 1 [document_type_id] FROM [Lp_documents].[dbo].[document_type] WHERE [document_type_name] = 'Legal Disclosure')
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Legal Letter', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'AR History', N'AR History')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'payment history', @docType)


SET @docType = (SELECT TOP 1 [document_type_id] FROM [Lp_documents].[dbo].[document_type] WHERE [document_type_name] = 'Renewal Letter')
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Renewal Request', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'LP Response', N'LP Response')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Response', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Settlement', N'Settlement')
SET @docType = @@IDENTITY
INSERT [dbo].[ComplaintDocumentTypeMapping] ([LegacyDocTypeName], [DocumentTypeID]) VALUES (N'Settlement', @docType)


INSERT INTO [Lp_documents].[dbo].[document_type]([document_type_name], [repository_folder]) VALUES(N'Formal Answer', N'Formal Answer')
--************************************************************************
