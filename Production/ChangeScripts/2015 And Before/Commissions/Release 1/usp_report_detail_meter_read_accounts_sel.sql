USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_report_detail_meter_read_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_report_detail_meter_read_accounts_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_report_meter_read_accounts_sel
 * Get meter reads received and accounts that are due for meter reads 
 
 * History
 *******************************************************************************
 * 9/23/2009 Gail Mangaroo.
 * Created.
 *******************************************************************************
 * 10/19/2009
 * Added last meter read and commission stats
 ******************************************************************************
 * 10/28/2009 Gail Mangaroo 
 * Added corrected issue where accounts without meter reads were not showing and 
 * accounts beyond the start deal date showing 
 *******************************************************************************
 * 11/12/2009 Gail Managaroo 
 * Added is_paud fileter and is_pending and no meter read fields
 *******************************************************************************
 exec usp_report_detail_meter_read_accounts_sel '7/1/2007' , '7/30/2007'
 *******************************************************************************
 * 1/15/2010 Gail Mangaroo 
 * Get usage from usage_detail 
 *******************************************************************************
 * 1/20/2010 Gail Mangaroo and rename sp.
 * Added utility ID 
 *******************************************************************************
 * 4/20/2010 Gail Mangaroo
 * Added vendor
 *******************************************************************************
* Modified 5/6/2010 Gail Mangaroo 
* Get vendor names from LibertyPower.dbo.salesChannel
*******************************************************************************
* 1/6/2011 Gail Mangaroo 
* Altered to ignore inactive usage detail records (AMEREN fix) 
*******************************************************************************
* 2/15/2012 Gail Mangaroo 
* Altered to use LibertyPower.dbo.Account 
*******************************************************************************
* 9/25/2012 Gail Mangaroo 
* Altered to use LibertyPower..Name 
*******************************************************************************
* 12/10/2012 Gail Mangaroo 
* Altered to use payment option tables and ignore payment options on vendor table
*******************************************************************************
 */
CREATE Procedure [dbo].[usp_report_detail_meter_read_accounts_sel]
(
@p_period_start_date datetime 
, @p_period_end_date datetime
, @p_show_missing_accts_only bit = 1 
, @p_show_paid_status int = -1  -- -1 means all / 0 Not Paid / 1 Paid
, @p_vendor_id int 
)

