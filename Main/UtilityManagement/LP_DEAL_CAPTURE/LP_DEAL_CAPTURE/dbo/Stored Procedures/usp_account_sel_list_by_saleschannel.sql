﻿

-- Modified Gail Mangaroo
-- PROD 9/10/2007   DEV 8/20/2007 
-- added category_descp field 

-- Modified Eric Hernandez
-- PROD 2/12/2008   DEV 2/12/2008
-- added date_flow_start field 

-- Modified Diogo Lima
-- DEV 1/5/2010
-- line 129 changed
-- a.contract_nbr = ac.contract_nbr changed to a.account_number = ac.account_number
-- =========================================================================
-- Modified by Jose Munoz 08/26/2010 
-- Ticket 17799
-- added column CreditScoreEncrypted
-- ==========================================================================
-- Modified Sofia Melo
-- DEV 11/17/2010
-- added DaysUsed field 
-- ==========================================================================
-- Modified Sofia Melo
-- DEV 2/16/2011
-- added fields deal_date, requested_flow_start_date, transfer_rate,
-- BillingAccount, name_key, meter_number, zone and ProjectedCommissionRate
-- modified date_flow_start field's functionality
-- ==========================================================================
-- Modified Isabelle Tamanini
-- DEV 2/28/2011
-- Modifying code to get the account information from the function instead 
-- of the account table: rate, contract_eff_start_date, date_end and 
-- date_deenrollment
-- SD21532
-- =========================================================================
-- Modified by Jose Munoz 03/01/2011 
-- Ticket 21532
-- Added columns rate, contract_eff_start_date, date_end and date_deenrollment
-- =========================================================================
-- Modified by Jose Munoz 12/19/2011 
-- Ticket 1-5347701	Get DRAFT lines removed from partner portal
-- Added filter set @sqlquery = @sqlquery + '    and a.status <> ''DRAFT'' '
-- when @p_account_status is null to avoid account with status = 'DRAFT'
-- =========================================================================
-- Modified by Jaime Forero 
-- Date: 2/8/2012
-- Refactored to use the new schema from IT079
-- =========================================================================
-- Modified by Gabor Kovacs
-- Date: 10/22/2012
-- Increased the size of contract number from 12 to 20
-- =========================================================================
-- Modified by Gabor Kovacs
-- Date: 11/12/2012
-- Added Product brand
-- =========================================================================
-- Modified by Gabor Kovacs
-- Date: 11/15/2012
-- Rounded transfer and contract rates to 5 decimal places
-- =========================================================================
/*

exec usp_account_sel_list_by_saleschannel 
        @p_username=N'LIBERTYPOWER\casa', @p_date_start=N'9/16/2007',
		@p_date_end=N'9/16/2012',
		@p_view=N'ALL',
		@p_rec_sel=N'50',
		@p_market=NULL

exec usp_account_sel_list_by_saleschannel 
@p_username=N'libertypower\CASA',
@p_date_start=N'1/7/2010',
@p_date_end=N'2/7/2012',
@p_view=N'ALL',@p_rec_sel=N'50',
@p_sort_expression=NULL,@p_accountnbr=N'10443720006633976'

exec usp_account_sel_list_by_saleschannel
@p_username=N'libertypower\CASA',
@p_date_start=N'2010-01-07',
@p_date_end=N'2012-02-07',
@p_view=N'ALL',@p_rec_sel=N'50'

*/
                      
CREATE PROCEDURE [dbo].[usp_account_sel_list_by_saleschannel]  
(@p_username                                        nchar(100),
 @p_date_start                                      datetime = NULL,
 @p_date_end                                        datetime = NULL,
 @p_view                                            varchar(35),
 @p_rec_sel                                         int = 50 ,
 @p_current_page									int = 1,  
 @p_page_size										int = 10000,  
 @p_accountnbr										varchar(30) = null,
 @p_customername									varchar(100) = null,
 @p_contractnbr										varchar(12) = null,
 @p_contract_type									varchar(25) = null,
 @p_market											varchar(20) = null,
 @p_utilities										varchar(500) = null,
 @P_sort_expression									varchar(20) = null,
 @p_account_status									varchar(15) = null
)
AS


declare @recordCount	int
declare @startRowIndex	int

set @startRowIndex = ((@p_current_page * @p_page_size) - @p_page_size) + 1

--declare @sqlquery as nvarchar(MAX) 

SELECT MarketCode
INTO #Market
FROM LibertyPower..Market (nolock)
WHERE charindex(MarketCode,@p_market ) <> 0

SELECT UtilityCode
INTO #Utility
FROM LibertyPower..Utility (nolock)
WHERE charindex(UtilityCode,@p_utilities ) <> 0


