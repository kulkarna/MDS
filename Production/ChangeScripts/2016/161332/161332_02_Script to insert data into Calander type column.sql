
-- Table to store Utilityid and corresponding Calandertype 

USE [Workspace]
GO
/****** Object:  Table [dbo].[TFS_161954_AMEREN_Accounts]    Script Date: 1/13/2017 12:31:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
set Nocount on 
GO
CREATE TABLE [dbo].[TFS_161954_AMEREN_Accounts](
	[Utilityid] [nvarchar](255) NULL,
	[UtilityCode] [nvarchar](255) NULL,
	[CalendarType] [nvarchar](255) NULL
) ON [PRIMARY]

GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'49', N'METED', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'55', N'PECO', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'50', N'PENELEC', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'51', N'PENNPR', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'37', N'PPL', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'56', N'WPP', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'21', N'DUQ', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'45', N'UGI', N'Business')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'13', N'BGE', N'Calendar')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'10', N'ALLEGMD', N'Calendar')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'20', N'DELMD', N'Calendar')
GO
INSERT [dbo].[TFS_161954_AMEREN_Accounts] ([Utilityid], [UtilityCode], [CalendarType]) VALUES (N'35', N'PEPCO-MD', N'Calendar')
GO



--copy the calander type column data from temp table to UtilityAcceleratedSwitch table 

Update a
set a.CalendarType=b.CalendarType
from Libertypower..UtilityAcceleratedSwitch(nolock)a
inner join workspace..TFS_161954_AMEREN_Accounts b(nolock)
on a.UtilityID=b.Utilityid

--Drop the table 
Drop table workspace..TFS_161954_AMEREN_Accounts