USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_FindRenewalNoticeLetterCandidates]    Script Date: 10/25/2013 10:17:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Eric Hernandez
-- Create date: 2011-08-23
-- Description:	Inserts a record into LetterQueue 
-- with document type of "Renewal Notice letters"
-- for each contract that will expire in X days.
-- =============================================
-- Modified:		: José Muñoz
-- Modified date	: 2013-20-25
-- Description		: IT121 Improve performace.
--					  Replace the views for the legacy tables
-- =============================================

ALTER PROCEDURE [dbo].[usp_FindRenewalNoticeLetterCandidates]
	
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
	/*
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
	*/
	DECLARE account_cursor CURSOR FAST_FORWARD FOR
	SELECT DISTINCT CC.Number
		,CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType	END AS account_type
		,ls.DocumentTypeID --, p.is_flexible
	FROM Libertypower..Account AA WITH (NOLOCK)
	INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
	ON AC.AccountContractID			= AA.CurrentContractID 
	AND AC.AccountID				= AA.AccountID 
	INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)
	ON CC.ContractID				= AC.ContractID 
	INNER JOIN Libertypower..AccountContractRate ACR WITH (NOLOCK)
	ON ACR.AccountContractID		= AC.AccountContractID 
	JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK)	
	ON AT.ID						= AA.AccountTypeID 
	JOIN Libertypower..Market MM WITH (NOLOCK)
	ON MM.ID						= AA.RetailMktID 
	JOIN Libertypower..LetterSchedule ls WITH (NOLOCK)
	ON ls.MarketID					= MM.ID 
	JOIN lp_common..common_product PP WITH (NOLOCK)
	ON PP.product_id				= ACR.LegacyProductID 
	INNER JOIN LibertyPower.dbo.AccountStatus AAS WITH (NOLOCK)	
	ON AAS.AccountContractID		= AC.AccountContractID 
	LEFT JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK)		
	ON SC.ChannelID					= CC.SalesChannelID
	JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	
	ON ACR2.AccountContractID		= AC.AccountContractID 
	-- NEW DEFAULT RATE JOIN:
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	-- END NEW DEFAULT RATE JOIN:
 	WHERE (datediff(dd,@today,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END) = ls.DaysBeforeContractEnd
			OR (datepart(dw, @today)= 6 -- if friday, also pick up records for the weekend
	AND (datediff(dd,@today,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END) = ls.DaysBeforeContractEnd+1 or datediff(dd,@today,CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd	ELSE AC_DefaultRate.RateEnd   END) = ls.DaysBeforeContractEnd+2)))
	AND AT.AccountType NOT IN ('LCI')
	AND PP.isdefault = 0 -- Product is not a default product.
	AND AAS.[Status] in ('905000','906000') -- Account is active.
	AND AA.AccountNumber not in (SELECT AccountNumber
								 FROM Libertypower..Account AA1 WITH (NOLOCK)
								 INNER JOIN Libertypower..AccountContract AC1 WITH (NOLOCK)
								 ON AC1.ContractID				= AA1.CurrentrenewalContractID
								 AND AC1.AccountID				= AA1.AccountID 
								 INNER JOIN LibertyPower.dbo.AccountStatus AAS1 WITH (NOLOCK)	
								 ON AAS1.AccountContractID		= AC1.AccountContractID 
								 WHERE AA1.utilityid			= AA.utilityid					
								 AND AAS1.SubStatus			NOT IN ('80','90')
								 )
	AND SC.ChannelName NOT IN ('AEM', 'TCC')
	
	OPEN account_cursor;

	-- Perform the first fetch.
	FETCH NEXT FROM account_cursor
	INTO @contract_nbr, @account_type, @document_type_id;
	
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Take the data from one account of the contract.
		/*
		SELECT TOP 1 @accountId = accountId
			,@sales_channel = replace(a.sales_channel_role, 'Sales Channel/','')
		FROM lp_account..account a
		JOIN lp_common..common_product p on a.product_id = p.product_id
		WHERE contract_nbr = @contract_nbr
		--and (p.is_flexible = @is_flexible or p.is_flexible is null)
		*/
		SELECT TOP 1 @accountId = AA.accountId
			,@sales_channel		= SC.ChannelName 
		FROM Libertypower..Account AA WITH (NOLOCK)
		INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
		ON AC.AccountContractID			= AA.CurrentContractID 
		AND AC.AccountID				= AA.AccountID 
		INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)
		ON CC.ContractID				= AC.ContractID 
		LEFT JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK)		
		ON SC.ChannelID					= CC.SalesChannelID
		WHERE CC.Number					= @contract_nbr
		
		-- If the document is 34, there is an alternate document we use, 33, in the case when the channel is inactive.
		IF @document_type_id in (34, 41)
		BEGIN
			IF NOT EXISTS (select *
						from libertypower..saleschannel WITH (NOLOCK)
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

	SET NOCOUNT OFF	
END


