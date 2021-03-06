USE [Lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_processor_get_usage_detail]    Script Date: 10/22/2013 12:07:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 1/8/2010
-- Description:	Get usage detail for requested accounts.
-- =============================================
/*
* 1/20/2010 Gail Mangaroo 
* Altered to account for multiple DUNS numbers per utility

* 4/1/2010 Gail Mangaroo 
* Altered to use a cursor to get assoc account numbers

* 4/27/2010 Gail Mangaroo 
* Altered to use data from vw_BilledUsage if not found in the other tables

* 5/3/2010 Gail Mangaroo
* Altered to compare header keys <= 0 

* 7/13/2010 Gail Mangaroo 
* Only retrieve usage from invoices since period start and end dates can overlap with individual meter reads

* 8/4/2010 Gail Mangaroo 
* Altered to ignore usage after the usage request is inactive and gather usage for specific account only if specified

* 1/6/2011 Gail Mangaroo 
* Altered to ignore inactive usage detail records (AMEREN fix) 

* 1/21/2011 Gail Mangaroo 
* Altered to be more efficient

* 2/2/2011 Gail Mangaroo 
* Temporarily turn off usage gathering for AMEREN.

* 2/18/2011 Gail Mangaroo 
* Turn on usage gathering for AMEREN ATMS payments

* 6/20/2011 Gail Mangaroo 
* Fixed join with account number history

* 9/6/2011 Gail Mangaroo 
* Added a usage comparison for AMEREN accounts. If the Invociesd usage matches the Consolidated usage then payment is allowed.

*10/23/2011 Gail Mangaroo
* ALtered to ensure any meter read that starts or ends within date range is included.

*1/20/2012 Gail Mangaroo 
* removed ameren special conditions since all accounts are corrected.

*1/31/2012 Gail Mangaroo 
* switched to new libertypower..account structures 

*3/10/2012 Gail Mangaroo 
* added account_id to usage_detail

*6/5/2012 Gail Mangaroo 
* optimized for performance and ignore Utility when checking for existence in lp_commissions..usage_detail

*6/26/2012 Gail Mangaroo 
* Resolved issue with column truncation error on temp table

*10/22/2012 Sadiel Jarvis
* Processing those rows on "usage_detail" that are not coming from ISTA anymore.. SR# 1-271101072
* Returning transactions that needs to be voided.
*/

ALTER PROCEDURE [dbo].[usp_processor_get_usage_detail] 
(@p_account_id varchar(50) = null,
 @TransactionToBeVoided varchar(500) output
 ) 

AS
BEGIN
	SET NOCOUNT ON

	SET @TransactionToBeVoided = ''

	-- Get relevant usage request 
	-- ===============================
	SELECT DISTINCT r.account_id   
				,  account_number = a.accountNumber 
				, r.utility_id 
				, u.duns_number 
				, dm.UtilityDuns 
				, r.inactive_ind 
				, r.date_start
				, date_end = case when r.inactive_ind = 1 AND isnull(r.date_inactive_eff, '1/1/1900') < isnull(r.date_end, '1/1/1900') then  convert(datetime,r.date_inactive_eff,101) else convert(datetime,r.date_end,101)  end 
		INTO #rqst
	FROM lp_commissions..usage_request r (NOLOCK) 
		JOIN lp_common..common_utility u (NOLOCK) ON r.utility_id = u.utility_id 
		JOIN LibertyPower..account a (NOLOCK) on r.account_id = a.accountIDLegacy
		LEFT JOIN LibertyPower.dbo.UtilityDunsMapping dm (NOLOCK) ON r.utility_id = dm.UtilityCode 
	WHERE  (r.inactive_ind = 0 OR dateadd(month,2,isnull(date_inactive_eff, '1/1/1900')) > getdate() ) 
		AND (r.account_id = @p_account_id OR @p_account_id IS NULL )
	
	
	-- Get Account List 
	-- ==================================
	SELECT DISTINCT r.account_id, r.account_number
	INTO #acct_list 
	FROM #rqst r
		

	-- Billing Account #'s can be much larger than regular account #s
	ALTER TABLE #acct_list
	ALTER COLUMN account_number varchar(50)
	
	-- Get Billing Account Numbers
	-- =====================================
	INSERT INTO #acct_list 
	SELECT DISTINCT r.account_id, i.BillingAccount
	FROM #rqst r
		JOIN lp_account..account_info i (NOLOCK) on  i.account_id = r.account_id 
	
	-- Get new Account Numbers 
	-- =====================================
	INSERT INTO #acct_list 
	SELECT DISTINCT r.account_id, new_account_number 
	FROM #rqst r 
		JOIN lp_account..account_number_history h  (NOLOCK) on r.account_number = h.old_account_number 

	-- Get old Account Numbers 
	-- =====================================
	INSERT INTO #acct_list 
	SELECT DISTINCT r.account_id, old_account_number 
	FROM #rqst r 
		JOIN lp_account..account_number_history h  (NOLOCK) on r.account_number = h.new_account_number 


	create index idx_acct_list ON #acct_list ( account_number) 
	create index idx_acct_list2 ON #acct_list ( account_id) 
	create index idx_rqst ON #rqst ( account_id) 
	
 
	---- =================================
	---- Get data from Invoices
	---- =================================
	SELECT DISTINCT 
		  esiid = r.account_number 
		, r.account_number
		, MeterNumber = ''
		, r.utility_id
		, v.UtilityDunsNumber
		, TdspName = ''
		, service_start = convert(datetime,v.FromDate,101)
		, service_end = convert(datetime,v.ToDate,101)
		, usage = TotalkWh
		, TransactionNbr = ''
		, TransactionSetPurposeCode = ''
		, [867_key] = 0 
		, IntervalDetail_Key = 0 
		, IntervalDetailQty_Key = 0 
		, source = 'Invoice'
		, date_received = getdate()
		, date_created = getdate()
		, username = 'System'
		, r.account_id
		
	INTO #final
	FROM  #rqst r
		JOIN #acct_list a 
			ON r.account_id = a.account_id  
		
		JOIN ISTA.dbo.vw_BilledUsage v  (NOLOCK) 
			ON (r.duns_number = v.UtilityDunsNumber OR r.UtilityDuns = v.UtilityDunsNumber)
				AND  v.AccountNumber = a.account_number 
				AND convert(datetime,v.FromDate,101) < r.date_end
				AND convert(datetime,v.ToDate,101) > r.date_start