--SELECT * 
--INTO #AllAccounts
--FROM [ufn_AllContractAccounts](@p_username,@p_date_start, @p_date_end , @p_accountnbr) 


DECLARE @AllAccounts TABLE 
(
	[record_type] [varchar](50) NULL,
	[account_id] [varchar](12) NULL,
	[account_number] [varchar](30) NULL,
	[utility_id] [varchar](50) NOT NULL,
	[account_name] [varchar](100) NULL,
	[customer_name] [varchar](100) NULL,
	[business_activity] [varchar](50) NULL,
	[business_type] [varchar](50) NULL,
	[service_address] [char](50) NULL,
	[service_suite] [char](50) NULL,
	[service_city] [char](50) NULL,
	[service_state] [char](2) NULL,
	[service_zip] [char](10) NULL,
	[billing_address] [char](50) NULL,
	[billing_suite] [char](50) NULL,
	[billing_city] [char](50) NULL,
	[billing_state] [char](2) NULL,
	[billing_zip] [char](10) NULL,
	[billing_first_name] [varchar](50) NULL,
	[billing_last_name] [varchar](50) NULL,
	[billing_title] [varchar](20) NULL,
	[billing_phone] [varchar](20) NULL,
	[billing_fax] [varchar](20) NULL,
	[billing_email] [nvarchar](256) NULL,
	[billing_birthday] [varchar](5) NULL,
	[customer_first_name] [varchar](50) NULL,
	[customer_last_name] [varchar](50) NULL,
	[customer_title] [varchar](20) NULL,
	[customer_phone] [varchar](20) NULL,
	[customer_fax] [varchar](20) NULL,
	[customer_email] [nvarchar](256) NULL,
	[customer_birthday] [varchar](5) NULL,
	[contract_type] [varchar](25) NULL,
	[contract_nbr] [varchar](20) NULL,
	[term_months] [int] NULL,
	[product_id] [char](20) NULL,
	[sales_channel_role] [nvarchar](100) NULL,
	[sales_rep] [varchar](100) NULL,
	[date_submit] [datetime] NULL,
	[annual_usage] [int] NULL,
	[credit_score] [real] NULL,
	[status] [varchar](50) NULL,
	[sub_status] [varchar](50) NOT NULL,
	[comments] [varchar](max) NULL,
	[category_descp] [varchar](100) NULL,
	[date_flow_start] [varchar](500) NULL,
	[retail_mkt_id] [varchar](50) NOT NULL,
	[CreditScoreEncrypted] [nvarchar](512) NOT NULL,
	[rate] [float] NULL,
	[contract_eff_start_date] [datetime] NULL,
	[date_end] [datetime] NULL,
	[date_deenrollment] [datetime] NULL,
	[date_deal] [datetime] NULL
)

INSERT @AllAccounts EXEC lp_deal_capture.dbo.[usp_GetAllContractAccounts] @p_username,@p_date_start, @p_date_end , @p_accountnbr, @p_contractnbr;

--INSERT @AllAccounts EXEC lp_deal_capture.dbo.[usp_GetAllContractAccounts_JFORERO] 'libertypower\ABC','1/7/2010', '2/10/2012' , '577604010260018', null;

