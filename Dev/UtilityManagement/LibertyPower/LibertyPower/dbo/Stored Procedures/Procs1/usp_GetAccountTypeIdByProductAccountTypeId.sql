-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 2/14/2013
-- Description:	Get AccountTypeId By ProductAccountTypeId
-- =============================================
CREATE PROCEDURE dbo.usp_GetAccountTypeIdByProductAccountTypeId 
	@ProductAccountTypeId int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT [ID]
    FROM dbo.AccountType with (nolock)
    WHERE ProductAccountTypeId=@ProductAccountTypeId
END
