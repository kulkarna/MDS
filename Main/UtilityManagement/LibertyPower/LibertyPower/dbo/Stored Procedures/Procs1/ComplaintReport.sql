-- =============================================
-- Author:		Carlos Lima
-- Create date: 2012-11-27
-- Description:	Generates a list of complaints
-- 20130103 - Term and Rate is now pulled from vw_AccountContractRate
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintReport]
    @MarketCode varchar(2) = NULL,
    @FromOpenDate datetime = NULL,
    @ToOpenDate datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT	c.ComplaintID, m.MarketCode, c.OpenDate, c.ClosedDate, con.SubmitDate, cra.Name AS RegulatoryAuthorityName, sc.ChannelName, con.SalesRep AS SalesAgent, 
                      at.AccountType, a.AccountNumber, n.Name AS AccountName, cc.Name AS ComplaintCategoryName, ct.Name AS ComplaintTypeName, c.PrimaryDescription, 
                      c.SecondaryDescription, cit.Name AS IssueTypeName, c.InboundCalls, c.InternalFindings, c.ResolutionDescription, c.DueDate, c.Waiver, c.Credit, 
                      cdo.Name AS DisputeOutcomeName, u.FullName AS UtilityFullName, cont.Type AS ContractType, au.AnnualUsage, dbo.vw_AccountContractRate.Term, 
                      dbo.vw_AccountContractRate.Rate
	FROM	dbo.SalesChannel AS sc 
	INNER JOIN dbo.AccountStatus AS ast 
	INNER JOIN dbo.AccountContract AS ac ON ast.AccountContractID = ac.AccountContractID 
	INNER JOIN dbo.Contract AS con ON ac.ContractID = con.ContractID 
	INNER JOIN dbo.ContractType AS cont ON con.ContractTypeID = cont.ContractTypeID 
	INNER JOIN dbo.ComplaintType AS ct 
	INNER JOIN dbo.ComplaintCategory AS cc ON ct.ComplaintCategoryID = cc.ComplaintCategoryID 
	INNER JOIN dbo.Utility AS u 
	INNER JOIN dbo.AccountType AS at 
	INNER JOIN dbo.ComplaintDisputeOutcome AS cdo
	INNER JOIN dbo.Complaint AS c ON cdo.ComplaintDisputeOutcomeID = c.DisputeOutcomeID
	INNER JOIN dbo.ComplaintIssueType AS cit ON c.ComplaintIssueTypeID = cit.ComplaintIssueTypeID
	INNER JOIN dbo.ComplaintStatus AS cs ON c.ComplaintStatusID = cs.ComplaintStatusID
	INNER JOIN dbo.Market AS m
	INNER JOIN dbo.Account AS a ON m.ID = a.RetailMktID ON c.AccountID = a.AccountID 
	INNER JOIN dbo.Name AS n ON a.AccountNameID = n.NameID 
				ON at.ID = a.AccountTypeID 
				ON u.ID = a.UtilityID 
				ON ct.ComplaintTypeID = c.ComplaintTypeID 
				ON con.ContractID = a.CurrentContractID AND ac.AccountID = a.AccountID 
				ON sc.ChannelID = con.SalesChannelID 
	LEFT OUTER JOIN dbo.vw_AccountContractRate ON ac.AccountContractID = dbo.vw_AccountContractRate.AccountContractID
	LEFT OUTER JOIN dbo.ComplaintRegulatoryAuthority AS cra ON c.ComplaintRegulatoryAuthorityID = cra.ComplaintRegulatoryAuthorityID 
	LEFT OUTER JOIN dbo.AccountUsage AS au ON a.AccountID = au.AccountID AND au.EffectiveDate = con.StartDate
	LEFT OUTER JOIN dbo.AccountLatestService AS als ON a.AccountID = als.AccountID
	WHERE	(@MarketCode IS NULL OR @MarketCode = '' OR (@MarketCode IS NOT NULL AND m.MarketCode = @MarketCode))
	AND		(@FromOpenDate IS NULL OR (@FromOpenDate IS NOT NULL AND c.OpenDate >= @FromOpenDate))
	AND		(@ToOpenDate IS NULL OR (@ToOpenDate IS NOT NULL AND c.OpenDate <= @ToOpenDate))
	
UNION

    SELECT DISTINCT c.ComplaintID, m.MarketCode, c.OpenDate, c.ClosedDate, NULL AS SubmitDate, cra.Name AS RegulatoryAuthorityName, sc.ChannelName, ca.SalesAgent, NULL 
                      AS AccountType, ca.UtilityAccountNumber, ca.AccountName, cc.Name AS ComplaintCategoryName, ct.Name AS ComplaintTypeName, c.PrimaryDescription, 
                      c.SecondaryDescription, cit.Name AS IssueTypeName, c.InboundCalls, c.InternalFindings, c.ResolutionDescription, c.DueDate, c.Waiver, c.Credit, 
                      cdo.Name AS DisputeOutcomeName, u.FullName AS UtilityFullName, NULL AS ContractType, 0 AS Term, NULL AS Rate, 0 AS AnnualUsage
	FROM	dbo.ComplaintIssueType AS cit
			INNER JOIN dbo.ComplaintDisputeOutcome AS cdo 
			INNER JOIN dbo.ComplaintCategory AS cc 
			INNER JOIN dbo.ComplaintType AS ct ON cc.ComplaintCategoryID = ct.ComplaintCategoryID 
			INNER JOIN dbo.ComplaintAccount AS ca 
			LEFT OUTER JOIN dbo.Utility AS u ON ca.UtilityID = u.ID 
			INNER JOIN dbo.Complaint AS c	ON ca.ComplaintAccountID = c.ComplaintAccountID 
											ON ct.ComplaintTypeID = c.ComplaintTypeID 
											ON cdo.ComplaintDisputeOutcomeID = c.DisputeOutcomeID 
											ON cit.ComplaintIssueTypeID = c.ComplaintIssueTypeID 
			INNER JOIN dbo.ComplaintStatus AS cs ON c.ComplaintStatusID = cs.ComplaintStatusID 
			LEFT OUTER JOIN dbo.ComplaintRegulatoryAuthority AS cra ON c.ComplaintRegulatoryAuthorityID = cra.ComplaintRegulatoryAuthorityID 
			LEFT OUTER JOIN dbo.Market AS m ON ca.MarketCode = m.MarketCode 
			LEFT OUTER JOIN dbo.SalesChannel AS sc ON ca.SalesChannelID = sc.ChannelID
    WHERE	(@MarketCode IS NULL OR @MarketCode = '' OR (@MarketCode IS NOT NULL AND ca.MarketCode = @MarketCode))
	AND		(@FromOpenDate IS NULL OR (@FromOpenDate IS NOT NULL AND c.OpenDate >= @FromOpenDate))
	AND		(@ToOpenDate IS NULL OR (@ToOpenDate IS NOT NULL AND c.OpenDate <= @ToOpenDate))
    
END


/****** Object:  StoredProcedure [dbo].[ComplaintAccountsSearch]    Script Date: 01/03/2013 14:19:43 ******/
SET ANSI_NULLS ON
