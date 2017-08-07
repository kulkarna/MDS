USE [Workspace]
GO


/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecordwk]    Script Date: 02/21/2017 15:39:19 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'AccountPropertyHistoryRecordwk' AND ss.name = N'dbo')
DROP TYPE [dbo].[AccountPropertyHistoryRecordwk]
GO

USE [Workspace]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecordwk]    Script Date: 02/21/2017 15:39:19 ******/
CREATE TYPE [dbo].[AccountPropertyHistoryRecordwk] AS TABLE(
      [Utility] [varchar](80) NULL,
      [AccountNumber] [varchar](50) NULL,
      [FieldName] [varchar](60) NULL,
      [FieldValue] [varchar](200) NULL,
      [EffectiveDate] [datetime] NULL,
      [FieldSource] [varchar](60) NULL,
      [CreatedBy] [varchar](256) NULL
)
GO

