
CREATE PROCEDURE [dbo].[usp_ReasonCodeContractCheckListClear]
(@ContractNumber	varchar(12)
,@AccountNumber		varchar(30) = ''
,@Step              int
,@CheckListID		int
,@ClearAccounts		int = 0)
AS
BEGIN
	IF (@AccountNumber <> '')		
		DELETE
		FROM  ReasonCodeContractCheckList 
		WHERE ContractNumber = @ContractNumber
		AND	  AccountNumber  = @AccountNumber
		AND	  Step			 = @Step
		AND	  CheckListID	 = @CheckListID
		
	ELSE
		IF (@ClearAccounts = 1)
			DELETE
			FROM  ReasonCodeContractCheckList 
			WHERE ContractNumber = @ContractNumber
			AND	  Step			 = @Step
			AND	  CheckListID	 = @CheckListID
			AND   AccountNumber  <> ''
		ELSE
			DELETE
			FROM  ReasonCodeContractCheckList 
			WHERE ContractNumber = @ContractNumber
			AND	  Step			 = @Step
			AND	  CheckListID	 = @CheckListID
			AND   AccountNumber  = ''
END