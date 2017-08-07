USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_AccountSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_AccountSelect]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
CREATE PROCEDURE dbo.usp_AccountSelect @AccountNumber varchar( 50 )
AS 
BEGIN
	SET NOCOUNT ON;
	
	SELECT a.ID ,
          a.ACCOUNT_NUMBER ,
          a.ACCOUNT_ID ,
          a.MARKET ,
          a.UTILITY ,
          a.METER_TYPE ,
          a.RATE_CLASS ,
          a.VOLTAGE ,
          a.ZONE ,
          a.VAL_COMMENT ,
          ISNULL( a.TCAP , -1 )AS TCAP ,
          ISNULL( a.ICAP , -1 )AS ICAP ,
          a.LOAD_SHAPE_ID ,
          a.LOSSES ,
          a.ANNUAL_USAGE ,
          a.USAGE_DATE ,
          a.NAME_KEY ,
          CASE
          WHEN acc.AccountNumber IS NULL THEN 'false'
              ELSE 'true'
          END AS IsExisting
     FROM
          OE_ACCOUNT a WITH ( NOLOCK ) LEFT JOIN Libertypower..Utility u WITH ( NOLOCK )
          ON a.UTILITY
           = u.UtilityCode
                                       LEFT JOIN Libertypower..Account acc WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = acc.AccountNumber
         AND u.ID
           = acc.UtilityID
     WHERE a.ACCOUNT_NUMBER
         = @AccountNumber
     ORDER BY UTILITY , a.ACCOUNT_NUMBER;
     
     SET NOCOUNT OFF;
END

GO
