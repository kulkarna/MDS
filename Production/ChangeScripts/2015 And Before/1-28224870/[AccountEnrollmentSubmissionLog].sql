USE [lp_account]
GO

/****** Object:  Table [dbo].[AccountEnrollmentSubmissionLog]    Script Date: 04/09/2013 14:27:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AccountEnrollmentSubmissionLog](
	[AccountEnrollmentSubmissionLogId] [int] IDENTITY(1,1) NOT NULL,
	[Account_ID] [char](12) NOT NULL,
	[Result] [varchar](10) NOT NULL,
	[Error] [text] NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_AccountEnrollmentSubmissionLog] PRIMARY KEY CLUSTERED 
(
	[AccountEnrollmentSubmissionLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


	 GO
	 
SET ANSI_PADDING OFF
GO


