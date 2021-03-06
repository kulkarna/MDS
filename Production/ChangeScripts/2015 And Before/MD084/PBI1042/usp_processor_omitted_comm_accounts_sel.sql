USE [lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_processor_omitted_comm_accounts_sel]    Script Date: 10/16/2012 03:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 2/2/2012
-- Description:	Retrieves all accounts not yet paid
-- =============================================
-- Modified 2/9/2012 Gail Mangaroo 
-- account for duplicate IL market
-- =============================================
-- exec usp_processor_omitted_comm_accounts_sel '3/1/2012'

ALTER Procedure [dbo].[usp_processor_omitted_comm_accounts_sel]
( @p_start_date datetime ) 
AS 
BEGIN 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT DISTINCT account_id  = ac.AccountIDlegacy , ac.AccountNumber, contract_nbr = cn.Number , Term = sum(acr.Term )
		, rateStart = min(acr.rateStart), sales_channel_role = v.vendor_system_name , cn.SubmitDate, contract_type = cdt.dealType
	
	FROM LibertyPower..Account ac (NOLOCK) 
		JOIN LibertyPower..AccountContract acn (NOLOCK) ON acn.AccountID = ac.AccountID
		JOIN LibertyPower..Contract cn (NOLOCK) ON acn.ContractID = cn.ContractID
		JOIN LibertyPower..AccountContractRate acr (NOLOCK) ON acr.AccountContractID = acn.AccountContractID AND IsContractedRate = 1 
		JOIN lp_Commissions..vendor v (NOLOCK) ON v.ChannelID = cn.SalesChannelID
		LEFT JOIN LibertyPower..AccountContractCommission acomm (NOLOCK) ON acomm.AccountContractID = acn.AccountContractID
		LEFT JOIN LibertyPower..AccountStatus s (NOLOCK) ON s.AccountContractID = acn.AccountContractID 
		
		JOIN LibertyPower..ContractDealType cdt (NOLOCK) ON cdt.ContractDealTypeID = cn.ContractDealTypeID
		
		JOIN LibertyPower..Market m (NOLOCK) on m.ID = ac.RetailMktId
		
		JOIN ( SELECT scat.*, m.MarketCode -- duplicate IL 
					FROM LibertyPower..SalesChannelAccountType scat (NOLOCK) 
						JOIN LibertyPower..Market m (NOLOCK) ON scat.MarketID = m.ID 
				 ) scat ON scat.ChannelID = v.ChannelID 
					AND ac.AccountTypeID = scat.AccountTypeID
					AND (ac.RetailMktID = scat.MarketID or m.MarketCode = scat.MarketCode)  -- duplicate IL
		
		LEFT JOIN lp_commissions..transaction_detail comm (NOLOCK) ON comm.account_id = ac.accountIdLegacy   
			AND comm.contract_nbr = cn.Number
			AND comm.vendor_id  = v.vendor_id
			AND comm.transaction_type_id in ( 1,5) 
			AND comm.void = 0 
						
		LEFT JOIN lp_commissions..transaction_request e (NOLOCK) ON e.account_id = ac.accountIdLegacy  
				AND e.contract_nbr = cn.Number 
				AND e.transaction_type_code in ( 'COMM', 'RENEWCOMM' ) 
				AND v.vendor_system_name = e.vendor_system_name
				AND (e.process_status in ( '0000003') or e.process_status is null )

		WHERE ( cn.SubmitDate >= @p_start_date OR @p_start_date is null )	-- limit data
			AND e.request_id is null										-- no pending request
			AND comm.transaction_detail_id is null							-- no commission paid
			AND v.inactive_ind = 0											-- vendor inactive
			AND cn.contractStatusID <> 2										-- contract not rejected
			AND (	s.status in ('905000', '906000', '06000' , '05000')		-- account flowing
						OR 
					(s.status in ('07000' ) AND s.substatus in ('20') )
				)
			AND datediff(day, cn.SubmitDate, getdate()) > 5  				-- accounts must be at least five days old to allow for corrections and contract merges etc... 

		GROUP BY  ac.AccountIDlegacy, ac.AccountNumber, cn.Number, v.vendor_system_name, cn.SubmitDate, cdt.dealType
END 
