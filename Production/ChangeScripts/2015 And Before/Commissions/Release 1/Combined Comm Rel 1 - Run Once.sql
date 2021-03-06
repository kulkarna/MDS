USE [lp_commissions]
GO


--ALTER TABLE dbo.vendor_calculation_freq
--DROP COLUMN group_id 
--GO 

ALTER TABLE dbo.vendor_calculation_freq
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_calculation_freq
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.vendor_calculation_freq
ADD interval float null 
GO 

--ALTER TABLE dbo.vendor_calculation_freq
--ALTER COLUMN interval float null 
--GO 


USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_grace_period
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_grace_period
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.vendor_grace_period
ADD date_option int null 
GO 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_grace_period_grace_period]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_grace_period] DROP CONSTRAINT [DF_vendor_grace_period_grace_period]
END
GO

ALTER TABLE dbo.vendor_grace_period
ALTER COLUMN grace_period float null 
GO 

ALTER TABLE [dbo].[vendor_grace_period] ADD  CONSTRAINT [DF_vendor_grace_period_grace_period]  DEFAULT ((0)) FOR [grace_period]
GO


USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_payment_freq
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_payment_freq
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.vendor_payment_freq
ADD interval float null 
GO 

--ALTER TABLE dbo.vendor_payment_freq
--ALTER COLUMN interval float null 
--GO 

USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_payment_option
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_payment_option
ADD interval_type_id int null 
GO 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__vendor_pa__group__3568C3A6]') AND type = 'D')
BEGIN
ALTER TABLE dbo.vendor_payment_option DROP CONSTRAINT DF__vendor_pa__group__3568C3A6
END
GO

--ALTER TABLE dbo.vendor_payment_option
--DROP COLUMN group_id 
--GO 

USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_report_date_option
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_report_date_option
ADD interval_type_id int null 
GO 


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__vendor_re__grace__12F3B011]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_report_date_option] DROP CONSTRAINT [DF__vendor_re__grace__12F3B011]
END
GO

ALTER TABLE dbo.vendor_report_date_option
ALTER COLUMN grace_period float null 
GO 

ALTER TABLE [dbo].[vendor_report_date_option] ADD  DEFAULT ((0)) FOR [grace_period]
GO


USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_calculation_freq
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_calculation_freq
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_calculation_freq
ADD interval float null 
GO 

ALTER TABLE dbo.zaudit_vendor_calculation_freq
ADD date_end datetime null 
GO 

USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD date_option int null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ALTER COLUMN grace_period float null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD date_end datetime null 
GO 

USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD interval int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD date_end datetime null 
GO 

USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD interval int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD date_end datetime null 
GO 


USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_report_date_option
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_report_date_option
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_report_date_option
ADD date_end datetime null 
GO 


USE [lp_commissions]
GO

CREATE NONCLUSTERED INDEX [idx_vendor_calculation_freq_vendor] ON [dbo].[vendor_calculation_freq] 
(
	[vendor_id] ASC
)
INCLUDE ( [package_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_vendor_grace_period_vendor] ON [dbo].[vendor_grace_period] 
(
	[vendor_id] ASC
)
INCLUDE ( [package_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_vendor_payment_freq_vendor] ON [dbo].[vendor_payment_freq] 
(
	[vendor_id] ASC
)
INCLUDE ( [package_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_vendor_payment_option_vendor] ON [dbo].[vendor_payment_option] 
(
	[vendor_id] ASC
)
INCLUDE ( [package_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_vendor_report_date_option_vendor] ON [dbo].[vendor_report_date_option] 
(
	[vendor_id] ASC
)
INCLUDE ( [package_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_vendor_setting_param_setting] ON [dbo].[vendor_setting_param] 
(
	[setting_type_id] ASC,
	[setting_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

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



USE Lp_commissions
GO

SET IDENTITY_INSERT [Lp_commissions].[dbo].[status_list] ON
GO 

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 20 , 'Draft' , 'Draft' , 'PACKAGES' , 1 , 1 ) 
GO

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 21 , 'Active' , 'Active' , 'PACKAGES' , 1 , 1 ) 
GO

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 22 , 'InActive' , 'InActive' , 'PACKAGES' , 1 , 1 ) 
GO

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 23 , 'HOLD'	,'Hold'	,'APPROVAL'	, 1 , 1 ) 
GO

SET IDENTITY_INSERT [Lp_commissions].[dbo].[status_list] OFF
GO



USE Lp_commissions
GO

UPDATE Lp_commissions..vendor_grace_period
SET date_option = 3 , date_modified = GETDATE() , modified_by = 'System'
WHERE date_option is null 
GO







