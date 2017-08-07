-- =============================================
-- Author:		Carlos Lima
-- Create date: 2012-11-27
-- Description:	Searches complaints based on parametric values
-- 20130103 - Fixed issue with Contract Numbers
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintSearch]
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
