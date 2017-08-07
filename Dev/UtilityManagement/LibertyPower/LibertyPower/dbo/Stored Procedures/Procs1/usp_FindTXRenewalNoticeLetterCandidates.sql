

-- =============================================
-- Author:		Sofia Melo
-- Create date: 2010-08-23
-- Description:	Inserts a register into LetterQueue 
-- with document type of "Renewal Notice letters"
-- for each contract that will expire in 15 days.
-- =============================================
CREATE PROCEDURE [dbo].[usp_FindTXRenewalNoticeLetterCandidates]
	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @contract_nbr varchar(50)
			, @accountId int
			, @document_type_id int
			, @date_scheduled datetime
			, @account_type varchar(50)
			, @is_flexible varchar(1)
			, @sales_channel varchar(50) 			
		
	set @date_scheduled = GETDATE()

	-- Find all TX contracts that will expires in 15 days.
	DECLARE account_cursor CURSOR FOR
	SELECT DISTINCT a.contract_nbr, a.account_type, p.is_flexible					
	FROM lp_account..account a
	JOIN lp_common..common_product p on a.product_id = p.product_id
 	WHERE (datediff(dd,getdate(),a.date_end) = 15 -- 15 days away from contract ending
 			OR (datepart(dw, getdate())= 6 -- if friday, also 16 and 17 days away from contract ending 
 				AND (datediff(dd,getdate(),a.date_end) = 16 or datediff(dd,getdate(),a.date_end) = 17)))
 			AND retail_mkt_id = 'TX'
 			AND account_type <> 'LCI'
			AND p.isdefault = 0 -- Product is not a default product.
			AND a.status in ('905000','906000') -- Account is active.			
	ORDER BY p.is_flexible desc, a.account_type, a.contract_nbr
	
	OPEN account_cursor;

	-- Perform the first fetch.
	FETCH NEXT FROM account_cursor
	INTO @contract_nbr, @account_type, @is_flexible;
	
	-- Find just one account by contract.
	SELECT TOP 1 @accountId = accountId, @sales_channel = replace(a.sales_channel_role,'Sales Channel/','')
	FROM lp_account..account a
	JOIN lp_common..common_product p on a.product_id = p.product_id
	WHERE contract_nbr = @contract_nbr
	and (p.is_flexible = @is_flexible or p.is_flexible is null)
	
	IF EXISTS (select *
				from libertypower..saleschannel
				where channelname not in ('LPINSIDESALES','LPOUTSIDESALES','OutboundTelesales','CUSTOMER_CARE','REGIONALSALES')
				and inactive = 0
				and channelname = @sales_channel)
	BEGIN
		SELECT @document_type_id = document_type_id 
		FROM lp_documents..document_type 
		WHERE document_type_code = 'RNA'
	END
	ELSE
	BEGIN
		SELECT @document_type_id = document_type_id 
		FROM lp_documents..document_type 
		WHERE document_type_code = 'RNO'
	END

	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Calls procedure to insert the register for current contract (row) of the cursor
		exec usp_LetterQueueInsert 'Scheduled', @contract_nbr, @accountId, @document_type_id, @date_scheduled, NULL, 'JOB'
		
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM account_cursor
		INTO @contract_nbr, @account_type, @is_flexible;		
		SET @accountId = (SELECT TOP 1 accountId FROM lp_account..account a
					  JOIN lp_common..common_product p on a.product_id = p.product_id
					  WHERE contract_nbr = @contract_nbr and 
					  (p.is_flexible = @is_flexible or p.is_flexible is null))
		SET @document_type_id = (SELECT document_type_id 
								 FROM lp_documents..document_type 
								 WHERE document_type_code = case @is_flexible when 1 then 'RNA'
															else 'RNO' end)
	END

	CLOSE account_cursor;
	DEALLOCATE account_cursor;
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_FindTXRenewalNoticeLetterCandidates';

