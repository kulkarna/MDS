USE [Lp_enrollment]
GO
/****** Object:  Table [dbo].[StatusTransitionsReasonCode]    Script Date: 03/07/2013 07:42:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonCode]') AND type in (N'U'))
DROP TABLE [dbo].[StatusTransitionsReasonCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTransitionsReasonCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StatusTransitionsReasonCode](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Reason] [varchar](200) NULL,
 CONSTRAINT [PK_StatusTransitionsReasonCode] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
