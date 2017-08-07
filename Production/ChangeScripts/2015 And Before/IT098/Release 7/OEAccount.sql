USE [Lp_transactions]
GO

/****** Object:  View [dbo].[OEAccount]    Script Date: 07/09/2013 15:50:29 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[OEAccount]'))
DROP VIEW [dbo].[OEAccount]
GO

USE [Lp_transactions]
GO

/****** Object:  View [dbo].[OEAccount]    Script Date: 07/09/2013 15:50:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET NOCOUNT ON;
GO

--Create new view to LibertyPower Utilities table.
CREATE VIEW [dbo].[OEAccount]
AS
SELECT     *
FROM         OfferEngineDB.dbo.OE_ACCOUNT (NOLOCK)

GO

SET NOCOUNT OFF
GO


GO
