USE [LibertyPower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecord]    Script Date: 06/09/2016 11:06:50 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'AccountPropertyHistoryRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[AccountPropertyHistoryRecord]
GO

USE [LibertyPower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecord]    Script Date: 06/09/2016 11:06:50 ******/
CREATE TYPE [dbo].[AccountPropertyHistoryRecord] AS TABLE(
	[Utility] [varchar](80) NULL,
	[AccountNumber] [varchar](50) NULL,
	[FieldName] [varchar](60) NULL,
	[FieldValue] [varchar](200) NULL,
	[EffectiveDate] [datetime] NULL,
	[FieldSource] [varchar](60) NULL,
	[CreatedBy] [varchar](256) NULL
)
GO


