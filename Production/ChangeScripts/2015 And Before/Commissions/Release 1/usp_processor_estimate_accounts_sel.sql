USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_processor_estimate_accounts_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_processor_estimate_accounts_sel]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 1/26/2011
-- Description:	Get accounts that require commission estimates
-- =============================================
-- Modified: 5/5/2011 Gail Mangaroo 
-- include accounts that need refreshed estimates
-- =============================================
-- Modified: 1/12/2012 Gail Mangaroo
-- Refresh when rate = 0 or rate is different in transaction_detail 
-- =============================================
-- Modified:1/17/2012 Gail Mangaroo 
-- Correct renewal acct condition
-- =============================================
-- Modified 2/3/2012 Gail Mangarpp 
-- Aletered to use new LibertyPower..Account structure 
-- rename sp 
-- =============================================
-- MOdified 12/10/2012 Gail Mangaroo
-- Compare estimates against account data
-- =============================================
CREATE Procedure [dbo].[usp_processor_estimate_accounts_sel]
(@p_start_date datetime =  null ) 

AS
BEGIN 
		-- default 1 month
		--declare @p_start_date datetime 
		SELECT @p_start_date = isnull(@p_start_date, dateadd(month , -2, getdate()) )
		
		SELECT DISTINCT account_id, contract_nbr, vendor_id, estimate_id, rate, base_amount, amount, comm_rate, comm_base_amount, comm_amt 
		FROM 
		(
			SELECT account_id = ac.accountIdLegacy
				, contract_nbr = cn.Number
				, rate = isnull(e.rate, 0) 
				, v.vendor_id
				, e.estimate_id 
				, comm_rate = isnull(d.rate, 0) 
				, e.amount 
				, comm_amt = isnull(d.amount, 0) 
				, e.base_amount
				, comm_base_amount = isnull(d.base_amount, 0)
			
			FROM LibertyPower..Account ac (NOLOCK) 
				JOIN LibertyPower..AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID 
				JOIN LibertyPower..Contract cn (NOLOCK) ON cn.ContractID = acn.ContractID 
				--JOIN LibertyPower..SalesChannel sc (NOLOCK) ON sc.ChannelID = cn.SalesChannelID
				JOIN lp_commissions..vendor v (NOLOCK) ON cn.SalesChannelID = v.ChannelID 
				JOIN LibertyPower..SalesChannelAccountType scat (NOLOCK) on scat.ChannelID = cn.SalesChannelID 
					AND scat.AccountTypeID = ac.AccountTypeID
					AND scat.MarketID = ac.RetailMktID
				JOIN LibertyPower..AccountContractRate acr (NOLOCK)  on acn.accountContractId = acr.AccountContractId 
					AND isContractedRate = 1
				JOIN LibertyPower..AccountUsage asg (NOLOCK)  on asg.AccountID = ac.accountId
				LEFT JOIN lp_commissions..commission_estimate e (NOLOCK) ON e.account_id = ac.accountIdLegacy
						AND e.contract_nbr = cn.Number   
						AND e.vendor_id = v.vendor_id 
				LEFT JOIN lp_commissions..transaction_detail d (NOLOCK) ON d.account_id = ac.accountIdLegacy
						AND d.contract_nbr = cn.Number   
						AND d.vendor_id = v.vendor_id
						AND d.void = 0 
						AND d.transaction_type_id in ( 1,5 ) 
			WHERE 1 = 1
				AND (e.estimate_id is null 
						or e.rate <> d.rate 
						or ( e.base_amount <> d.base_amount AND d.reason_code not like '%c5000%' ) 
						or ( d.rate is null
							AND ( e.rate = 0 
								or e.contract_rate <> acr.Rate 
								or e.base_amount <> asg.annualUsage  
								) 
							)
					) 
				AND cn.SignedDate >= @p_start_date
				--AND a.status not in ( '911000' , '999999' , '999998' ) 
			
			UNION 
			
			SELECT e.account_id, e.contract_nbr, rate = 0 , v.vendor_id, estimate_id, comm_rate = 0 , e.amount , comm_amt = 0 , e.base_amount, comm_base_amount = 0
			FROM lp_commissions..commission_estimate e (NOLOCK)
				JOIN lp_commissions..vendor v (NOLOCK) ON v.vendor_id = e.vendor_id 
			WHERE e.rate is null 
				OR e.init_pymt_opt_def_id is null 
				OR e.res_pymt_opt_def_id is null 
				OR e.evg_pymt_opt_def_id is null     
	 )	as a  
	
END 
GO 