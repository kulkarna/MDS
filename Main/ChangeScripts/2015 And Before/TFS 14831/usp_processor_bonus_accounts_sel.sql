USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * usp_processor_bonus_accounts_sel

 * Get acounts due for a bonus payment
 
 * History

 *******************************************************************************
 * 12/9/2013 Louis Rosenthal
 * Created
 *******************************************************************************
 */

Create Procedure [dbo].[usp_processor_bonus_accounts_sel]
(@p_start_date datetime  = null  )
AS
BEGIN
	SET NOCOUNT ON;

SELECT DISTINCT 
	   account_id = a.[AccountIDlegacy]
	  ,contract_nbr = c.[Number]
	  ,v.[vendor_system_name]
	  ,assoc_transaction_id = td1.[transaction_detail_id]
  FROM [LibertyPower].[dbo].[Account] a (NOLOCK)
  JOIN [LibertyPower].[dbo].[AccountContract] ac (NOLOCK) ON ac.[AccountID] = a.[AccountID]
  JOIN [LibertyPower].[dbo].[Contract] c (NOLOCK) ON c.[ContractID] = ac.[ContractID]
  JOIN [LibertyPower].[dbo].[AccountStatus] ast (NOLOCK) ON ast.[AccountContractID] = ac.[AccountContractID]
  JOIN [LibertyPower].[dbo].[AccountService] asvc (NOLOCK) ON asvc.[account_id] = a.[AccountIDlegacy]
  JOIN [Lp_commissions].[dbo].[vendor] v (NOLOCK) ON v.[ChannelID] = c.[SalesChannelID]
  JOIN [Lp_commissions].[dbo].[vendor_payment_option] vpo (NOLOCK) ON vpo.[vendor_id] = v.[vendor_id]
  JOIN [Lp_commissions].[dbo].[payment_option] po (NOLOCK) ON po.[payment_option_id] = vpo.[payment_option_id]
  JOIN [Lp_commissions].[dbo].[transaction_detail] td1 (NOLOCK) ON td1.[account_id] = a.[AccountIdLegacy]
															   AND td1.[contract_nbr] = c.[Number]
															   AND td1.[vendor_id] = v.[vendor_id]
															   AND td1.[transaction_type_id] = 1	-- COMM
															   --AND td1.[invoice_id] > 0				-- must have been paid
															   AND td1.[void] = 0
  LEFT JOIN [Lp_commissions].[dbo].[transaction_detail] td2 (NOLOCK) ON td1.[account_id] = a.[AccountIdLegacy]
																	AND td1.[contract_nbr] = c.[Number]
																	AND td1.[vendor_id] = v.[vendor_id]
																	AND td1.[transaction_type_id] = 3	-- BONUS
																	AND td1.[void] = 0
  LEFT JOIN [Lp_commissions].[dbo].[transaction_request] tr (NOLOCK) ON tr.[account_id] = a.[AccountIdLegacy]
																	AND tr.[contract_nbr] = c.[Number]
																	AND tr.[transaction_type_code] = 'BONUS'
																	AND tr.[vendor_system_name] = v.[vendor_system_name]
																	AND (tr.[process_status] in ( '0000003') OR tr.[process_status] IS NULL)
 WHERE ( c.[SubmitDate] >= @p_start_date OR @p_start_date IS NULL )				-- limit data
   AND DATEDIFF(DAY, c.SubmitDate, GETDATE()) > 5								-- accounts must be at least five days old to allow for corrections and contract merges etc... 
   AND c.[ContractStatusID]<>2													-- contract not rejectesd
   AND ast.[Status] IN ('905000', '906000')										-- account status is Enrolled - Done
   AND asvc.[StartDate] IS NOT NULL												--+
   AND asvc.[StartDate] <> '1900-01-01 00:00:00'								--|account has flowed for 30 days or more
   AND DATEDIFF(DAY, asvc.[StartDate], GETDATE()) >= 30							--+
   AND v.[inactive_ind]=0														-- active vendor
   AND vpo.[active]=1 AND po.[active]=1 AND po.[payment_option_code] = 'Bonus'	-- active 'Bonus' payment option
   AND td2.transaction_detail_id IS NULL										-- bonus payment not made
   AND tr.request_id IS NULL													-- no pending request


SET NOCOUNT OFF;

END 