----------------------------------------------------------------------------------------------
--Change 1: Add IsForSave Field to the Database with deafult of 1 for LP_Deal_Capture Database
--Table: deal_contract_account
----------------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) 
AND NOT (EXISTS(SELECT * FROM sys.columns WHERE [name]=N'IsForSave' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
ALTER TABLE [dbo].[deal_contract_account]
	ADD [IsForSave] [bit] NULL
	CONSTRAINT [DF_deal_contract_account_IsForSave] DEFAULT ((1)) WITH VALUES

GO
-------------------------------------------------------------------------------------
--2: new proc [usp_contract_account_upd_FlagSave] added
-------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_account_upd_FlagSave]    Script Date: 07/16/2013 13:24:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contract_account_upd_FlagSave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_contract_account_upd_FlagSave]
GO
----------------------------------------------------------------------
-- Added		: Sara Laskhmanan
-- Date		: 07/15/2013
-- Description	:Proc to update the flagforSave in contractAccount table for one account

---------------------------------------------------------------------------------
-- exec usp_contract_account_upd_FlagSave 'contractNumber', 'Account NUmber',1

 
CREATE procedure [dbo].[usp_contract_account_upd_FlagSave] 
(@p_contract_nbr                                    char(12),
@p_account_nbr				  varchar(30),
@p_flagsave bit)
as

If exists(Select contract_nbr from deal_contract_account with (nolock) where contract_nbr=@p_contract_nbr and account_number=@p_account_nbr)
Begin

Update deal_contract_account set isForSave=@p_flagsave where contract_nbr=@p_contract_nbr and account_number=@p_account_nbr

End
GO
-------------------------------------------------------------------------------------
--3: new proc [usp_contract_accounts_upd_FlagSave] added
-------------------------------------------------------------------------------------

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_accounts_upd_FlagSave]    Script Date: 07/16/2013 14:12:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contract_accounts_upd_FlagSave]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_contract_accounts_upd_FlagSave]
GO
----------------------------------------------------------------------
-- Added		: Sara Laskhmanan
-- Date		: 07/15/2013
-- Description	:Proc to update the flagforSave in contractAccount table for all the accounts belonging to the Contract

---------------------------------------------------------------------------------
-- exec usp_contract_accounts_upd_FlagSave 'contractNumber',1

 
CREATE procedure [dbo].[usp_contract_accounts_upd_FlagSave] 
(@p_contract_nbr                                    char(12),
@p_flagsave bit)
as

If exists(Select contract_nbr from deal_contract_account with (nolock) where contract_nbr=@p_contract_nbr )
Begin

Update deal_contract_account set isForSave=@p_flagsave where contract_nbr=@p_contract_nbr 

End


GO
-------------------------------------------------------------------------------------
--4: [usp_contract_account_select_list] isForSave Field added
-------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

--exec usp_contract_account_sel_list 'WVILCHEZ', '2006-0000121'
-------------------------------------------------------------------------------
--MOdified: July 16 2013 
--Desc: isForSave Field added to the select list
--PBI: 14205 Accounts grid selelct all option
--Sara lakshmanan
-----------------------------------------------------------------------------

ALTER procedure [dbo].[usp_contract_account_select_list]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30))
as

declare @w_sales_channel_role                       nvarchar(50)
	
select @w_sales_channel_role                        = sales_channel_role
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

declare @w_user_id                                  int

select @w_user_id                                   = UserID
from lp_portal..Users with (nolock)
where Username                                      = @p_username

