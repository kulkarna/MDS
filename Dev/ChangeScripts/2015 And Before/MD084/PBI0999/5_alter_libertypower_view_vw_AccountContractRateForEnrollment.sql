USE [LibertyPower]
GO

/****** Object:  View [dbo].[vw_AccountContractRateForEnrollment]    Script Date: 10/02/2012 17:30:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Modified by LAR at 10/17/2012 15:39:03 PBI 0999 ******/
/****** Just Select All records having IsContractedRate = 1,(acr.PriceID IS NOT NULL),(acr.PriceID <> 0)  and minimal RateStart date  ******/
ALTER VIEW [dbo].[vw_AccountContractRateForEnrollment]
AS
SELECT     acr.AccountContractRateID, acr.AccountContractID, acr.LegacyProductID, acr.Term, acr.RateID, acr.Rate, acr.RateCode, acr.RateStart, acr.RateEnd, 
                      acr.IsContractedRate, acr.HeatIndexSourceID, acr.HeatRate, acr.TransferRate, acr.GrossMargin, acr.CommissionRate, acr.AdditionalGrossMargin, acr.Modified, 
                      acr.ModifiedBy, acr.DateCreated, acr.CreatedBy, acr.PriceID, b.TotalTerm, b.MinRateStart, b.MaxRateEnd
FROM	dbo.AccountContractRate AS acr with (nolock)
INNER JOIN
            (
            SELECT     acr.AccountContractID, acr.IsContractedRate, acr.PriceId, MIN(acr.RateStart) AS MinRateStart, SUM(acr.Term) as TotalTerm, MAX(acr.RateEnd) as MaxRateEnd
            FROM          dbo.AccountContractRate AS acr with (nolock)
			WHERE (acr.PriceID IS NOT NULL) AND (acr.PriceID <> 0)
            GROUP BY acr.AccountContractID, acr.IsContractedRate, acr.PriceId
            ) 
            AS b ON b.AccountContractID = acr.AccountContractID and b.IsContractedRate = acr.IsContractedRate and b.PriceId = acr.PriceId 
				and b.MinRateStart=acr.RateStart 
WHERE (acr.PriceID IS NOT NULL) AND (acr.PriceID <> 0)


GO