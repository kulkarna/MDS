USE Integration
GO


/****** Object:  Table [dbo].[transaction_logged_status]    Script Date: 09/09/2013 11:32:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[transaction_logged_status](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](10) NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_transaction_logged_status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[transaction_logged_status] ON
INSERT [dbo].[transaction_logged_status] ([Id], [Name], [Description]) VALUES (1, N'Logged', N'The transaction was logged')
INSERT [dbo].[transaction_logged_status] ([Id], [Name], [Description]) VALUES (2, N'Skipped', N'The transaction was skipped')
SET IDENTITY_INSERT [dbo].[transaction_logged_status] OFF

USE [Integration]
GO
/************ Update Transaction Tables *********************/
ALTER TABLE [dbo].[EDI_814_transaction_result] ADD PRIMARY KEY CLUSTERED 
(
	[EDI_814_transaction_result_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EDI_814_transaction] ADD PRIMARY KEY NONCLUSTERED 
(
	[EDI_814_transaction_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EDI_814_transaction_change] ADD PRIMARY KEY CLUSTERED 
(
	[EDI_814_transaction_change_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF not exists(SELECT * FROM sys.columns WHERE name=N'EventLoggedStatus' AND object_id=object_id(N'EDI_814_transaction_result'))
BEGIN
	ALTER TABLE edi_814_transaction_result ADD EventLoggedStatus smallint null;
END 
GO

ALTER TABLE [dbo].[EDI_814_transaction_result]  WITH CHECK ADD FOREIGN KEY([EventLoggedStatus])
REFERENCES [dbo].[transaction_logged_status] ([Id])
GO

UPDATE EDI_814_transaction_result SET EventLoggedStatus = 2

ALTER TABLE EDI_814_transaction_result with nocheck
ADD FOREIGN KEY (EDI_814_transaction_id)
REFERENCES  EDI_814_transaction (EDI_814_transaction_id)

ALTER TABLE EDI_814_transaction_change  WITH NOCHECK 
ADD FOREIGN KEY(EDI_814_transaction_id)
REFERENCES EDI_814_transaction (EDI_814_transaction_id)

