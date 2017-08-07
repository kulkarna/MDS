
USE lp_MtM
GO

sp_RENAME 'MtMAccount.ProxiedLocation' , 'ProxiedZone', 'COLUMN'

GO

/****** Object:  Index [idx_MtMAccount_Zone]    Script Date: 12/09/2013 15:54:44 ******/
CREATE NONCLUSTERED INDEX [idx_MtMAccount_Zone] ON [dbo].[MtMAccount] 
(
	[Zone] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Data_01]
GO

ALTER TABLE MtMAccount DROP COLUMN SettlementLocationRefID

GO

ALTER TABLE MtMAccount DROP COLUMN LoadProfileRefID
