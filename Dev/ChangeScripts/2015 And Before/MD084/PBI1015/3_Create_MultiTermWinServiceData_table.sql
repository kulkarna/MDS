USE [LibertyPower]
GO

/****** Object:  Table [dbo].[MultiTermWinServiceData]    Script Date: 09/13/2012 15:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MultiTermWinServiceData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeadTime] [int] NOT NULL,
	[StartToSubmitDate] [datetime] NOT NULL,
	[ToBeExpiredAccountContactRateId] [int] NOT NULL,
	[MeterReadDate] [datetime] NOT NULL,
	[NewAccountContractRateId] [int] NULL,
	[RateEndDateAjustedByService] [bit] NOT NULL,
	[MultiTermWinServiceStatusId] [int] NOT NULL,
	[ServiceLastRunDate] [datetime] NULL,
	[IstaErrorMssg] [nvarchar](200) NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_MultyTermWinServiceProcessList] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MultiTermWinServiceData]  WITH CHECK ADD  CONSTRAINT [FK_MultiTermWinServiceData_AccountContractRate] FOREIGN KEY([ToBeExpiredAccountContactRateId])
REFERENCES [dbo].[AccountContractRate] ([AccountContractRateID])
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] CHECK CONSTRAINT [FK_MultiTermWinServiceData_AccountContractRate]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData]  WITH CHECK ADD  CONSTRAINT [FK_MultiTermWinServiceData_AccountContractRate1] FOREIGN KEY([NewAccountContractRateId])
REFERENCES [dbo].[AccountContractRate] ([AccountContractRateID])
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] CHECK CONSTRAINT [FK_MultiTermWinServiceData_AccountContractRate1]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData]  WITH CHECK ADD  CONSTRAINT [FK_MultiTermWinServiceData_MultiTermWinServiceStatus] FOREIGN KEY([MultiTermWinServiceStatusId])
REFERENCES [dbo].[MultiTermWinServiceStatus] ([Id])
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] CHECK CONSTRAINT [FK_MultiTermWinServiceData_MultiTermWinServiceStatus]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData]  WITH CHECK ADD  CONSTRAINT [FK_MultiTermWinServiceData_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] CHECK CONSTRAINT [FK_MultiTermWinServiceData_User]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData]  WITH CHECK ADD  CONSTRAINT [FK_MultiTermWinServiceData_User1] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] CHECK CONSTRAINT [FK_MultiTermWinServiceData_User1]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] ADD  CONSTRAINT [DF_MultiTermWinServiceData_RateEndDateAjustedByService]  DEFAULT ((0)) FOR [RateEndDateAjustedByService]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] ADD  CONSTRAINT [DF_MultyTermWinServiceProcessList_ProcessStatus]  DEFAULT ((1)) FOR [MultiTermWinServiceStatusId]
GO

ALTER TABLE [dbo].[MultiTermWinServiceData] ADD  CONSTRAINT [DF_MultyTermWinServiceProcessList_CreateDate]  DEFAULT (getdate()) FOR [DateCreated]
GO

