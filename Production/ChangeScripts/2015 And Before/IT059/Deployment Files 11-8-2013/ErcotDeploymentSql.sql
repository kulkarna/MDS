USE [ERCOT]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountInfoAccountsSelect]    Script Date: 11/12/2013 16:33:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountInfoAccountsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountInfoAccountsSelect]
GO

USE [ERCOT]
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountInfoAccountsSelect]    Script Date: 11/12/2013 16:33:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************  usp_AccountInfoAccountsSelect *********************************/
CREATE Procedure [dbo].[usp_AccountInfoAccountsSelect]
	@AccountNumber VARCHAR(100)

AS

BEGIN

SELECT	distinct a.*, m.OEZone
FROM	AccountInfoAccounts a
INNER	JOIN AccountInfoSettlement b
ON		a.STATIONCODE = b.Substation
INNER	JOIN AccountInfoZoneMapping m
ON		b.SettlementLoadZone = m.ErcotZone
WHERE	a.ESIID = @AccountNumber
			 
END


GO