AS
BEGIN 

		--drop table #temp_meter_rds 
		--drop table #final_list
		--drop table  #tmp_next_acct  
		
		--declare @p_period_start_date datetime 
		--declare @p_period_end_date datetime
		--declare @p_show_missing_accts_only bit 
		--declare @p_show_paid_status int 
		--declare @p_vendor_id int 

		--set @p_period_start_date = '10/1/2012'
		--set @p_period_end_date = '1/1/2013'
		--set @p_show_missing_accts_only = 0 
		--set @p_show_paid_status  = -1 
		--set @p_vendor_id = 315
		
		
		--DECLARE @acct_nbrs table ( account_number varchar(40) , assoc_account_number varchar(40)) 
	DECLARE @acct varchar(40) 
	DECLARE @acct_ID varchar(40) 
	DECLARE @new_acct varchar(40) 
	DECLARE @date_deal datetime 
	
	DECLARE @service_start datetime 
	DECLARE @service_end datetime
	DECLARE @read_date datetime
	DECLARE @usage float
	DECLARE @comm_date  datetime 
	DECLARE @comm_rate float 
	DECLARE @comm_amt float 
	DECLARE @channelID varchar(50) 
	
	CREATE TABLE #temp_meter_rds 
	(	account_number varchar(30) 
	, esiid varchar(30) 
	, TdspDuns varchar(100)
	, service_start datetime
	, service_end datetime
	, usage float
	, transaction_nbr varchar(100) 
	, purpose_code varchar(100) 
	, header_key int 
	, detail_key int 
	, detail_qty_key int 
	, source_code char(1)
	, date_created datetime 
	, meter_number varchar(100)
	)

	CREATE TABLE #final_list 
	(	account_number varchar(50)
		, SalesChannelID varchar(300)
		, SalesChannel varchar(350)
		, retail_mkt_id varchar(5)
		, ContractNumber varchar(30)
		, AccountNumber varchar(30)
		, CustomerName varchar(300)
		, date_deal datetime
		, FlowStartDate datetime
		, next_read_date datetime
		, rate float
		, TdspDuns varchar(100)
		, service_start datetime
		, service_end datetime
		, usage float
		, TransactionNbr varchar(100)
		, TransactionSetPurposeCode varchar(100)
		, [867_key] int
		, Detail_Key int
		, Detail_Qty_Key int 
		, source varchar(100)
		, datecreated datetime
		, transaction_detail_id int
		, zone varchar(20)
		, last_service_start datetime 
		, last_service_end datetime
		, last_read_date datetime
		, last_usage float
		, last_commission_date datetime
		, last_commission_rate float  
		, last_commission_amount float
		, is_paid bit 
		, is_flowing bit
		, account_id varchar(50)
		, is_pending_pymt bit 
		, no_meter_read bit 
		)

	
	-- Get all accounts due for a meter read within date range  
	-- =======================================================
	SELECT DISTINCT * 
	INTO #tmp_next_acct 
	FROM 
	( 	SELECT m.read_date as next_read_date, account_id = a.accountIdLegacy , account_number = a.accountNumber , utility_id = u.utilityCode
		FROM LibertyPower.dbo.account a (NOLOCK) 
			JOIN LibertyPower.dbo.accountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
			JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
			JOIN LibertyPower.dbo.utility u (NOLOCK) ON a.UtilityID = u.ID
			JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID  
				AND v.initial_pymt_option_id = 1
				AND c.SignedDate > '9/21/2009'
			LEFT JOIN lp_account.dbo.account_additional_info i (NOLOCK) ON a.accountIdLegacy = i.account_id 
			LEFT JOIN lp_common.dbo.meter_read_calendar m (NOLOCK) on u.utilityCode= m.utility_id 
				AND i.field_04_value = m.read_cycle_id 
		WHERE 
			(( calendar_year BETWEEN YEAR(@p_period_start_date) AND YEAR(@p_period_end_date) 
				AND calendar_month BETWEEN MONTH(@p_period_start_date) AND MONTH(@p_period_end_date ) 
			  ) OR  ltrim(rtrim(isnull(i.field_04_value, ''))) = '' ) 
			 AND (v.vendor_id = @p_vendor_id OR @p_vendor_id = 0 )
		
		) as x


	-- Final Select 
	-- =========================================
	INSERT INTO #final_list 
	
	-- Accounts with meter reads 
	-- ===========================
	SELECT DISTINCT 
		r.account_number 
		, SalesChannelID = upper(sc.ChannelName )
		, SalesChannel = upper(v.vendor_system_name)
		, retail_mkt_id = m.MarketCode 
		, ContractNumber = c.Number
		, AccountNumber = a.AccountNumber
		, CustomerName = arn.name
		, date_deal = c.SignedDate
		, FlowStartDate = c.StartDate
		, n.next_read_date 
		, d.rate 
		, r.TdspDuns
		, r.service_start
		, r.service_end
		, r.usage
		, r.Transaction_Nbr
		, r.Purpose_Code
		, r.[header_key]
		, r.Detail_Key
		, r.Detail_Qty_Key 
		, r.source_code
		, r.date_created
		, u.transaction_detail_id 
		, a.zone
		, last_service_start = d.date_term_start 
		, last_service_end = d.date_term_end
		, last_read_date = r.date_received
		, last_usage = null  
		, last_commission_date = null
		, last_commission_rate = null 
		, last_commission_amount = null
		, is_paid = case when u.header_key is not null and d.approval_status_id in (1,3) then 1 else 0 end -- true if meter read related to a transaction and transaction approved and paid on report
		, is_flowing = case when s.status in ( '911000','999998','999999') then 0 else 1 end
		, account_id = a.accountIdLegacy
		, is_pending_pymt = case when u.header_key is not null and d.invoice_id = 0 and d.approval_status_id in (1,3) then 1 else 0 end -- true if meter read related to a transaction and transaction approved but not yet paid on report
		, no_meter_read = 0 
		
	FROM lp_commissions.dbo.usage_detail r (NOLOCK)
		
		JOIN LibertyPower.dbo.account a (NOLOCK) ON r.account_number = a.accountNumber 
		JOIN LibertyPower.dbo.accountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
		JOIN LibertyPower.dbo.utility ut (NOLOCK) ON a.UtilityID = ut.ID AND r.utility_id = ut.utilityCode
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.ChannelID = c.SalesChannelID
		JOIN LibertyPower.dbo.market m (NOLOCK) ON a.retailMktID = m.id 
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID 
		LEFT JOIN LibertyPower.dbo.Name arn (NOLOCK) ON a.AccountNameID = arn.NameID
		LEFT JOIN #tmp_next_acct n (NOLOCK) ON r.account_number = n.account_number 
		
		JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID
			--AND v.initial_pymt_option_id = 1

		LEFT JOIN transaction_usage_detail u (NOLOCK) ON r.header_key = u.header_key 
		LEFT JOIN lp_commissions.dbo.transaction_detail d (NOLOCK) ON d.transaction_detail_id = u.transaction_detail_id 
		
	WHERE @p_show_missing_accts_only  = 0 
		AND r.date_received BETWEEN @p_period_start_date AND @p_period_end_date
		AND (v.vendor_id = @p_vendor_id OR @p_vendor_id = 0 ) 
		AND r.inactive = 0
		AND	  -- Todo : Add check for account overrides
			  -- vendor option set 
			  (SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
					FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
						JOIN lp_commissions..payment_option po (NOLOCK) on vpo.payment_option_id = po.payment_option_id 
						JOIN lp_commissions..payment_option_setting pos (NOLOCK) on pos.payment_option_id = pos.payment_option_id 
					WHERE vpo.date_effective <= c.SignedDate
						AND ( vpo.date_end > c.SignedDate OR isnull(vpo.date_end, '1/1/1900')  = '1/1/1900' ) 
						AND vpo.active = 1 
						AND po.payment_option_type_id = 1 -- intial payment 
						AND pos.payment_option_def_id = 1 -- ATMS
						AND vendor_id = v.vendor_ID
					ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 )  > 0 
				
	-- UNION 
	
	INSERT INTO #final_list 
	
	--  accounts missing meter reads
	-- ==============================
	SELECT DISTINCT h.account_number  --
		, SalesChannelID = upper(sc.ChannelName )
		, SalesChannel = upper(v.vendor_system_name)
		, retail_mkt_id = m.MarketCode 
		, ContractNumber = c.Number
		, AccountNumber = a.AccountNumber
		, CustomerName = arn.name
		, date_deal = c.SignedDate
		, FlowStartDate = c.StartDate
		, h.next_read_date 
		, null rate
		, null TdspDuns
		, null service_start
		, null service_end
		, null usage
		, null TransactionNbr
		, null TransactionSetPurposeCode
		, null [867_key]
		, null Detail_Key
		, null Detail_Qty_Key
		, null source
		, null datecreated
		, null transaction_detail_id
		, a.zone
		, last_service_start = null 
		, last_service_end = null
		, last_read_date = null
		, last_usage = null  
		, last_commission_date = comm.target_date
		, last_commission_rate = last_d.rate 
		, last_commission_amount = last_d.amount
		, is_paid = 0
		, is_flowing = case when s.status in ( '911000','999998','999999') then 0 else 1 end
		, account_id = a.accountIDLegacy
		, is_pending_pymt = 0 
		, no_meter_read = 1 
		
    FROM #tmp_next_acct h 
			
		LEFT JOIN lp_commissions.dbo.usage_detail r (NOLOCK) ON r.account_number = h.account_number 
				AND r.date_received BETWEEN @p_period_start_date AND @p_period_end_date
				AND h.utility_id = r.utility_id
				AND r.inactive = 0
				
		JOIN LibertyPower.dbo.account a (NOLOCK) ON r.account_number = a.accountNumber 
		JOIN LibertyPower.dbo.accountContract ac (NOLOCK) ON ac.AccountID = a.AccountID 
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = ac.ContractID
		JOIN LibertyPower.dbo.utility u (NOLOCK) ON a.UtilityID = u.ID AND r.utility_id = u.utilityCode
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.ChannelID = c.SalesChannelID
		JOIN LibertyPower.dbo.market m (NOLOCK) ON a.retailMktID = m.id 
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = ac.AccountContractID 
		LEFT JOIN LibertyPower.dbo.Name arn (NOLOCK) ON a.AccountNameID = arn.NameID
		JOIN lp_commissions.dbo.vendor v (NOLOCK) ON c.SalesChannelID = v.ChannelID
		
		LEFT JOIN ( SELECT account_id , max(transaction_detail_id) as detail_id , target_date = max(r.target_date )
						FROM lp_commissions.dbo.transaction_detail d (NOLOCK) 
							JOIN lp_commissions.dbo.invoice i (NOLOCK) on d.invoice_id = i.invoice_id
							JOIN lp_commissions.dbo.vendor v (NOLOCK) on d.vendor_id = v.vendor_id --AND v.vendor_name = @channelID
							JOIN lp_commissions.dbo.report r (NOLOCK) on i.report_id = r.report_id
							LEFT OUTER JOIN LibertyPower.dbo.SalesChannel AS SC (NOLOCK) ON v.ChannelID = SC.ChannelID 
						WHERE d.void = 0 
							and d.approval_status_id = 1 
							and reason_Code like 'c5000%' 
							and sc.ChannelName = @channelID
						GROUP BY account_id 
				  )  as comm ON comm.account_id = h.account_id 
				  			
		LEFT JOIN transaction_detail last_d (NOLOCK) ON last_d.transaction_detail_id = comm.detail_id 
						
	WHERE r.account_number is null 
			
	UPDATE #final_list SET FlowStartDate = NULL WHERE FlowStartDate = '1/1/1900'
	UPDATE #final_list SET is_flowing = 0 WHERE FlowStartDate IS NULL 
	
		
	SELECT DISTINCT * FROM #final_list 
	WHERE (@p_show_paid_status = -1 or is_paid = @p_show_paid_status )  -- show all or only the specified status

END 
GO
