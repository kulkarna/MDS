USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_renewal_sel_list]    Script Date: 10/29/2012 11:48:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/19/2007
-- Description:	Select accountlist for renewal
-- =============================================
*******************************************************************************
 * 2010-04-16 - Jose Munoz
 * Modify:
 * Change from/join clause:
 * Ticket 15113
 * Enrollment Submission Error message
 * Problem: Duplicate account_id for two rows in retail_market_table with diference  wholesale_mkt_id.

	Old Join
	JOIN lp_common..common_retail_market e ON a.retail_mkt_id = e.retail_mkt_id 

	New Join
	inner join Libertypower..common_retail_market_table x with (nolock)
	on x.retail_mkt_id				= a.retail_mkt_id
	inner join lp_common..common_retail_market e with (NOLOCK)
	on e.retail_mkt_id				= x.retail_mkt_id
	and e.wholesale_mkt_id			= x.wholesale_mkt_id

-- =============================================
-- Modified: Jose Munoz 5/11/2010
-- Add evergreen_option_id, evergreen_commission_end, residual_option_id, residual_commission_end
--     initial_pymt_option_id, sales_manager, evergreen_commission_rate Columns
-- Project IT021
-- =============================================	
-- Modified: Isabelle Tamanini 5/10/2011
-- Add service_rate_class to select clause
-- MD056
-- =============================================
-- Modified: Jaime Forero
-- Changed Query so it performs better
-- IT079
-- =============================================
-- Modified: Isabelle Tamanini
-- Commented out line of code that filters by LeadTime
-- It was causing issues on check_account page
-- 1-31053071
-- =============================================
-- Modified by: Lev Rosenblum at 09/27/2012
-- Add distinct key-word to eliminate record duplication. Add AccountContractID to output also.
-- MD084 (PBI 0999)
-- =============================================
	
	
	--exec usp_account_renewal_sel_list 'libertypower\jmunoz'
*/
	
ALTER PROCEDURE [dbo].[usp_account_renewal_sel_list]
(@p_username                                        nchar(100),
 @p_view                                            varchar(35) = 'ALL',
 @p_rec_sel                                         int = 50,
 @p_account_id_filter                               char(12) = 'ALL',
 @p_account_number_filter                           varchar(30) = 'ALL',
 @p_contract_nbr_filter                             char(12)= 'ALL',
 @p_full_name_filter                                varchar(30)= '',
 @p_status_filter                                   varchar(15)= 'ALL',
 @p_sub_status_filter                               varchar(15)= 'ALL',
 @p_utility_id_filter                               varchar(15)= 'ALL',                                      
 @p_entity_id_filter                                varchar(15)= 'ALL',
 @p_retail_mkt_id_filter                            varchar(04)= 'ALL',
 @p_account_type_filter                             varchar(35)= 'ALL',
 @p_sales_channel_role_filter                       varchar(50)= 'ALL')
as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select @p_account_id_filter			= case when @p_account_id_filter = 'NONE' or @p_account_id_filter = '' then 'ALL' else @p_account_id_filter end

select @p_account_number_filter		= case when @p_account_number_filter = 'NONE' or @p_account_number_filter = '' then 'ALL' else @p_account_number_filter end

select @p_contract_nbr_filter		= case when @p_contract_nbr_filter = 'NONE' or @p_contract_nbr_filter = '' then 'ALL' else @p_contract_nbr_filter end

select @p_status_filter				= case when @p_status_filter = 'NONE' or @p_status_filter = '' then 'ALL' else @p_status_filter end

select @p_sub_status_filter			= case when @p_sub_status_filter = 'NONE' or @p_sub_status_filter = '' then 'ALL' else @p_sub_status_filter end

select @p_utility_id_filter			= case when @p_utility_id_filter = 'NONE' or @p_utility_id_filter = '' then 'ALL' else @p_utility_id_filter end

select @p_entity_id_filter			= case when @p_entity_id_filter = 'NONE' or @p_entity_id_filter = '' then 'ALL' else @p_entity_id_filter end

select @p_retail_mkt_id_filter		= case when @p_retail_mkt_id_filter = 'NONE' or @p_retail_mkt_id_filter = '' then 'ALL' else @p_retail_mkt_id_filter end

select @p_account_type_filter		= case when @p_account_type_filter = 'NONE' or @p_account_type_filter = '' then 'ALL' else @p_account_type_filter end

select @p_sales_channel_role_filter = case when @p_sales_channel_role_filter = 'NONE' or @p_sales_channel_role_filter = '' then 'ALL' else @p_sales_channel_role_filter end

