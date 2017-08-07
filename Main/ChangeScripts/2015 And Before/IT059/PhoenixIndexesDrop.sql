USE [Libertypower]
GO

/****** Object:  Index [idx__temp1]    Script Date: 10/22/2013 17:49:25 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND name = N'IDX_AccountPropertyHistory_Active')
DROP INDEX [IDX_AccountPropertyHistory_Active] ON [dbo].[AccountPropertyHistory] WITH ( ONLINE = OFF )
GO


USE [Libertypower]
GO

/****** Object:  Index [idx__temp1]    Script Date: 10/22/2013 17:49:25 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND name = N'IDX_AccountPropertyHistory_EffectiveDate')
DROP INDEX [IDX_AccountPropertyHistory_EffectiveDate] ON [dbo].[AccountPropertyHistory] WITH ( ONLINE = OFF )
GO



USE [Libertypower]
GO

/****** Object:  Index [idx__temp1]    Script Date: 10/22/2013 17:49:25 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND name = N'IDX_AccountPropertyHistory_FieldName')
DROP INDEX [IDX_AccountPropertyHistory_FieldName] ON [dbo].[AccountPropertyHistory] WITH ( ONLINE = OFF )
GO



USE [Libertypower]
GO

/****** Object:  Index [idx__temp1]    Script Date: 10/22/2013 17:49:25 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND name = N'IDX_AccountPropertyHistory_LockStatus')
DROP INDEX [IDX_AccountPropertyHistory_LockStatus] ON [dbo].[AccountPropertyHistory] WITH ( ONLINE = OFF )
GO



USE [Libertypower]
GO

/****** Object:  Index [idx__temp1]    Script Date: 10/22/2013 17:49:25 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountPropertyHistory]') AND name = N'IDX_AccountPropertyHistory_UtilityID_AccountNumber')
DROP INDEX [IDX_AccountPropertyHistory_UtilityID_AccountNumber] ON [dbo].[AccountPropertyHistory] WITH ( ONLINE = OFF )
GO

