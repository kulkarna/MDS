USE lp_MtM
GO

ALTER TABLE MtMZainetMaxAccount ADD SettlementLocationRefID INT 
GO

ALTER TABLE MtMZainetMaxAccount ADD LoadProfileRefID INT 

GO

sp_RENAME 'MtMZainetMaxAccount.ProxiedZone' , 'ProxiedLocation', 'COLUMN'

GO

DROP INDEX MtMZAM_Z ON MtMZainetMaxAccount

GO

CREATE NONCLUSTERED INDEX [idx_MtMZainetMaxAccount_SettlementLocationRefID] ON [dbo].[MtMZainetMaxAccount] 
(
	SettlementLocationRefID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO


/*
ALTER TABLE MtMZainetMaxAccount DROP COLUMN Zone


ALTER TABLE MtMZainetMaxAccount DROP COLUMN LoadProfile

*/
GO



