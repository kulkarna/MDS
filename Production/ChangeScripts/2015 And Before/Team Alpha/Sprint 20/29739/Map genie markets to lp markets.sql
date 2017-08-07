USE GENIE
GO

--To generate the update scripts, run this
--SELECT DISTINCT 'UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = ' + CAST(LPM.ID as nvarchar) + ' WHERE [MarketID] = ' + CAST(M.MarketID as nvarchar) + ';' [SCRIPT]
      
--  FROM [GENIE].[dbo].[LK_Market] M
--  INNER JOIN LibertyPower..Market LPM ON LPM.MarketCode = M.MarketCode
--  WHERE LPM.InactiveInd = 0

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO



if  COL_LENGTH('dbo.LK_Market', 'LPMarketID') IS NULL
BEGIN
ALTER TABLE dbo.LK_Market ADD
	LPMarketID int NOT NULL CONSTRAINT DF_LK_Market_LPMarketID DEFAULT 0;
	
ALTER TABLE dbo.LK_Market SET (LOCK_ESCALATION = TABLE);

END
GO

UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 1 WHERE [MarketID] = 1;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 10 WHERE [MarketID] = 10;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 11 WHERE [MarketID] = 11;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 12 WHERE [MarketID] = 12;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 13 WHERE [MarketID] = 13;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 16 WHERE [MarketID] = 15;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 2 WHERE [MarketID] = 2;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 3 WHERE [MarketID] = 3;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 4 WHERE [MarketID] = 4;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 5 WHERE [MarketID] = 5;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 6 WHERE [MarketID] = 6;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 7 WHERE [MarketID] = 7;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 8 WHERE [MarketID] = 8;
UPDATE [GENIE].[dbo].[LK_Market] SET [LPMarketID] = 9 WHERE [MarketID] = 9;

COMMIT
GO

