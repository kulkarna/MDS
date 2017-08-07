-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of contracts related to an account
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintContractsByAccountIdSelect]
(
	@accountID int
)
As

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DISTINCT ContractID
INTO #Contracts
FROM AccountContract
WHERE ContractID = @accountID

SELECT	c.ContractID,
		c.Number AS ContractNumber,
		c.ContractTypeID, 
		ct.Type AS ContractType, 
		c.ContractStatusID, 
		cs.Descp AS ContractStatus, 
		c.StartDate, 
		c.EndDate, 
		c.SalesChannelID,
		sc.ChannelName,
		c.SalesRep
FROM	dbo.Contract c
		INNER JOIN dbo.ContractType ct ON c.ContractTypeID = ct.ContractTypeID 
        INNER JOIN dbo.ContractStatus cs ON c.ContractStatusID = cs.ContractStatusID 
        INNER JOIN dbo.SalesChannel sc ON c.SalesChannelID = sc.ChannelID
WHERE c.ContractID IN (SELECT ContractID FROM #Contracts)


DROP TABLE #Contracts
