

/* **********************************************************************************************
 *	Modified by:		Cghazal	
 *  Modified Date: 11/1/2012																*
 *	Modified:	use the view vw_AccountContractRate												*
 *  exec:		usp_GetUsageByUtility '1', '0', '2', '3', 'FIXED', '1/1/2012', '12/31/2012'		*
 ********************************************************************************************** */

CREATE PROCEDURE [dbo].[usp_GetUsageByUtility]
(
	@UtilityID			int,
	@IsCustom			tinyint,
	--@BeginUsageInterval int,
	--@EndUsageInterval	int,
	@UsageTypeBilled	int,
	@UsageTypeHist		int,
	@Category			varchar(50),
	@DateUsageStart		datetime,
	@DateUsageEnd		datetime
)

AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	DISTINCT
			a.AccountNumber
	INTO	#t1
	FROM	 Account a   (nolock)
	
	INNER	JOIN AccountContract ac   (nolock)
	ON		a.AccountID = ac.AccountID  
	
	INNER	JOIN vw_AccountContractRate acr   (nolock)
	ON		ac.AccountContractID = acr.AccountContractID   
	--AND		acr.IsContractedRate = 1  
	
	INNER	JOIN Lp_common..common_product p  (nolock)
	ON		acr.LegacyProductID = p.product_id  
	AND		LTRIM(RTRIM(p.product_category)) = @Category  
	AND		p.IsCustom = @IsCustom    
	
	WHERE	a.UtilityID = @UtilityID  


	SELECT	s.AccountNumber, 
			--CAST(DATEPART(yyyy, s.ToDate) AS varchar(4)) as UsageYear, 
			SUM (s.TotalKwh) as TotalKwh, COUNT(*) as CountUsage
	
	FROM	UsageConsolidated s (nolock)
		
	INNER	JOIN #t1 a
	ON		s.AccountNumber = a.AccountNumber
		
	WHERE	(	UsageType = @UsageTypeBilled
			OR	UsageType = @UsageTypeHist
			)
	AND		s.ToDate BETWEEN @DateUsageStart AND @DateUsageEnd
				
	GROUP	BY s.AccountNumber/*, 
				CAST(DATEPART(yyyy, s.ToDate) AS varchar(4))*/
	
	--HAVING	SUM (s.TotalKwh) < @EndUsageInterval
	--AND		SUM (s.TotalKwh) > @BeginUsageInterval

	SET NOCOUNT OFF;
	
END