-- SELECT * FROM @AllAccounts ;
set rowcount @p_rec_sel

   select a.account_id,
		  a.account_number,
          '="'+a.account_number+'"' as account_number_excel,
          utility_id = b.utility_descp,
          a.account_name,
          a.customer_name,
          a.business_activity,
          a.business_type,
          a.service_address,
          a.service_suite, 
          a.service_city,
          a.service_state,
          a.service_zip,
          a.billing_address,
          a.billing_suite,
          a.billing_city,
          a.billing_state,
          a.billing_zip,
          a.billing_first_name,
          a.billing_title,
          a.billing_phone,
          a.billing_fax,
          a.billing_email,
          a.billing_birthday,
          a.customer_first_name,
          a.customer_last_name,
          a.customer_title,
          a.customer_phone,
          a.customer_fax,
          a.customer_email,
		  a.customer_birthday,
          a.contract_type,
          a.contract_nbr,
          a.term_months,
          product_id = c.product_descp,          
          a.sales_channel_role,
          a.sales_rep,
          a.date_submit,
          a.annual_usage,
          a.credit_score,
          a.status,
          a.sub_status,
		  a.comments,
		  a.category_descp,
		  date_flow_start = case when a.contract_type like '%renewal%' then convert(varchar(10), a.contract_eff_start_date, 101)
          else convert(varchar(10), isnull(S.StartDate, '1900-01-01'), 101) end,
		  a.retail_mkt_id,
		  --PriceRate	= a.rate,
		  Round(a.rate,5) as PriceRate,
		  ServiceOptionSelected = (select option_id 
									from lp_common..common_views 
									where process_id = 'enrollment type'
									and seq = DETAIL.EnrollmentTypeID),
		  a.contract_eff_start_date,
		  convert(varchar(10), a.date_end, 101) date_end,
		  a.date_deenrollment,
		  a.CreditScoreEncrypted,
		  DaysUsed = (select  sum(datediff(d, FromDate,  ToDate))DaysUsage
		  from libertypower..usage (nolock) t1
		  inner join libertypower..usagetype (nolock) t2 on usagetype = t2.value
		  inner join libertypower..usagesource (nolock) t3 on usagesource = t3.value
		  inner join libertypower..AuditUsageUsed (nolock) t4 on id = rowid
		  where t1.AccountNumber = a.account_number
		    and t4.created in (select max(t5.created) from libertypower..AuditUsageUsed (nolock) t5 where t5.AccountNumber = t1.AccountNumber)),
		  convert(varchar(10), a.date_deal, 101) date_deal,
		  convert(varchar(10), ac2.RequestedStartDate, 101) requested_flow_start_date,
		  Round(f.transfer_rate,5) as transfer_rate,
		  e.BillingAccount,
		  e.name_key,
		  --'122' as meter_number, -- 
		  d.meter_number,
		  ac.zone,
		  ProjectedCommissionRate = f.rate,
		  c.ProductBrandId,
          AC.AccountID,
          AC2.AccountContractID,
          ProductBrand.Name as ProductBrand
	INTO #temp
	FROM @AllAccounts a
	JOIN lp_common..common_utility b with (NOLOCK) on b.utility_id = a.utility_id
	JOIN lp_common..common_product c with (NOLOCK) on c.product_id = a.product_id 
	LEFT JOIN (SELECT account_id, MAX(meter_number) as meter_number FROM lp_account..account_meters with (NOLOCK) group by account_id) d	on a.account_id = d.account_id
	
	LEFT JOIN lp_account..account_info e with (NOLOCK) on a.account_id = e.account_id 
	LEFT JOIN lp_commissions..commission_estimate f with (NOLOCK) on f.account_id = a.account_id AND f.contract_nbr = a.contract_nbr
	JOIN LibertyPower..Account ac (NOLOCK) ON a.account_id = ac.AccountIDLegacy -- needs to be legacy since deal capture still uses it
	JOIN LibertyPower..[Contract] C2 (NOLOCK) ON a.contract_nbr = C2.Number
	JOIN LibertyPower..AccountContract AC2 (NOLOCK) ON ac.AccountID = ac2.AccountID AND C2.ContractID = AC2.ContractID
	JOIN LibertyPower..AccountDetail DETAIL	(NOLOCK) ON DETAIL.AccountID = AC.AccountID 
	LEFT JOIN LibertyPower..AccountLatestService S (NOLOCK) ON ac.AccountID = S.AccountID
	Inner Join LibertyPower.dbo.ProductBrand ProductBrand with (NOLOCK) On ProductBrand.ProductBrandID = c.ProductBrandId
	
	WHERE 1=1
	AND (@p_date_start IS NULL     OR a.date_submit >= @p_date_start)
	AND (@p_date_end IS NULL       OR a.date_submit <= @p_date_end)
	AND (@p_accountnbr IS NULL     OR a.account_number like '%' + @p_accountnbr + '%')
	AND (@p_customername IS NULL   OR a.customer_name like '%' + @p_customername + '%' OR a.account_name like '%' + @p_customername + '%')
	AND (@p_contractnbr IS NULL    OR a.contract_nbr = @p_contractnbr)
	AND (@p_account_status IS NULL OR a.[status] = @p_account_status)
	AND a.[status] <> 'DRAFT' 
	AND (@p_market IS NULL		   OR @p_market = 'ALL' OR a.retail_mkt_id IN (select MarketCode from #Market))
	AND (@p_utilities IS NULL	   OR @p_market = 'ALL' OR a.utility_id IN (select UtilityCode from #Utility))
	AND (@p_contract_type IS NULL  OR @p_contract_type = 'ALL' OR a.contract_type = @p_contract_type)



select @recordcount=count(*) FROM #temp



SELECT ROW_NUMBER() OVER (ORDER BY date_submit ) AS ROWID, *
INTO #ResultTable
FROM #temp


SELECT *, @recordcount RecordCount, CEILING(cast(@recordCount as float) / cast( str(@p_page_size) as float)) PageCount
FROM #ResultTable
WHERE RowId BETWEEN @startRowIndex AND ((@startRowIndex + str(@p_page_size) ) - 1)

--ORDER BY date_submit desc 
--if  @p_sort_expression <> 'ALL'
--set @sqlquery = @sqlquery + 'ORDER ' + @p_sort_expression + ' asc '




