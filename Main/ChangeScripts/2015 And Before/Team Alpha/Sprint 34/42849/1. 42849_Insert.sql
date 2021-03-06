USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_TabletDataCacheInsertforCacheItem]    Script Date: 06/23/2014 13:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************

* PROCEDURE:     [usp_TabletDataCacheInsertforCacheItem]
* PURPOSE:       Insert the Cache data for Tablet 
* HISTORY:       
*******************************************************************************
* 3/19/2013 - Pradeep Katiyar
* Created.
*******************************************************************************
6/23/2014  Sara modified 
Added ExpirationDate, input Parameter for procedure  [usp_TabletDataCacheInsertforCacheItem]
****************************************************************************************************
*/

ALTER PROCEDURE [dbo].[usp_TabletDataCacheInsertforCacheItem] 
      @p_TabletDataCacheItemID int,
      @p_ChannelId int,
      @p_HashValue Uniqueidentifier,
      @p_DateModified Datetime,
      @p_CreatedDate datetime,
      @p_ExpirationDate datetime = null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

Begin
      insert into LibertyPower..TabletDataCache(TabletDataCacheItemID,ChannelID,HashValue,DateModified,CreatedDate, ExpirationDate) 
            select @p_TabletDataCacheItemID,@p_ChannelId,@p_HashValue,@p_DateModified,@p_CreatedDate ,@p_ExpirationDate

End
            
Set NOCOUNT OFF;
END