select ca.account_number,
	   ca.account_id,
       ca.status,
       ca.utility_id,
       ca.contract_type,
       ca.account_type,
       ca.customer_name_link,              
       ca.customer_address_link,
	   ca.customer_contact_link,
       ca.billing_address_link,
	   ca.billing_contact_link,
	   ca.owner_name_link,
	   ca.service_address_link,
	   ca.account_name_link,  
	   ca.additional_id_nbr, 
	   ca.additional_id_nbr_type,
	   ca.sales_channel_role,
	   ca.sales_rep,
	   ca.retail_mkt_id,
	   ca.product_id,
	   ca.date_deal,
	   ca.date_submit,
	   ca.business_type,
	   ca.business_activity,
	   ca.contract_eff_start_date,
	   ca.term_months,
	   ca.date_end,
	   ca.date_created,
	   ca.TaxStatus,
	   ca.origin,
	   ca.deal_type,
	   ca.customer_code,
	   ca.customer_group,
	   ca.SSNEncrypted,
       n.full_name,
       a.address,
       a.suite,
       a.city,
       a.state,
       a.zip,
       ca.requested_flow_start_date,
       ca.enrollment_type,
       ba.address as "Billingaddress",
       ba.suite as "Billingsuite",
       ba.city as "Billingcity",
       ba.state as "Billingstate",
       ba.zip as "Billingzip",
       ca.rate_id,
       ca.rate,
       m.meter_number,
       pr.rate_descp,
       --'' AS rate_descp,
       ca.customer_code,
       ai.name_key,
       ai.BillingAccount,
       ai.MeterDataMgmtAgent,
       ai.MeterServiceProvider,
       ai.MeterInstaller,
       ai.MeterReader,
       ai.SchedulingCoordinator,
       c.first_name,
       c.last_name,
       c.phone,
       c.title,
       c.fax,
       c.email,
       ca.zone,
       dcc.date_comment,
       dcc.comment,
       cb.first_name AS "BillingFirstName",
	   cb.last_name AS "BillingLastName",
	   cb.title AS "BillingTitle",
	   cb.Phone AS "BillingPhone",
	   cb.fax AS "BillingFax",
	   cb.email AS "BillingEmail",
	   cn.full_name AS "CustomerName",
	   ow.full_name AS "OwnerName",
	   cus.address AS "CustomerAddress",
	   cus.suite AS "CustomerSuite",
	   cus.state AS "CustomerState",
	   cus.zip AS "CustomerZip",
	   cus.city AS "CustomerCity",
	   dca.contract_nbr_amend,
	   ca.PriceID,
	   (SELECT ISNULL(IsCustom, 0)FROM lp_common..common_product WITH (NOLOCK) WHERE product_id = ca.product_id) AS IsCustom
	   , ca.RatesString
	   , isNUll(ca.IsForSave,1) as IsForSave --Added on July 16 2013
from deal_contract_account ca with (NOLOCK INDEX = deal_contract_account_idx)
left join deal_name n with (nolock) ON ca.contract_nbr = n.contract_nbr AND ca.account_name_link = n.name_link
left join deal_contact c with (nolock) ON ca.contract_nbr = c.contract_nbr AND ca.customer_contact_link = c.contact_link
left join deal_address a  with (nolock) ON ca.contract_nbr = a.contract_nbr AND ca.service_address_link = a.address_link
left join deal_address ba  with (nolock) ON ca.contract_nbr = ba.contract_nbr AND ca.billing_address_link = ba.address_link
left join deal_address cus  with (nolock) ON ca.contract_nbr = cus.contract_nbr AND ca.customer_address_link = cus.address_link
left join account_meters m  with (nolock) ON ca.account_id = m.account_id
left join deal_contract_comment dcc  with (nolock) ON ca.contract_nbr = dcc.contract_nbr
left join lp_common..common_product_rate pr  with (nolock) ON ca.product_id = pr.product_id AND ca.rate_id = pr.rate_id
left join lp_account..account_info ai  with (nolock) ON ca.account_id = ai.account_id
left join deal_contact cb  with (nolock) ON ca.contract_nbr = cb.contract_nbr AND ca.billing_contact_link = cb.contact_link
left join deal_name cn  with (nolock) ON ca.contract_nbr = cn.contract_nbr AND ca.account_name_link = cn.name_link
left join deal_name ow  with (nolock) ON ca.contract_nbr = ow.contract_nbr AND ca.account_name_link = ow.name_link
left join deal_contract_amend dca  with (nolock) ON ca.contract_nbr = dca.contract_nbr
where ca.contract_nbr                                  = @p_contract_nbr
and   @p_account_number							   IN ('',ca.account_number)
order by ca.account_id desc

GO

-------------------------------------------------------------------------------------
--5: modified  proc [usp_contract_account_upd]
-------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

-------------------------------------------------------------------------------
--MOdified: July 16 2013 
--Desc: isForSave Field updated 
--PBI: 14205 Accounts grid selelct all option
--Sara lakshmanan
-----------------------------------------------------------------------------

