USE OfferEngineDB
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_ProspectAccountsSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_ProspectAccountsSelect]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************
 * usp_ProspectAccountsSelect
 * Select prospect account data for offer id
 *
 *******************************************************************************
 * 5/11/2009 - Rick Deigsler
 * Created.
 *
 * Modified 5/20/2010 - Rick Deigsler
 * Added offer id parameter to usp_NstarUtilityCodeUpdate call
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProspectAccountsSelect] @OfferId varchar( 50 )
AS
BEGIN
    SET NOCOUNT ON;
    -- SD Ticket 13295
    -- Updates utility code in offer engine with utility code in usage.
    -- Pricing uploads all NSTAR accounts as NSTAR-BOS.    
    EXEC usp_NstarUtilityCodeUpdate @OfferId;
    SELECT DISTINCT a.UTILITY ,
           p.CUSTOMER_NAME AS CustomerName ,
           a.ACCOUNT_NUMBER AS AccountNumber ,
           ad.ADDRESS AS ServiceAddress ,
           ad.Zip AS ZipCode ,
           a.RATE_CODE AS RateCode ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()) AS LoadProfile ,
           a.SUPPLY_GROUP AS SupplyGroup ,
           m.METER_NUMBER AS MeterNumber ,
           CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
           CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9))AS TCAP ,
           a.BILL_GROUP AS BillGroup ,
           a.STRATUM_VARIABLE AS StratumVariable ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()) AS VOLTAGE ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) AS ZONE ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()) AS RateClass ,
           o.OFFER_ID AS OfferId ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()) AS LoadShapeID ,
           Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()) AS MeterType ,
           a.MARKET AS RetailMarketCode ,
           a.IsIcapEsimated ,
           a.ID AS OE_ACCOUNT_ID,
           CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS Losses
      FROM
           OE_OFFER_ACCOUNTS o WITH ( NOLOCK ) INNER JOIN OE_ACCOUNT a WITH ( NOLOCK )
           ON o.oe_account_id
            = a.id
                                               LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH ( NOLOCK )
           ON a.ACCOUNT_NUMBER
            = ad.ACCOUNT_NUMBER
                                               INNER JOIN OE_PRICING_REQUEST_OFFER po WITH ( NOLOCK )
           ON po.OFFER_ID
            = o.OFFER_ID
                                               INNER JOIN OE_PRICING_REQUEST p WITH ( NOLOCK )
           ON p.REQUEST_ID
            = po.REQUEST_ID
                                               LEFT JOIN( 
                                                          SELECT TOP 1 ACCOUNT_NUMBER ,
                                                                       METER_NUMBER
                                                            FROM OE_ACCOUNT_METERS WITH ( NOLOCK ))m
           ON a.ACCOUNT_NUMBER
            = m.ACCOUNT_NUMBER
                                              
      WHERE o.OFFER_ID
          = @OfferId;
    SET NOCOUNT OFF;
END;

GO
