-- =============================================
-- Author:		Lev Rosenblum
-- Create date: <01/15/2013>
-- Description:	Overrides rates into dbo.deal_contract_account table
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_account_override_rates]
(
	@ContractNumber                                 char(12)
	, @AccountNumber                                varchar(30)
	, @Rate                                         float
	, @RatesString									varchar(200)
)
AS
BEGIN
	UPDATE dbo.deal_contract_account
	SET rate=@Rate, RatesString=@RatesString
	WHERE account_number=@AccountNumber and contract_nbr=@ContractNumber

END
