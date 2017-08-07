USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[MappingRecord]    Script Date: 07/27/2013 20:18:10 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'MappingRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[MappingRecord]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[MappingRecord]    Script Date: 07/27/2013 20:18:10 ******/
CREATE TYPE [dbo].[MappingRecord] AS TABLE(
	[MappingStyle] [varchar](60) NULL,
	[Utility] [varchar](80) NULL,
	[DeterminantName] [varchar](60) NULL,
	[DeterminantValue] [varchar](200) NULL,
	[DeleteOrNot] [varchar](20) NULL
)
GO


