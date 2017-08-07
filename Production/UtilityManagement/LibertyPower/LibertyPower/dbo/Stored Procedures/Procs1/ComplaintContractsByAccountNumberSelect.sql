-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of contracts related to an account
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintContractsByAccountNumberSelect] 
	@accountNumber varchar(30)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @accountID int
	SET @accountID = (SELECT TOP 1 AccountID FROM Account (nolock) WHERE AccountNumber = @accountNumber)

    EXEC [dbo].[ComplaintContractsByAccountIdSelect] @accountID = @accountID
END
