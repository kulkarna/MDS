USE LibertyPower
GO

CREATE VIEW [dbo].[vw_AccountContractRate]
AS

-- This view will replace the table AccountContractRate when we want to get the contracted rate for an account
-- This View will return the CURRENT contracted rate, along with the TOTAL term for the whole contract length, 
--	The MIN rate start date of the whole contract length and the MAX rate end date of the whole contract length.
-- Depending on when the view will be ran, we will get a different rate value
-- This view is implemented as part of the Multi term project because:
--		1. a multi term account, will have multiple contracted rates in the table AccountContractRate
--		2. Having the multiple rates, will mess up almost every SP/Function/View 
--			that joins to the table AccountContractRate as most of them relies on the fact that there is only ONE contracted rate
--		3. This view will return the data only for the contracted rates. 
--			Variable rates will still be handled the way they are now in each SP/Function/View 

-- FIRST: get the account contract rates that are not flowing yet: the min start date is in the future. For those return the first rate

SELECT	acr.AccountContractRateID, 
        acr.AccountContractID, 
        acr.LegacyProductID, 
        b.Term, 
        acr.RateID, 
        acr.Rate, 
        acr.RateCode, 
        b.RateStart, 
        b.RateEnd,
        acr.IsContractedRate, 
        acr.HeatIndexSourceID, 
        acr.HeatRate, 
        acr.TransferRate, 
        acr.GrossMargin, 
        acr.CommissionRate, 
        acr.AdditionalGrossMargin, 
        acr.Modified,
        acr.ModifiedBy, 
        acr.DateCreated, 
        acr.CreatedBy, 
        acr.PriceID,
        acr.Term as CurrentTerm,
        acr.RateStart as CurrentRateStart,
		acr.RateEnd as CurrentRateEnd
FROM	dbo.AccountContractRate AS acr (nolock)
INNER	JOIN (
                  SELECT	acr1.AccountContractID, 
							MIN(acr1.RateStart) AS RateStart, 
							SUM(acr1.Term) as Term, 
							MAX(acr1.RateEnd) as RateEnd
                  FROM		dbo.AccountContractRate AS acr1 (nolock)
                  WHERE		acr1.IsContractedRate = 1
                  GROUP		BY 
                            acr1.AccountContractID
                  ) AS b 
ON      b.AccountContractID = acr.AccountContractID
WHERE 	acr.IsContractedRate = 1
AND 	1 = CASE 
  						WHEN b.RateStart >= GETDATE() AND b.RateStart = acr. RateStart THEN 1
  						WHEN (b.RateStart < GETDATE()AND b.RateEnd >= GETDATE()) AND (acr.RateStart < GETDATE() AND acr.RateEnd >= GETDATE()) THEN 1
  						WHEN b.RateEnd   < GETDATE() AND b.RateEnd = acr.RateEnd THEN 1
						ELSE 0
			END  
