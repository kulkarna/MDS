-- =============================================
-- Author:		Eric Hernandez
-- Create date: 2011-10-23
-- Description:	Inserts a row into LetterQueue 
-- with document type of "termination notification letter"
-- for each account which had an ETF invoice charge.
-- =============================================
CREATE PROCEDURE [dbo].[usp_FindTerminationLetterCandidates]
	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @contract_nbr varchar(50)
			, @AccountID int
			, @document_type_id int
			, @date_scheduled datetime
			, @print_day datetime
			, @today datetime
			, @account_type varchar(50)
			--, @is_flexible varchar(1)
			, @sales_channel varchar(50)
	
	SET @document_type_id = 26
	SET @today = lp_enrollment.dbo.ufn_date_format(getdate(), '<YYYY>-<MM>-<DD>')
	SET @date_scheduled = @today

	DECLARE account_cursor CURSOR FOR
	SELECT DISTINCT a.contract_nbr, a.AccountID
	FROM libertypower.dbo.AccountEtfInvoiceQueue i
	JOIN lp_account.dbo.account a ON i.AccountID = a.AccountID
	LEFT JOIN Libertypower..LetterQueue lq ON a.AccountID = lq.AccountID AND a.contract_nbr = lq.ContractNumber AND lq.DocumentTypeID = @document_type_id
	WHERE DateDiff(dd,i.DateInserted,getdate()) between 0 and 7
	AND lq.LetterQueueID IS NULL -- Ensures the sames contract/account does not get multiple letters.
	AND i.DateInserted >= '2011-10-23' -- Cutover date for the new letter process.

	OPEN account_cursor;

	-- Perform the first fetch.
	FETCH NEXT FROM account_cursor
	INTO @contract_nbr, @AccountID
	
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC usp_LetterQueueInsert 'Scheduled', @contract_nbr, @accountId, @document_type_id, @date_scheduled, NULL, 'JOB'
		
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM account_cursor
		INTO @contract_nbr, @AccountID;		
	END

	CLOSE account_cursor
	DEALLOCATE account_cursor
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_FindTerminationLetterCandidates';

