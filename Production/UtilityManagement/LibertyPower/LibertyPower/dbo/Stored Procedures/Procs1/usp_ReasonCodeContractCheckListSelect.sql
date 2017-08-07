
CREATE PROCEDURE [dbo].[usp_ReasonCodeContractCheckListSelect]
(@ContractNumber	varchar(12)
,@AccountNumber		varchar(30) = ''
,@Step              int
,@CheckListID		int)
AS
BEGIN
	SELECT ReasonCodeID
	FROM  ReasonCodeContractCheckList 
	WHERE ContractNumber = @ContractNumber
	AND	  AccountNumber  = @AccountNumber
	AND	  Step			 = @Step
	AND	  CheckListID	 = @CheckListID
END