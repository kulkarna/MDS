create PROCEDURE [dbo].[usp_unsubmitted_deals_delete]
	@p_ContractNumber varchar(50)
AS
BEGIN
	begin transaction

	delete from lp_deal_capture..deal_contract
	where contract_nbr = @p_ContractNumber

	delete from lp_deal_capture..deal_contract_account
	where contract_nbr = @p_ContractNumber

	delete from lp_deal_capture..deal_name
	where contract_nbr = @p_ContractNumber

	delete from lp_contract_renewal..deal_contract
	where contract_nbr = @p_ContractNumber

	delete from lp_contract_renewal..deal_contract_account
	where contract_nbr = @p_ContractNumber

	delete from lp_contract_renewal..deal_name
	where contract_nbr = @p_ContractNumber

	commit transaction
END



