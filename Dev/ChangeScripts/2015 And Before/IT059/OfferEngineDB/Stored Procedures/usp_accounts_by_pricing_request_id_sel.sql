USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_accounts_by_pricing_request_id_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_accounts_by_pricing_request_id_sel]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
-- Author:		Maurício Nogueira
-- Create date: 7/19/2010
-- Description:	
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- =============================================
CREATE PROCEDURE dbo.usp_accounts_by_pricing_request_id_sel @p_pricing_request_id varchar( 50 )
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT a.ID ,
          ISNULL( a.BillingAccountNumber , '' )AS BillingAccountNumber ,
          -- INF83 TR006 / 05/08/2009 hbm
          a.ACCOUNT_NUMBER ,
          ISNULL( a.ACCOUNT_ID , '' )AS ACCOUNT_ID ,
          ISNULL( a.MARKET , '' )AS MARKET ,
          ISNULL( a.UTILITY , '' )AS UTILITY ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()),'') AS METER_TYPE ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()),'') AS RATE_CLASS, 
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()),'') AS VOLTAGE, 
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) ,'') AS ZONE, 
          ISNULL( a.VAL_COMMENT , '' )AS VAL_COMMENT ,
          CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS TCAP, 
		  CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
		  ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()),'') AS LOAD_SHAPE_ID,  
		  CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS LOSSES, 
          ISNULL( a.ANNUAL_USAGE , 0 )AS ANNUAL_USAGE ,
          USAGE_DATE ,
          ISNULL( c.METER_NUMBER , '' )AS METER_NUMBER ,
          ISNULL( d.ADDRESS , '' )AS ADDRESS ,
          ISNULL( d.SUITE , '' )AS SUITE ,
          ISNULL( d.CITY , '' )AS CITY ,
          ISNULL( d.STATE , '' )AS STATE ,
          ISNULL( d.ZIP , '' )AS ZIP ,
          CASE
          WHEN acc.AccountNumber IS NULL THEN 'false'
              ELSE 'true'
          END AS IsExisting ,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'TariffCode',GETDATE()),'') AS TarrifCode,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()),'') AS LOAD_PROFILE,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Grid',GETDATE()),'') AS Grid,
          ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LbmpZone',GETDATE()),'') AS LbmpZone,
          ISNULL( a.NAME_KEY , '' )AS NAME_KEY ,
          ISNULL( acc.EntityID , '' )AS EntityID ,
          ISNULL( a.IsAnnualUsageEstimated , 0 )AS IsAnnualUsageEstimated ,
          ISNULL( a.EstimatedAnnualUsage , 0 )AS EstimatedAnnualUsage
     FROM
          OE_ACCOUNT a WITH ( NOLOCK ) INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS b WITH ( NOLOCK )
          ON a.ID
           = b.OE_ACCOUNT_ID
                                       LEFT OUTER JOIN dbo.OE_ACCOUNT_METERS c WITH ( NOLOCK )
          ON b.OE_ACCOUNT_ID
           = c.OE_ACCOUNT_ID
                                       LEFT OUTER JOIN dbo.OE_ACCOUNT_ADDRESS d WITH ( NOLOCK )
          ON b.OE_ACCOUNT_ID
           = d.OE_ACCOUNT_ID
                                       LEFT JOIN Libertypower.dbo.Utility u WITH ( NOLOCK )
          ON a.UTILITY
           = u.UtilityCode
                                       LEFT JOIN Libertypower.dbo.Account acc WITH ( NOLOCK )
          ON a.ACCOUNT_NUMBER
           = acc.AccountNumber
         AND u.ID
           = acc.UtilityID
     WHERE b.PRICING_REQUEST_ID
         = @p_pricing_request_id
     ORDER BY a.UTILITY , a.ACCOUNT_NUMBER;

	SET NOCOUNT OFF;
END
GO