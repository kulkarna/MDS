USE [Lp_transactions]
GO

/****** Object:  Table [dbo].[DataShift]    Script Date: 03/01/2013 14:05:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DataShift](
      [Iso] [nvarchar](50) NOT NULL,
      [Utility] [nvarchar](50) NOT NULL,
      [Shift] [smallint] NULL,
CONSTRAINT [PK_DataShift] PRIMARY KEY CLUSTERED 
(
      [Iso] ASC,
      [Utility] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DataShift] ADD  CONSTRAINT [DF_DataShift_Shift]  DEFAULT ((0)) FOR [Shift]
GO


insert into Lp_transactions.dbo.DataShift values ('PJM','CSP',-1)
insert into Lp_transactions.dbo.DataShift values ('PJM','DUKE',-1)
insert into Lp_transactions.dbo.DataShift values ('PJM','PECO',-1)
-- insert into Lp_transactions.dbo.DataShift values ('PJM','PPL',-1)
insert into Lp_transactions.dbo.DataShift values ('PJM','OHP',-1)
