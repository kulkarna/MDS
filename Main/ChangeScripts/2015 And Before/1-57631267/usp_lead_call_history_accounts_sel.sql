

USE [Lp_Enrollment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sadiel Jarvis
-- Create date: Feb 14, 2013
-- Description:	Retrieves a list of accounts given a contract number
-- =============================================
CREATE PROCEDURE [dbo].[usp_lead_call_history_accounts_sel]
	@p_contract_nbr varchar(30)
AS	
	SELECT
		lpa.retail_mkt_id as Market, 
		SUBSTRING(lpa.SalesChannelID, 15, LEN(lpa.SalesChannelID)) as SalesChannel, 
		lpa.AccountNumber,		
		lpu.FullName as Utility,
		lpa.Zone,
		lpa.service_rate_class as ServiceClass,
		lpa.ContractTerm,
		convert(char,lpa.contract_eff_start_date,101) ContractDate,
		convert(char,lpa.date_end,101) ContractEndDate,
		b.Name as ProductDescription,
		lpa.rate_id AS RateID,
		ACR.Rate as PriceRate,
		AccountStatus AS Status,
		lpus.AnnualUsage
                                                   
    FROM          LibertyPower.dbo.Contract AS lpc WITH (nolock) INNER JOIN
                           LibertyPower.dbo.AccountContract AS lpac WITH (nolock) ON lpc.ContractID = lpac.ContractID INNER JOIN
                           libertypower.dbo.account AS A WITH (NOLOCK) ON lpac.AccountID = A.AccountID /*and a.CurrentContractID = lpac.ContractID*/ INNER JOIN
                           [lp_account].[dbo].[tblAccounts_vw] AS lpa WITH (nolock) ON A.AccountidLegacy = lpa.Account_id INNER JOIN
                           LibertyPower.dbo.Utility AS lpu WITH (nolock) ON lpa.Utility = lpu.UtilityCode 
                           LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
										   FROM LibertyPower.dbo.AccountContractRate ACRR     WITH (NOLOCK)
										 GROUP BY ACRR.AccountContractID
									  ) ACRR2 ON ACRR2.AccountContractID = lpac.AccountContractID
							JOIN LibertyPower..AccountContractRate acr (nolock) ON ACRR2.AccountContractRateID = acr.AccountContractRateID 
							JOIN lp_common..common_product p (nolock) ON acr.LegacyProductID = p.product_id INNER JOIN
                           Libertypower..ProductBrand b WITH (NOLOCK) ON P.ProductBrandID = b.ProductBrandID INNER JOIN						                         
                           LibertyPower.dbo.AccountUsage lpus WITH (NOLOCK) ON lpus.AccountID = A.AccountID and lpc.StartDate = lpus.EffectiveDate
WHERE     lpc.Number = @p_contract_nbr
GO