ALTER procedure [dbo].[usp_contract_account_upd]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_account_number_new                              varchar(30),
 @p_account_name									varchar(50),
 @p_address                                         char(50),
 @p_suite                                           char(10),
 @p_city                                            char(28),
 @p_state                                           char(02),
 @p_zip                                             char(10),
 @p_first_name								       char(50),
 @p_last_name								        char(50),
 @p_phone_number	                                 char(50),
 @p_billing_address                                 char(50),
 @p_billing_suite                                           char(10),
 @p_billing_city                                            char(28),
 @p_billing_state                                           char(02),
 @p_billing_zip                                             char(10),
 @p_error                                           char(01)		= '',
 @p_msg_id                                          char(08)		= '',
 @p_descp                                           varchar(250)	= '',
 @p_result_ind                                      char(01)		= 'Y',
 @p_zone											varchar(20),
  @p_isRowSelectedforSave											bit=1)

as

select @p_account_number                            = upper(@p_account_number)

declare @w_address_link                             int
declare @w_billing_address_link                     int
declare @w_name_link								int
declare @w_contact_link								int
declare @w_utility_id								char(15)
 
select @w_address_link	= service_address_link,
	   @w_billing_address_link	= billing_address_link,
	   @w_name_link		= account_name_link,
	   @w_contact_link = customer_contact_link,
	   @w_utility_id	= utility_id
from lp_deal_capture..deal_contract_account
where contract_nbr		= @p_contract_nbr
and	  account_number	= @p_account_number
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(25)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                                    = 0
select @w_descp_add                                 = ''
declare @w_application                              varchar(20)

if @w_return                                       <> 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000001'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account ID)'
   goto goto_select
end


	exec @w_return = lp_deal_capture.dbo.usp_contract_address_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number,
											  @p_address,
											  @p_city,
											  @p_state,
											  @p_zip,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_descp_add output
											  
	exec @w_return = lp_deal_capture.dbo.usp_contract_address_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number,
											  @p_billing_address,
											  @p_billing_city,
											  @p_billing_state,
											  @p_billing_zip,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_descp_add output
											  										  

	if @w_return <> 0
	begin
	   goto goto_select
	end
	
if (rtrim(ltrim(@p_account_number)) <> rtrim(ltrim(@p_account_number_new)))
begin	
	exec @w_return = usp_contract_account_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number_new,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_utility_id



	if @w_return <> 0
	begin
	   goto goto_select
	end
end
update lp_deal_capture..deal_contract_account
set account_number	= @p_account_number_new,
	zone			= @p_zone,
	isForSave=@p_isRowSelectedforSave
	--Added on JUly 12 2013 IsForSave Chkbox
where	contract_nbr = @p_contract_nbr
and		account_number = @p_account_number
	
update lp_deal_capture..deal_address 
set address	= @p_address,
	suite	= @p_suite,
	city	= @p_city,
	state	= @p_state,
	zip		= @p_zip
where contract_nbr = @p_contract_nbr
and address_link = @w_address_link

update lp_deal_capture..deal_contact
set first_name = @p_first_name,
	last_name = @p_last_name,	
	phone = @p_phone_number
where contract_nbr = @p_contract_nbr
and contact_link = @w_contact_link

update lp_deal_capture..deal_address 
set address	= @p_billing_address,
	suite	= @p_billing_suite,
	city	= @p_billing_city,
	state	= @p_billing_state,
	zip		= @p_billing_zip
where contract_nbr = @p_contract_nbr
and address_link = @w_billing_address_link

update lp_deal_capture..deal_name 
set full_name	= @p_account_name	
where	contract_nbr = @p_contract_nbr
		and name_link = @w_name_link
       
       
       
if @@error <> 0 or @@rowcount = 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000001'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account ID)'
   goto goto_select
end

select @w_return                                    = 0

goto_select:

if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, 
                                    @w_descp output,
                                    @w_application
   select @w_descp = ltrim(rtrim(@w_descp)) 
                   + ' ' 
                   + @w_descp_add 
end
 
if @p_result_ind = 'Y'
begin
   select flag_error = @w_error,
          code_error = @w_msg_id,
          message_error = @w_descp,
		  account_number = @p_account_number
   goto goto_return
end
 
select @p_error = @w_error,
       @p_msg_id = @w_msg_id,
       @p_descp = @w_descp,
	   @p_account_number = @p_account_number
 
goto_return:
return @w_return


GO