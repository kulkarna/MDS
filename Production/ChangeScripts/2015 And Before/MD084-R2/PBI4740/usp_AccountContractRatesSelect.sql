Use lp_commissions
GO 

CREATE PROC usp_AccountContractRatesSelect
( @p_account_id varchar(50)
 , @p_contract_nbr varchar(50)
 ) 
AS
BEGIN 

			--declare @p_account_id varchar(50)
			--declare @p_contract_nbr varchar(50)

			--set @p_account_id = '2013-0009314'
			--set @p_contract_nbr = '2013-0008778'

			-- acct				contr
			--4917822667	2013-0008778

			--AccountIdLegacy	Number
			--2013-0009314	2013-0008778
			-- 2013-0016878	2013-0015309
			-- 2013-0018126	2013-0013277

	SELECT a.AccountID 
		, a.AccountNumber
		, a.AccountIdLegacy
		, c.Number
		, c.ContractID 
		, acr.AccountContractRateID 
		, acr.AccountContractID
		, PriceID = acr.PriceID 
		, Price = case when pr.ProductTypeid = 7 then pcpm.Price else pr.price end
		, c.ContractStatusID 
		, acr.ProductCrossPriceMultiId
		, acr.LegacyProductID
		, acr.Term
		, acr.RateID
		, acr.Rate
		, acr.RateStart
		, acr.RateEnd
		, acr.IsContractedRate
		, acr.TransferRate
		, acr.PriceID
		
	FROM LibertyPower.dbo.Account a (NOLOCK) 
		LEFT JOIN LibertyPower.dbo.AccountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
		LEFT JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
		LEFT JOIN LibertyPower.dbo.AccountContractRate acr (NOLOCK) ON acr.AccountContractID = ac.AccountContractID -- AND acr.IsContractedRate = 1
		LEFT JOIN LibertyPower.dbo.Price pr (NOLOCK) ON pr.id = acr.priceid
		LEFT JOIN LibertyPower.dbo.ProductCrossPriceMulti pcpm (NOLOCK) ON acr.ProductCrossPriceMultiId = pcpm.ProductCrossPriceMultiId

	WHERE 1 = 1 
		AND a.AccountIdLegacy = @p_account_id 
		AND c.Number = @p_contract_nbr 
	
END 
GO