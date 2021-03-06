USE [lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_rollover_detail_sel]    Script Date: 10/15/2012 22:39:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 
-- Description:	Get account details prior to a rollover
-- =============================================
-- Modified: 8/5/2009 Gail Mangaroo
-- Altered to accept product_id as additonal parameter
-- =============================================
-- Modified: 9/10/2009 Gail Mangaroo 
-- Added de-enrollment date 
-- =============================================
-- Modified: 2/18/2011 Gail Mangaroo 
-- Added date_deenrolled in addition to date_deenrollment
-- simplified to a single query 
-- =============================================
-- Modified: 8/17/2011 Gail Mangaroo 
-- Altered to use isDefault column to determine if the product is a rollover product
-- =============================================
-- Modified: 10/17/2011 Gail Mangaroo 
-- Added contract_eff_start_date as parameter to account for times when product changes after rollover e.g. ONCOR_VAR v TXU_VAR
-- =============================================
-- Modified: 3/8/2012 Gail Mangaroo
-- Modified to use new LibertyPower..Account structure
-- =============================================
-- exec usp_account_rollover_detail_sel '2009-0023409' , '90008363A', 'AMEREN_IP_ABC' , '2010-10-02 00:00:00.000'

ALTER Procedure [dbo].[usp_account_rollover_detail_sel] 
( 
	@p_account_id varchar(35)  
	, @p_contract_nbr varchar(35)
	, @p_product_id varchar(35) 
	, @p_contract_eff_date datetime = null
) 
AS
BEGIN

	SELECT account_id = a.accountIDLegacy
		, p.product_id 
		, contract_nbr = c.Number
		, contract_eff_start_date = c.StartDate
		, date_flow_start = acr.RateStart
		, term_months = acr.Term
		, contract_type = cdt.DealType
		, cdt.ContractDealTypeID
		, date_deal = c.SignedDate
		, rate = acr.Rate
		, rate_id = Acr.RateID 
		, date_deenrollment = null
		, date_deenrolled = null
		, zaudit_id  = null 
		, status = acs.status 
		, sub_status = acs.SubStatus

		,acr.IsContractedRate 
	
	FROM LibertyPower..Account a (NOLOCK) 
		JOIN LibertyPower..AccountContract acc (NOLOCK) ON a.accountid = acc.accountid
		JOIN LibertyPower..Contract c (NOLOCK) ON acc.contractid = c.contractid 
		--JOIN LibertyPower..AccountContractRate acr (NOLOCK) ON acr.accountContractID = acc.accountContractID 
		JOIN LibertyPower.dbo.vw_AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acc.AccountContractID
		JOIN LibertyPower..ContractDealType cdt (NOLOCK) ON c.ContractDealTypeID = cdt.ContractDealTypeID
		JOIN LibertyPower..AccountStatus acs (NOLOCK) ON acs.AccountContractId = acc.AccountContractId
		JOIN lp_common..common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id
		
	WHERE a.AccountidLegacy = @p_account_id
		AND c.Number = @p_contract_nbr
		AND acr.IsContractedRate = 0 
		AND (p.isDefault = 1 OR p.product_id in (SELECT product_id  
													FROM lp_common..common_product (NOLOCK) 
													WHERE default_expire_product_id = @p_product_id 							
												   )
			)
	ORDER BY acr.AccountContractRateID desc 

/*
	DECLARE @isDefault int 
	
	-- see if product is a rollover product
	SELECT @isDefault = isnull(isDefault, 0) 
	FROM lp_common..common_product 
	WHERE product_id = @p_product_id

	-- Get all records where the product rolls over into the current product 
	SELECT TOP 1  account_id , product_id , contract_nbr , contract_eff_start_date , date_flow_start , term_months , contract_type , date_deal , rate , rate_id , date_deenrollment, date_deenrolled = date_deenrollment, zaudit_id  = zaudit_account_id , status , sub_status
	FROM lp_account..zaudit_account 
	WHERE account_id = @p_account_id
		AND contract_nbr = @p_contract_nbr
		AND (product_id in (SELECT product_id  
							FROM lp_common..common_product 
							WHERE default_expire_product_id = @p_product_id 							
						   )
			 OR @isDefault = 1
			 ) 
		AND product_id <> @p_product_id	
		AND (contract_eff_start_date <> 	@p_contract_eff_date OR @p_contract_eff_date is null ) 	
		
	ORDER BY zaudit_account_id  DESC 

*/
END 
