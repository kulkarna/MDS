
CREATE PROC [dbo].[usp_ReasonCodeContractCheckListInsert] 
(@ContractNumber	varchar(12)
,@AccountNumber		varchar(30) = ''
,@Step				int
,@CheckListID		int
,@ReasonCodeID		int
)
AS 
BEGIN 

	INSERT INTO [LibertyPower].[dbo].[ReasonCodeContractCheckList]
		([ContractNumber]
		,[AccountNumber]
		,[Step]
		,[CheckListID]
		,[ReasonCodeID]
		,[DateCreated]
		)
     VALUES
		(@ContractNumber
		,@AccountNumber
		,@Step
		,@CheckListID
		,@ReasonCodeID
		,getdate()
		)
END 

