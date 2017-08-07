USE [libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecord]    Script Date: 02/04/2014 17:23:28 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'AccountPropertyHistoryRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[AccountPropertyHistoryRecord]
GO

USE [libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecord]    Script Date: 02/04/2014 17:23:28 ******/
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