if @p_full_name_filter <> ''
begin
   select @p_full_name_filter = @p_full_name_filter 
end

set rowcount @p_rec_sel


SELECT distinct a.account_id,
     a.account_number,
     a.account_type,
     status = b.status_descp,
     sub_status = c.sub_status_descp,
     a.customer_id,
     entity_id = d.entity_descp,
     a.contract_nbr,
     a.contract_type,
     retail_mkt_id = e.retail_mkt_descp,
     utility_id = isnull(f.LegacyName, f.FullName),
     product_id = g.product_descp,
     a.rate_id,
     a.rate,
     names = 'Names',
     address = 'Address',
     contact = 'Contacs',
     a.business_type,
     a.business_activity,
     a.additional_id_nbr_type,
     a.additional_id_nbr,
     a.annual_usage, annual_usage_mw = (a.annual_usage)/1000,      
     a.credit_score,
     a.credit_agency,
     a.term_months,
     a.username,
     a.sales_channel_role,
     a.sales_rep,
     a.contract_eff_start_date,
     a.date_end,
     a.date_deal,
     a.date_created,
     a.date_submit,
     a.date_flow_start,
     a.date_por_enrollment,
     a.date_deenrollment,
     a.date_reenrollment,
     a.tax_status,
     a.tax_rate,
     a.origin,
     -- 'no description' rate_descp, -- r.rate_descp,
     h.full_name,
     a.por_option,
     a.billing_type,
     a.chgstamp,
     a.SSNEncrypted, -- Added for IT002
     a.CreditScoreEncrypted --Added for IT002
	,a.evergreen_commission_end		--IT021
	,a.residual_option_id	--IT021
	,a.residual_commission_end	--IT021
	,a.initial_pymt_option_id	--IT021
	,a.sales_manager	--IT021
	,a.evergreen_commission_rate 	--IT021   
	,service_rate_class = acct.ServiceRateClass 
	,a.product_id as product_id_key
	,a.AccountContractID_key as AccountContractID
INTO #temp

FROM account_renewal a 
JOIN enrollment_status b with (nolock) ON a.status = b.status
JOIN enrollment_sub_status c with (nolock) ON a.status = c.status and a.sub_status = c.sub_status
JOIN lp_common..common_entity d with (nolock) ON a.entity_id = d.entity_id
JOIN Libertypower..common_retail_market_table x with (nolock) on x.retail_mkt_id = a.retail_mkt_id
JOIN lp_common..common_retail_market e with (NOLOCK) on e.retail_mkt_id = x.retail_mkt_id and e.wholesale_mkt_id = x.wholesale_mkt_id
JOIN LibertyPower.dbo.Utility f with (nolock) ON a.utility_id = f.UtilityCode
JOIN lp_common..common_product g with (nolock) ON a.product_id = g.product_id
JOIN account_name h with (nolock) ON a.account_id = h.account_id and a.customer_name_link = h.name_link
JOIN LibertyPower..Account acct with (nolock)  ON a.account_id = acct.AccountIDLegacy
JOIN LibertyPower..Utility u with (nolock)  on u.UtilityCode = a.utility_id
LEFT JOIN LibertyPower..UtilityRateLeadTime ut with (nolock)  on u.ID = ut.UtilityID

WHERE  1=1
and (@p_account_id_filter = 'ALL' or a.account_id = @p_account_id_filter) 
and (@p_account_number_filter = 'ALL' or a.account_number = @p_account_number_filter) 
and (@p_contract_nbr_filter = 'ALL' or a.contract_nbr = @p_contract_nbr_filter)
and (@p_status_filter = 'ALL' or a.status = @p_status_filter) 
and (@p_sub_status_filter = 'ALL' or a.sub_status = @p_sub_status_filter) 
and (@p_utility_id_filter = 'ALL' or a.utility_id = @p_utility_id_filter) 
and (@p_entity_id_filter = 'ALL' or a.entity_id = @p_entity_id_filter) 
and (@p_retail_mkt_id_filter = 'ALL' or a.retail_mkt_id = @p_retail_mkt_id_filter) 
and (@p_account_type_filter = 'ALL' or a.account_type = @p_account_type_filter)
and (@p_sales_channel_role_filter = 'ALL' or a.sales_channel_role = @p_sales_channel_role_filter)
and (@p_full_name_filter = '' or h.full_name like @p_full_name_filter+ '%')


SELECT t.* , r.rate_descp
FROM #temp t
JOIN lp_common..common_product_rate r with (nolock) ON t.product_id_key = r.product_id and t.rate_id = r.rate_id
order by sub_status

