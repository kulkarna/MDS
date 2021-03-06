USE [LibertyPower]
GO

/****** Object:  Table [dbo].[EventStatus]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventStatus](
	[Id] [int] IDENTITY(0,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
 CONSTRAINT [PK_EventStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'Events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventStatus'
GO
SET IDENTITY_INSERT [dbo].[EventStatus] ON
INSERT [dbo].[EventStatus] ([Id], [Name], [Description]) VALUES (0, N'ValueNotSet', N'')
INSERT [dbo].[EventStatus] ([Id], [Name], [Description]) VALUES (1, N'Pending', N'Event is pending processing')
INSERT [dbo].[EventStatus] ([Id], [Name], [Description]) VALUES (2, N'Complete', N'Event has completed processing')
INSERT [dbo].[EventStatus] ([Id], [Name], [Description]) VALUES (3, N'Error', N'An Error occurred that prevented the event from being processed')
SET IDENTITY_INSERT [dbo].[EventStatus] OFF
/****** Object:  Table [dbo].[EventType]    Script Date: 09/09/2013 14:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DomainId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NOT NULL,
	[LpTransactionId] [int] NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[EventType] ON
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (1, 1, N'InboundEnrollmentRequested', N'Account Enrollment Requested', 2)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (2, 1, N'EnrollmentRejected', N'Enrollment for the Account was Rejected', 3)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (3, 1, N'EnrollmentAccepted', N'Account Enrolled', 4)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (4, 1, N'InboundDropRequested ', N'Account Drop was requested', 6)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (5, 1, N'DropRejected', N'Account Drop Rejected', 7)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (6, 1, N'DropAccepted', N'Account Dropped', 8)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (7, 1, N'FlowStartDateChanged', N'Flow Start Date changed', 9)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (8, 1, N'FlowEndDateChanged', N'Flow End Date Changed', 10)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (9, 1, N'InboundReinstatementRequested', N'Account Reinstatement was Requested', 12)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (10, 1, N'HistoricalUsageAcceped', N'Historical Usage was Accepted', 13)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (11, 1, N'HistoricalUsageRejected', N'Historical Usage was Rejected', 14)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (12, 1, N'BillTypeChanged', N'The Bill Type for the Account was Changed', 15)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (13, 1, N'HistoricalUsageNoUsage', N'There is not Historical Usage for the Account', 16)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (14, 1, N'AccountVerified', N'Account Information Verified (aka CheckAccount)', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (15, 1, N'CommissionCalculated', N'Account Commission Calculated', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (16, 1, N'DeEnrolled', N'Account De-enrolled', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (17, 1, N'DropRequestReceived', N'Account Drop Acceptance Received', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (18, 1, N'RateChangedAutomatic', N'Account Rate Changed Automatically', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (19, 1, N'RateChangedManual', N'Account Rate Changed Manually', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (20, 1, N'RenewalNoticeSent', N'Account Renewal Notice Sent', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (21, 1, N'Renewed', N'Existing Account Renewed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (22, 1, N'Rollover', N'Account Rollover Occured', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (23, 1, N'UsageUpdatedAutomatic', N'Account Usage Updated Automatically', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (24, 1, N'UsageUpdatedManual', N'Account Usage Updated Manually', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (25, 1, N'AccountCommissionRequirementsSatisfied', N'Account Commissions requirements have been satisfied for a workflow', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (26, 2, N'ContractCreated', N'New contract was created', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (27, 2, N'UsageAcquired', N'Usage numbers obtained for contract', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (28, 2, N'CreditCheck', N'Credit worthiness was checked for the entity on the contract', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (29, 2, N'DocumentsVerified', N'Signed contract reviewed for completeness and accuracy', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (30, 2, N'EnrollmentCancelled', N'Enrollment was cancelled', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (31, 2, N'PostUsageCheckCredit', N'Post-usage credit check was run', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (32, 2, N'ThirdPartyVerification', N'Third-Party Verified a voice contract (a.k.a. TPV)', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (33, 2, N'WelcomeLetterPrinted', N'A welcome letter was printed and sent for the contract', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (34, 2, N'CheckAccountRun', N'Reviewed contract for previous customer relationship', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (35, 2, N'CustomerAssigned', N'Merged incoming contract with any customer record we already had on file', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (36, 2, N'FinanceReview', N'Finance department reviewed contract', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (37, 2, N'RateCodeApproved', N'Rate code approved for the contract', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (38, 2, N'PostUsageMinUsageCheck', N'Contract checked for min usage (post-usage)', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (39, 2, N'PostUsageMaxUsageCheck', N'Contract checked for max usage (post-usage)', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (40, 2, N'PriceValidated', N'Price per KWh for contract was validated', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (41, 2, N'ServiceClassAcquired', N'Service class for contract was acquired', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (42, 2, N'BillingTaxExemption', N'Tax exemption was recorded by Billing department', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (43, 2, N'CustomerCareTaxExemption', N'Tax Exemption was recorded by Customer Care department', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (44, 2, N'DealScreeningComplete', N'Deal screening has been completed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (45, 2, N'EnrollmentSatisfied', N'All steps in the enrollment process have been completed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (46, 2, N'ContractCommissionRequirementsSatisfied', N'All requirements needed to pay commissions have been satisfied', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (47, 2, N'SalesChannelChanged', N'Sales channel for the contract was changed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (48, 2, N'SalesRepChanged', N'Sales representative for the contract was changed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (49, 3, N'BadLead', N'Customer Bad Lead', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (50, 3, N'ContactInbound', N'Customer Contact Inbound', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (51, 3, N'ContactOutbound', N'Customer Contact Outbound', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (52, 3, N'CustomerCreated', N'Customer Created', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (53, 3, N'Emailed', N'Customer Emailed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (54, 3, N'InformationUpdate', N'Customer Information Update', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (55, 3, N'Lead', N'Customer Lead', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (56, 3, N'LegalConcern', N'Customer Legal Concern', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (57, 3, N'LetterSent', N'Customer Letter Sent', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (58, 3, N'Merge', N'Merge Customer Records', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (59, 3, N'Question', N'Customer Question', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (60, 3, N'Reviewed', N'Customer Reviewed', NULL)
INSERT [dbo].[EventType] ([Id], [DomainId], [Name], [Description], [LpTransactionId]) VALUES (61, 3, N'StatusChange', N'Customer Status Change', NULL)
SET IDENTITY_INSERT [dbo].[EventType] OFF
/****** Object:  Table [dbo].[EventInstance]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventInstance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[ErrorId] [int] NULL,
	[EventDate] [datetime] NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_EventInstance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventParameter]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventParameter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventInstanceId] [int] NOT NULL,
	[ParameterName] [varchar](50) NOT NULL,
	[ParameterValue] [varchar](250) NOT NULL,
 CONSTRAINT [PK_EventParameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventError]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorMessage] [varchar](250) NULL,
	[ErrorDate] [datetime] NULL,
	[EventInstanceId] [int] NULL,
 CONSTRAINT [PK_EventError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountEvent]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccountEvent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventInstanceId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
 CONSTRAINT [PK_AccountEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerEvent]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerEvent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventInstanceId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_CustomerEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventParameterName]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventParameterName](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](150) NULL,
 CONSTRAINT [PK_EventParameterName] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[EventParameterName] ON
INSERT [dbo].[EventParameterName] ([Id], [Name], [Description]) VALUES (1, N'ReasonCode', NULL)
INSERT [dbo].[EventParameterName] ([Id], [Name], [Description]) VALUES (2, N'EffectiveDate', NULL)
INSERT [dbo].[EventParameterName] ([Id], [Name], [Description]) VALUES (3, N'NewBillType', NULL)
SET IDENTITY_INSERT [dbo].[EventParameterName] OFF
/****** Object:  Table [dbo].[ContractEvent]    Script Date: 09/09/2013 14:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContractEvent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventInstanceId] [int] NOT NULL,
	[ContractId] [int] NOT NULL,
 CONSTRAINT [PK_ContractEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK_AccountEvent_Account]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[AccountEvent]  WITH CHECK ADD  CONSTRAINT [FK_AccountEvent_Account] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountID])
GO
ALTER TABLE [dbo].[AccountEvent] CHECK CONSTRAINT [FK_AccountEvent_Account]
GO
/****** Object:  ForeignKey [FK_AccountEvent_EventInstance]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[AccountEvent]  WITH CHECK ADD  CONSTRAINT [FK_AccountEvent_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([Id])
GO
ALTER TABLE [dbo].[AccountEvent] CHECK CONSTRAINT [FK_AccountEvent_EventInstance]
GO
/****** Object:  ForeignKey [FK_ContractEvent_Contract]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[ContractEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContractEvent_Contract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[Contract] ([ContractID])
GO
ALTER TABLE [dbo].[ContractEvent] CHECK CONSTRAINT [FK_ContractEvent_Contract]
GO
/****** Object:  ForeignKey [FK_ContractEvent_EventInstance]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[ContractEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContractEvent_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([Id])
GO
ALTER TABLE [dbo].[ContractEvent] CHECK CONSTRAINT [FK_ContractEvent_EventInstance]
GO
/****** Object:  ForeignKey [FK_CustomerEvent_Customer]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD  CONSTRAINT [FK_CustomerEvent_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[CustomerEvent] CHECK CONSTRAINT [FK_CustomerEvent_Customer]
GO
/****** Object:  ForeignKey [FK_CustomerEvent_EventInstance]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[CustomerEvent]  WITH CHECK ADD  CONSTRAINT [FK_CustomerEvent_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([Id])
GO
ALTER TABLE [dbo].[CustomerEvent] CHECK CONSTRAINT [FK_CustomerEvent_EventInstance]
GO
/****** Object:  ForeignKey [FK_EventError_EventInstance]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[EventError]  WITH CHECK ADD  CONSTRAINT [FK_EventError_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([Id])
GO
ALTER TABLE [dbo].[EventError] CHECK CONSTRAINT [FK_EventError_EventInstance]
GO
/****** Object:  ForeignKey [FK_EventInstance_EventError]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[EventInstance]  WITH CHECK ADD  CONSTRAINT [FK_EventInstance_EventError] FOREIGN KEY([ErrorId])
REFERENCES [dbo].[EventError] ([Id])
GO
ALTER TABLE [dbo].[EventInstance] CHECK CONSTRAINT [FK_EventInstance_EventError]
GO
/****** Object:  ForeignKey [FK_EventInstance_EventStatus]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[EventInstance]  WITH CHECK ADD  CONSTRAINT [FK_EventInstance_EventStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[EventStatus] ([Id])
GO
ALTER TABLE [dbo].[EventInstance] CHECK CONSTRAINT [FK_EventInstance_EventStatus]
GO
/****** Object:  ForeignKey [FK_EventInstance_EventType]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[EventInstance]  WITH CHECK ADD  CONSTRAINT [FK_EventInstance_EventType] FOREIGN KEY([TypeId])
REFERENCES [dbo].[EventType] ([Id])
GO
ALTER TABLE [dbo].[EventInstance] CHECK CONSTRAINT [FK_EventInstance_EventType]
GO
/****** Object:  ForeignKey [FK_EventParameter_EventInstance]    Script Date: 09/09/2013 14:33:19 ******/
ALTER TABLE [dbo].[EventParameter]  WITH CHECK ADD  CONSTRAINT [FK_EventParameter_EventInstance] FOREIGN KEY([EventInstanceId])
REFERENCES [dbo].[EventInstance] ([Id])
GO
ALTER TABLE [dbo].[EventParameter] CHECK CONSTRAINT [FK_EventParameter_EventInstance]
GO
