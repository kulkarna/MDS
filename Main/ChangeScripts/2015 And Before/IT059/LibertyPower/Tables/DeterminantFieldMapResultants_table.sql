USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMapResultants]    Script Date: 10/15/2013 10:14:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeterminantFieldMapResultants]') AND type in (N'U'))
DROP TABLE [dbo].[DeterminantFieldMapResultants]
GO

USE [Libertypower]
GO

/****** Object:  Table [dbo].[DeterminantFieldMapResultants]    Script Date: 10/15/2013 10:14:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeterminantFieldMapResultants](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FieldMapID] [int] NOT NULL,
	[ResultantFieldName] [varchar](60) NOT NULL,
	[ResultantFieldValue] [varchar](200) NOT NULL,
 CONSTRAINT [PK_DeterminantFieldMapResultants_1] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [Libertypower]
/****** Object:  Index [CIdx_DeterminantFieldMapResultants]    Script Date: 10/15/2013 10:14:32 ******/
CREATE UNIQUE CLUSTERED INDEX [CIdx_DeterminantFieldMapResultants] ON [dbo].[DeterminantFieldMapResultants] 
(
	[FieldMapID] ASC,
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


