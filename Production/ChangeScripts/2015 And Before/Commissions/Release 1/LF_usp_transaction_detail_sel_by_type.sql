USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_transaction_detail_sel_by_type]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_transaction_detail_sel_by_type]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 8/14/2008
-- Description:	Get transaction detail
-- =============================================
-- Modified 10/2/2009 Gail Mangaroo 
-- Added Vendor_Descp field
-- =====================================================
-- 11/24/2009 Gail Mangaroo
-- Added (NOLOCK) optimizer hint and check for residual correction transactions
-- =============================================
-- 3/17/2011 Gail Mangaroo	
-- Added assoc transaction id param
--==============================================
-- 6/29/2011 Modified Gail Mangaroo
-- ignore voiding adjustments
-- =============================================
-- 10/21/2011 Gail Mangaroo 
-- Account for compound reason codes
-- =============================================
-- 5/9/2012 Gail Mangaroo
-- Ignore voided chargebacks
-- =============================================
-- =============================================
-- 10/22/2012 Lehem Felican
-- Added default value of '' for @p_account_id parameter
-- Added to WHERE clause account_id = @p_account_id Or @p_account_id = ''
-- =============================================
CREATE PROCEDURE [dbo].[usp_transaction_detail_sel_by_type] 
	  @p_account_id varchar(30) = ''
	, @p_contract_nbr varchar(30)
	, @p_vendor_id int 
	, @p_transaction_type_id int 
	, @p_payable_only bit = 1
	, @p_ignore_chbk bit = 0 
	, @p_reason_code varchar(50) = null
	, @p_assoc_trans_id int = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT d.* 
	FROM [lp_commissions].[dbo].[transaction_detail] d (NOLOCK)
	
	WHERE transaction_type_id = @p_transaction_type_id
		AND (account_id = @p_account_id Or @p_account_id = '')
		AND isnull(void, 0) = 0 
		-- status is not rejected or @p_payable_only = 0 
		AND ( (approval_status_id <> 2) OR  @p_payable_only = 0 )
		AND vendor_id = @p_vendor_id 
		AND contract_nbr = @p_contract_nbr
		AND ( -- check for a blank reason code as exact match 
			 (len(ltrim(rtrim(@p_reason_code))) = 0 AND len(ltrim(rtrim(d.reason_code))) = 0 )
				OR 
			 -- use pattern matching for non-empty reason codes
			 (len(ltrim(rtrim(@p_reason_code))) > 0 AND d.reason_code like ltrim(rtrim(@p_reason_code)) + '%')
				OR 
			-- return all if reason code not provided 
			  @p_reason_code is null
			)
		AND ( @p_ignore_chbk = 1  
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
		AND (assoc_transaction_id = @p_assoc_trans_id OR isnull(@p_assoc_trans_id, 0) = 0 )

	ORDER BY [transaction_detail_id]


END
GO