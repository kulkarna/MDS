USE [Lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_transaction_usage_detail_sel_by_acct]    Script Date: 10/17/2014 3:16:43 PM ******/
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_transaction_usage_detail_sel_by_acct' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_transaction_usage_detail_sel_by_acct];
GO
/*******************************************************************************

 * usp_transaction_usage_detail_sel_by_acct

 * Retrieve transaction specific usage for account.
 
 * History

 *******************************************************************************
 
 * 8/14/2009 Gail Mangaroo.
 
 * Created.
 
 *******************************************************************************
 
* 1/14/2010 Gail Mangaroo 

* Added vendor id parameter 

********************************************************************************
-- 8/3/2011 Gail Mangaroo	
-- added assoc_trans_id field
-- ============================================
-- 2/9/2012 Gail Mangaroo 
-- Ignore not only chgbks but adjustments assoc with chbk
-- =============================================
-- 10/17/2014 Sadiel Jarvis
-- Fixed subquery so it will scan for voids and chargebacks ONLY on transaction details belonging to currently received account and contract.
-- 20/17/2014 Pradeep Katiyar
-- Added transaction_detail_id check in subquery to filter the list based on transaction_detail_id.
-- =============================================
 */
 
Create Procedure [dbo].[usp_transaction_usage_detail_sel_by_acct]
(
  @p_account_id varchar(50)
, @p_contract_nbr varchar(50) 
, @p_ignore_chbk bit = 1 
, @p_vendor_id int = 0 
 )
AS
BEGIN 

	SET NOCOUNT ON

	SELECT u.* , d.reason_code , d.transaction_type_id
	FROM transaction_usage_detail u (NOLOCK)
		JOIN transaction_detail d (NOLOCK) ON d.transaction_detail_id = u.transaction_detail_id 
	WHERE d.account_id = @p_account_id 
		AND d.contract_nbr = @p_contract_nbr
		AND d.void = 0 
		AND (d.vendor_id = @p_vendor_id OR isnull(@p_vendor_id, 0) = 0 ) 
		AND ( @p_ignore_chbk = 1  
					OR  
				( @p_ignore_chbk = 0 AND d.transaction_detail_id not in
													(   SELECT transaction_detail_id FROM transaction_detail (NOLOCK)
														WHERE account_id = @p_account_id 
															AND contract_nbr = @p_contract_nbr
															AND (transaction_type_id = 2 OR ( transaction_type_id = 7 AND reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
															AND (assoc_transaction_id =  d.transaction_detail_id  OR ( d.transaction_type_id = 7 and assoc_transaction_id = d.assoc_transaction_id)) -- transaction voided or assoc with transaction that's voided
															AND approval_status_id <> 2 -- not rejected
															AND isnull(void, 0) = 0 
															
													)
			) ) 
				
	SET NOCOUNT OFF
END
