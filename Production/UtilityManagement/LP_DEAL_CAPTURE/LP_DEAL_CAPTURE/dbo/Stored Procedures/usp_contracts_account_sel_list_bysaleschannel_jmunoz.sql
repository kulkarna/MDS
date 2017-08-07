/*
 *******************************************************************************
 * 04/26/2012 - Jose Munoz - SWCS
 * Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
			and use the new table in libertypower database
 *******************************************************************************
 
exec usp_contracts_account_sel_list_bysaleschannel 'libertypower\dmarino' 
exec usp_contracts_account_sel_list_bysaleschannel_jmunoz 'libertypower\dmarino' 

*/


CREATE procedure [dbo].[usp_contracts_account_sel_list_bysaleschannel_jmunoz] 
(@p_username                                        nchar(100),
 @p_view                                            varchar(35) = 'ALL',
 @p_rec_sel                                         int = 50)
as

set rowcount @p_rec_sel
 
if @p_view                                          = 'ALL'
begin
   select a.status,
          a.contract_nbr,
          a.account_number,
          a.utility_account_number,
          a.retail_mkt_id,
          a.utility_id,
          a.product_id,
          a.rate_id,
          a.rate
	from (select a.status,
                a.contract_nbr,
                e.account_number,
                utility_account_number = e.account_number,
                e.retail_mkt_id,
                e.utility_id,
                e.product_id,
                e.rate_id,
                e.rate
         from deal_contract a with (NOLOCK INDEX = deal_contract_idx)
         inner join libertypower..[User]		b with (NOLOCK)
         on b.Username                           = @p_username
         inner join libertypower..[UserRole]	c with (NOLOCK)
         on c.UserID							= b.UserID
         inner join libertypower..[Role]		d with (NOLOCK)
         on d.RoleID							= c.RoleID
         and d.RoleName							= a.sales_channel_role
         inner join deal_contract_account		e with (NOLOCK INDEX = deal_contract_account_idx)
         on e.contract_nbr						= a.contract_nbr
         where (a.status                        like 'DRAFT%'
         or     a.status                        = 'RUNNING')
         and   e.status                         <> 'SENT'
         union
         select  
			[status]					= AAS.[Status]
			,[contract_nbr]				= CO.Number
			,[account_number]			= AA.AccountNumber
			,[utility_account_number]	= AA.AccountNumber
			,[retail_mkt_id]			= MA.MarketCode
			,[Utility_id]				= UT.UtilityCode
			,[product_id]				= ACR.LegacyProductID
			,[rate_id]					= ACR.RateID
			,[rate]						= ACR.Rate
		from libertypower..[User] U with (NOLOCK INDEX = User__Username_I)
		inner join libertypower..[UserRole] UR with (NOLOCK)
		on UR.UserID						= U.UserID 
		inner join libertypower..[Role]		RO with (NOLOCK)
		on RO.RoleID						= UR.RoleID 
		inner join LibertyPower.dbo.SalesChannel SC		WITH (NOLOCK)		
		on 'SALES CHANNEL/' + SC.ChannelName = RO.RoleName
		inner join libertypower..[Contract]	CO with (NOLOCK)
		on CO.SalesChannelID				= SC.ChannelID
		inner join libertypower..[AccountContract]	AC with (NOLOCK)
		on AC.ContractID					= CO.ContractID
		inner join libertypower..[Account]	AA with (NOLOCK)
		on AA.CurrentContractId				= AC.ContractId
		and AA.AccountID					= AC.AccountID
		inner join Libertypower..[Utility]	UT with (NOLOCK)
		on UT.ID							= AA.UtilityID
		inner join Libertypower..[Market]	MA with (NOLOCK)
		on MA.ID							= AA.RetailMktID
		inner join libertypower..[AccountStatus] AAS with (NOLOCK)
		on AAS.AccountContractID			= AC.AccountContractID
		inner join Libertypower..[AccountContractRate]	ACR with (NOLOCK)
		on ACR.AccountContractRateID		= (	SELECT MAX(ACCRT.AccountContractRateID)
												FROM Libertypower..[AccountContractRate] ACCRT WITH (NOLOCK)
												WHERE ACCRT.AccountContractId		= AC.AccountContractId)

		where U.Username					= @p_username) a
   order by a.account_number
end



