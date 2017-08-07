USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyRecord]    Script Date: 08/22/2013 13:22:20 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'AccountPropertyRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[AccountPropertyRecord]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[AccountPropertyRecord]    Script Date: 08/22/2013 13:22:20 ******/
CREATE TYPE [dbo].[AccountPropertyRecord] AS TABLE(
	[Utility] [varchar](80) NULL,
	[AccountNumber] [varchar](50) NULL,
	[FieldName] [varchar](60) NULL,
	[FieldValue] [varchar](200) NULL,
	[EffectiveDate] [datetime] NULL
)
GO


