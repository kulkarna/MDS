USE LibertyPower 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeterminantHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UtilityID] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccountNumber] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FieldName] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FieldValue] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[FieldSource] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserIdentity] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[LockStatus] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_EffectiveDate]  DEFAULT (getdate()) FOR [EffectiveDate]
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_UserIdentity]  DEFAULT ('Unknown') FOR [UserIdentity]
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [DF_DeterminantHistory_Active]  DEFAULT ((1)) FOR [Active]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of field being recorded; see' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'FieldName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date a record value is used as cuurent value; by default this equals the DateCreated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'EffectiveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source of the record; see enum FieldUpdateSources for possible values' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'FieldSource'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date a record was written' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'DateCreated'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can be Locked, Unlocked, or NULL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'LockStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Set this bit to 1 to remove old records from consideration for performance issues' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeterminantHistory', @level2type=N'COLUMN',@level2name=N'Active'
GO
Create clustered index CIdx_DeterminantHistory on DeterminantHistory ( UtilityID, AccountNumber, FieldName, EffectiveDate ) 


GO

/****** Object:  Index [PK_DeterminantHistory_1]    Script Date: 05/01/2013 10:48:18 ******/
ALTER TABLE [dbo].[DeterminantHistory] ADD  CONSTRAINT [PK_DeterminantHistory_1] PRIMARY KEY  
(
      [ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
