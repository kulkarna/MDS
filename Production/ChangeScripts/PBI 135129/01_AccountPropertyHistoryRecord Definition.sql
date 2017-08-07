USE [Libertypower]
GO

DROP PROCEDURE [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]

DROP TYPE [dbo].[AccountPropertyHistoryRecord]

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyHistoryRecord]    Script Date: 3/28/2017 1:23:10 PM ******/
CREATE TYPE [dbo].[AccountPropertyHistoryRecord] AS TABLE(
	[Utility] [varchar](80) NULL,
	[AccountNumber] [varchar](50) NULL,
	[FieldName] [varchar](60) NULL,
	[FieldValue] [varchar](200) NULL,
	[EffectiveDate] [datetime] NULL,
	[FieldSource] [varchar](60) NULL,
	[LockStatus] [varchar](60) NULL,
	[CreatedBy] [varchar](256) NULL
)
GO


