USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_processor_trueup_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_processor_trueup_accounts_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 8/3/2011
-- Description:	Retrieves all commission/residual payments accounts due for a true up
-- =============================================
-- Modifed 8/8/2011 Gail Mangaroo 
-- Temporarily disable trueing up chargedback accounts 
-- =============================================
-- Modified 8/25/2011 Gail Mangaroo
-- removed 2nd join with transaction request, corrected date field used in selection 
-- =============================================
-- Modified 9/14/2011 Gail Mangaroo
-- Activate TrueUP on chargedback accounts as 8/1/2011
-- =============================================
-- Modified 9/22/2011 Gail Mangaroo
-- Fixed effective date 
-- =============================================
-- Modified 10/16/2011 Gail Mangaroo 
-- temp disable 
-- ==============================================
-- Modified 11/7/2011 Gail Mangaroo 
-- Altered to trueup last transaction (per type) so as to avoid dups 
-- ==============================================
-- Modified 11/10/2011 Gail Mangaroo 
-- enabled
-- =============================================
-- Modified 12/7/2012 Gail Mangaroo 
-- Use LibertyPower..Account and remove reference to payment option fields in vendor tables 
-- =============================================

CREATE PROCEDURE [dbo].[usp_processor_trueup_accounts_sel] 
	(@p_period_end_date datetime  = null 
	, @p_exclude_pending bit = 0
	 )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--drop table #comm_temp
	--declare @p_exclude_pending bit  
	
	SELECT max(comm.transaction_detail_id ) as transaction_detail_id 
				, comm.account_id
				, comm.contract_nbr
				, comm.vendor_id 
				, case when comm.transaction_type_id = 5 then 1 else comm.transaction_type_id end as transaction_type_id 
				, count(comm.transaction_detail_id ) as tran_count 
				, comm.term 
				, comm.date_term_start 
				, comm.date_deal 
				, comm.amount 
				, comm.reason_Code 
				
		INTO #comm_temp 
	
	FROM lp_commissions..transaction_detail comm (NOLOCK) 
		
		LEFT JOIN lp_commissions..transaction_detail void (NOLOCK) ON comm.transaction_detail_id = void.assoc_transaction_id
				AND void.transaction_type_id in ( 2, 7) 
				AND void.void = 0 
				AND void.approval_status_id <> 2 
				AND void.reason_code like '%C0012%'
			
	WHERE  comm.transaction_type_id in ( 1,5 ,6 ) 
		AND comm.void = 0 
		AND comm.approval_status_id <> 2 
		AND void.transaction_detail_id is null						-- original commission not voided
		AND comm.reason_code not like '%c5000%'						-- not ATMS 
		--and comm.account_id = '2011-0067010'
		
	GROUP BY  comm.account_id, comm.contract_nbr, comm.vendor_id, case when comm.transaction_type_id = 5 then 1 else comm.transaction_type_id end 
			, comm.term , comm.date_term_start ,  comm.date_deal , comm.amount , comm.reason_code 
			
	SELECT DISTINCT
		
		comm.account_id 
		, comm.contract_nbr 
		, v.vendor_system_name
		, comm.transaction_detail_id
		
	FROM #comm_temp comm 
		
		JOIN lp_commissions..vendor v (NOLOCK) ON comm.vendor_id = v.vendor_id 
	
		JOIN LibertyPower..account acc (NOLOCK) ON comm.account_id = acc.accountIDLegacy
		JOIN LibertyPower..Contract cn (NOLOCK) ON comm.contract_nbr = cn.Number
		JOIN LibertyPower..accountContract acn (NOLOCK) ON acn.Accountid = acc.accountID 
			AND cn.ContractId = acn.ContractID
		JOIN LibertyPower..accountContractCommission acm (NOLOCK) ON acm.accountContractID = acn.accountContractID
				
		LEFT JOIN lp_commissions..transaction_detail chbk (NOLOCK) ON comm.transaction_detail_id = chbk.assoc_transaction_id
			AND chbk.transaction_type_id in ( 2 ) 
			AND chbk.void = 0 
			AND chbk.approval_status_id <> 2 
			
		LEFT JOIN lp_commissions..transaction_detail trueup (NOLOCK) ON comm.account_id = trueup.account_id 
			AND trueup.contract_nbr = comm.contract_nbr
			AND trueup.vendor_id  = comm.vendor_id
			AND trueup.transaction_type_id in ( 7, 9) 
			AND (trueup.reason_code like '%c2000%' -- end of term reason_code
					OR trueup.reason_code like '%c3000%' -- residual payment reason_code 
					OR trueup.reason_code like '%c3002%' -- trueup payment reason code 
				) 
			AND trueup.void = 0 
			
		LEFT JOIN lp_commissions..transaction_detail void2 (NOLOCK) ON trueup.transaction_detail_id = void2.assoc_transaction_id
			AND void2.transaction_type_id in ( 2, 7) 
			AND void2.void = 0 
			AND void2.approval_status_id <> 2 
			AND void2.reason_code like '%C0012%'
											
		JOIN lp_commissions..vendor_payment_option vpo (NOLOCK) ON vpo.vendor_id = v.vendor_ID
			AND vpo.active = 1 
																		
		JOIN lp_commissions..payment_option po (NOLOCK) ON vpo.payment_option_id = po.payment_option_id 
			AND po.payment_option_type_id = 2
		
		JOIN lp_commissions..payment_option_setting	pos (NOLOCK) ON pos.payment_option_id = po.payment_option_id 
		
		JOIN lp_commissions..payment_option_def	pod (NOLOCK) ON pos.payment_option_def_id = pod.payment_option_def_id
						 
		LEFT JOIN lp_commissions..transaction_request e (NOLOCK) ON comm.account_id = e.account_id 
			AND comm.contract_nbr = e.contract_nbr 
			AND e.transaction_type_code in ( 'TRUEUP' ) 
			AND v.vendor_system_name = e.vendor_system_name
			AND (e.process_status in ( '0000003') or e.date_processed is null )
			
		LEFT JOIN lp_commissions..transaction_request e3 (NOLOCK) ON comm.account_id = e3.account_id 
			AND comm.contract_nbr = e3.contract_nbr 
			AND e3.transaction_type_code in ( 'TRUEUP' ) 
			AND v.vendor_system_name = e3.vendor_system_name
			AND e3.process_status = '0000002' 
								
	WHERE 1 = 1 --- temp disable 
		AND v.inactive_ind  = 0										-- vendor active 
		AND (@p_exclude_pending = 0 OR e.request_id IS NULL)		-- exclude pending transaction_request unless otherwise specified
		AND ((@p_exclude_pending = 0 AND e.request_id IS NOT NULL) 
				OR e3.request_id IS NULL )							-- exclude errors
		AND comm.transaction_detail_id is not null					-- original commission paid
		
		
		AND trueup.transaction_detail_id is null					-- trueup transaction not yet created
		AND void2.transaction_detail_id is null						-- trueup transaction is voided
		
		AND comm.date_deal > case when chbk.transaction_detail_id is null 
					then '1/1/2001' else '8/1/2011' end				-- only true up onchargebacks as of '8/1/2011'
		
		AND ( dateadd ( month , comm.term , case when comm.date_term_start < comm.date_deal 
					then comm.date_deal else comm.date_term_start end 
					) <= getdate()									-- some transactions have an incorrect date_term_start
			
				OR chbk.date_term_end <= getdate()					-- don't wait until term end date if already chargedback; use deenrollment date
			) 
					
		AND abs(comm.amount) <> abs(isnull(chbk.amount, 0))			-- if nothing was paid then no need to true-up
		
			
		 -- account override set
		AND	((v.allow_account_override = 1 and isnull(acm.ResidualOptionID, 0) > 0)  
			  OR 
			  -- vendor option set 
			  ( (SELECT TOP 1 isnull(vpo.payment_option_id, 0 ) 
					FROM lp_commissions..vendor_payment_option vpo (NOLOCK)
						JOIN lp_commissions..payment_option po on vpo.payment_option_id = po.payment_option_id 
					WHERE vpo.date_effective <= comm.date_deal 
						AND ( vpo.date_end > comm.date_deal OR isnull(vpo.date_end, '1/1/1900')  = '1/1/1900' ) 
						AND vpo.active = 1 
						AND po.payment_option_type_id = 2
						AND vendor_id = v.vendor_ID
					ORDER BY vpo.vendor_id , vpo.date_effective desc 
				 )  > 0 
				) 
			)

		
	order by 3,2
		
END
GO
