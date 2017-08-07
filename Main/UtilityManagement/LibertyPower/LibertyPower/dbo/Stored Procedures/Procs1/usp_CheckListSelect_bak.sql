
CREATE PROCEDURE [dbo].[usp_CheckListSelect_bak]
(@Step              int,
 @AccountType		int,
 @ContractNumber	char(12) = '')
AS
BEGIN
	IF @ContractNumber = ''
		SELECT *
		FROM  CheckList
		WHERE Step			= @Step
		  AND AccountType	= @AccountType
		ORDER BY [Order]
	ELSE
		SELECT *,
			   (SELECT TOP 1 clc.[State] 
				FROM CheckListContract clc
				WHERE [ContractNumber] = @ContractNumber
				  AND clc.[CheckListID] = cl.[CheckListID]
				ORDER BY clc.[DateCreated] DESC) [State]
		FROM CheckList cl
		WHERE [Step] = @Step
		  AND [AccountType] = @AccountType
		  AND [Status] != 1
		ORDER BY [Order]
END