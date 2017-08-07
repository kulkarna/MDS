USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_retention_header_sel_list]    Script Date: 11/02/2012 13:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
--------------------------------------------------------------------------
-- Modified by Sofia Melo
-- Date: 03/10/2010
-- Added filter to exclude TCC accounts
--------------------------------------------------------------------------
-- Modified by Cathy Ghazal
-- Date: 11/02/2012
-- use vw_AccountContractRate instead of AccountContractRate and get the max aCcountContractRateID for isContractedRate = 0
--------------------------------------------------------------------------

-- exec usp_retention_header_sel_list 'libertypower\e3hernandez', 'BY CALL_REQUEST_ID ASC', 100

-- exec [usp_retention_header_sel_list_JFORERO] 'libertypower\e3hernandez', 'BY CALL_REQUEST_ID ASC', 100

-- exec [usp_retention_header_sel_list] 'libertypower\e3hernandez', 'BY CALL_REQUEST_ID ASC', 50

---            exec [usp_retention_header_sel_list_JFORERO] 'libertypower\e3hernandez', 'BY CALL_REQUEST_ID ASC', 50

--   exec [usp_retention_header_sel_list_BAK] 'libertypower\e3hernandez', 'BY CALL_REQUEST_ID ASC', 50

 *************************************************************************************
 * Modified	: 06/15/2012   Jose Munoz - SWCS
 * Ticket	: 1-17313438
 *				Please remove any custom priced contracts/accounts from the Retention queue
 *
 *************************************************************************************
 * Modified	: 06/27/2012   Isabelle Tamanini
 * Ticket	: 1-17245732
 *				Only show in the retention queue accounts that deenrolled in the last 90 days
 *
 *************************************************************************************
*/

ALTER PROCEDURE [dbo].[usp_retention_header_sel_list]
(@p_username                         NCHAR(100),
 @p_view                             VARCHAR(35),
 @p_rec_sel                          INT = 50,
 @p_call_status_filter               VARCHAR(05)	= NULL,
 @p_call_reason_code_filter          VARCHAR(05)	= NULL,
 @p_assigned_to_username_filter      NCHAR(100)		= NULL,
 @p_phone_filter                     VARCHAR(20)	= NULL,
 @p_call_request_id_filter           CHAR(15)		= NULL)
AS

SET NOCOUNT ON 

DECLARE @SELECT_clause			VARCHAR(2000)
	,@orderby_clause			VARCHAR(50)

IF @p_call_status_filter IN ('NONE','ALL')          SET @p_call_status_filter = NULL
IF @p_call_reason_code_filter IN ('NONE','ALL')     SET @p_call_reason_code_filter = NULL
IF @p_assigned_to_username_filter IN ('ALL')		SET @p_assigned_to_username_filter = NULL
IF @p_phone_filter IN ('NONE','ALL')                SET @p_phone_filter = NULL
IF @p_call_request_id_filter IN ('NONE','ALL')      SET @p_call_request_id_filter = NULL

SET @p_call_status_filter = LTRIM(RTRIM(@p_call_status_filter))

SET ROWCOUNT @p_rec_sel

SELECT a.call_request_id,
	a.phone,
	a.account_id,
 	b.AccountNumber AS account_number,
	a.contract_nbr,
	a.no_of_accounts,
	a.total_annual_usage,
	call_status = CASE WHEN a.call_status = 'L' THEN 'Lost'
					WHEN a.call_status = 'S' THEN 'Save'
					WHEN a.call_status = 'A' THEN 'Attempted'
					WHEN a.call_status = 'O' THEN 'Open'
				  END,
	nbr_prev_attempts = dbo.ufn_retention_detail_count_attempt( @p_username, a.call_request_id),
	nextcalldate = lp_enrollment.dbo.ufn_date_format(dbo.ufn_retention_nextcalldate_attempt( @p_username, a.call_request_id),'<m>/<dd>/<yyyy>'),
	a.call_reason_code,
	call_reason_code_descp = c.option_id,
	a.assigned_to_username,	
	lp_enrollment.dbo.ufn_date_format(a.date_resolved,'<m>/<dd>/<yyyy>') AS date_resolved,
	a.username,
	a.date_created AS date_created,
	lp_enrollment.dbo.ufn_date_format(a.date_created,'<m>/<dd>/<yyyy>') AS date_created_formatted,
	a.chgstamp,
	a.active,
	a.excluded_by_username,
	M.MarketCode AS retail_mkt_id,
	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id
		
	--,p.product_category,
	--p.product_id
INTO #temp
FROM retention_header a WITH (NOLOCK)
JOIN LibertyPower..Account b WITH (NOLOCK)						ON a.account_id = b.AccountIdLegacy 
JOIN LibertyPower.dbo.AccountContract AC	WITH (NOLOCK)		ON b.AccountID = AC.AccountID AND b.CurrentContractID = AC.ContractID
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2	WITH (NOLOCK)	ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
JOIN LibertyPower.dbo.Market M			WITH (NOLOCK)			ON b.RetailMktID = M.ID
JOIN LibertyPower.dbo.[Contract] CONT	WITH (NOLOCK)			ON b.CurrentContractID = CONT.ContractID
--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)	ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later

-- NEW DEFAULT RATE JOIN:
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
		   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
	       WHERE ACRR.IsContractedRate = 0 
	       GROUP BY ACRR.AccountContractID
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
-- END NEW DEFAULT RATE JOIN:


/*
JOIN lp_common..common_product p (NOLOCK) ON 


(AC_DefaultRate.AccountContractID IS NOT NULL AND ACR2.LegacyProductID = p.product_id) 
											OR AC_DefaultRate.LegacyProductID = p.product_id

*/


JOIN lp_common..common_views c WITH (NOLOCK) ON c.process_id = 'REASON CODE' AND c.return_value = a.call_reason_code
JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK)		ON CONT.SalesChannelID = SC.ChannelID 
JOIN LibertyPower.dbo.AccountStatus ACS					 WITH (NOLOCK) ON AC.AccountContractID = ACS.AccountContractID
JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON b.AccountID = ASERVICE.AccountID
	
WHERE a.call_status				= isnull(@p_call_status_filter,a.call_status)
	AND a.call_reason_code		= isnull(@p_call_reason_code_filter,a.call_reason_code) 
	AND a.assigned_to_username	= isnull(@p_assigned_to_username_filter,a.assigned_to_username)
	AND a.phone					= isnull(@p_phone_filter,a.phone)
	AND a.call_request_id		= isnull(@p_call_request_id_filter,a.call_request_id)
	AND SC.ChannelName			not like '%TCC%'
	AND getdate() <= DATEADD(dd, 90, LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate ))

--select * from lp_common..common_product
/*
BY CALL_REQUEST_ID
BY NO_OF_ACCOUNTS
BY TOTAL_ANNUAL_USAGE
BY CALL_STATUS
BY NBR_PREV_ATTEMPTS
BY NEXTCALLDATE
BY DATE_CREATED
*/

/* 
ticket 1-17313438
Add p.IsCustom = 0 into where clause
*/
SET @SELECT_clause = '

SELECT	t.*,
		p.product_category,
		p.product_id
		
FROM	#temp t
JOIN lp_common..common_product p (NOLOCK) ON t.product_id = p.product_id  
AND p.IsCustom				= 0
'
SET @ORDERBY_clause = ' order ' + lower(@p_view) + ' '

exec(@SELECT_clause + @ORDERBY_clause)

SET NOCOUNT ON 

