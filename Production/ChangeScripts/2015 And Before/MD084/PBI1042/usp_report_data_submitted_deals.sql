USE [lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_report_data_submitted_deals]    Script Date: 10/16/2012 04:02:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================
-- Author:			Gail Mangaroo 
-- Created Date:	2/1/2012
-- Description:		Get report detail for submitted deals report 
-- =====================================================
-- Modified 9/20/2012 Gail Mangaroo 
-- Use LibertyPower..Name 
-- =====================================================
-- exec usp_report_data_submitted_deals '1/1/2012' ,'2/1/2012'
ALTER Procedure [dbo].[usp_report_data_submitted_deals]
(
@p_start_date datetime
, @p_end_date datetime 
, @p_vendor_id int = 0
)
AS 
BEGIN 

	--declare @p_start_date datetime
	--declare @p_end_date datetime 
	--declare @p_vendor_id int 

	--set @p_start_date = '9/1/2012'
	--set @p_end_date = '9/21/2012'
	--set @p_vendor_id = 27 
	
	SELECT sc.ChannelName, ac.AccountIdLegacy, ac.AccountNumber, cn.Number , full_name = an.Name , mk.MarketCode , act.Description, cn.SubmitDate , acr.LegacyProductID 
		, u.UtilityCode, acr.Rate as ContractRate, Term = acr.Term, cn.SalesRep , au.AnnualUsage, s.status, s.substatus, es.Status_descp 
		, CommissionsBaseAmt = d.base_amount, CommissionsRate = d.rate , CommissionsAmt = d.amount, CommissionsChbkAdj = void.amount
		, CommissionsPymtTerm = d.term , CommissionsDueDate = d.date_due , CommissionsStatus = sl.status_code
		--term salesrep sttaus
	FROM LibertyPower.dbo.Account ac (NOLOCK) 
		JOIN LibertyPower.dbo.AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID
		JOIN LibertyPower.dbo.Contract cn (NOLOCK) ON acn.ContractID = cn.ContractID
		JOIN lp_Commissions.dbo.vendor v (NOLOCK) ON v.ChannelID = cn.SalesChannelID
		JOIN LibertyPower.dbo.Name an (NOLOCK) ON an.NameID = ac.AccountNameID
		JOIN LibertyPower.dbo.Market mk (NOLOCK) ON mk.ID = ac.RetailMktID
		JOIN LibertyPower.dbo.AccountType act (NOLOCK) ON act.ID = ac.AccountTypeID
		--JOIN LibertyPower.dbo.AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acn.AccountContractID 
				--AND IsContractedRate = 1 
		JOIN LibertyPower.dbo.vw_AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acn.AccountContractID 
			AND acr.IsContractedRate = 1
		JOIN LibertyPower.dbo.Utility u (NOLOCK) ON u.ID = ac.UtilityID
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.CHannelID = cn.SalesChannelID 
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON s.AccountContractID = acn.AccountContractID 
		LEFT JOIN LibertyPower.dbo.AccountUsage au (NOLOCK) ON ac.AccountID = au.AccountID AND  cn.StartDate = au.EffectiveDate
		LEFT JOIN lp_account.dbo.enrollment_status es (NOLOCK) ON s.status = es.status
		LEFT JOIN lp_Commissions.dbo.transaction_detail d (NOLOCK) ON d.account_id = ac.AccountIDLegacy AND cn.Number = d.contract_nbr
			AND d.void = 0 
			AND d.transaction_type_id in ( 1,5 ) 	
			AND d.vendor_id = v.vendor_id
		LEFT JOIN lp_Commissions.dbo.transaction_detail void (NOLOCK) ON void.assoc_transaction_id = d.transaction_detail_id 
			AND void.void = 0 
			AND void.transaction_type_id in ( 7,9 ) -- reason_code like '%C0012%'
		LEFT JOIN lp_Commissions.dbo.status_list sl (NOLOCK) ON sl.status_id = d.approval_status_id 
		
	WHERE cn.SubmitDate between @p_start_date and @p_end_date 
		AND (v.vendor_id = @p_vendor_id OR @p_vendor_id = 0 )
		AND void.transaction_detail_id is null 
		
	ORDER BY ChannelName, Full_name

END 
