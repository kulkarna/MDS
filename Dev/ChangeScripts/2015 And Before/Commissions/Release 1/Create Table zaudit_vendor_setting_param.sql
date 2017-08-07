USE [lp_commissions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[zaudit_vendor_setting_param](
	[audit_id] [int] IDENTITY(1,1) NOT NULL,
	[vendor_setting_param_id] [int] NULL,
	[setting_type_id] [int] NULL,
	[setting_id] [int] NULL,
	[param_id] [int] NULL,
	[param_value] [varchar](150) NULL,
	[active] [bit] NULL,
	[date_created] [datetime] NULL,
	[username] [varchar](100) NULL,
	[date_modified] [datetime] NULL,
	[modified_by] [varchar](100) NULL,
	[param_operator] [int] NULL,
	[date_audit] [datetime] NULL,
 CONSTRAINT [PK_zaudit_vendor_setting_param] PRIMARY KEY CLUSTERED 
(
	[audit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[zaudit_vendor_setting_param] ADD  CONSTRAINT [DF_zaudit_vendor_setting_param]  DEFAULT (getdate()) FOR [date_audit]
GO



