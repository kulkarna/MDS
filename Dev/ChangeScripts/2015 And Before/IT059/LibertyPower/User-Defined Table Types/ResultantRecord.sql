USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[ResultantRecord]    Script Date: 07/27/2013 20:22:11 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'ResultantRecord' AND ss.name = N'dbo')
DROP TYPE [dbo].[ResultantRecord]
GO

USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[ResultantRecord]    Script Date: 07/27/2013 20:22:11 ******/
CREATE TYPE [dbo].[ResultantRecord] AS TABLE(
	[MappingStyle] [varchar](60) NULL,
	[Utility] [varchar](80) NULL,
	[DeterminantName] [varchar](60) NULL,
	[DeterminantValue] [varchar](200) NULL,
	[ResultantName] [varchar](60) NULL,
	[ResultantValue] [varchar](200) NULL,
	[DeleteOrNot] [varchar](20) NULL
)
GO


