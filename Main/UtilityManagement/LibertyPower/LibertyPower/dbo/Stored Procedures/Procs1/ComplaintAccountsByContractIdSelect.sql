-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of accounts related to a contract
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountsByContractIdSelect]
(
	@ContractID int
)
As

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT  a.AccountID, 
		a.AccountIdLegacy, 
		a.AccountNumber,
		a.CurrentContractID,
		ac.ContractID,
		ac.AccountContractID,
		c.Number As ContractNumber,
		a.AccountTypeID,
		at.AccountType As AccountTypeCode,
		at.Description AS AccountTypeName, 
        a.RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp, 
        dbo.Name.Name, 
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		acr.AccountContractRateID, 
		dbo.AccountUsage.AnnualUsage,
		[dbo].[ufn_GetLegacyAccountStatus](acs.[Status], acs.SubStatus) AS EnrollmentStatus,
		[dbo].[ufn_GetLegacyFlowStartDate](acs.[Status], acs.SubStatus, als.StartDate) as FlowStartDate,
		als.EndDate As DeenrollmentDate,
		acr.Term,
		acr.Rate, 
		acs.[Status], 
		acs.SubStatus
FROM	dbo.AccountContract ac 
		INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID AND a.CurrentContractID = ac.ContractID 
		LEFT JOIN dbo.Name ON a.AccountNameID = dbo.Name.NameID 
		INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID 
		LEFT JOIN dbo.Address ad ON a.ServiceAddressID = ad.AddressID 
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
		INNER JOIN dbo.Market as m ON a.RetailMktID = m.ID 
		LEFT JOIN dbo.AccountStatus acs ON ac.AccountContractID = acs.AccountContractID 
		INNER JOIN dbo.Contract c ON ac.ContractID = c.ContractID AND a.CurrentContractID = c.ContractID 
		LEFT OUTER JOIN dbo.AccountUsage ON a.AccountID = dbo.AccountUsage.AccountID AND dbo.AccountUsage.EffectiveDate = c.StartDate 
		LEFT OUTER JOIN dbo.AccountLatestService als ON a.AccountID = als.AccountID 
		LEFT OUTER JOIN dbo.AccountContractRate as acr ON ac.AccountContractID = acr.AccountContractID AND acr.IsContractedRate = 1 
		INNER JOIN dbo.SalesChannel ON c.SalesChannelID = SalesChannel.ChannelID
WHERE	ac.ContractID = @ContractID
ORDER BY a.AccountNumber
