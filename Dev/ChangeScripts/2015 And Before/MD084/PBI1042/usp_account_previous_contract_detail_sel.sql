USE [lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_previous_contract_detail_sel]    Script Date: 10/15/2012 22:31:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mannagaroo
-- Create date: 11/2/2008
-- Description:	Get previous account details
-- =============================================
-- Modified: 4/17/2009 Gail Mangaroo
-- Altered to use cursor to search
-- =============================================
-- Modified 12/10/2010 Gail Mangaroo 
-- changed parameter name to @p_previous_contract_nbr
-- =============================================
-- Modified 12/10/2010 Gail Mangaroo -- prod 1/28/2012
-- changed parameter back to @p_contract_nbr and added zaudit_account_renewal
-- =============================================]
-- Modified: 12/14/2011 Gail Mangaroo
-- Switch from lp_account..account to LibertyPower..Account
-- =============================================
-- Modifed 1/31/2012 Gail Mangaroo 
-- use rateStart instead of contarct start since contarct start may not be accurate
-- =============================================
-- Modified 9/20/2012 Gail Mangaroo 
-- Removed joins with account_name and SalesChannel
-- Added min and account_id to Where of subquery
-- =============================================
-- exec usp_account_previous_contract_detail_sel  '2009-0023409' , '90008363A'

ALTER PROCEDURE [dbo].[usp_account_previous_contract_detail_sel] 
	@p_account_id varchar(30)
   , @p_contract_nbr varchar(30)
AS
BEGIN


		--declare @p_account_id varchar(30)
		--declare @p_contract_nbr varchar(30)

		--set @p_account_id = '2008-0021829' -- '2010-0056698'
		--set @p_contract_nbr = '20120060872' -- '2012-0483924'
								
	SET NOCOUNT ON;
	declare @start datetime
	
	SELECT @start = c.StartDate 
	FROM LibertyPower..Contract c (NOLOCK)
	WHERE c.Number = @p_contract_nbr

	SELECT TOP 1 account_id = a.accountIDLegacy , contract_nbr = c.Number, sales_channel_role = v.vendor_system_name , date_deal = c.SignedDate, c.startdate 
	FROM LibertyPower.dbo.Account a (NOLOCK)
			JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
			JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID
			--JOIN LibertyPower.dbo.AccountContractRate accr  (NOLOCK) on acc.AccountContractID = accr.AccountContractID and IsContractedRate = 1 
			JOIN LibertyPower.dbo.vw_AccountContractRate accr (NOLOCK) ON accr.AccountContractID = acc.AccountContractID AND accr.IsContractedRate = 1
			LEFT JOIN lp_commissions.dbo.Vendor v (NOLOCK) on c.SalesChannelID = v.ChannelID
	WHERE a.accountIDLegacy = @p_account_id
		AND NOT (c.ContractDealTypeID = 2 AND c.ContractStatusID = 2 )   --- ignore renewal contracts that failed
		AND accr.RateStart < (SELECT min(accr.RateStart )
								FROM LibertyPower.dbo.Contract c (NOLOCK)
									JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON  c.ContractID = acc.ContractID
									JOIN LibertyPower.dbo.AccountContractRate accr  (NOLOCK) on acc.AccountContractID = accr.AccountContractID 
									JOIN LibertyPower.dbo.Account a (NOLOCK) on a.accountid = acc.accountid
								WHERE c.Number = @p_contract_nbr 
									and a.accountidLegacy = @p_account_id
									and IsContractedRate = 1
								GROUP BY acc.AccountContractID ) 
	ORDER by accr.RateStart desc 

END
