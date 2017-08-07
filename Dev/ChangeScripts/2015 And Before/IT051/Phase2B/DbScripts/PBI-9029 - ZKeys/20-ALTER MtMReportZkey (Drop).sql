
USE [lp_MtM]
GO

DROP INDEX MtMReportZkey.idx_MtMReportZkey_BIYZ

GO 

--ALTER TABLE dbo.MtMReportZkey
--	DROP COLUMN ISO, /*Zone, */ Book
--GO 

CREATE NONCLUSTERED INDEX [idx_MtMReportZkey_BIYZ] ON [dbo].[MtMReportZkey] 
(
	[BookId] ASC,
	[ISOId] ASC,
	[Year] ASC,
	[Zone] ASC
	--[ZainetLocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

