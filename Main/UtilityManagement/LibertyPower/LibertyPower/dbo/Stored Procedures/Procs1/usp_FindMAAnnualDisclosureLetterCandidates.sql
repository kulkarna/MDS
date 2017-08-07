


-- =============================================
-- Author:		Sofia Melo
-- Create date: 2010-08-23
-- Description:	Inserts a register into LetterQueue 
-- with document type of "disclosure letter"
-- for each contract whose anniversary is in 30 days.
-- =============================================
CREATE PROCEDURE [dbo].[usp_FindMAAnnualDisclosureLetterCandidates]
	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @contract_nbr varchar(50)
			, @accountId int
			, @document_type_id int
			, @date_scheduled datetime
			, @today datetime
			
	SET @today = CAST(FLOOR( CAST( GETDATE() AS FLOAT ) ) AS DATETIME)

	SET @document_type_id = (SELECT document_type_id 
							 FROM lp_documents..document_type WHERE document_type_code = 'ADL')
	SET @date_scheduled = DATEADD(day,1,@today)

	-- Find all contracts that will expires in 30 days.
	DECLARE account_cursor CURSOR FOR
	SELECT DISTINCT contract_nbr
	FROM lp_account..account a
	JOIN lp_common..common_product p on a.product_id = p.product_id	
	WHERE datepart(dd, contract_eff_start_date) = datepart(dd,DATEADD(day,30,@today))
	and datepart(mm, contract_eff_start_date) = datepart(mm,DATEADD(day,30,@today))
	AND p.isdefault = 0
	AND a.status in ('905000','906000','11000') -- Active account
	AND contract_nbr NOT IN (SELECT DISTINCT ContractNumber FROM LetterQueue WHERE DocumentTypeId = @document_type_id)
	AND retail_mkt_id = 'MA'	
	ORDER BY contract_nbr
	
	OPEN account_cursor;

	-- Perform the first fetch.
	FETCH NEXT FROM account_cursor
	INTO @contract_nbr;
	-- Find one account just one account by contract
	SET @accountId = (SELECT TOP 1 accountId FROM lp_account..account WHERE contract_nbr = @contract_nbr)

	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Calls procedure to insert the register for current contract (row) of the cursor
		exec usp_LetterQueueInsert 'Scheduled', @contract_nbr, @accountId, @document_type_id, @date_scheduled, NULL, 'JOB'

		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM account_cursor
		INTO @contract_nbr;		
		SET @accountId = (SELECT TOP 1 accountId FROM lp_account..account WHERE contract_nbr = @contract_nbr)

	END

	CLOSE account_cursor;
	DEALLOCATE account_cursor;
	
END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_FindMAAnnualDisclosureLetterCandidates';

