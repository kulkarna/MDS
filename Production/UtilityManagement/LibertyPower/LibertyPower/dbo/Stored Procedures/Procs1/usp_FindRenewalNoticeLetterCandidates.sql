

-- =============================================
-- Author:		Eric Hernandez
-- Create date: 2011-08-23
-- Description:	Inserts a record into LetterQueue 
-- with document type of "Renewal Notice letters"
-- for each contract that will expire in X days.
-- =============================================
CREATE PROCEDURE [dbo].[usp_FindRenewalNoticeLetterCandidates]
	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @contract_nbr varchar(50)
			, @accountId int
			, @document_type_id int
			, @date_scheduled datetime
			, @print_day datetime
			, @today datetime
			, @account_type varchar(50)
			--, @is_flexible varchar(1)
			, @sales_channel varchar(50)
	
	set @today = lp_enrollment.dbo.ufn_date_format(getdate(), '<YYYY>-<MM>-<DD>')
	set @date_scheduled = @today

	-- Find all TX contracts that will expires in 15 days.
	DECLARE account_cursor CURSOR FOR
	SELECT DISTINCT a.contract_nbr, a.account_type, ls.DocumentTypeID --, p.is_flexible
	FROM lp_account..account a
	JOIN lp_common..common_product p on a.product_id = p.product_id
	JOIN Libertypower..Market m on a.retail_mkt_id = m.MarketCode
	JOIN Libertypower..LetterSchedule ls on m.ID = ls.MarketID
 	WHERE (datediff(dd,@today,a.date_end) = ls.DaysBeforeContractEnd
 			OR (datepart(dw, @today)= 6 -- if friday, also pick up records for the weekend
 				AND (datediff(dd,@today,a.date_end) = ls.DaysBeforeContractEnd+1 or datediff(dd,@today,a.date_end) = ls.DaysBeforeContractEnd+2)))
 			--AND a.retail_mkt_id <> 'TX' -- Texas is currently handled in another process.
 			AND account_type NOT IN ('LCI')
			AND p.isdefault = 0 -- Product is not a default product.
			AND a.status in ('905000','906000') -- Account is active.
			AND a.account_number not in (select account_number from lp_account..account_renewal where sub_status not in ('80','90'))			
			AND a.sales_channel_role NOT IN ('SALES CHANNEL/AEM', 'SALES CHANNEL/TCC')
	--ORDER BY p.is_flexible desc, a.account_type, a.contract_nbr
	
	OPEN account_cursor;

	-- Perform the first fetch.
	FETCH NEXT FROM account_cursor
	INTO @contract_nbr, @account_type, @document_type_id;
	
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Take the data from one account of the contract.
		SELECT TOP 1 @accountId = accountId, @sales_channel = replace(a.sales_channel_role,'Sales Channel/','')
		FROM lp_account..account a
		JOIN lp_common..common_product p on a.product_id = p.product_id
		WHERE contract_nbr = @contract_nbr
		--and (p.is_flexible = @is_flexible or p.is_flexible is null)

		-- If the document is 34, there is an alternate document we use, 33, in the case when the channel is inactive.
		IF @document_type_id in (34, 41)
		BEGIN
			IF NOT EXISTS (select *
						from libertypower..saleschannel
						where channelname not in ('LPINSIDESALES','LPOUTSIDESALES','OutboundTelesales','CUSTOMER_CARE','REGIONALSALES')
						and inactive = 0
						and channelname = @sales_channel)
			BEGIN
				IF @document_type_id = 34
					SET @document_type_id = 33 
				ELSE IF @document_type_id = 41
					SET @document_type_id = 40 
			END
		END

		-- Calls procedure to insert the current contract (row)
		exec usp_LetterQueueInsert 'Scheduled', @contract_nbr, @accountId, @document_type_id, @date_scheduled, NULL, 'JOB'
		
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM account_cursor
		INTO @contract_nbr, @account_type, @document_type_id;		
	END

	CLOSE account_cursor;
	DEALLOCATE account_cursor;
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_FindRenewalNoticeLetterCandidates';

