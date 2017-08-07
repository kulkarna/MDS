USE [LibertyPower]
GO

/****** Object:  Index [idx1]    Script Date: 06/25/2012 11:49:07 ******/
CREATE NONCLUSTERED INDEX [idx1] ON [dbo].[zAuditUtility] 
(
	[zAuditUtilityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

/****** Object:  Index [NDX_zAuditUtilityAuditChangeDate]    Script Date: 06/26/2012 15:25:58 ******/
CREATE NONCLUSTERED INDEX [NDX_zAuditUtilityAuditChangeDate] ON [dbo].[zAuditUtility] 
(
	[AuditChangeDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


