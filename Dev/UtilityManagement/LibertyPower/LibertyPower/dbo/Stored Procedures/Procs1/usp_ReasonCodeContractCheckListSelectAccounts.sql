
CREATE PROCEDURE [dbo].[usp_ReasonCodeContractCheckListSelectAccounts]
(@ContractNumber	varchar(12)
,@Step              int
,@CheckListID		int)
AS
BEGIN
	SELECT ReasonCodeID
	FROM  ReasonCodeContractCheckList 
	WHERE ContractNumber = @ContractNumber
	AND	  Step			 = @Step
	AND	  CheckListID	 = @CheckListID
	AND   AccountNumber  <> ''
END