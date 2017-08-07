USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_accounts_by_offer_id_sel]    Script Date: 01/21/2014 17:17:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_accounts_by_offer_id_sel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_accounts_by_offer_id_sel]
GO

USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_accounts_by_offer_id_sel]    Script Date: 01/21/2014 17:17:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description: 
--
-- Modified 10/27/2010 - Rick Deigsler
-- Added IsExisting to select	
-- Modified 1/21/2014 - Jikku Joseph John
-- Added Future icaps and tcaps as return value
-- =============================================
CREATE PROCEDURE [dbo].[usp_accounts_by_offer_id_sel]

@p_offer_id		varchar(50)

AS
BEGIN
SET NOCOUNT ON;

SELECT		a.ID, 
			ISNULL(a.BillingAccountNumber,'') AS BillingAccountNumber, 
			ISNULL(a.ACCOUNT_NUMBER,'') AS ACCOUNT_NUMBER, 
			ISNULL(a.ACCOUNT_ID,'') AS ACCOUNT_ID, 
			ISNULL(a.MARKET,'') AS MARKET, 
			ISNULL(a.UTILITY,'') AS UTILITY, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'MeterType',GETDATE()),'') AS METER_TYPE, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'RateClass',GETDATE()),'') AS RATE_CLASS, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Voltage',GETDATE()),'') AS VOLTAGE, 
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Zone',GETDATE()) ,'') AS ZONE, 
			ISNULL(a.VAL_COMMENT,'') AS VAL_COMMENT, 
			CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Tcap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS TCAP, 
			CAST(ISNULL( Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'ICap',GETDATE()) , -1 ) AS DECIMAL(18,9)) AS ICAP,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadShapeID',GETDATE()),'') AS LOAD_SHAPE_ID,  
			CAST(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LossFactor',GETDATE()) AS DECIMAL(18,9)) AS LOSSES, 
			ISNULL(a.ANNUAL_USAGE,0) AS ANNUAL_USAGE,
			USAGE_DATE,
			CASE WHEN acc.AccountNumber IS NULL THEN 'false' ELSE 'true' END AS IsExisting,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'TariffCode',GETDATE()),'') AS TarrifCode,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LoadProfile',GETDATE()),'') AS LOAD_PROFILE,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'Grid',GETDATE()),'') AS Grid,
			ISNULL(Libertypower.dbo.GetDeterminantValue(a.UTILITY,a.ACCOUNT_NUMBER,'LbmpZone',GETDATE()),'') AS LbmpZone,
			FutrIcap.FieldValue AS FutureIcap,
          	FutrIcap.EffectiveDate AS FutureIcapEffectiveDate,
          	FutrTcap.FieldValue AS FutureTcap,
          	FutrTcap.EffectiveDate AS FutureTcapEffectiveDate,
			ISNULL(a.IsAnnualUsageEstimated, 0) AS IsAnnualUsageEstimated,
			ISNULL(a.EstimatedAnnualUsage, 0) AS EstimatedAnnualUsage	
FROM		OE_ACCOUNT a WITH (NOLOCK) 
			INNER JOIN dbo.OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
			LEFT JOIN Libertypower.dbo.Utility u WITH (NOLOCK) ON a.UTILITY = u.UtilityCode
			LEFT JOIN Libertypower.dbo.Account acc WITH (NOLOCK) ON a.ACCOUNT_NUMBER = acc.AccountNumber and u.ID = acc.UtilityID
			
			outer  apply (
			SELECT top 1 FieldValue ,
					   CAST(EffectiveDate AS Date) As EffectiveDate 
					   FROM libertypower..AccountPropertyHistory WITH (NOLOCK)
				  WHERE UtilityID = a.UTILITY
					AND AccountNumber = a.ACCOUNT_NUMBER
					AND FieldName = 'Icap'
					AND CAST(EffectiveDate AS Date) > GetDate()
					AND Active = 1
				  ORDER BY AccountPropertyHistoryID DESC
				  ) FutrIcap
			outer  apply (
			SELECT top 1 FieldValue ,
					   CAST(EffectiveDate AS Date) As EffectiveDate
				  FROM libertypower..AccountPropertyHistory WITH (NOLOCK)
				  WHERE UtilityID = a.UTILITY
					AND AccountNumber = a.ACCOUNT_NUMBER
					AND FieldName = 'Tcap'
					AND CAST(EffectiveDate AS Date) > GetDate()
					AND Active = 1
				  ORDER BY AccountPropertyHistoryID DESC
				  ) FutrTcap     
WHERE		b.OFFER_ID = @p_offer_id
ORDER BY	a.UTILITY, a.ACCOUNT_NUMBER

SET NOCOUNT OFF;
END


GO


