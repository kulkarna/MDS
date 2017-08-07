USE [Lp_commissions]
GO


CREATE TABLE [dbo].[Compensation_Package](
	[package_id] [int] IDENTITY(1,1) NOT NULL,
	[package_name] [varchar](150) NULL,
	[package_descp] [varchar](max) NULL,
	[status_id] [int] NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[username] [varchar](50) NOT NULL,
	[date_created] [datetime] NOT NULL,
	[modified_by] [varchar](50) NULL,
	[date_modified] [datetime] NULL,
 CONSTRAINT [PK_Compensation_Package] PRIMARY KEY CLUSTERED 
(
	[package_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Compensation_Package] ADD  CONSTRAINT [DF_Compensation_Package_date_created]  DEFAULT (getdate()) FOR [date_created]
GO

ALTER TABLE [dbo].[Compensation_Package] ADD  CONSTRAINT [DF_Compensation_Package_status_id]  DEFAULT (0) FOR [status_id]
GO