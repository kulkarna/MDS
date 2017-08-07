USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_account_ins]    Script Date: 12/27/2013 14:54:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec usp_contract_account_ins 'WVILCHEZ', '2006-0000121', '1234567890'

-- =============================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- Project IT037
-- =============================================
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 7/25/2013 
-- Ticket: 1-179692237
-- Changed PriceID to BIGINT
-- =============================================
-- Modify : Sara lakshmanan
-- Date : 12/27/2013 
-- Ticket: 1-346568382 - Davita renewal 20130103801 AEPCE
-- The Deals whose origin is Custom deal upload, have the curren contract Id and current reneweal id as Null. And they don't have entry in lp..Account table.
--So, we are not able to get the AccountLegacyId. we create a new one and finally when it goes to CAPI, we get error while trying to add the same account number  
--It says company account cannot be found
-- =============================================
ALTER procedure [dbo].[usp_contract_account_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_error                                           char(01)		= '',
 @p_meter_number									varchar(2000)	= 'NONE',
 @p_msg_id                                          char(08)		= '',
 @p_descp                                           varchar(250)	= '',
 @p_result_ind                                      char(01)		= 'Y',
 @p_utility_id										char(15) = null,
 @p_zone											varchar(20),
 @PriceID					bigint = 0)


as

SET NOCOUNT ON

select @p_account_number                            = upper(@p_account_number)
 
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
select @w_application                               = 'COMMON'

declare @w_account_id                               char(12)
select @w_account_id                                = ''

declare @w_account_number_prefix                    varchar(10)
declare @w_prefix_length							int
declare @w_address_link								int
declare @w_name_link								int


--IF EXISTS(SELECT account_id FROM lp_account..account with (nolock)
--			WHERE account_number = @p_account_number 
--			AND utility_id = @p_utility_id ) 
--BEGIN
--	SELECT @w_account_id = account_id FROM lp_account..account with (nolock)
--			WHERE account_number = @p_account_number 
--			AND utility_id = @p_utility_id
--END
-- Date : 12/27/2013 
--Modified the if exists rule to look for AccountlegacyId(account_id) in LIbertypower..Account Table instead of LP_Account..account View database
--To do: infuture we need to find the account Id in the code and then sedn in only the info that is needed for isnerting to deal_contract_account table
--Should eliminate the cross reference to Libertypower database from lp_deal_capture database.

 If exists (Select A.AccountIdLegacy from  LIbertyPower..Account A With (NoLock)
Inner Join LIbertyPower..Utility U with (NoLOCK) on A.UtilityID=U.ID
 Where A.AccountNumber= @p_account_number  and U.UtilityCode=@p_utility_id )
BEGIN

Select @w_account_id =A.AccountIdLegacy from  LIbertyPower..Account A With (NoLock)
Inner Join LIbertyPower..Utility U with (NOLOCK) on A.UtilityID=U.ID
 Where A.AccountNumber= @p_account_number  and U.UtilityCode=@p_utility_id 
 
END
ELSE 
BEGIN
exec @w_return                                      = usp_get_key @p_username, 
                                                                  'ACCOUNT ID', 
                                                                  @w_account_id output, 
                                                                  'N'
END                                                                 

if @w_return                                       <> 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000001'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account ID)'
   goto goto_select
end

-- determine if a prefix needs to be added to account number  --------------------
select @w_account_number_prefix                      = AccountNumberPrefix
from  LibertyPower..Utility with (nolock)
where UtilityCode = (select top 1 utility_id 
                    from  deal_contract with (nolock) where contract_nbr = @p_contract_nbr)

select @w_prefix_length                              = len(@w_account_number_prefix)

select @w_address_link								 =	MAX(address_link)
from lp_deal_capture..deal_address with (nolock)
where contract_nbr = @p_contract_nbr

select @w_name_link								 =	MAX(name_link)
from lp_deal_capture..deal_name with (nolock)
where contract_nbr = @p_contract_nbr

