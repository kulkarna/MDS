USE lp_MtM
GO

ALTER TABLE MtMZainetMaxAccount DROP COLUMN SettlementLocationRefID
GO

ALTER TABLE MtMZainetMaxAccount DROP COLUMN LoadProfileRefID

GO

sp_RENAME 'MtMZainetMaxAccount.ProxiedLocation' , 'ProxiedZone', 'COLUMN'

GO

/****** Object:  Index [MtMZAM_Z]    Script Date: 12/09/2013 16:01:43 ******/
CREATE NONCLUSTERED INDEX [MtMZAM_Z] ON [dbo].[MtMZainetMaxAccount] 
(
	[Zone] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

DROP INDEX idx_MtMZainetMaxAccount_SettlementLocationRefID ON MtMZainetMaxAccount

GO