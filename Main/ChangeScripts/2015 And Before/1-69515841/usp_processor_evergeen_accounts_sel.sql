USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * usp_processor_evergreen_accounts_sel

 * Get acounts due for an  evergreen payment
 
 * History

 *******************************************************************************

 * 12/11/2008 Gail Mangaroo.

 * Created.

 *******************************************************************************

-- Modified 6/3/2010
-- Altered to leverage account overrides & rename sp.
-- ===============================================
-- Modified 8/17/2010 Gail Mangaroo
-- Altered to created just the first payment for evergeen 
-- ===============================================
-- Modified 8/5/2011 Gail Mangaroo
-- Altered to exclude voiding adjustment transaction 
-- ===============================================
-- Modified 8/18/2011 Gail Mangaroo 
-- Altered to use isDefault field to detect rollover products/contracts 
-- ===============================================
-- Modified 8/25/2011 Gail Mangaroo
-- Added NOLOCK hints
-- ===============================================
-- Modified 12/7/2012 Gail Mangaroo 
-- Use LibertyPower..Account structure, remove reference to payment option fields on vendor table
-- ===============================================
-- Modified 2/26/2013 Gail Mangaroo 
-- Fix error with Last_count field missing.
-- ===============================================
 */

ALTER Procedure [dbo].[usp_processor_evergreen_accounts_sel]
(@p_period_end_date datetime  = null  )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @p_period_end_date datetime  
	--SET @p_period_end_date = isnull(@p_period_end_date, getdate()) 

	SELECT DISTINCT 
		account_id = ac.accountIDLegacy 
		, contract_nbr  = cn.Number 
		, date_deal = cn.signedDate 
		, contract_type = ct.[Type]
		, term_months = acr.Term 
		, sales_channel_role = v.vendor_system_name 
		, v.vendor_id 
		, contract_eff_start_date = cn.StartDate 
		, last_count = 0

	FROM LibertyPower..Account ac (NOLOCK) 
		JOIN LibertyPower..AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID
		JOIN LibertyPower..Contract cn (NOLOCK) ON acn.ContractID = cn.ContractID
		JOIN LibertyPower..AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acn.AccountContractID 
			AND IsContractedRate = 0 -- rolled over to the variable
		JOIN lp_Commissions..vendor v (NOLOCK) ON v.ChannelID = cn.SalesChannelID
		LEFT JOIN LibertyPower..AccountContractCommission acomm (NOLOCK) ON acomm.AccountContractID = acn.AccountContractID
		LEFT JOIN LibertyPower..AccountStatus s (NOLOCK) ON s.AccountContractID = acn.AccountContractID 
		LEFT JOIN LibertyPower..ContractType ct (NOLOCK) ON ct.contractTypeID = cn.contractTypeID
		LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id 
				
		LEFT JOIN transaction_detail d (NOLOCK) on ac.accountIDLegacy  = d.account_id 
			and cn.Number = d.contract_nbr 
			and d.vendor_id = v.vendor_id
			and d.void = 0 
			and d.approval_status_id = 1
			and d.transaction_type_id in (1,5)  
			
		LEFT JOIN transaction_detail chbk (NOLOCK) on d.transaction_detail_id = chbk.assoc_transaction_id 
			and chbk.void = 0 
			and chbk.approval_status_id = 1 
			and (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%')) 	-- chargeback or voiding adjustment
			
		LEFT JOIN transaction_detail evg (NOLOCK) on ac.accountIDLegacy = evg.account_id 
			and cn.Number = evg.contract_nbr 
			and evg.vendor_id = v.vendor_id
			and evg.void = 0 
			and evg.transaction_type_id = 8
			
	WHERE 1 = 1 
		AND s.[status] in ('905000','906000', '05000', '06000')				-- account is active 
		AND v.inactive_ind  = 0												-- vendor active 
		AND @p_period_end_date > dateadd(month, acr.Term, acr.RateStart )  -- term ended
		AND (p.isDefault = 1 OR p.product_id in (SELECT product_id  
													FROM lp_common..common_product (NOLOCK) 
													WHERE default_expire_product_id =  p.product_id						
												   )
			) -- Rolled over
			
		AND d.transaction_detail_id is not null   -- original commission found
		AND chbk.transaction_detail_id is null 
		AND evg.transaction_detail_id is null -- no evergreen payments yet made
		
		AND (
				(v.allow_account_override = 1 AND isnull(acomm.EvergreenOptionID, 0 ) > 0 )
					OR
				(SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
						FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
							JOIN lp_commissions..payment_option po (NOLOCK) on vpo.payment_option_id = po.payment_option_id 
						WHERE vpo.date_effective <= cn.SignedDate 
							AND ( vpo.date_end >= cn.SignedDate OR isnull(vpo.date_end , '1/1/1900' ) = '1/1/1900' )
							AND vpo.active = 1 
							AND po.payment_option_type_id = 3
							AND vendor_id = v.vendor_ID
						ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 ) > 0 
			 )
		AND cn.ContractStatusID <> 2 -- Not Rejected 
END 	
