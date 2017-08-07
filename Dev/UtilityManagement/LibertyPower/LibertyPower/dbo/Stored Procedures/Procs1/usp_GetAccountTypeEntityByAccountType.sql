-- =============================================
-- Author:		Lev A. Rosenblum
-- Create date: 11/09/2012
-- Description:	Get accountType entity by AccountType
-- =============================================
CREATE PROCEDURE dbo.usp_GetAccountTypeEntityByAccountType
	@AccountType varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT [ID]
		  ,[AccountType]
		  ,[Description]
		  ,[AccountGroup]
		  ,[DateCreated]
		  ,[ProductAccountTypeID]
	  FROM [Libertypower].[dbo].[AccountType]
	  WHERE [AccountType]=@AccountType
END
