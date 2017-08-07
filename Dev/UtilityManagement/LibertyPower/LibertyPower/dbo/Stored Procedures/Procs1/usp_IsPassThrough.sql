
Create PROCEDURE [dbo].[usp_IsPassThrough]
	@AccountNumber nvarchar(50)	
as

Select
	Top 1 DealPricingDetail.HasPassThrough
From	
	LibertyPower.dbo.Account Account with (nolock) 
	Inner Join LibertyPower.dbo.AccountContract AccountContract with (nolock) 
	ON Account.AccountID = AccountContract.AccountID
	Inner Join LibertyPower.dbo.[Contract] [Contract] with (nolock) 
	ON Account.CurrentContractID = [Contract].ContractID 
	Inner Join LibertyPower.dbo.AccountContractRate AccountContractRate with (nolock) 
	ON AccountContract.AccountContractID = AccountContractRate.AccountContractID
	Inner Join lp_deal_capture.dbo.deal_pricing_detail DealPricingDetail with (nolock) 
	ON AccountContractRate.LegacyProductID = DealPricingDetail.product_id and AccountContractRate.rateid = DealPricingDetail.rate_id
Where 
	Account.AccountNumber = @AccountNumber
Order By
	AccountContractRate.AccountContractRateID Desc