if @w_prefix_length                                  > 0
begin
   if  (charindex('+', ltrim(rtrim(@w_account_number_prefix))) <> 0)
   and (left(@p_account_number, (@w_prefix_length - 1))        <> right(@w_account_number_prefix, (@w_prefix_length - 1)))
   begin
      select @p_account_number                       = right(@w_account_number_prefix, (@w_prefix_length - 1)) 
                                                     + @p_account_number
   end
end

exec @w_return = usp_contract_account_val @p_username,
                                          'I',
                                          'ALL',
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @p_utility_id



if @w_return <> 0
begin
   goto goto_select
end
insert into deal_contract_account 
	(contract_nbr,contract_type, account_number, status, account_id, retail_mkt_id, utility_id,account_type, product_id
	, rate_id, rate, account_name_link, customer_name_link, 
		customer_address_link,
       customer_contact_link,
		billing_address_link,
       billing_contact_link,
       owner_name_link,
       service_address_link,
       business_type,
       business_activity,
       additional_id_nbr_type,
       additional_id_nbr,
       contract_eff_start_date,
	   enrollment_type,
       term_months,
       date_end,
       date_deal,
       date_created,
       date_submit,
       sales_channel_role,
       username,
       sales_rep,
       origin,
       grace_period, chgstamp,requested_flow_start_date,
       deal_type,
       customer_code,
       customer_group
       ,[SSNClear],[SSNEncrypted],[CreditScoreEncrypted],HeatIndexSourceID,HeatRate
		,evergreen_option_id
		,evergreen_commission_end
		,residual_option_id
		,residual_commission_end
		,initial_pymt_option_id
		,evergreen_commission_rate
		,TaxStatus
		,zone
		,PriceID
		, RatesString)
       
select @p_contract_nbr,
       contract_type,
       @p_account_number,
       status                                       = ' ',
      @w_account_id,
       case when upper(rtrim(ltrim(retail_mkt_id))) = 'SELECT...'
            then 'NN'
            else retail_mkt_id
       end,
       case when upper(rtrim(ltrim(utility_id))) = 'SELECT...'
            then 'NONE'
            else utility_id
       end,
       account_type,
       case when upper(rtrim(ltrim(product_id))) = 'SELECT...'
            then 'NONE'
            else product_id
       end,
       case when upper(rtrim(ltrim(product_id))) = 'SELECT...'
            then 999999999
            else rate_id
       end,
       rate,
       @w_name_link,
       customer_name_link,
       customer_address_link,
       customer_contact_link,
       billing_address_link,
       billing_contact_link,
       owner_name_link,
       @w_address_link,
       business_type,
       business_activity,
       additional_id_nbr_type,
       additional_id_nbr,
       contract_eff_start_date,
	   enrollment_type,
       term_months,
       date_end,
       date_deal,
       date_created,
       date_submit,
       sales_channel_role,
       @p_username,
       
       sales_rep,
       origin,
       grace_period,
       0,	--chgstamp
       requested_flow_start_date,
       deal_type,
       customer_code,
       customer_group,
       SSNClear,
       SSNEncrypted,
       CreditScoreEncrypted,
	   HeatIndexSourceID, -- Project IT37
	   HeatRate       -- Project IT37
		,NULL --[evergreen_option_id] 
		,NULL --[evergreen_commission_end] 
		,NULL --[residual_option_id] 
		,NULL --[residual_commission_end] 
		,NULL --[initial_pymt_option_id] 
		,NULL --[evergreen_commission_rate] 
		,TaxStatus
		,@p_zone
		,@PriceID
		, RatesString
from  deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

if @@error <> 0 or @@rowcount = 0
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000051'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account Number)'
end

select @w_return                                    = 0

if @p_meter_number                                 <> 'NONE'
begin
   declare @w_id			                        int
   declare @w_value                                 varchar(500)
   declare @w_rowcount                              int

   insert into account_meters
   select distinct
          @w_account_id,
          value 
   from lp_account.dbo.ufn_split_delimited_string (@p_meter_number, ',')
   where len(ltrim(rtrim(value)))                   > 0
end

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

--- END of procedure [dbo].[usp_contract_account_ins] -----------------------------------------------------------------

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK INSERT INTO #error_status (has_error) VALUES (1) SET NOEXEC ON END

SET NOCOUNT OFF
GO


