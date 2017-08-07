-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Searches for LP accounts, or non-LP accounts who filed a complaint
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountsSearch]
(
	@AccountID int,
	@AccountNumber varchar(30) = NULL,
	@AccountAddress varchar(200) = NULL,
	@AccountPhone varchar(30) = NULL,
	@IsLP bit = NULL
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
		c.SubmitDate As SubmitDate,
		a.AccountTypeID,
		at.AccountType As AccountTypeCode,
		at.Description AS AccountTypeName, 
        --a.RetailMktID, 
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
		acr.AccountContractRateID, 
		dbo.AccountUsage.AnnualUsage,
		--[dbo].[ufn_GetLegacyAccountStatus](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus) AS EnrollmentStatus,
		(st.status_descp + ' - ' + st.sub_status_descp) As EnrollmentStatus,
		[dbo].[ufn_GetLegacyFlowStartDate](dbo.AccountStatus.[Status], dbo.AccountStatus.SubStatus, dbo.AccountLatestService.StartDate) as FlowStartDate,
		AccountLatestService.EndDate As DeenrollmentDate,
		(SELECT COUNT(*) FROM dbo.Account a1 WHERE a1.CurrentContractID = a.CurrentContractID) As NumberOfAccounts,
		acr.Term,
		acr.Rate, 
		dbo.AccountStatus.Status, 
		dbo.AccountStatus.SubStatus,
		c.SalesChannelID,
		c.SalesRep,
		(dbo.SalesChannel.ChannelName + ' - ' + dbo.SalesChannel.ChannelDescription) As SalesChannelName
FROM	dbo.AccountContract ac 
		INNER JOIN dbo.Account a ON ac.AccountID = a.AccountID AND a.CurrentContractID = ac.ContractID 
		LEFT JOIN dbo.Name ON a.AccountNameID = dbo.Name.NameID 
		INNER JOIN dbo.AccountType at ON a.AccountTypeID = at.ID 
		LEFT JOIN dbo.[Address] ad ON a.ServiceAddressID = ad.AddressID 
		INNER JOIN dbo.Utility u ON a.UtilityID = u.ID 
		INNER JOIN dbo.Market m ON a.RetailMktID = m.ID 
		LEFT JOIN dbo.AccountStatus ON ac.AccountContractID = dbo.AccountStatus.AccountContractID 
		INNER JOIN dbo.[Contract] c ON ac.ContractID = c.ContractID AND a.CurrentContractID = c.ContractID 
		LEFT OUTER JOIN dbo.AccountUsage ON a.AccountID = dbo.AccountUsage.AccountID AND dbo.AccountUsage.EffectiveDate = c.StartDate 
		LEFT OUTER JOIN dbo.AccountLatestService ON a.AccountID = dbo.AccountLatestService.AccountID 
		LEFT OUTER JOIN dbo.vw_AccountContractRate acr ON ac.AccountContractID = acr.AccountContractID 
		INNER JOIN dbo.SalesChannel ON c.SalesChannelID = SalesChannel.ChannelID 
		INNER JOIN (SELECT ss.[status]
						  ,ss.[sub_status]
						  ,s.[status_descp]
						  ,ss.[sub_status_descp]
					 FROM [Lp_Account].[dbo].[enrollment_status] s
					 JOIN  [Lp_Account].[dbo].[enrollment_sub_status] ss on s.status = ss.status
					 ) As st ON dbo.AccountStatus.[Status] = st.status AND dbo.AccountStatus.SubStatus = st.sub_status
WHERE	(@IsLP = 1 OR @IsLP IS NULL)
AND		(
			(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.AccountNumber = @AccountNumber) OR
			(@AccountID > 0 AND a.AccountID = @AccountID)
		)

UNION

SELECT	a.ComplaintAccountID AS AccountID, 
		'' AS AccountIdLegacy, 
		a.UtilityAccountNumber As AccountNumber,
		0 AS CurrentContractID,
		0 AS ContractID,
		0 AS AccountContractID,
		'' AS ContractNumber,
		NULL AS ContractDate,
		-1 AS AccountTypeID,
		'NOLP' As AccountTypeCode,
		'Non-Liberty Power Account' AS AccountTypeName, 
        --a.MarketID AS RetailMktID, 
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
		INNER JOIN dbo.Market m ON a.MarketCode = m.MarketCode
		LEFT JOIN dbo.Utility u ON a.UtilityID = u.ID 
		LEFT JOIN dbo.SalesChannel ON a.SalesChannelID = SalesChannel.ChannelID
WHERE	(@IsLP = 0 OR @IsLP IS NULL)
AND		(
			(@AccountNumber IS NOT NULL AND @AccountNumber != '' AND a.UtilityAccountNumber = @AccountNumber) OR
			(@AccountID > 0 AND a.ComplaintAccountID = @AccountID)
		)

ORDER BY AccountNumber
