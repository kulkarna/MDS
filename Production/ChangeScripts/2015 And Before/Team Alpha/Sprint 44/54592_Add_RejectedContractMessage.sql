USE [Lp_deal_capture]
GO

/****** Object:  Table [dbo].[RejectedContractMessage]    Script Date: 11/12/2014 10:42:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF Exists (Select 1 from sys.tables (NOLOCK) where name='RejectedContractMessage')
BEGIN 
 DROP Table RejectedContractMessage;
END

CREATE TABLE [dbo].[RejectedContractMessage](
	[RejectedContractMessageID] [int] IDENTITY(1,1) NOT NULL,
	[ContractNumber] [char](12) NOT NULL,
	[EmailTypeID] [int] NOT NULL,
	[ErrorMessage] [varchar](4000) NULL,
	[Subject] [varchar](4000) NULL,
	[Body] [varchar](max) NULL,
	[ToEmail] [varchar](1000) NULL,
	[CustomerEmail] [nchar](100) NULL,
	[SalesChannelEmail] [nchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
CONSTRAINT [PK_RejectedContractMessage] PRIMARY KEY CLUSTERED 
(
	[RejectedContractMessageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON ,DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


GO

ALTER TABLE [dbo].[RejectedContractMessage] ADD  CONSTRAINT [DF_RejectedContractMessage_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

CREATE UNIQUE INDEX NDX_RejectedContractMessageContractNumberEmailTypeID ON RejectedContractMessage (ContractNumber, EmailTypeID)

GO

SET ANSI_PADDING OFF
GO


