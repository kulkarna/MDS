-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/28/2012
-- Description:	Added as means to get rates related to a deal
-- =============================================
/*

EXEC Libertypower..usp_AccountContractRateSelectByAccountContractNumber '7130438138', '2012-0011548'
219798



*/

CREATE PROCEDURE [dbo].[usp_AccountContractRateSelectByAccountContractNumber]
	-- Add the parameters for the stored procedure here
	@AccountNumber VARCHAR(50) = NULL,
	@ContractNumber VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select acr.* 
	from LibertyPower..AccountContract ac (nolock)
	join LibertyPower..Account a (nolock) on ac.AccountID = a.AccountID
	join LibertyPower..[Contract] c (nolock) on ac.ContractID = c.ContractID
	join LibertyPower..AccountContractRate acr (nolock) on ac.AccountContractID = acr.AccountContractID
	where a.AccountNumber = @AccountNumber
	and c.Number = @ContractNumber


END
