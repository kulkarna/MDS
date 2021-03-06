USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_transaction_detail_sel_by_category]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_transaction_detail_sel_by_category]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 7/22/2008
-- Description:	Get transaction detail
-- =============================================
-- 11/24/2009 Gail Mangaroo
-- Added (NOLOCK) optimizer hint and check for residual correction transactions
-- =============================================
-- 12/9/2010 Modified Gail Mangaroo 
-- allow contract_nbr and vendor_id to be ignored 
-- =============================================
-- 6/29/2011 Modified Gail Mangaroo
-- ignore voiding adjustments
-- =============================================
-- 10/21/2011 Gail Mangaroo 
-- Account for compound reason codes
-- =============================================
-- 12/15/2011 Gail Mangaroo 
-- Account for voided chargebacks
-- =============================================
-- =============================================
-- 11/05/2012 Lehem Felican
-- Added default value for account_id
-- =============================================
CREATE PROCEDURE [dbo].[usp_transaction_detail_sel_by_category] 
	
	@p_transaction_type_category varchar(20)
	, @p_account_id varchar(20) = ''
	, @p_contract_nbr varchar(30)
	, @p_vendor_id int 
	, @p_payable_only bit = 1
	, @p_ignore_chbk bit = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	  SELECT  d.* 
	
	  FROM [lp_commissions].[dbo].[transaction_detail] d (NOLOCK)
		JOIN transaction_type t ON t.transaction_type_id = d.transaction_type_id 
 
	  WHERE transaction_type_category = @p_transaction_type_category
			AND (account_id = @p_account_id OR @p_account_id = '')
			AND isnull(void, 0) = 0 
			-- status is not rejected or @p_payable_only = 0 
			AND ( (approval_status_id <> 2) OR  @p_payable_only = 0 )
			AND (vendor_id = @p_vendor_id OR @p_vendor_id = 0) 
			AND (contract_nbr = @p_contract_nbr OR ltrim(rtrim(isnull(@p_contract_nbr, ''))) = '') 

			AND ( @p_payable_only = 0  
					OR @p_ignore_chbk = 1 
					OR NOT EXISTS (--chargebacks
									SELECT chbk.transaction_detail_id 
									FROM lp_commissions..transaction_detail chbk (NOLOCK)
										LEFT JOIN lp_commissions..transaction_detail void (NOLOCK) ON void.assoc_transaction_id = chbk.transaction_detail_id 
											AND void.void = 0 
											AND void.transaction_type_id = 7 
											AND void.reason_code like '%C0012%' -- Void
											
									WHERE ( chbk.transaction_type_id = 2 -- chargeback 
												OR 
											( chbk.transaction_type_id = 7 -- Adjustment 
												AND chbk.reason_code like '%C0012%' -- Void
											)
										   ) 
										AND chbk.assoc_transaction_id =  d.transaction_detail_id 
										AND chbk.approval_status_id <> 2 -- not rejected
										AND isnull(chbk.void, 0) = 0
										AND void.transaction_detail_id is null -- chbk not voided
										
									UNION 
										
									-- residual correction transactions
									SELECT transaction_detail_id FROM transaction_detail (NOLOCK)
									WHERE transaction_type_id = 7 -- adjustment 
										AND assoc_transaction_id =  d.transaction_detail_id 
										AND reason_code like '%C3001%'
										AND approval_status_id <> 2 -- not rejected
										AND isnull(void, 0) = 0  
										AND d.transaction_type_id = 6 -- source transaction is a residual
																			
									)
				) 
		
		ORDER BY date_created 

END
GO