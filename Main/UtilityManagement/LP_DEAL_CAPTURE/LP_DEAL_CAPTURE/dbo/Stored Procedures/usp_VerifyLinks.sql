
-- ======================================
-- usp_VerifyLinks
-- Created by José Muñoz 06/10/2011
-- Verify Renewal Contract links 
-- ======================================
/*
declare @w_descp               varchar(255)
exec lp_deal_capture..usp_VerifyLinks '20110040803' , @w_descp output
select @w_descp w_descp

*/

CREATE proc [dbo].[usp_VerifyLinks]
	(@contract_nbr			char(12)
	,@w_descp               varchar(255) OUTPUT
	,@AllErrorsFlag			bit = 0)  -- 0 for one error, 1 for all erros
as	

set nocount on 
set @w_descp = ''
declare @output table ([AccountId]			varchar(12)
						,[AccountNumber]	varchar(30)
						,[Field]			varchar(60)
						,[Link]				smallint
						,[Description]		varchar(200))


insert into @output
select a.account_id, a.account_number, 'customer_address_link', a.customer_address_link
	,'Customer Address Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Customer Address.'
from lp_deal_capture..deal_contract_account a with (nolock)
where contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_address b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.address_link		= a.customer_address_link)

insert into @output
select a.account_id, a.account_number, 'billing_address_link', a.billing_address_link
	,'Billing Address Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Billing Address.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_address b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.address_link		= a.billing_address_link)

insert into @output
select a.account_id, a.account_number, 'service_address_link', a.service_address_link
	,'Service Address Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Service Address.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_address b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.address_link		= a.service_address_link)


insert into @output
select a.account_id, a.account_number, 'account_name_link', a.account_name_link
	,'Account Name Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Account Name.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_name b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.name_link			= a.account_name_link)

insert into @output
select a.account_id, a.account_number, 'customer_name_link', a.customer_name_link
	,'Customer Name Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Customer Name.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_name b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.name_link			= a.customer_name_link)

insert into @output
select a.account_id, a.account_number, 'owner_name_link', a.owner_name_link
	,'Owner Name Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Owner Name.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_name b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.name_link			= a.owner_name_link)

insert into @output
select a.account_id, a.account_number, 'customer_contact_link', a.customer_contact_link
	,'Customer Contact Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Customer Contact.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_contact b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.contact_link		= a.customer_contact_link)

insert into @output
select a.account_id, a.account_number, 'billing_contact_link', a.billing_contact_link
	,'Billing Contact Problem with account number # ' + ltrim(rtrim(a.account_number))
	+ '. Please check the Billing Contact.'
from lp_deal_capture..deal_contract_account a with (nolock)
where a.contract_nbr		= @contract_nbr
and not exists (select * from lp_deal_capture..deal_contact b with (nolock)
							where b.contract_nbr	= a.contract_nbr
							and b.contact_link		= a.billing_contact_link)

if @AllErrorsFlag = 0
begin
	select top 1 	@w_descp = LTRIM(RTRIM([Description]))
	from @output
	order by [AccountNumber], [Description]
end
else
begin
	set @w_descp = ''
	select * from @output
	order by AccountNumber
end

set nocount off
