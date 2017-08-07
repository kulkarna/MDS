Create PROCEDURE [dbo].usp_CustomersBySalesChannelIDSelect
	@SalesChannelID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select
		Customer.*
	From
		LibertyPower.dbo.Customer Customer
		Inner Join LibertyPower.dbo.Account Account with (nolock) On Account.CustomerID = Customer.CustomerID
		Inner Join LibertyPower.dbo.AccountContract AccountContract with (nolock) On AccountContract.AccountID = Account.AccountID
		Inner Join LibertyPower.dbo.[Contract] [Contract] with (nolock) On AccountContract.ContractID = [Contract].ContractID
	Where
		[Contract].SalesChannelID = @SalesChannelID
END

