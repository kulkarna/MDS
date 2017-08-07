USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SalesChannelDeviceAssignment_SalesChannel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SalesChannelDeviceAssignment]'))
ALTER TABLE [dbo].[SalesChannelDeviceAssignment] DROP CONSTRAINT [FK_SalesChannelDeviceAssignment_SalesChannel]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SalesChannelDeviceAssignment_ChannelID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SalesChannelDeviceAssignment] DROP CONSTRAINT [DF_SalesChannelDeviceAssignment_ChannelID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SalesChannelDeviceAssignment_DeviceID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SalesChannelDeviceAssignment] DROP CONSTRAINT [DF_SalesChannelDeviceAssignment_DeviceID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SalesChannelDeviceAssignment_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SalesChannelDeviceAssignment] DROP CONSTRAINT [DF_SalesChannelDeviceAssignment_IsActive]
END

GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[SalesChannelDeviceAssignment]    Script Date: 12/09/2013 16:08:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SalesChannelDeviceAssignment]') AND type in (N'U'))
DROP TABLE [dbo].[SalesChannelDeviceAssignment]
GO

USE [LibertyPower]
GO

/****** Object:  Table [dbo].[SalesChannelDeviceAssignment]    Script Date: 12/09/2013 16:08:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SalesChannelDeviceAssignment](
	[AssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[ChannelID] [int] NOT NULL,
	[DeviceID] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SalesChannelDeviceAssignment] PRIMARY KEY CLUSTERED 
(
	[AssignmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SalesChannelDeviceAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SalesChannelDeviceAssignment_SalesChannel] FOREIGN KEY([ChannelID])
REFERENCES [dbo].[SalesChannel] ([ChannelID])
GO

ALTER TABLE [dbo].[SalesChannelDeviceAssignment] CHECK CONSTRAINT [FK_SalesChannelDeviceAssignment_SalesChannel]
GO

ALTER TABLE [dbo].[SalesChannelDeviceAssignment] ADD  CONSTRAINT [DF_SalesChannelDeviceAssignment_ChannelID]  DEFAULT ((0)) FOR [ChannelID]
GO

ALTER TABLE [dbo].[SalesChannelDeviceAssignment] ADD  CONSTRAINT [DF_SalesChannelDeviceAssignment_DeviceID]  DEFAULT ('') FOR [DeviceID]
GO

ALTER TABLE [dbo].[SalesChannelDeviceAssignment] ADD  CONSTRAINT [DF_SalesChannelDeviceAssignment_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO


