USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintSearch]    Script Date: 01/03/2013 09:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create date: 2012-11-27
-- Description:	Searches complaints based on parametric values
-- 20130103 - Fixed issue with Contract Numbers
-- =============================================
ALTER PROCEDURE [dbo].[ComplaintSearch]
	@ComplaintID int = 0,
	@AccountNumber varchar(30) = NULL,
    @ControlNumber varchar(30) = NULL,
    @ContractNumber varchar(50) = NULL,
    @AccountName varchar(30) = NULL,
    @UtilityID int = 0,
    @CasePrimeID int = 0,
    @MarketCode char(2) = NULL,
    @SalesChannelID int = 0,
    @SubmitDate datetime = NULL,
    @OpenDate datetime = NULL,
    @StatusID int = -1,
    @FirstRecord int = 1,
    @PageSize int = 50,
    @SortBy varchar(50) = 'DueDays',
    @SortByDirection varchar(5) = ''
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF @SortBy = ''
		SET @SortBy = 'DueDays'

	DECLARE @searchScript NVARCHAR(Max)
	SET @searchScript = N'SELECT	c.ComplaintID, c.ComplaintLegacyID As LegacyID, a.AccountNumber, n.Name As AccountName, c.ComplaintStatusID AS StatusID, c.OpenDate, c.DueDate, cn.Number AS ContractNumber, '
	SET @searchScript = @searchScript + N'				cn.SalesChannelID, sc.ChannelName, cn.SalesRep AS SalesAgent, ct.Name AS ComplaintTypeName, '
	SET @searchScript = @searchScript + N'				DATEDIFF(dd,GETDATE(), c.DueDate) AS DueDays '
			
	SET @searchScript = @searchScript + N'		FROM	dbo.ComplaintType ct '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Name n '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Account a '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Market m ON a.RetailMktID = m.ID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Complaint c ON a.AccountID = c.AccountID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.Contract cn ON a.CurrentContractID = cn.ContractID ON n.NameID = a.AccountNameID '
	SET @searchScript = @searchScript + N'				INNER JOIN dbo.SalesChannel sc ON cn.SalesChannelID = sc.ChannelID ON ct.ComplaintTypeID = c.ComplaintTypeID '
	SET @searchScript = @searchScript + N'		WHERE	c.ComplaintID = c.ComplaintID '
	IF @ComplaintID > 0
		SET @searchScript = @searchScript + N'		AND c.ComplaintID = @ComplaintID '
	IF @ControlNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND c.ControlNumber = @ControlNumber '
	IF @AccountNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND a.AccountNumber = @AccountNumber '
	IF @ContractNumber IS NOT NULL
		SET @searchScript = @searchScript + N'		AND cn.Number = @ContractNumber '
	IF @AccountName IS NOT NULL
		SET @searchScript = @searchScript + N'		AND n.Name LIKE ''%' + @AccountName + '%'' '
	IF @UtilityID > 0
		SET @searchScript = @searchScript + N'		AND	a.UtilityID = @UtilityID' 
	IF @CasePrimeID > 0
		SET @searchScript = @searchScript + N'		AND	c.CasePrimeID = @CasePrimeID '
	IF @MarketCode IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	m.MarketCode = @MarketCode '
	IF @SalesChannelID > 0
		SET @searchScript = @searchScript + N'		AND	cn.SalesChannelID = @SalesChannelID '
	IF @SubmitDate IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	CONVERT(varchar(8), cn.SubmitDate, 112) = CONVERT(varchar(8), @SubmitDate, 112) '
	IF @OpenDate IS NOT NULL
		SET @searchScript = @searchScript + N'		AND	CONVERT(varchar(8), c.OpenDate, 112) = CONVERT(varchar(8), @OpenDate, 112) '
	IF @StatusID > -1
		SET @searchScript = @searchScript + N'		AND	c.ComplaintStatusID = @StatusID '
			
	IF @SubmitDate IS NULL AND @ContractNumber IS NULL
		BEGIN
			SET @searchScript = @searchScript + N'		UNION '
				    
			SET @searchScript = @searchScript + N'		SELECT  c.ComplaintID, c.ComplaintLegacyID As LegacyID, a.UtilityAccountNumber AS AccountNumber, a.AccountName, c.ComplaintStatusID AS StatusID, c.OpenDate, c.DueDate, '''' AS ContractNumber, '
			SET @searchScript = @searchScript + N'				 a.SalesChannelID, sc.ChannelName, a.SalesAgent, ct.Name AS ComplaintTypeName, '
			SET @searchScript = @searchScript + N'				 DATEDIFF(dd,GETDATE(), c.DueDate) AS DueDays '
			SET @searchScript = @searchScript + N'		FROM    dbo.ComplaintAccount a '
			SET @searchScript = @searchScript + N'				INNER JOIN dbo.Complaint c ON a.ComplaintAccountID = c.ComplaintAccountID '
			SET @searchScript = @searchScript + N'				INNER JOIN dbo.ComplaintType ct ON c.ComplaintTypeID = ct.ComplaintTypeID '
			SET @searchScript = @searchScript + N'				LEFT OUTER JOIN dbo.SalesChannel sc ON a.SalesChannelID = sc.ChannelID '
			SET @searchScript = @searchScript + N'		WHERE	c.ComplaintID = c.ComplaintID '
			IF @ComplaintID > 0
				SET @searchScript = @searchScript + N'		AND c.ComplaintID = @ComplaintID '
			IF @ControlNumber IS NOT NULL
				SET @searchScript = @searchScript + N'		AND c.ControlNumber = @ControlNumber '
			IF @AccountNumber IS NOT NULL
				SET @searchScript = @searchScript + N'		AND a.UtilityAccountNumber = @AccountNumber '
			IF @AccountName IS NOT NULL
				SET @searchScript = @searchScript + N'		AND a.AccountName LIKE ''%' + @AccountName + '%'' '
			IF @UtilityID > 0
				SET @searchScript = @searchScript + N'		AND	a.UtilityID = @UtilityID '
			IF @MarketCode IS NOT NULL
				SET @searchScript = @searchScript + N'		AND	a.MarketCode = @MarketCode '
			IF @CasePrimeID > 0
				SET @searchScript = @searchScript + N'		AND	c.CasePrimeID = @CasePrimeID '
			IF @SalesChannelID > 0
				SET @searchScript = @searchScript + N'		AND	a.SalesChannelID = @SalesChannelID '
			IF @OpenDate IS NOT NULL
				SET @searchScript = @searchScript + N'		AND	CONVERT(varchar(8), c.OpenDate, 112) = CONVERT(varchar(8), @OpenDate, 112) '
			IF @StatusID > -1
				SET @searchScript = @searchScript + N'		AND	c.ComplaintStatusID = @StatusID '
		END

	CREATE TABLE #tempResults (ComplaintID int, 
							   LegacyID int, 
							   AccountNumber nvarchar(100),
							   AccountName nvarchar(100), 
							   StatusID int, 
							   OpenDate datetime, 
							   DueDate datetime,
							   ContractNumber nvarchar(50),
							   SalesChannelID int, 
							   ChannelName nvarchar(150), 
							   SalesAgent nvarchar(100), 
							   ComplaintTypeName nvarchar(50), 
							   DueDays int
							   )

	DECLARE @searchParamDef NVARCHAR(Max)
	SET @searchParamDef = N'@ComplaintID int,@AccountNumber varchar(30),@ControlNumber varchar(30),@ContractNumber varchar(50),@AccountName varchar(30),@UtilityID int,@CasePrimeID int,@MarketCode char(2),@SalesChannelID int, @SubmitDate datetime, @OpenDate datetime, @StatusID int';
	

	INSERT INTO #tempResults 
	EXEC sp_executesql @searchScript, @searchParamDef, @ComplaintID = @ComplaintID, 
													   @AccountNumber = @AccountNumber,
													   @ControlNumber = @ControlNumber, 
													   @ContractNumber = @ContractNumber, 
													   @AccountName = @AccountName, 
													   @UtilityID = @UtilityID, 
													   @CasePrimeID = @CasePrimeID, 
													   @MarketCode = @MarketCode, 
													   @SalesChannelID = @SalesChannelID, 
													   @SubmitDate = @SubmitDate,
													   @OpenDate = @OpenDate,
													   @StatusID = @StatusID

	SELECT	COUNT(*) as TotalResults, 
			@FirstRecord as FirstRecord,
			CASE
				WHEN COUNT(*) < (@FirstRecord + @PageSize) THEN COUNT(*)
				ELSE (@FirstRecord + @PageSize)
			END as LastRecord 
	FROM #tempResults


	DECLARE @Script NVARCHAR(Max);
	DECLARE @ParmDefinition NVARCHAR(500);
    
    SET @ParmDefinition = N'@FirstRecord int,@PageSize int';
    
    SET @Script = N'SELECT * '
    SET @Script = @Script + N'FROM (SELECT *, ROW_NUMBER() OVER(ORDER BY ' + @SortBy + ' ' + @SortByDirection + ') AS RowNumber FROM #tempResults) as SearchResults '
    SET @Script = @Script + N'WHERE RowNumber >= @FirstRecord AND RowNumber < (@FirstRecord + @PageSize) '
    SET @Script = @Script + N'ORDER BY ' + @SortBy + ' ' + @SortByDirection
    
    print @Script
    print @SortBy + ' ' + @SortByDirection
    
    EXECUTE sp_executesql @Script, @ParmDefinition, @FirstRecord = @FirstRecord, @PageSize = @PageSize
    
    
    DROP TABLE #tempResults

END



/****** Object:  StoredProcedure [dbo].[ComplaintReport]    Script Date: 01/03/2013 13:47:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create date: 2012-11-27
-- Description:	Generates a list of complaints
-- 20130103 - Term and Rate is now pulled from vw_AccountContractRate
-- =============================================
ALTER PROCEDURE [dbo].[ComplaintReport]
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
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Searches for LP accounts, or non-LP accounts who filed a complaint
-- =============================================
ALTER PROCEDURE [dbo].[ComplaintAccountsSearch]
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
