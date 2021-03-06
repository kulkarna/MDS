/****** Object:  Table [dbo].[RECONEDI_ProcessResultsFormula]    Script Date: 6/21/2014 8:23:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ProcessResultsFormula](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FormulaDescp] [varchar](100) NOT NULL,
	[Formula] [varchar](max) NOT NULL,
	[InactiveInd] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[RECONEDI_ProcessResultsFormula] ON 

INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (1, N'EDI Enrollment Info - Summary', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0), 
Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0), 
Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(a.Book0_VolumeMwh), 0) 
from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock) 
on a.ID = b.ReconEDIAccountID  where a.Reconid = @ReconID and a.ProcessType = ''Daily'' group by a.AccountID, a.ContractID) a) a cross join (select Book1_NoAccounts = count(*), 
Book1_VolumeMwh = isnull(sum(b.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_EDIAccounts a with (nolock) 
inner join RECONEDI_EDIVolume b with (nolock) on  a.ID = b.ReconEDIAccountID where a.Reconid = @ReconID and   a.ProcessType = ''Custom'' group by a.AccountID, a.ContractID) b) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (2, N'EDI Enrollment Info - Detail', N'select a.ID, a.ReconID, a.AccountID, a.ContractID, a.ContractNumber, a.ISO, a.Utility, a.AccountNumber, ContractRateStart = convert(varchar(10), a.ContractRateStart, 101), ContractRateEnd = convert(varchar(10), a.ContractRateEnd, 101), a.ProcessType,b.YearUsage, b.Volume
from RECONEDI_EDIAccounts a (nolock) inner join RECONEDI_EDIVolume b (nolock) on a.ID = b.ReconEDIAccountID where a.ReconID = @ReconID
', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (3, N'Mark to Market Info - Summary', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0),
 Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0),
 Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(a.Book0_VolumeMwh), 0)
 from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock)
 on a.ID = b.ReconMTMAccountID where a.Reconid = @ReconID and a.book = 0 group by a.AccountID, a.ContractID) a) a cross join (select Book1_NoAccounts = count(*),
 Book1_VolumeMwh = isnull(sum(b.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_MTMAccounts a with (nolock)
 inner join RECONEDI_MTMVolume b with (nolock) on  a.ID = b.ReconMTMAccountID where a.Reconid = @ReconID and a.book = 1 group by a.AccountID, a.ContractID) b) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (4, N'Mark to Market Info - Detail', N'select a.ID, a.ReconID, a.AccountID, a.ContractID, a.ContractNumber, a.ISO, a.Utility, a.AccountNumber, a.MTMAccountID, StartDate = convert(varchar(10), a.StartDate, 101), EndDate = convert(varchar(10), a.EndDate, 101), a.Book, b.YearUsage, b.Volume 
from RECONEDI_MTMAccounts a (nolock) inner join RECONEDI_MTMVolume b (nolock) on a.ID = b.ReconMTMAccountID
', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (5, N'Variance ', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0) - isnull(b.Book0_NoAccounts, 0),
 Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) - isnull(b.Book0_VolumeMwh, 0), Book1_NoAccounts = isnull(a.Book1_NoAccounts, 0) - isnull(b.Book1_NoAccounts, 0),
 Book1_VolumeMwh = isnull(a.Book1_VolumeMwh, 0) - isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Total_NoAccounts, 0) - isnull(b.Total_NoAccounts, 0),
 Total_VolumeMwh = isnull(a.Total_VolumeMwh, 0) - isnull(b.Total_VolumeMwh, 0) from (select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), 
 Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0), Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), 
 Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0), Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) 
 from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(a.Book0_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0)
 from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock) on  a.ID   = b.ReconEDIAccountID where a.Reconid = @ReconID and a.ProcessType = ''Daily'' 
 group by a.AccountID, a.ContractID) a) a cross join (select Book1_NoAccounts = count(*), Book1_VolumeMwh = isnull(sum(b.Book1_VolumeMwh), 0) from (select a.AccountID,
 a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock) on a.ID = b.ReconEDIAccountID
 where a.Reconid = @ReconID and a.ProcessType = ''Custom'' group by a.AccountID, a.ContractID) b) b) a cross join (select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0),
 Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0), Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), 
 Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0), Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) 
 from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(a.Book0_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0)
 from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock) on a.ID = b.ReconMTMAccountID where a.Reconid = @ReconID and a.book = 0 group by a.AccountID,
 a.ContractID) a) a cross join (select Book1_NoAccounts = count(*), Book1_VolumeMwh = isnull(sum(b.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, 
 Book1_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock) on a.ID = b.ReconMTMAccountID
 where a.Reconid = @ReconID and   a.book = 1 group by a.AccountID, a.ContractID) b) b) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (6, N'Common Info EDI - Summary', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0),
 Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0),
 Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(b.Book0_VolumeMwh), 0)
 from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock)
 on  a.ID = b.ReconEDIAccountID where a.Reconid  = @ReconID and   a.ProcessType = ''Daily'' and   a.ReconReasonID in (@ReconReasonID) group by a.AccountID, a.ContractID) b) a
 cross join (select Book1_NoAccounts = count(*), Book1_VolumeMwh = isnull(sum(c.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0)
 from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock) on  a.ID = b.ReconEDIAccountID where a.Reconid  = @ReconID and   a.ProcessType = ''Custom'' and 
 a.ReconReasonID in (@ReconReasonID) group by a.AccountID, a.ContractID) c) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (8, N'Common Info EDI - Detail', N'select a.ID, a.ReconID, a.AccountID, a.ContractID, a.ContractNumber, a.ISO, a.Utility, a.AccountNumber, ContractRateStart = convert(varchar(10), a.ContractRateStart, 101), ContractRateEnd = convert(varchar(10), a.ContractRateEnd, 101), a.ProcessType, b.YearUsage, b.Volume 
from RECONEDI_EDIAccounts a (nolock) inner join RECONEDI_EDIVolume b (nolock) on a.ID = b.ReconEDIAccountID where a.ReconID = @Reconid and a.ReconReasonID in @ReconReasonID', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (10, N'Common Info MTM - Summary', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0),
 Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0),
 Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(b.Book0_VolumeMwh), 0)
 from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock)
 on  a.ID = b.ReconMTMAccountID where a.Reconid = @ReconID and a.Book = 0 and a.ReconReasonID  in (@ReconReasonID) group by a.AccountID, a.ContractID) b) a 
 cross join (select Book1_NoAccounts = count(*), Book1_VolumeMwh = isnull(sum(c.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0)
 from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock) on a.ID  = b.ReconMTMAccountID where a.Reconid = @ReconID and a.Book = 1 and 
 a.ReconReasonID in (@ReconReasonID) group by a.AccountID, a.ContractID) c) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (11, N'Common Info MTM - Detail', N'select a.ID, a.ReconID, a.AccountID, a.ContractID, a.ContractNumber, a.ISO, a.Utility, a.AccountNumber, a.MtMAccountID, StartDate = convert(varchar(10), a.StartDate, 101), EndDate = convert(varchar(10), a.EndDate, 101), a.Book, b.YearUsage, b.Volume 
from RECONEDI_MTMAccounts a (nolock) inner join RECONEDI_MTMVolume b (nolock) on a.ID = b.ReconMTMAccountID where a.ReconID = @Reconid and a.ReconReasonID in @ReconReasonID', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (12, N'Missing Info in EDI - Summary', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0),
 Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0),
 Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(b.Book0_VolumeMwh), 0)
 from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock)
 on  a.ID = b.ReconMTMAccountID where a.Reconid = @ReconID and a.Book = 0 and a.ReconReasonID  in @ReconReasonID group by a.AccountID, a.ContractID) b) a 
 cross join (select Book1_NoAccounts = count(*), Book1_VolumeMwh = isnull(sum(c.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0)
 from RECONEDI_MTMAccounts a with (nolock) inner join RECONEDI_MTMVolume b with (nolock) on a.ID  = b.ReconMTMAccountID where a.Reconid = @ReconID and a.Book = 1 and 
 a.ReconReasonID in @ReconReasonID group by a.AccountID, a.ContractID) c) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (14, N'Missing Info in EDI - Detail', N'select a.ID, a.ReconID, a.AccountID, a.ContractID, a.ContractNumber, a.ISO, a.Utility, a.AccountNumber, a.MtMAccountID, StartDate = convert(varchar(10), a.StartDate, 101), EndDate = convert(varchar(10), a.EndDate, 101), a.Book, b.YearUsage, b.Volume 
from RECONEDI_MTMAccounts a (nolock) inner join RECONEDI_MTMVolume b (nolock) on a.ID = b.ReconMTMAccountID where a.ReconID = @Reconid and a.ReconReasonID in @ReconReasonID', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (15, N'Missing Info in MTM - Summary', N'select Book0_NoAccounts = isnull(a.Book0_NoAccounts, 0), Book0_VolumeMwh = isnull(a.Book0_VolumeMwh, 0),
 Book1_NoAccounts = isnull(b.Book1_NoAccounts, 0), Book1_VolumeMwh = isnull(b.Book1_VolumeMwh, 0), Total_NoAccounts = isnull(a.Book0_NoAccounts, 0) + isnull(b.Book1_NoAccounts, 0),
 Total_VolumeMwh = isnull(a.Book0_VolumeMwh, 0) + isnull(b.Book1_VolumeMwh, 0) from (select Book0_NoAccounts = count(*), Book0_VolumeMwh = isnull(sum(b.Book0_VolumeMwh), 0)
 from (select a.AccountID, a.ContractID, Book0_VolumeMwh = isnull(sum(b.volume), 0) from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock)
 on  a.ID = b.ReconEDIAccountID where a.Reconid  = @ReconID and   a.ProcessType = ''Daily'' and   a.ReconReasonID in @ReconReasonID group by a.AccountID, a.ContractID) b) a
 cross join (select Book1_NoAccounts = count(*), Book1_VolumeMwh = isnull(sum(c.Book1_VolumeMwh), 0) from (select a.AccountID, a.ContractID, Book1_VolumeMwh = isnull(sum(b.volume), 0)
 from RECONEDI_EDIAccounts a with (nolock) inner join RECONEDI_EDIVolume b with (nolock) on  a.ID = b.ReconEDIAccountID where a.Reconid  = @ReconID and   a.ProcessType = ''Custom'' and 
 a.ReconReasonID in @ReconReasonID group by a.AccountID, a.ContractID) c) b', 0)
INSERT [dbo].[RECONEDI_ProcessResultsFormula] ([ID], [FormulaDescp], [Formula], [InactiveInd]) VALUES (16, N'Missing Info in MTM - Detail', N'select a.ID, a.ReconID, a.AccountID, a.ContractID, a.ContractNumber, a.ISO, a.Utility, a.AccountNumber, 
ContractRateStart = convert(varchar(10), a.ContractRateStart, 101), ContractRateEnd = convert(varchar(10), a.ContractRateEnd, 101), a.ProcessType, b.YearUsage, b.Volume 
from RECONEDI_EDIAccounts a (nolock) inner join RECONEDI_EDIVolume b (nolock) on a.ID = b.ReconEDIAccountID where a.ReconID = @Reconid and a.ReconReasonID in @ReconReasonID', 0)
SET IDENTITY_INSERT [dbo].[RECONEDI_ProcessResultsFormula] OFF
