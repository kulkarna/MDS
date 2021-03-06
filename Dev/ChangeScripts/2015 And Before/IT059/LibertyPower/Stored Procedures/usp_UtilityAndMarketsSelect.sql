USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UtilityAndMarketsSelect]    Script Date: 07/13/2013 14:15:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UtilityAndMarketsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_UtilityAndMarketsSelect]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_UtilityAndMarketsSelect]    Script Date: 07/13/2013 14:15:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * LibertyPower.dbo.usp_UtilityAndMarketsSelect
 * Gets active utilities
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityAndMarketsSelect]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.ID AS UtilityID ,
           u.UtilityCode ,
           m.ID AS RetailMarketID ,
           m.MarketCode ,
           w.WholesaleMktId
      FROM
           libertypower..Utility u WITH ( NOLOCK ) JOIN libertypower..Market m WITH ( NOLOCK )
           ON u.MarketID = m.ID
                                                   JOIN libertypower..WholesaleMarket w WITH ( NOLOCK )
           ON w.ID = m.WholesaleMktId
      WHERE m.InactiveInd = 0
      ORDER BY u.UtilityCode;
    SET NOCOUNT OFF;
END;

GO


