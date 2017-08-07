-- =============================================
-- Author:		Sadiel Jarvis
-- Create date: Feb 14th, 2013
-- Description:	Need to know if a contract has accounts still flowing
-- =============================================
CREATE FUNCTION [dbo].[ufn_ContractHasAccountsFlowing]
(
	@p_contract_nbr varchar(30)
)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	DECLARE @NumberOfAccounts int	
	
	/* If at least one EndDate is null or in the future, we have a contract with account(s) still flowing */
	SELECT     @NumberOfAccounts = count(AccountService.EndDate)
	FROM         Contract with (nolock) INNER JOIN
						  AccountContract with (nolock) ON Contract.ContractID = AccountContract.ContractID INNER JOIN
						  Account with (nolock) ON AccountContract.AccountID = Account.AccountID INNER JOIN
						  AccountService with (nolock) ON Account.AccountNumber = AccountService.account_id
	WHERE     (Contract.Number = @p_contract_nbr) and ((AccountService.EndDate is null) or (AccountService.EndDate > GetDate()))

	If @NumberOfAccounts > 0
	Begin
		Set @Result = 1
	End 
	Else 
	Begin	
		Set @Result = 0
	End	
	
	-- Returns 0 or 1
	Return @Result
END
