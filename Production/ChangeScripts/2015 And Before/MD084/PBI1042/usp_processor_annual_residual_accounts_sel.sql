USE [lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_processor_annual_residual_accounts_sel]    Script Date: 10/16/2012 03:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 7/12/2008
-- Description:	Retrieves all accounts due for annual residual
-- =============================================
-- Modified  8/28/2009 Gail Mangaroo
-- Altered to take into account retry dates on transaction_request
-- =============================================
-- Modified 9/3/2009
-- Altered to include renewal contracts which were dropped after some other mod 
-- =============================================
-- Modified 9/10/2009
-- Altered to ignore flow start dates since renewal contracts can have very old flow start dates
-- =============================================
-- Modified 12/30/2009 
-- Altered to ignore accounts with existing errors & modifications for the 50/50 payment option 
-- =============================================
-- Modified 6/3/2010
-- Altered to leverage account overrides & rename sp.
-- =============================================
-- execute usp_processor_annual_residual_accounts_sel '8/12/2010'

-- ==============================================
-- Modified 8/12/2010 Gail Mangaroo 
-- Temporarily disable 
-- ==============================================
-- Modified 8/17/2010 Gail Mangaroo 
-- enabled 
-- ==============================================
-- Modified 9/22/2010 Gail Mangaroo
-- Optimized for speed to prevent timeouts
-- ==============================================
-- Modified 9/29/2010 Gail Mangaroo 
-- Temporarily disable 
-- ==============================================
-- Modified 10/6/2010 Gail Mangaroo 
-- re-enable
-- ==============================================
-- Modified 4/12/2011 Gail Mangaroo 
-- remove transaction_request_error records from selection condition
-- ==============================================
-- Modified 4/27/2011 Gail Mangaroo 
-- correct issues with second residual payment not being made.
-- ==============================================
-- Modified 6/1/2011 Gail Mangaroo 
-- Ignore account status 
-- ==============================================
-- Modified 6/9/2011 Gail Mangaroo
-- fix issue with total_payment_term not populating
-- ==============================================
-- Modified 6/22/2011 Gail Mangaroo 
-- Ignore residual payments that have been charged back 
-- ==============================================
-- Modified 8/2/2011 Gail Mangaroo 
-- revert to ignoring accounts not currently flowing. These accounts should be taken care of in the true-up process.
-- added new true-up transaction type 
-- ==============================================
-- Modified 8/9/2011 Gail Mangaroo 
-- Modified for performance and correct conversion error
-- ==============================================
-- Modified 10/19/2011 Gail Mangaroo
-- Added function to generate residual payment number
-- ==============================================
-- Modified 10/19/2011 Gail Mangaroo
-- Added function to generate residual payment number
-- Ignore trueUp only transactions
-- ==============================================
-- Modified 1/25/2012 Gail Mangaroo
-- Compare paid term with contrct term on account since contract term on account may have been modified since transations generd 
-- Do not compute pymt/anniversay #.. let code handle it...
-- ==============================================
-- Modified 2/2/2012 Gail Mangaroo 
-- Altered to use new LibertyPower..account structure 
-- ==============================================
-- exec usp_processor_annual_residual_accounts_sel '9/22/2012'

ALTER PROCEDURE [dbo].[usp_processor_annual_residual_accounts_sel] 
	(@p_period_end_date datetime = null 
	, @p_exclude_pending bit = 0
	)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT account_id  = ac.AccountIDlegacy , ac.AccountNumber, contract_nbr = cn.Number , Term = sum(acr.Term)
		 , rateStart = min(acr.rateStart), sum(comm.term) as term_paid , last_anniv_number = 0 , v.vendor_system_name 
	
	FROM LibertyPower..Account ac (NOLOCK) 
		JOIN LibertyPower..AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID
		JOIN LibertyPower..Contract cn (NOLOCK) ON acn.ContractID = cn.ContractID
		JOIN LibertyPower..AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acn.AccountContractID 
			AND IsContractedRate = 1 
		JOIN lp_Commissions..vendor v (NOLOCK) ON v.ChannelID = cn.SalesChannelID
		LEFT JOIN LibertyPower..AccountContractCommission acomm (NOLOCK) ON acomm.AccountContractID = acn.AccountContractID
		LEFT JOIN LibertyPower..AccountStatus s (NOLOCK) ON s.AccountContractID = acn.AccountContractID 
			
		JOIN lp_commissions..transaction_detail comm (NOLOCK) ON comm.account_id = ac.accountIdLegacy   
			AND comm.contract_nbr = cn.Number
			AND comm.vendor_id  = v.vendor_id
			AND comm.transaction_type_id in ( 1,5, 6) 
			AND comm.void = 0 
			AND comm.approval_status_id <> 2 
			AND comm.reason_code not like 'c5000%' -- not ATMS//payment option def id ????
			
		LEFT JOIN lp_commissions..transaction_detail chbk (NOLOCK) ON comm.transaction_detail_id = chbk.assoc_transaction_id
			AND (chbk.transaction_type_id = 2 OR ( chbk.transaction_type_id = 7 AND chbk.reason_code like '%C0012%'))  -- chargeback or voiding adjustment
			AND chbk.void = 0 
			AND chbk.approval_status_id <> 2 
		
		LEFT JOIN lp_commissions..transaction_request e (NOLOCK) ON e.account_id = ac.accountIdLegacy  
				AND e.contract_nbr = cn.Number 
				AND e.transaction_type_code in ( 'ANNUALCOMM' , 'RESIDUALCOMM' ) 
				AND v.vendor_system_name = e.vendor_system_name
				AND (e.process_status in ( '0000003') or e.process_status is null )
				
	WHERE s.status in ('905000','906000', '05000', '06000')					-- Account is flowing
		AND comm.transaction_detail_id is not null							-- Commission/Residual is paid
		AND chbk.transaction_detail_id is null								-- Commission/Residual not charged back
		AND (
				(v.allow_account_override = 1 AND isnull(acomm.ResidualOptionID, 0 ) > 0 AND isnull(acomm.ResidualOptionID, 0 ) <> 7 )
					OR
				(SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
						FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
							JOIN lp_commissions..payment_option po (NOLOCK) on vpo.payment_option_id = po.payment_option_id 
						WHERE vpo.date_effective <= cn.SignedDate 
							AND vpo.active = 1 
							AND po.payment_option_type_id = 2
							AND vendor_id = v.vendor_ID
							AND vpo.payment_option_id <> 7 -- TrueUp only 
						ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 ) > 0 
			 )
		AND not ( cn.ContractDealTypeID = 2 AND cn.ContractStatusID = 2 )	-- Not Rejected Renewals
		AND e.request_id IS NULL											-- No Request pending
		AND cn.SubmitDate > dateadd ( year , -3 , getdate()  )				-- Submitted in the last 3 yrs - just to limit data
		AND v.inactive_ind = 0												-- Active vendor
		
	Group BY ac.AccountIDlegacy, ac.AccountNumber , cn.Number, v.vendor_system_name 
	
	Having sum(comm.term) < sum(acr.Term)										-- term paid is less than contract term)
		AND dateadd(month, sum(comm.term), min(acr.rateStart) ) < getdate()		-- due for next payment
		
END
