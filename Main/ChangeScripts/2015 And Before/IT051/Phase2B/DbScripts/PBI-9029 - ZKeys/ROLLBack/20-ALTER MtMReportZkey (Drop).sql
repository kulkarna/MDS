USE [lp_MtM]
GO

/****** Object:  Index [idx_MtMReportZkey_BIYZ]    Script Date: 12/09/2013 15:49:30 ******/
CREATE NONCLUSTERED INDEX [idx_MtMReportZkey_BIYZ] ON [dbo].[MtMReportZkey] 
(
	[Book] ASC,
	[ISO] ASC,
	[Year] ASC,
	[Zone] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO


