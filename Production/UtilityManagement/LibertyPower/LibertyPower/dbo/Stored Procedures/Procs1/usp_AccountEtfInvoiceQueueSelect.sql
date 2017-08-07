

CREATE PROCEDURE [dbo].[usp_AccountEtfInvoiceQueueSelect] 
	@DateInvoicedStart datetime = null
	,@DateInvoicedEnd datetime = null
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

	IF @DateInvoicedStart IS NULL SET @DateInvoicedStart = '1/1/1753'
	IF @DateInvoicedEnd IS NULL SET @DateInvoicedEnd = '12/30/9999'
	IF @DateInsertedStart IS NULL SET @DateInsertedStart = '1/1/1753'
	IF @DateInsertedEnd IS NULL SET @DateInsertedEnd = '12/30/9999'
	IF @Aging IS NULL SET @Aging = 0 --2147483647
	IF @AccountNumber IS NULL SET @AccountNumber = ''
	IF @CustomerName IS NULL SET @CustomerName = ''
	IF @IstaInvoiceNumber IS NULL SET @IstaInvoiceNumber = ''

	-- ADD 1 Day to include all records of the same day that have a time value
	SET @DateInvoicedEnd = DATEADD(DAY,1,@DateInvoicedEnd) 
	SET @DateInsertedEnd = DATEADD(DAY,1,@DateInsertedEnd) 


	IF NOT @StatusID = 0
	BEGIN
		SET @StatusIDStart = @StatusID
		SET @StatusIDEnd = @StatusID
	END
	ELSE
	BEGIN
		SET @StatusIDStart = 1
		SET @StatusIDEnd = 5
	END

	SELECT full_name, AccountEtfInvoiceQueue.*, DATEDIFF (DAY, DateInserted, GetDate()) As t 
		FROM AccountEtfInvoiceQueue WITH (NOLOCK)
	LEFT OUTER JOIN lp_account..account WITH (NOLOCK) ON AccountEtfInvoiceQueue.AccountID = lp_account..account.AccountID
	LEFT OUTER JOIN lp_account..account_name WITH (NOLOCK) ON lp_account..account_name.account_id = lp_account..account.account_id AND lp_account..account_name.name_link = lp_account..account.customer_name_link
	WHERE 
		(AccountEtfInvoiceQueue.DateInvoiced IS NULL OR (AccountEtfInvoiceQueue.DateInvoiced >= @DateInvoicedStart AND AccountEtfInvoiceQueue.DateInvoiced < @DateInvoicedEnd ))
		AND (AccountEtfInvoiceQueue.DateInserted >= @DateInsertedStart AND AccountEtfInvoiceQueue.DateInserted < @DateInsertedEnd )
		AND ( AccountEtfInvoiceQueue.StatusID BETWEEN @StatusIDStart AND @StatusIDEnd ) 
		AND @Aging <=  DATEDIFF (DAY, AccountEtfInvoiceQueue.DateInserted, GetDate()) 
		AND lp_account..account.account_number LIKE '%' + @AccountNumber + '%' -- Customer account #
		AND lp_account..account_name.full_name LIKE '%' + @CustomerName + '%' -- Customer name 
		AND (@IstaInvoiceNumber = '' OR AccountEtfInvoiceQueue.IstaInvoiceNumber LIKE '%' + @IstaInvoiceNumber + '%')
	

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfInvoiceQueueSelect';

