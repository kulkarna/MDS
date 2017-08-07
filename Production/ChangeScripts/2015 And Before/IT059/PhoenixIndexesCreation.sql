USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistory_Active]    Script Date: 10/14/2013 17:06:50 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistory_Active] ON [dbo].[AccountPropertyHistory] 
(
	[Active] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistory_EffectiveDate]    Script Date: 10/14/2013 17:06:50 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistory_EffectiveDate] ON [dbo].[AccountPropertyHistory] 
(
	[EffectiveDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistory_FieldName]    Script Date: 10/14/2013 17:06:50 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistory_FieldName] ON [dbo].[AccountPropertyHistory] 
(
	[DateCreated] ASC,
	[FieldName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistory_LockStatus]    Script Date: 10/14/2013 17:06:50 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistory_LockStatus] ON [dbo].[AccountPropertyHistory] 
(
	[LockStatus] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [Libertypower]
/****** Object:  Index [IDX_AccountPropertyHistory_UtilityID_AccountNumber]    Script Date: 10/14/2013 17:06:50 ******/
CREATE NONCLUSTERED INDEX [IDX_AccountPropertyHistory_UtilityID_AccountNumber] ON [dbo].[AccountPropertyHistory] 
(
	[UtilityID] ASC,
	[AccountNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO