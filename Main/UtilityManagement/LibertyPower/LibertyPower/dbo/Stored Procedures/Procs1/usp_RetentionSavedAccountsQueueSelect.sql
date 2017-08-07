


CREATE PROCEDURE [dbo].[usp_RetentionSavedAccountsQueueSelect] 
	@DateProcessingStart datetime = null
	,@DateProcessingEnd datetime = null
	,@DateInsertedStart datetime = null
	,@DateInsertedEnd datetime = null
	,@StatusID int = null
	,@Aging int = null
	,@AccountNumber varchar(30) = null
	,@CustomerName varchar(100) = null
	,@IstaInvoiceNumber varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StatusIDStart int 
	DECLARE @StatusIDEnd int 

	IF @DateProcessingStart IS NULL SET @DateProcessingStart = '1/1/1753'
	IF @DateProcessingEnd IS NULL SET @DateProcessingEnd = '12/30/9999'
	IF @DateInsertedStart IS NULL SET @DateInsertedStart = '1/1/1753'
	IF @DateInsertedEnd IS NULL SET @DateInsertedEnd = '12/30/9999'
	IF @Aging IS NULL SET @Aging = -1 --2147483647
	IF @AccountNumber IS NULL SET @AccountNumber = ''
	IF @CustomerName IS NULL SET @CustomerName = ''
	IF @IstaInvoiceNumber IS NULL SET @IstaInvoiceNumber = ''

	-- ADD 1 Day to include all records of the same day that have a time value
	SET @DateProcessingEnd = DATEADD(DAY,1,@DateProcessingEnd) 
	SET @DateInsertedEnd = DATEADD(DAY,1,@DateInsertedEnd) 


	IF NOT @StatusID = 0
	BEGIN
		SET @StatusIDStart = @StatusID
		SET @StatusIDEnd = @StatusID
	END
	ELSE
	BEGIN
		SET @StatusIDStart = 1
		SET @StatusIDEnd = 3
	END

	SELECT full_name, RetentionSavedAccountsQueue.*, DATEDIFF (DAY, RetentionSavedAccountsQueue.DateInserted, GetDate()) As t 
		FROM RetentionSavedAccountsQueue WITH (NOLOCK)
	INNER JOIN LibertyPower..AccountEtfInvoiceQueue AccountEtfInvoiceQueue  WITH (NOLOCK)
		ON 	 AccountEtfInvoiceQueue.EtfInvoiceID = RetentionSavedAccountsQueue.EtfInvoiceID	 
	LEFT OUTER JOIN lp_account..account WITH (NOLOCK) ON RetentionSavedAccountsQueue.AccountID = lp_account..account.AccountID
	LEFT OUTER JOIN lp_account..account_name WITH (NOLOCK) ON lp_account..account_name.account_id = lp_account..account.account_id AND lp_account..account_name.name_link = lp_account..account.customer_name_link
	WHERE 
		(RetentionSavedAccountsQueue.DateProcessed IS NULL OR (RetentionSavedAccountsQueue.DateProcessed >= @DateProcessingStart AND RetentionSavedAccountsQueue.DateProcessed < @DateProcessingEnd ))
		AND (RetentionSavedAccountsQueue.DateInserted >= @DateInsertedStart AND RetentionSavedAccountsQueue.DateInserted < @DateInsertedEnd )
		AND ( RetentionSavedAccountsQueue.StatusID BETWEEN @StatusIDStart AND @StatusIDEnd ) 
		AND @Aging <  DATEDIFF (DAY, RetentionSavedAccountsQueue.DateInserted, GetDate()) 
		AND lp_account..account.account_number LIKE '%' + @AccountNumber + '%' -- Customer account #
		AND lp_account..account_name.full_name LIKE '%' + @CustomerName + '%' -- Customer name 
		AND (AccountEtfInvoiceQueue.IstaInvoiceNumber IS NULL OR (AccountEtfInvoiceQueue.IstaInvoiceNumber LIKE '%' + @IstaInvoiceNumber + '%')) 
	

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RetentionSavedAccountsQueueSelect';