/* Processing those rows on "usage_detail" that are not coming from ISTA anymore.. SR# 1-271101072 */

			/* 1. Get current list of usages */
			select * into #acct_list1  from lp_commissions..usage_detail d (NOLOCK)
			where d.account_id = @p_account_id 

			DECLARE @usage_detail_id int
			DECLARE db_NonValidList CURSOR FAST_FORWARD FOR  

			/* 2. For each usage in previous list not matching with those coming from ISTA on #final.. */
			SELECT        d.usage_detail_id 
			FROM            [#acct_list1] AS d 
			WHERE        (d.usage_detail_id NOT IN
										 (SELECT DISTINCT d.usage_detail_id
										   FROM            [#final] AS f INNER JOIN
																	 dbo.usage_detail AS d WITH (NOLOCK) ON d.account_id = f.account_id AND CONVERT(datetime, d.service_start, 101) = CONVERT(datetime, 
																	 f.service_start, 101) AND CONVERT(datetime, d.service_end, 101) = CONVERT(datetime, f.service_end, 101)))


			OPEN db_NonValidList   
			FETCH NEXT FROM db_NonValidList INTO @usage_detail_id   

			WHILE @@FETCH_STATUS = 0   
			BEGIN   

					/* 3. Set it to inactive */
				   UPDATE       dbo.usage_detail
					SET                inactive = 1
					WHERE        (usage_detail_id = @usage_detail_id)

					/* 4. Return transaction list associated with this usage_detail row that therefore need to be voided */
					SELECT @TransactionToBeVoided = @TransactionToBeVoided + STUFF((SELECT ',' + cast(td.transaction_detail_id as varchar)
                       FROM            dbo.usage_detail AS ud (NOLOCK) INNER JOIN
                         dbo.transaction_detail AS td (NOLOCK) ON ud.service_start = td.date_term_start AND ud.service_end = td.date_term_end AND ud.account_id = td.account_id
						WHERE        (ud.usage_detail_id = @usage_detail_id) AND (td.void = 0)
                        FOR XML PATH ('')), 1, 1, '')

				   FETCH NEXT FROM db_NonValidList INTO @usage_detail_id   
			END   

			CLOSE db_NonValidList   
			DEALLOCATE db_NonValidList

			drop table #acct_list1

/* End Processing SR# 1-271101072 */


	-- ==================================
	-- Save meter reads
	-- ==================================
	INSERT INTO [lp_commissions].[dbo].[usage_detail]
           ([esiid]
           ,[account_number]
           ,[meter_number]
           ,[utility_id]
           ,[TdspDuns]
           ,[TdspName]
           ,[service_start]
           ,[service_end]
           ,[usage]
           ,[transaction_nbr]
           ,[purpose_code]
           ,[header_key]
           ,[detail_key]
           ,[detail_qty_key]
           ,[source_code]
           ,[date_received]
           ,[date_created]
           ,[username]
           ,[account_id]
           )			

	 SELECT f.* 
	 FROM #final f
 		LEFT JOIN lp_commissions..usage_detail d (NOLOCK) 
				ON d.account_id = f.account_id 
					-- AND d.utility_id = r.utility_id 
					AND convert(datetime,d.service_start,101) = convert(datetime,f.service_start,101)
					AND convert(datetime,d.service_end,101) = convert(datetime,f.service_end,101) 
					AND d.inactive = 0			
	WHERE d.usage_detail_id is null   

	SET NOCOUNT OFF
END
