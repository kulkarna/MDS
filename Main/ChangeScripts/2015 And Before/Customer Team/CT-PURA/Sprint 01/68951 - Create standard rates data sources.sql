USE [Libertypower]
GO
/****** Object:  Table [dbo].[tblStardardRate]    Script Date: 04/22/2015 10:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStardardRate](
	[StandardRateEntityId] [uniqueidentifier] NOT NULL,
	[UtilityId] [int] NOT NULL,
	[GenerationRate] [real] NOT NULL,
	[GenerationCost] [real] NULL,
	[EffectiveStartDate] [date] NOT NULL,
	[EffectiveEndDate] [date] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblStardardRate] PRIMARY KEY CLUSTERED 
(
	[StandardRateEntityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[tblStardardRate] ([StandardRateEntityId], [UtilityId], [GenerationRate], [GenerationCost], [EffectiveStartDate], [EffectiveEndDate], [ModifiedBy], [CreatedBy]) VALUES (N'060cfb0d-28d2-41fc-879f-2e0764ece6fe', 46, 13.3108, NULL, CAST(0x6E390B00 AS Date), CAST(0x223A0B00 AS Date), 1, 1)
INSERT [dbo].[tblStardardRate] ([StandardRateEntityId], [UtilityId], [GenerationRate], [GenerationCost], [EffectiveStartDate], [EffectiveEndDate], [ModifiedBy], [CreatedBy]) VALUES (N'955c6bef-38ec-49f6-9ca3-5922c1d54985', 15, 9.99, NULL, CAST(0xB6380B00 AS Date), CAST(0x6D390B00 AS Date), 1, 1)
INSERT [dbo].[tblStardardRate] ([StandardRateEntityId], [UtilityId], [GenerationRate], [GenerationCost], [EffectiveStartDate], [EffectiveEndDate], [ModifiedBy], [CreatedBy]) VALUES (N'1d74b47b-98c9-409b-82f1-c7cce3b76c90', 15, 12.629, NULL, CAST(0x6E390B00 AS Date), CAST(0x223A0B00 AS Date), 1, 1)
INSERT [dbo].[tblStardardRate] ([StandardRateEntityId], [UtilityId], [GenerationRate], [GenerationCost], [EffectiveStartDate], [EffectiveEndDate], [ModifiedBy], [CreatedBy]) VALUES (N'28082ddb-de38-4115-8bca-dda3ff3b7822', 46, 8.6657, NULL, CAST(0xB6380B00 AS Date), CAST(0x6D390B00 AS Date), 1, 1)
/****** Object:  Default [DF_tblStardardRate_StandardRateEntityId]    Script Date: 04/22/2015 10:26:14 ******/
ALTER TABLE [dbo].[tblStardardRate] ADD  CONSTRAINT [DF_tblStardardRate_StandardRateEntityId]  DEFAULT (newid()) FOR [StandardRateEntityId]
GO
/****** Object:  ForeignKey [FK_tblStardardRate_Utility]    Script Date: 04/22/2015 10:26:14 ******/
ALTER TABLE [dbo].[tblStardardRate]  WITH CHECK ADD  CONSTRAINT [FK_tblStardardRate_Utility] FOREIGN KEY([UtilityId])
REFERENCES [dbo].[Utility] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblStardardRate] CHECK CONSTRAINT [FK_tblStardardRate_Utility]
GO


