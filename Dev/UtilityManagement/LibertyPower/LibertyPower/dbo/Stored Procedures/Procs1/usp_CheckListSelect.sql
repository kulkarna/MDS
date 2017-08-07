
CREATE PROCEDURE [dbo].[usp_CheckListSelect]
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
	BEGIN
		SELECT CheckListID, [State], ROW_NUMBER() OVER(PARTITION BY CheckListID ORDER BY DateCreated DESC) as rownum
		INTO #CheckListContract
		FROM CheckListContract clc
		WHERE [ContractNumber] = @ContractNumber

		SELECT cl.*,clc.[State] 
		FROM CheckList cl (NOLOCK)
		LEFT JOIN #CheckListContract clc (NOLOCK) ON clc.[CheckListID] = cl.[CheckListID]
		WHERE cl.[Step] = @Step AND cl.[AccountType] = @AccountType AND cl.[Status] != 1 AND (clc.rownum = 1 OR clc.rownum is null)
		ORDER BY [Order]	
	END
		--SELECT *,
		--	   (SELECT TOP 1 clc.[State] 
		--		FROM CheckListContract clc
		--		WHERE [ContractNumber] = @ContractNumber
		--		  AND clc.[CheckListID] = cl.[CheckListID]
		--		ORDER BY clc.[DateCreated] DESC) [State]
		--FROM CheckList cl
		--WHERE [Step] = @Step
		--  AND [AccountType] = @AccountType
		--  AND [Status] != 1
		--ORDER BY [Order]
END