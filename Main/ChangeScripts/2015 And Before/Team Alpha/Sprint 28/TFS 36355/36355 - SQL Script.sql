USE [LibertyPower]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannel' AND COLUMN_NAME = 'Tablet')
Alter table LibertyPower..[SalesChannel] add  Tablet  int not null DEFAULT (0)
go
update LibertyPower..[SalesChannel] set tablet=1 where ChannelName in ('EG1','IMC','NYM','NYMIL','USD', 'NYMCT','TMM','CMG','UTY','TRM')
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_GetTabletSalesChannels' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_GetTabletSalesChannels;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_GetTabletSalesChannels]
 * PURPOSE:		Get the list of sales channels supported by tablets.
 * HISTORY:		
 *******************************************************************************
 * 4/4/2014 - Pradeep Katiyar
 * Created.
 */

CREATE PROCEDURE [dbo].[usp_GetTabletSalesChannels] 
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

select SC.*
	from LibertyPower..SalesChannel SC  WITH (NoLock) 
		where SC.Tablet=1 order by SC.ChannelName
              
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power