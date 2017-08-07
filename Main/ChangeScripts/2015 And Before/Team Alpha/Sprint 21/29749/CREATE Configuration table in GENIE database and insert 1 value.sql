USE [GENIE]
GO

/****** Object:  Table [dbo].[Configuration]    Script Date: 01/06/2014 11:01:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Configuration](
	[ConfigurationID] [int] IDENTITY(1,1) NOT NULL,
	[ConfigurationName] [varchar](50) NOT NULL,
	[ConfigurationValue] [varchar](500) NOT NULL,
	[ConfigurationTypeName] [varchar](150) NULL,
	[DateModified] [datetime] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK__Configuration] PRIMARY KEY CLUSTERED 
(
	[ConfigurationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, Data_compression=PAGE) ON [PRIMARY],
 CONSTRAINT [IX_Configuration_ConfigurationName] UNIQUE NONCLUSTERED 
(
	[ConfigurationName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, Data_compression=PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_ConfigName]  DEFAULT ('') FOR [ConfigurationName]
GO

ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_ConfigValue]  DEFAULT ('') FOR [ConfigurationValue]
GO

ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_DateModified]  DEFAULT (getdate()) FOR [DateModified]
GO

ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO

ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO


SET IDENTITY_INSERT GENIE..Configuration ON;
GO
INSERT INTO GENIE..Configuration (ConfigurationID, ConfigurationName, ConfigurationValue, ConfigurationTypeName, DateModified, DateCreated, ModifiedBy, CreatedBy)
VALUES(1,	'TemplateFilePath',	'\\LPCDMZSQLCTR1\GENIE_PROD\ContractTemplates',	'System.String',	GETDATE(),	GETDATE(),	2241, 2241);
GO
SET IDENTITY_INSERT GENIE..Configuration OFF;
GO