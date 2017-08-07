-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of accounts, either customers of LP, or non-customers who filed a complaint
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountsByNumberOrIDSelect]
(
	@AccountNumber varchar(30) = NULL,
	@AccountID int
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
		c.SignedDate As ContractDate,
		a.AccountTypeID,
		at.AccountType As AccountTypeCode,
		at.Description AS AccountTypeName, 
        a.RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp, 
        dbo.Name.Name, 
        ad.Address1,
        ad.City,
        ad.[State],
        ad.Zip,
        '' AS Phone,
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		dbo.AccountContractRate.AccountContractRateID, 
		dbo.AccountUsage.AnnualUsage,
		[dbo].[ufn_GetLegacyAccountStatus](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus) AS EnrollmentStatus,
		[dbo].[ufn_GetLegacyFlowStartDate](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus, dbo.AccountLatestService.StartDate) as FlowStartDate,
		[dbo].[ufn_GetLegacyDateDeenrollment](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus, dbo.AccountLatestService.EndDate) AS DeenrollmentDate,
		(SELECT COUNT(*) FROM dbo.Account a1 WHERE a1.CurrentContractID = a.CurrentContractID) As NumberOfAccounts,
		AccountContractRate.Term,
		AccountContractRate.Rate, 
		dbo.AccountStatus.Status, 
		dbo.AccountStatus.SubStatus,
		c.SalesChannelID,
		c.SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	dbo.AccountContract ac 
		INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID 
		INNER JOIN dbo.Name ON a.AccountNameID = dbo.Name.NameID
		INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID
		INNER JOIN dbo.Address ad ON a.ServiceAddressID = ad.AddressID
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID
		INNER JOIN dbo.Market m ON a.RetailMktID = m.ID
		INNER JOIN dbo.AccountStatus ON ac.AccountContractID = dbo.AccountStatus.AccountContractID
		INNER JOIN dbo.Contract c ON ac.ContractID = c.ContractID AND a.CurrentContractID = c.ContractID
		LEFT OUTER JOIN dbo.AccountUsage ON a.AccountID = dbo.AccountUsage.AccountID AND dbo.AccountUsage.EffectiveDate = c.StartDate
		LEFT OUTER JOIN dbo.AccountLatestService ON a.AccountID = dbo.AccountLatestService.AccountID
		LEFT OUTER JOIN dbo.AccountContractRate ON ac.AccountContractID = dbo.AccountContractRate.AccountContractID AND dbo.AccountContractRate.IsContractedRate = 0
		INNER JOIN dbo.SalesChannel ON c.SalesChannelID = SalesChannel.ChannelID
WHERE	(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.AccountNumber = @AccountNumber)
OR		(@AccountID > 0 AND a.AccountID = @AccountID)

UNION

SELECT	0 AS AccountID, 
		'' AS AccountIdLegacy, 
		a.UtilityAccountNumber,
		0 AS CurrentContractID,
		0 AS ContractID,
		0 AS AccountContractID,
		'' AS ContractNumber,
		NULL AS ContractDate,
		0 AS AccountTypeID,
		'' As AccountTypeCode,
		'' AS AccountTypeName, 
        m.ID AS RetailMktID, 
        m.MarketCode, 
        m.RetailMktDescp,
        a.AccountName As Name, 
        a.Address As Address1,
        a.City,
        m.MarketCode AS [State],
        a.Zip,
        a.Phone,
        a.UtilityID, 
        u.UtilityCode, 
		u.FullName AS UtilityName, 
		0 AS AccountContractRateID, 
		0 AS AnnualUsage,
		'' AS EnrollmentStatus,
		NULL as FlowStartDate,
		NULL AS DeenrollmentDate,
		0 As NumberOfAccounts,
		0 AS Term,
		0 AS Rate, 
		NULL AS Status, 
		NULL AS SubStatus,
		a.SalesChannelID,
		a.SalesAgent As SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	ComplaintAccount a 
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
		INNER JOIN dbo.Market m ON a.MarketCode = m.MarketCode
		LEFT JOIN dbo.SalesChannel ON a.SalesChannelID = SalesChannel.ChannelID
WHERE	(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.UtilityAccountNumber = @AccountNumber)


ORDER BY AccountNumber
