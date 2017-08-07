


-- =============================================
-- Author:		Jaime Forero
-- Create date: 7/29/2010
-- Description:	gets all the file contexts for all the curve files of INF82
-- =============================================
CREATE PROCEDURE [dbo].[usp_VRE_GetCurveFiles]
	@CurveFileType VARCHAR(50) = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	IF @StartDate IS NULL
		SET @StartDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	DECLARE @tempCurveFiles TABLE 
	(
		FileContextGUID UNIQUEIDENTIFIER,
		OriginalFileName VARCHAR(256),
		CurveFileType VARCHAR(50),
		DateCreated DATETIME,
		CreatedBy INT,
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		NumRecords INT
	);

	IF @CurveFileType IS NULL OR @CurveFileType = 'ARCreditReservePercent'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
				SELECT C.FileContextGUID,'ARCreditReservePercent', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
				FROM VREARCreditReservePercent C 
				JOIN [User] U ON C.CreatedBy = U.UserID
				GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'CaisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'CaisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRECaisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'CapacityTransmissionFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'CapacityTransmissionFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRECapacityTransmissionFactor C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'HourlyProfiles'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'HourlyProfiles', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREHourlyProfile C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'Markup'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'Markup', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREMarkupCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'MisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'MisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREMisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'NeisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'NeisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRENeisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'NyisoPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'NyisoPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRENyisoDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'PjmPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'PjmPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPjmDayAhead C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;

	IF @CurveFileType IS NULL OR @CurveFileType = 'AncillaryServices'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'AncillaryServices', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREAncillaryServicesCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
    IF @CurveFileType IS NULL OR @CurveFileType = 'AuctionRevenueRightPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'AuctionRevenueRightPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREAuctionRevenueRightPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	 -------------------------------------------------------------------------
	IF @CurveFileType IS NULL OR @CurveFileType = 'BillingTransactionCost'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'BillingTransactionCost', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREBillingTransactionCostCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'FinanceFee'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'FinanceFee', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREFinanceFeeCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'LossFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'LossFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRELossFactorItemDataCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'POR'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'POR', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPorDataCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'RenewablePortfolioStandardPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'RenewablePortfolioStandardPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRERenewablePortfolioStandardPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'TCapFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'TCapFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRETCapFactorCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'TCapPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'TCapPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRETCapPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'UCapFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'UCapFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREUCapFactorCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'UCapPrice'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'UCapPrice', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREUCapPriceCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	-------------------------------------------------------------------------------
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'DailyProfile'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'DailyProfile', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREDailyProfileCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'PromptEnergyPriceCurve'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'PromptEnergyPriceCurve', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREPromptEnergyPriceCurveHeader C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'RUCSettlementCurve'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'RUCSettlementCurve', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRERUCSettlementCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'ShapingFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'ShapingFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VREShapingFactorCurve C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	IF @CurveFileType IS NULL OR @CurveFileType = 'SuplierPremiumFactor'
	BEGIN
		INSERT INTO @tempCurveFiles (FileContextGUID, CurveFileType, DateCreated, OriginalFileName, CreatedBy, FirstName, LastName, NumRecords ) 
			SELECT C.FileContextGUID,'SuplierPremiumFactor', MAX(C.DateCreated), 'N/A',C.CreatedBy ,U.Firstname, U.Lastname, COUNT(C.FileContextGUID) AS NumRecords 
			FROM VRESupplierPremiumCurveHeader C 
			JOIN [User] U ON C.CreatedBy = U.UserID
			GROUP BY C.FileContextGUID, C.CreatedBy, U.Firstname,U.Lastname;
	END;
	
	
	SELECT * FROM @tempCurveFiles
	WHERE  DateCreated BETWEEN @StartDate AND @EndDate;	
	
	
END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_GetCurveFiles';

