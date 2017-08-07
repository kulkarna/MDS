
--exec usp_import_account

-- ===============================================================
-- Modified José Muñoz 01/20/2011
-- Account/ Customer Name should be trimmed when inserting into the Table....  
-- Ticket 20906
-- ===============================================================

CREATE procedure [dbo].[usp_import_account]
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_return                                   int
declare @w_descp                                    varchar(250)
declare @w_descp_add                                varchar(100)

select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_return                                    = 0
select @w_descp                                     = ' ' 
select @w_descp_add                                 = ' ' 

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'
 
declare @w_account_id                               char(12)
declare @w_account_number                           varchar(30)
declare @w_account_type                             varchar(35)
declare @w_status                                   varchar(15)
declare @w_sub_status                               varchar(15)
declare @w_entity_id                                char(15)
declare @w_contract_nbr                             char(12)
declare @w_contract_type                            varchar(15)
declare @w_retail_mkt_id                            char(02)
declare @w_utility_id                               char(15)
declare @w_product_id                               char(20)
declare @w_rate_id                                  int
declare @w_rate                                     float
declare @w_account_name_link                        int
declare @w_customer_name_link                       int
declare @w_customer_address_link                    int
declare @w_customer_contact_link                    int
declare @w_billing_address_link                     int
declare @w_billing_contact_link                     int
declare @w_owner_name_link                          int
declare @w_service_address_link                     int
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_contract_eff_start_date                  datetime
declare @w_term_months                              int
declare @w_date_end                                 datetime
declare @w_date_deal                                datetime
declare @w_date_created                             datetime
declare @w_date_submit                              datetime
declare @w_sales_channel_role                       nvarchar(50)
declare @w_username                                 nchar(100)
declare @w_sales_rep                                varchar(100)
declare @w_origin                                   varchar(50)
declare @w_annual_usage                             money
declare @w_date_flow_start                          datetime
declare @w_date_por_enrollment                      datetime
declare @w_date_deenrollment                        datetime
declare @w_date_reenrollment                        datetime
declare @w_tax_status                               varchar(20)
declare @w_tax_rate                                 float
declare @w_credit_score                             real
declare @w_credit_agency                            varchar(30)

declare @w_param_04                                 varchar(20)

declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @t_account_number                           varchar(30)
select @t_account_number                            = ''

declare @w_AccountNumber                            nvarchar(255)
declare @w_UtilityID                                nvarchar(255)
declare @w_NationalAccount                          bit
declare @w_AccountName                              nvarchar(255)
declare @w_CustomerName                             nvarchar(255)
declare @w_CustomerType                             nvarchar(255)
declare @w_BusinessType                             nvarchar(255)
declare @w_OwnerName                                nvarchar(255)
declare @w_OwnerLastName                            nvarchar(255)
declare @w_ServiceStreet                            nvarchar(255)
declare @w_ServiceCity                              nvarchar(255)
declare @w_ServiceState                             nvarchar(255)
declare @w_ServiceZip                               nvarchar(255)
declare @w_BillingStreet                            nvarchar(255)
declare @w_BillingCity                              nvarchar(255)
declare @w_BillingState                             nvarchar(255)
declare @w_BillingZip                               nvarchar(255)
declare @w_ContactName                              nvarchar(255)
declare @w_ContactLastName                          nvarchar(255)
declare @w_ContactTitle                             nvarchar(255)
declare @w_ContactPhone                             nvarchar(255)
declare @w_ContactFax                               nvarchar(255)
declare @w_ContactEmail                             nvarchar(255)
declare @w_ContactBirthday                          datetime
declare @w_AcctContactName                          nvarchar(255)
declare @w_AcctContactLastName                      nvarchar(255)
declare @w_AcctContactPhone                         nvarchar(255)
declare @w_ContractType                             nvarchar(255)
declare @w_ContractNumber                           nvarchar(255)
declare @w_ContractTerm                             float
declare @w_ContractPK                               int
declare @w_ProductId                                nvarchar(255)
declare @w_PriceRate                                float
declare @w_TaxStatus                                nvarchar(255)
declare @w_TaxRate                                  float
declare @w_SalesChannelID                           nvarchar(255)
declare @w_SalesRep                                 nvarchar(255)
declare @w_AnnualUsage                              float
declare @w_CommissionTransID                        int
declare @w_CommissionAmt                            money
declare @w_CommissionStatus                         nvarchar(255)
declare @w_CommissionStatusDate                     datetime
declare @w_CommissionPymtDueDate                    datetime
declare @w_CreditScore                              nvarchar(255)
declare @w_CreditApproved                           bit
declare @w_CreditApprovedBy                         nvarchar(255)
declare @w_DateReceived                             datetime
declare @w_AccountStatusID                          int
declare @w_CurrentStatusEffDate                     datetime
declare @w_StatusApproved                           bit
declare @w_ApprovalStatusDate                       datetime
declare @w_SubmitDate                               datetime
declare @w_ExpectedStartDate                        datetime
declare @w_ContractReceived                         bit
declare @w_ConfirmationDate                         datetime
declare @w_CUBSEffectiveDate                        datetime
declare @w_FlowStartDate                            datetime
declare @w_Re_enrollmentDate                        datetime
declare @w_De_enrollmentDate                        datetime
declare @w_De_enrollmentReasonCode                  int
declare @w_WaiveTermFee                             bit
declare @w_Comment                                  nvarchar(255)
declare @w_Driver                                   nvarchar(255)
declare @w_UpdateStatus                             bit
declare @w_LastUpdate                               datetime
declare @w_LBMPZone                                 nvarchar(255)
declare @w_ServiceClass                             nvarchar(255)
declare @w_StratumVariable                          float
declare @w_Rider                                    int
declare @w_TripNumber                               int
declare @w_ICAP                                     float
declare @w_MuniCode                                 nvarchar(255)
declare @w_RateClass                                nvarchar(255)
declare @w_ProfitabilityFactor                      float
declare @w_Competitor                               nvarchar(255)
declare @w_Program                                  nvarchar(255)

declare @t_UpdDate                                  datetime

declare @w_UpdateTypeID                             int
declare @w_OldValue                                 int
declare @w_OldValueDate                             datetime
declare @w_NewValue                                 int
declare @w_NewValueDate                             datetime
declare @w_UpdDate                                  datetime

declare @w_risk_request_id                          varchar(50)

declare @w_field_01_value                           varchar(20)
declare @w_field_02_value                           varchar(20)
declare @w_field_03_value                           varchar(20)
declare @w_field_04_value                           varchar(20)
declare @w_field_05_value                           varchar(20)
declare @w_field_06_value                           varchar(20)
declare @w_field_07_value                           varchar(20)
declare @w_field_08_value                           varchar(20)
declare @w_field_09_value                           varchar(20)
declare @w_field_10_value                           varchar(20)

declare @w_full_name                                varchar(100)

declare @w_first_name                               varchar(50)
declare @w_last_name                                varchar(50)
declare @w_title                                    varchar(20)
declare @w_phone                                    varchar(20)
declare @w_fax                                      varchar(20)
declare @w_email                                    nvarchar(256)
declare @w_birthday                                 varchar(05)

declare @w_customer_full_name                       varchar(100)

declare @w_customer_address                         char(50)
declare @w_customer_suite                           char(10)
declare @w_customer_city                            char(28)
declare @w_customer_state                           char(02)
declare @w_customer_zip                             char(10)

declare @w_customer_first_name                      varchar(50)
declare @w_customer_last_name                       varchar(50)
declare @w_customer_title                           varchar(20)
declare @w_customer_phone                           varchar(20)
declare @w_customer_fax                             varchar(20)
declare @w_customer_email                           nvarchar(256)
declare @w_customer_birthday                        varchar(05)

declare @w_address                                  char(50)
declare @w_suite                                    char(10)
declare @w_city                                     char(28)
declare @w_state                                    char(02)
declare @w_zip                                      char(10)

declare @w_add_cont                                 int
select @w_add_cont                                  = 1

declare @w_comment_account                          varchar(max)

declare @t_AccountNumber                            nvarchar(255)
select @t_AccountNumber                             = ''

declare @w_rowcount                                 int
select @w_rowcount                                  = 0

declare @w_rowcount_his                             int
select @w_rowcount_his                              = 0

select @w_username                                  = 'libertypower\dmarino'

declare @t_contract_type                            varchar(15)
select @t_contract_type                             = 'TPV'

select @w_rowcount                                  = @@rowcount

declare @w_account_id_seq                           int

select @w_account_id_seq                            = 0


while @w_rowcount                                  <> 0
begin

   set rowcount 1

   select @w_AccountNumber                             = AccountNumber,
          @w_UtilityID                                 = UtilityID,
          @w_NationalAccount                           = NationalAccount,
          @w_AccountName                               = AccountName,
          @w_CustomerName                              = CustomerName,
          @w_CustomerType                              = CustomerType,
          @w_BusinessType                              = BusinessType,
          @w_OwnerName                                 = OwnerName,
          @w_OwnerLastName                             = OwnerLastName,
          @w_ServiceStreet                             = ServiceStreet,
          @w_ServiceCity                               = ServiceCity,
          @w_ServiceState                              = ServiceState,
          @w_ServiceZip                                = ServiceZip,
          @w_BillingStreet                             = BillingStreet,
          @w_BillingCity                               = BillingCity,
          @w_BillingState                              = BillingState,
          @w_BillingZip                                = BillingZip,
          @w_ContactName                               = ContactName,
          @w_ContactLastName                           = ContactLastName,
          @w_ContactTitle                              = ContactTitle,
          @w_ContactPhone                              = ContactPhone,
          @w_ContactFax                                = ContactFax,
          @w_ContactEmail                              = ContactEmail,
          @w_ContactBirthday                           = ContactBirthday,
          @w_AcctContactName                           = AcctContactName,
          @w_AcctContactLastName                       = AcctContactLastName,
          @w_AcctContactPhone                          = AcctContactPhone,
          @w_ContractType                              = ContractType,
          @w_ContractNumber                            = ContractNumber,
          @w_ContractTerm                              = ContractTerm,
          @w_ContractPK                                = ContractPK,
          @w_ProductId                                 = ProductId,
          @w_PriceRate                                 = PriceRate,
          @w_TaxStatus                                 = TaxStatus,
          @w_TaxRate                                   = TaxRate,
          @w_SalesChannelID                            = SalesChannelID,
          @w_SalesRep                                  = SalesRep,
          @w_AnnualUsage                               = AnnualUsage,
          @w_CommissionTransID                         = CommissionTransID,
          @w_CommissionAmt                             = CommissionAmt,
          @w_CommissionStatus                          = CommissionStatus,
          @w_CommissionStatusDate                      = CommissionStatusDate,
          @w_CommissionPymtDueDate                     = CommissionPymtDueDate,
          @w_CreditScore                               = CreditScore,
          @w_CreditApproved                            = CreditApproved,
          @w_CreditApprovedBy                          = CreditApprovedBy,
          @w_DateReceived                              = DateReceived,
          @w_AccountStatusID                           = AccountStatusID,
          @w_CurrentStatusEffDate                      = CurrentStatusEffDate,
          @w_StatusApproved                            = StatusApproved,
          @w_ApprovalStatusDate                        = ApprovalStatusDate,
          @w_SubmitDate                                = SubmitDate,
          @w_ExpectedStartDate                         = ExpectedStartDate,
          @w_ContractReceived                          = ContractReceived,
          @w_ConfirmationDate                          = ConfirmationDate,
          @w_CUBSEffectiveDate                         = CUBSEffectiveDate,
          @w_FlowStartDate                             = FlowStartDate,
          @w_Re_enrollmentDate                         = Re_enrollmentDate,
          @w_De_enrollmentDate                         = De_enrollmentDate,
          @w_De_enrollmentReasonCode                   = De_enrollmentReasonCode,
          @w_WaiveTermFee                              = WaiveTermFee,
          @w_Comment                                   = Comment,
          @w_Driver                                    = Driver,
          @w_UpdateStatus                              = UpdateStatus,
          @w_LastUpdate                                = LastUpdate,
          @w_LBMPZone                                  = LBMPZone,
          @w_ServiceClass                              = ServiceClass,
          @w_StratumVariable                           = StratumVariable,
          @w_Rider                                     = Rider,
          @w_TripNumber                                = TripNumber,
          @w_ICAP                                      = ICAP,
          @w_MuniCode                                  = MuniCode,
          @w_RateClass                                 = RateClass,
          @w_ProfitabilityFactor                       = ProfitabilityFactor,
          @w_Competitor                                = Competitor,
          @w_Program                                   = Program
   from Enrollment_Access..tblAccounts with (NOLOCK INDEX = tblAccounts_idx)
   where AccountNumber                                 > @t_AccountNumber
   and   UtilityID                                    <> 'O&R'
   and   AccountNumber                            is not null
   and   AccountNumber                                <> ' '
--   and   ContractNumber                           is not null
--   and   ContractNumber                               <> ' '
   and   upper(ContractType)                           = @t_contract_type

   select @w_rowcount                                  = @@rowcount

   set rowcount 0

   select @t_contract_type                          = @w_ContractType

   while @w_rowcount                               <> 0
   and   @t_contract_type                           = @w_ContractType
   begin

      set rowcount 0

      select @t_account_number                      = @w_AccountNumber

   --begin tran

      select @w_descp_add                              = ' '

      select @w_return                                 = 1

      select @w_account_id_seq                         = @w_account_id_seq + 1

      select @w_account_id                             = 'ACCS' + '-' + right('0000000' + ltrim(rtrim(str(@w_account_id_seq))), 7)

      select @w_account_number                         = @w_AccountNumber

      select @w_account_type                           = case when @w_NationalAccount = 0
                                                              then 'SMB'
                                                              else 'NATIONAL'
                                                         end
   
      select @w_status                                 = ''
      select @w_sub_status                             = ''
   
      select @w_status                                 = status,
             @w_sub_status                             = sub_status
      from lp_account..status_convertion
      where AccountStatusID                            = @w_AccountStatusID

      select @w_utility_id                             = ''
      select @w_entity_id                              = ''

      select @w_utility_id                             = utility_id,
             @w_entity_id                              = entity_id
      from lp_common..common_utility
      where duns_number                                = @w_UtilityID

      if @@rowcount                                    = 0
      begin
         select @w_utility_id                          = @w_UtilityID
         select @w_entity_id                              = entity_id
         from lp_common..common_utility
         where utility_id                                 = @w_UtilityID
      end

      select @w_add_cont                               = case when @w_ContractNumber = ' '
                                                              or   @w_ContractNumber is null
                                                              then @w_add_cont + 1
                                                              else @w_add_cont
                                                        end


      select @w_contract_nbr                           = case when @w_ContractNumber = ' '
                                                              or   @w_ContractNumber is null
                                                              then 'HIST-' + right('0000000' + ltrim(rtrim(convert(varchar(07), @w_add_cont))), 7)
                                                              else @w_ContractNumber
                                                         end

      select @w_contract_type                          = case when upper(@w_ContractType) = 'TPV'
                                                              or   @w_ContractType = ' '
                                                              or   @w_ContractType is null
                                                              then 'VOICE'
                                                              when upper(@w_ContractType) = 'PAPER'
                                                              then 'PAPER'
                                                         end
  
      select @w_retail_mkt_id                          = case when @w_utility_id = 'CONED'
                                                              or   @w_utility_id = 'NIMO' 
                                                              then 'NY'
                                                              else 'MD'
                                                         END

      select @w_product_id                             = case when @w_utility_id = 'CONED'
                                                              then 'CONED-GS-24'
                                                              when @w_utility_id = 'NIMO'
                                                              then 'NIMO-GS-24'
                                                              when @w_utility_id = 'BGE'
                                                              then 'BGE-FIXED-12'
                                                              when @w_utility_id = 'PEPCO-MD'
                                                              then 'PEPCO-MD-FIXED-12'
                                                              else @w_ProductId
                                                         end
 
      select @w_rate_id                                = 0

      select @w_rate_id                                = case when @w_utility_id = 'CONED'
                                                              and  @w_LBMPZone = 'H'
                                                              then 1
                                                              when @w_utility_id = 'CONED'
                                                              and  @w_LBMPZone = 'I'
                                                              then 2    
                                                              when @w_utility_id = 'CONED'
                                                              and  @w_LBMPZone = 'J'
                                                              then 3
                                                              when @w_utility_id = 'NIMO'
                                                              then 0
                                                          else 100
                                                       end  
 
      if @w_utility_id = 'BGE' and @w_utility_id = 'PEPCO-MD'
      begin
         select @w_rate_id = rate_id
         from lp_common..common_product_rate
         where rate =  @w_PriceRate
      end

                                                           
      select @w_rate                                   = isnull(@w_PriceRate, 0)
      select @w_account_name_link                      = 1
      select @w_customer_name_link                     = 2
      select @w_customer_address_link                  = 2
      select @w_customer_contact_link                  = 2
      select @w_billing_address_link                   = 3
      select @w_billing_contact_link                   = 3
      select @w_owner_name_link                        = 4
      select @w_service_address_link                   = 5
      select @w_business_type                          = case when @w_CustomerType = ' '
                                                              or   @w_CustomerType is null
                                                              then 'NONE'
                                                              else upper(isnull(@w_CustomerType, 'NONE'))
                                                         end
      select @w_business_activity                      = case when @w_BusinessType = ' '
                                                              or   @w_BusinessType is null
                                                              then 'NONE'
                                                              else upper(isnull(@w_BusinessType, 'NONE'))
                                                         end
      select @w_additional_id_nbr_type                 = 'NONE'
      select @w_additional_id_nbr                      = 'NONE'
      select @w_contract_eff_start_date                = '19000101'
      select @w_term_months                            = isnull(@w_ContractTerm, 0)
      select @w_date_end                               = dateadd(mm, isnull(@w_ContractTerm, 0), isnull(@w_FlowStartDate, '19000101'))
      select @w_date_deal                              = isnull(@w_SubmitDate, '19000101')
      select @w_date_created                           = getdate()
      select @w_date_submit                            = isnull(@w_SubmitDate, '19000101')
      select @w_sales_channel_role                     = 'Sales Channel/' + ltrim(rtrim(isnull(@w_SalesChannelID, '')))
      select @w_sales_rep                              = isnull(@w_SalesRep, '')
      select @w_origin                                 = 'INIT LOAD'
      select @w_annual_usage                           = isnull(@w_AnnualUsage, 0)
      select @w_date_flow_start                        = isnull(@w_FlowStartDate, '19000101')
      select @w_date_por_enrollment                    = case when @w_AccountStatusID = 14
                                                              then isnull(@w_CurrentStatusEffDate, '19000101')
                                                              else '19000101'
                                                         end
      select @w_date_deenrollment                      = isnull(@w_De_enrollmentDate, '19000101')
      select @w_date_reenrollment                      = isnull(@w_Re_enrollmentDate, '19000101')
      select @w_tax_status                             = 'FULL'
      select @w_tax_rate                               = isnull(@w_TaxRate, 0)
      select @w_credit_score                           = 0
      select @w_credit_agency                          = 'NONE'

      if exists(select contract_nbr
                from lp_account..account with (NOLOCK INDEX = account_idx)
                where contract_nbr                     = @w_contract_nbr
                and   contract_type                   <> @w_contract_type)
      begin
         select @w_contract_nbr                        = substring(@w_contract_type, 1, 1)  
                                                       + '-'
                                                       + ltrim(rtrim(@w_contract_nbr))
      end

--select 100
      exec @w_return = lp_account..usp_account_ins @w_username,
                                                   @w_account_id,
                                                   @w_account_number,
                                                   @w_account_type,
                                                   @w_status,
                                                   @w_sub_status,
                                                   ' ',
                                                   @w_entity_id,
                                                   @w_contract_nbr,
                                                   @w_contract_type,
                                                   @w_retail_mkt_id,
                                                   @w_utility_id,
                                                   @w_product_id,
                                                   @w_rate_id,
                                                   @w_rate,
                                                   1,
                                                   2,
                                                   2,
                                                   2,
                                                   3,
                                                   3,
                                                   4,
                                                   5,
                                                   @w_business_type,
                                                   @w_business_activity,
                                                   @w_additional_id_nbr_type,
                                                   @w_additional_id_nbr,
                                                   @w_contract_eff_start_date,
                                                   @w_term_months,
                                                   @w_date_end,
                                                   @w_date_deal,
                                                   @w_date_created,
                                                   @w_date_submit,
                                                   @w_sales_channel_role,
                                                   @w_sales_rep,
                                                   @w_origin,
                                                   @w_annual_usage,
                                                   @w_date_flow_start,
                                                   @w_date_por_enrollment,
                                                   @w_date_deenrollment,
                                                   @w_date_reenrollment,
                                                   @w_tax_status,
                                                   @w_tax_rate,
                                                   @w_credit_score,
                                                   @w_credit_agency,
                                                   @w_error output,
                                                   @w_msg_id output, 
                                                   ' ',
                                                   'N'

      if @w_return                                    <> 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = ' (Insert Account) '

         goto goto_select
      end

      select @w_field_01_value                         = ''
      select @w_field_02_value                         = ''
      select @w_field_03_value                         = ''
      select @w_field_04_value                         = ''
      select @w_field_05_value                         = ''
      select @w_field_06_value                         = ''

      if @w_utility_id                                 = 'CONED'
      begin
         select @w_field_01_value                      = isnull(@w_LBMPZone, '')
         select @w_field_02_value                      = isnull(@w_ServiceClass, '')
         select @w_field_03_value                      = convert(varchar(20), isnull(@w_StratumVariable, ''))
         select @w_field_04_value                      = convert(varchar(20), isnull(@w_TripNumber, ''))
         select @w_field_05_value                      = convert(varchar(20), isnull(@w_ICAP, ''))
         select @w_field_06_value                      = convert(varchar(20), isnull(@w_ProfitabilityFactor, ''))
      end

      select @w_field_07_value                         = ''
      select @w_field_08_value                         = ''
      select @w_field_09_value                         = ''
      select @w_field_10_value                         = ''

--select 200
      exec @w_return = lp_account..usp_account_additional_info_ins @w_username,
                                                                   @w_account_id,
                                                                   @w_field_01_value,
                                                                   @w_field_02_value,
                                                                   @w_field_03_value,
                                                                   @w_field_04_value,
                                                                   @w_field_05_value,
                                                                   @w_field_06_value,
                                                                   @w_field_07_value,
                                                                   @w_field_08_value,
                                                                   @w_field_09_value,
                                                                   @w_field_10_value,                                                                
                                                                   @w_error output,
                                                                   @w_msg_id output, 
                                                                   ' ',
                                                                   'N'



      if @w_return                                    <> 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = ' (Insert Account Additional Info) '

         goto goto_select
      end

--account_comment

      if  @w_Comment                              is not null
      and @w_Comment                                  <> ' '
      begin
         select @w_comment_account                     = @w_Comment

--select 300
         exec @w_return = lp_account..usp_accounts_comments_ins @w_username,
                                                                @w_account_id,
                                                                'NONE',
                                                                @w_getdate,
                                                                'ACCOUNT',
                                                                @w_comment_account,
                                                                @w_error output,
                                                                @w_msg_id output, 
                                                                ' ',
                                                                'N'
   
         if @w_return                                    <> 0
         begin
            --rollback tran
            select @w_application                         = 'COMMON'
            select @w_error                               = 'E'
            select @w_msg_id                              = '00000051'
            select @w_return                              = 1
            select @w_descp_add                           = ' (Insert Account Comments) '

            goto goto_select
         end
                                                                     
      end


--account_name

      if @w_CustomerName                              is null
      or @w_CustomerName                               = ' '
      begin
         select @w_customer_full_name                  = isnull(@w_AccountName, '')
      end
      else
      begin
         select @w_customer_full_name                  = isnull(@w_CustomerName, '')
      end
  
      select @w_full_name                              = ''

      select @w_full_name                              = case when @w_AccountName is null
                                                              or   @w_AccountName = ' '
                                                              then @w_customer_full_name
                                                              else isnull(@w_AccountName, '')
                                                         end
--select 400
      insert into lp_account..account_name
      select @w_account_id,
             1,
             LTRIM(RTRIM(@w_full_name)),	-- TICKET 20906
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
      --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Account Name)'

         goto goto_select
      end

--customer_name

      select @w_full_name                              = ''

      select @w_full_name                              = isnull(@w_CustomerName, '')
--select 500
      insert into lp_account..account_name
      select @w_account_id,
             2,
             LTRIM(RTRIM(@w_full_name)),	-- TICKET 20906
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Customer Name)'

         goto goto_select
      end

-- customer address

      if @w_BillingStreet                             is null
      or @w_BillingStreet                              = ' '
      begin
         select @w_customer_address                    = isnull(@w_ServiceStreet, '')
         select @w_customer_city                       = isnull(@w_ServiceCity, '')
         select @w_customer_state                      = isnull(@w_ServiceState, '')
         select @w_customer_zip                        = isnull(@w_ServiceZip, '')
      end
      else
      begin
         select @w_customer_address                    = isnull(@w_BillingStreet, '')
         select @w_customer_city                       = isnull(@w_BillingCity, '')
         select @w_customer_state                      = isnull(@w_BillingState, '')
         select @w_customer_zip                        = isnull(@w_BillingZip, '')
      end

      select @w_address                                = ''
      select @w_suite                                  = ''
      select @w_city                                   = ''
      select @w_state                                  = ''
      select @w_zip                                    = ''

      select @w_address                                = isnull(@w_customer_address, '')
      select @w_suite                                  = ''
      select @w_city                                   = isnull(@w_customer_city, '')
      select @w_state                                  = isnull(@w_customer_state, '')
      select @w_zip                                    = isnull(@w_customer_zip, '')
--select 600   
      insert into lp_account..account_address
      select @w_account_id,
             2,
             @w_address,
             @w_suite,
             @w_city,
             @w_state,
             @w_zip,
             ' ',
             ' ',
             ' ',
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Customer Address)'

         goto goto_select
      end

--customer_contact

      if  @w_ContactName                          is not null
      and @w_ContactName                              <> ' '
      begin

         select @w_customer_first_name                 = isnull(@w_ContactName, '')
         select @w_customer_last_name                  = isnull(@w_ContactLastName, '')
         select @w_customer_title                      = isnull(@w_ContactTitle, '')
         select @w_customer_phone                      = isnull(@w_ContactPhone, '')
         select @w_customer_fax                        = isnull(@w_ContactFax, '')
         select @w_customer_email                      = isnull(@w_ContactEmail, '')
         select @w_customer_birthday                   = case when @w_ContactBirthday is null
                                                              then 'NONE'
                                                              else substring(convert(char(10), @w_ContactBirthday, 101), 1, 5)
                                                         end

      end
      else
      begin
         select @w_customer_first_name                 = isnull(@w_AcctContactName, '')
         select @w_customer_last_name                  = isnull(@w_AcctContactLastName, '')
         select @w_customer_title                      = ''
         select @w_customer_phone                      = isnull(@w_AcctContactPhone, '')
         select @w_customer_fax                        = ''
         select @w_customer_email                      = ''
         select @w_customer_birthday                   = ''

      end

select @w_phone                                     = @w_customer_phone

exec lp_common..usp_phone @w_phone output

select @w_customer_phone                            = @w_phone

      select @w_first_name                             = ''
      select @w_last_name                              = ''
      select @w_title                                  = ''
      select @w_phone                                  = ''
      select @w_fax                                    = ''
      select @w_email                                  = ''
      select @w_birthday                               = ''

      select @w_first_name                             = isnull(@w_customer_first_name, '')
      select @w_last_name                              = isnull(@w_customer_last_name, '')
      select @w_title                                  = isnull(@w_customer_title, '')
      select @w_phone                                  = isnull(@w_customer_phone, '')
      select @w_fax                                    = isnull(@w_customer_fax, '') 
      select @w_email                                  = isnull(@w_customer_email, '')
      select @w_birthday                               = isnull(@w_customer_birthday, '')
--select 700
      insert into lp_account..account_contact
      select @w_account_id,
             2,
             @w_first_name,
             @w_last_name,
             @w_title,                          
             @w_phone,
             @w_fax,
             @w_email,
             @w_birthday,
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Contact Address)'

         goto goto_select
      end

-- billing address

      select @w_address                                = ''
      select @w_suite                                  = ''
      select @w_city                                   = ''
      select @w_state                                  = ''
      select @w_zip                                    = ''

      if @w_ServiceStreet                             is null
      or @w_ServiceStreet                              = ' '
      begin
         select @w_address                             = @w_customer_address
         select @w_suite                               = ''
         select @w_city                                = @w_customer_city
         select @w_state                               = @w_customer_state
         select @w_zip                                 = @w_customer_zip
      end
      else
      begin
         select @w_address                             = isnull(@w_ServiceStreet, '')
         select @w_suite                               = ''
         select @w_city                                = isnull(@w_ServiceCity, '')
         select @w_state                               = isnull(@w_ServiceState, '')
         select @w_zip                                 = isnull(@w_ServiceZip, '')
      end
--select 800
      insert into lp_account..account_address
      select @w_account_id,
             3,
             @w_address,
             @w_suite,
             @w_city,
             @w_state,
             @w_zip,
             ' ',
             ' ',
             ' ',
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Billing Address)'

         goto goto_select
      end

--billing_contact

      select @w_first_name                             = ''
      select @w_last_name                              = ''
      select @w_title                                  = ''
      select @w_phone                                  = ''
      select @w_fax                                    = ''
      select @w_email                                  = ''
      select @w_birthday                               = ''

      select @w_first_name                             = isnull(@w_customer_first_name, '')
      select @w_last_name                              = isnull(@w_customer_last_name, '')
      select @w_title                                  = isnull(@w_customer_title, '')
      select @w_phone                                  = isnull(@w_customer_phone, '')
      select @w_fax                                    = isnull(@w_customer_fax, '') 
      select @w_email                                  = isnull(@w_customer_email, '')
      select @w_birthday                               = isnull(@w_customer_birthday, '')

--select 900

      insert into lp_account..account_contact
      select @w_account_id,
             3,
             @w_first_name,
             @w_last_name,
             @w_title,                          
             @w_phone,
             @w_fax,
             @w_email,
             @w_birthday,
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Billing Contact)'

         goto goto_select
      end

--owner_name

      select @w_full_name                              = ''

      select @w_full_name                              = case when @w_OwnerName is null
                                                              or   @w_OwnerName = ' '
                                                              then @w_customer_full_name
                                                              else isnull(@w_OwnerName, '')
                                                                 + ' '
                                                                 + isnull(@w_OwnerLastName, '')
                                                         end

--select 1000
      insert into lp_account..account_name
      select @w_account_id,
             4,
             LTRIM(RTRIM(@w_full_name)),		-- TICKET 20906
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Owner Name)'

         goto goto_select
      end

-- services address

      select @w_address                                = ''
      select @w_suite                                  = ''
      select @w_city                                   = ''
      select @w_state                                  = ''
      select @w_zip                                    = ''

      if @w_ServiceStreet                             is null
      or @w_ServiceStreet                              = ' '
      begin
         select @w_address                             = @w_customer_address
         select @w_suite                               = ''
         select @w_city                                = @w_customer_city
         select @w_state                               = @w_customer_state
         select @w_zip                                 = @w_customer_zip
      end
      else
      begin
         select @w_address                             = isnull(@w_ServiceStreet, '')
         select @w_suite                               = ''
         select @w_city                                = isnull(@w_ServiceCity, '')
         select @w_state                               = isnull(@w_ServiceState, '')
         select @w_zip                                 = isnull(@w_ServiceZip, '')
      end
  
--select 1001
      insert into lp_account..account_address
      select @w_account_id,
             5,
             @w_address,
             @w_suite,
             @w_city,
             @w_state,
             @w_zip,
             ' ',
             ' ',
             ' ',
             0

      if @@error                                      <> 0
      or @@rowcount                                    = 0
      begin
         --rollback tran
         select @w_application                         = 'COMMON'
         select @w_error                               = 'E'
         select @w_msg_id                              = '00000051'
         select @w_return                              = 1
         select @w_descp_add                           = '(Insert Service Address)'

         goto goto_select
      end

      select @t_UpdDate                                = '19000101'

      set rowcount 1

      select @w_UpdateTypeID                           = UpdateTypeID,
             @w_OldValue                               = OldValue,
             @w_OldValueDate                           = OldValueDate,
             @w_NewValue                               = NewValue,
             @w_NewValueDate                           = NewValueDate,
             @w_UpdDate                                = UpdDate
      from Enrollment_Access..tblAccountHistory with (NOLOCK INDEX = tblAccountHistory_idx)
      where AccountNumber                              = @t_account_number
      and   UpdateTypeID                               = 1
      and   UpdDate                                    > @t_UpdDate

      select @w_rowcount_his                           = @@rowcount

      if @w_rowcount_his                              <> 0
      begin

         select @w_status                              = status,
                @w_sub_status                          = sub_status
         from lp_account..status_convertion
         where AccountStatusID                         = @w_OldValue
--select 1002
         exec @w_return = lp_account..usp_account_status_history_ins @w_username,
                                                                     @w_account_id,
                                                                     @w_status,
                                                                     @w_sub_status,
                                                                     @w_getdate,
                                                                     'INIT LOAD',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     @w_UpdDate,
                                                                     @w_error output,
                                                                     @w_msg_id output,
                                                                     ' ',
                                                                     'N'


         if @w_return                                 <> 0
         begin
            --rollback tran
            set rowcount 0
            select @w_application                      = 'COMMON'
            select @w_error                            = 'E'
            select @w_msg_id                           = '00000051'
            select @w_return                           = 1
            select @w_descp_add                        = ' (Insert History Account) '
   
            goto goto_select
         end

      end

      while @w_rowcount_his                           <> 0
      begin

         set rowcount 0

         select @t_UpdDate                             = @w_UpdDate

         select @w_return                              = 1

         select @w_status                              = ''
         select @w_sub_status                          = ''

         select @w_status                              = status,
                @w_sub_status                          = sub_status
         from lp_account..status_convertion
         where AccountStatusID                         = @w_NewValue

         if exists(select account_id
                   from lp_account..account_status_history
                   where account_id                    = @w_account_id)
         begin
            goto goto_next
         end
--select 1003
         exec @w_return = lp_account..usp_account_status_history_ins @w_username,
                                                                     @w_account_id,
                                                                     @w_status,
                                                                     @w_sub_status,
                                                                     @w_getdate,
                                                                     'INIT LOAD',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     @w_UpdDate,
                                                                     @w_error output,
                                                                     @w_msg_id output,
                                                                     ' ',
                                                                     'N'


         if @w_return                                 <> 0
         begin
            --rollback tran
            set rowcount 0
            select @w_application                      = 'COMMON'
            select @w_error                            = 'E'
            select @w_msg_id                           = '00000051'
            select @w_return                           = 1
            select @w_descp_add                        = ' (Insert History Account) '

            goto goto_select
         end

         goto_next:

         select @w_UpdateTypeID                        = UpdateTypeID,
                @w_OldValue                            = OldValue,
                @w_OldValueDate                        = OldValueDate,
                @w_NewValue                            = NewValue,
                @w_NewValueDate                        = NewValueDate,
                @w_UpdDate                             = UpdDate
         from Enrollment_Access..tblAccountHistory with (NOLOCK INDEX = tblAccountHistory_idx)
         where AccountNumber                              = @t_account_number
         and   UpdateTypeID                               = 1
         and   UpdDate                                    > @t_UpdDate

         select @w_rowcount_his                        = @@rowcount
   
      end

      select @t_UpdDate                                = '19000101'

      set rowcount 1

      select @w_UpdateTypeID                           = UpdateTypeID,
             @w_OldValue                               = OldValue,
             @w_OldValueDate                           = OldValueDate,
             @w_NewValue                               = NewValue,
             @w_NewValueDate                           = NewValueDate,
             @w_UpdDate                                = UpdDate
      from Enrollment_Access..tblAccountHistory with (NOLOCK INDEX = tblAccountHistory_idx)
      where AccountNumber                              = @t_account_number
      and   UpdateTypeID                               = 2
      and   UpdDate                                    > @t_UpdDate

      select @w_rowcount_his                           = @@rowcount

      while @w_rowcount_his                           <> 0
      begin

         set rowcount 0

         select @t_UpdDate                             = @w_UpdDate
--select 1004
         insert into lp_account..account_reason_code_hist
         select @w_account_id,
                @w_getdate,
                right('000' + ltrim(rtrim(convert(varchar(03), substring(ltrim(rtrim(@w_NewValue)), 1, 3)))), 3),
                'INIT LOAD',
                @w_username,
                0

         select @w_UpdateTypeID                        = UpdateTypeID,
                @w_OldValue                            = OldValue,
                @w_OldValueDate                        = OldValueDate,
                @w_NewValue                            = NewValue,
                @w_NewValueDate                        = NewValueDate,
                @w_UpdDate                             = UpdDate
         from Enrollment_Access..tblAccountHistory with (NOLOCK INDEX = tblAccountHistory_idx)
         where AccountNumber                              = @t_account_number
         and   UpdateTypeID                               = 2
         and   UpdDate                                    > @t_UpdDate

         select @w_rowcount_his                        = @@rowcount
   
      end

   --commit tran

      set rowcount 1

      select @w_AccountNumber                          = AccountNumber,
             @w_UtilityID                              = UtilityID,
             @w_NationalAccount                        = NationalAccount,
             @w_AccountName                            = AccountName,
             @w_CustomerName                           = CustomerName,
             @w_CustomerType                           = CustomerType,
             @w_BusinessType                           = BusinessType,
             @w_OwnerName                              = OwnerName,
             @w_OwnerLastName                          = OwnerLastName,
             @w_ServiceStreet                          = ServiceStreet,
             @w_ServiceCity                            = ServiceCity,
             @w_ServiceState                           = ServiceState,
             @w_ServiceZip                             = ServiceZip,
             @w_BillingStreet                          = BillingStreet,
             @w_BillingCity                            = BillingCity,
             @w_BillingState                           = BillingState,
             @w_BillingZip                             = BillingZip,
             @w_ContactName                            = ContactName,
             @w_ContactLastName                        = ContactLastName,
             @w_ContactTitle                           = ContactTitle,
             @w_ContactPhone                           = ContactPhone,
             @w_ContactFax                             = ContactFax,
             @w_ContactEmail                           = ContactEmail,
             @w_ContactBirthday                        = ContactBirthday,
             @w_AcctContactName                        = AcctContactName,
             @w_AcctContactLastName                    = AcctContactLastName,
             @w_AcctContactPhone                       = AcctContactPhone,
             @w_ContractType                           = ContractType,
             @w_ContractNumber                         = ContractNumber,
             @w_ContractTerm                           = ContractTerm,
             @w_ContractPK                             = ContractPK,
             @w_ProductId                              = ProductId,
             @w_PriceRate                              = PriceRate,
             @w_TaxStatus                              = TaxStatus,
             @w_TaxRate                                = TaxRate,
             @w_SalesChannelID                         = SalesChannelID,
             @w_SalesRep                               = SalesRep,
             @w_AnnualUsage                            = AnnualUsage,
             @w_CommissionTransID                      = CommissionTransID,
             @w_CommissionAmt                          = CommissionAmt,
             @w_CommissionStatus                       = CommissionStatus,
             @w_CommissionStatusDate                   = CommissionStatusDate,
             @w_CommissionPymtDueDate                  = CommissionPymtDueDate,
             @w_CreditScore                            = CreditScore,
             @w_CreditApproved                         = CreditApproved,
             @w_CreditApprovedBy                       = CreditApprovedBy,
             @w_DateReceived                           = DateReceived,
             @w_AccountStatusID                        = AccountStatusID,
             @w_CurrentStatusEffDate                   = CurrentStatusEffDate,
             @w_StatusApproved                         = StatusApproved,
             @w_ApprovalStatusDate                     = ApprovalStatusDate,
             @w_SubmitDate                             = SubmitDate,
             @w_ExpectedStartDate                      = ExpectedStartDate,
             @w_ContractReceived                       = ContractReceived,
             @w_ConfirmationDate                       = ConfirmationDate,
             @w_CUBSEffectiveDate                      = CUBSEffectiveDate,
             @w_FlowStartDate                          = FlowStartDate,
             @w_Re_enrollmentDate                      = Re_enrollmentDate,
             @w_De_enrollmentDate                      = De_enrollmentDate,
             @w_De_enrollmentReasonCode                = De_enrollmentReasonCode,
             @w_WaiveTermFee                           = WaiveTermFee,
             @w_Comment                                = Comment,
             @w_Driver                                 = Driver,
             @w_UpdateStatus                           = UpdateStatus,
             @w_LastUpdate                             = LastUpdate,
             @w_LBMPZone                               = LBMPZone,
             @w_ServiceClass                           = ServiceClass,
             @w_StratumVariable                        = StratumVariable,
             @w_Rider                                  = Rider,
             @w_TripNumber                             = TripNumber,
             @w_ICAP                                   = ICAP,
             @w_MuniCode                               = MuniCode,
             @w_RateClass                              = RateClass,
             @w_ProfitabilityFactor                    = ProfitabilityFactor,
             @w_Competitor                             = Competitor,
             @w_Program                                = Program
      from Enrollment_Access..tblAccounts with (NOLOCK INDEX = tblAccounts_idx)
      where AccountNumber                              > @t_account_number
      and   UtilityID                                 <> 'O&R'
      and   AccountNumber                         is not null
      and   AccountNumber                             <> ' '
--      and   ContractNumber                        is not null
--      and   ContractNumber                            <> ' '
      and   upper(ContractType)                        = @t_contract_type

      select @w_rowcount                               = @@rowcount

   end

   set rowcount 0

   if @t_contract_type                                 = 'TPV'
   begin   
      select @t_contract_type                          = 'PAPER'
      select @w_rowcount                               = @@rowcount
   end
end
   

set rowcount 0

create table #contrato
(contract_nbr                                       char(12),
 contract_type                                      varchar(35))

insert into #contrato
select distinct contract_nbr, contract_type
from lp_account..account

declare @w_check_type                               char(10)
select @w_check_type                                = ''

declare @w_check_request_id                         char(25)
select @w_check_request_id                          = ''

declare @w_approval_status                          varchar(25)


set rowcount 1

select @w_contract_nbr                              = contract_nbr,
       @w_contract_type                             = contract_type
from #contrato
/*
while @@rowcount                                   <> 0
begin

   set rowcount 0

   select @w_contract_type                          = case when upper(@w_contract_type) = 'TPV'
                                                           then 'VOICE'
                                                           when upper(@w_contract_type) = 'PAPER'
                                                           then 'PAPER'
                                                      end

   select @w_return                                 = 1

   select @w_check_type                             = 'CREDIT CHECK'

   if exists(select utility_id, contract_nbr, contract_type
             from lp_account..account with (NOLOCK INDEX = account_idx)
             where contract_nbr                     = @w_contract_nbr
             and   contract_type                    = @w_contract_type
             and   utility_id                       = 'CONED')
   begin
      select @w_check_type                          = 'PROFITABILITY'
   end


   select @w_check_request_id                       = 'ENROLLMENT'
  

   exec @w_return = lp_enrollment..usp_check_account_ins @w_username,
                                                         @w_contract_nbr,
                                                         ' ',
                                                         @w_check_type,
                                                         @w_check_request_id,
                                                         'PENDING',
                                                         @w_getdate,
                                                         ' ',
                                                         '19000101',
                                                         'INIT LOAD',
                                                         ' ',
                                                         ' ',
                                                         '19000101',
                                                         ' ',
                                                         '19000101',
                                                         '19000101',
                                                         0,
                                                         @w_error output,                                                         @w_msg_id output, 
                                                         ' ',
                                                         'N'


   if @w_return                                    <> 0
   begin
      --rollback tran
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Check Credit) '

      goto goto_select
   end

   if @w_contract_type                              = 'VOICE'
   begin

      select @w_return                              = 1

      exec @w_return = lp_enrollment..usp_check_account_ins @w_username,
                                                            @w_contract_nbr,
                                                            ' ',
                                                            'TPV',
                                                            @w_check_request_id,
                                                            'PENDING',
                                                            @w_getdate,
                                                            ' ',
                                                            '19000101',
                                                            'INIT LOAD',
                                                            ' ',
                                                            ' ',
                                                            '19000101',
                                                            ' ',
                                                            '19000101',
                                                            '19000101',
                                                            0,
                                                            @w_error output,
                                                            @w_msg_id output, 
                                                            ' ',
                                                            'N'
              
      if @w_return                                  = 1
      begin
         --rollback tran
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = ' (Insert Check TPV) '

         goto goto_select
      end
   end
   else
   begin
      select @w_return                              = 1

      exec @w_return = lp_enrollment..usp_check_account_ins @w_username,
                                                            @w_contract_nbr,
                                                            ' ',
                                                            'DOCUMENTS',
                                                            @w_check_request_id,
                                                            'PENDING',
                                                            @w_getdate,
                                                            ' ',
                                                            '19000101',
                                                            'INIT LOAD',
                                                            ' ',
                                                            ' ',
                                                            '19000101',
                                                            ' ',
                                                            '19000101',
                                                            '19000101',
                                                            0,
                                                            @w_error output,
                                                            @w_msg_id output, 
                                                            ' ',
                                                            'N'
              
      if @w_return                                  = 1
      begin
         --rollback tran
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = ' (Insert Check Document) '

         goto goto_select
      end
   end

   select @w_return                                 = 1

   exec @w_return = lp_enrollment..usp_check_account_ins @w_username,
                                                         @w_contract_nbr,
                                                         ' ',
                                                         'LETTER',
                                                         @w_check_request_id,
                                                         'PENDING',
                                                         @w_getdate,
                                                         ' ',
                                                         '19000101',
                                                         'INIT LOAD',
                                                         ' ',
                                                         ' ',
                                                         '19000101',
                                                         ' ',
                                                         '19000101',
                                                         '19000101',
                                                         0,
                                                         @w_error output,
                                                         @w_msg_id output, 
                                                         ' ',
                                                         'N'

   select @w_return                                 = 1

   exec @w_return = lp_enrollment..usp_check_account_ins @w_username,
                                                         @w_contract_nbr,
                                                         ' ',
                                                         'CONTRACT',
                                                         @w_check_request_id,
                                                         'PENDING',
                                                         @w_getdate,
                                                         ' ',
                                                         '19000101',
                                                         'INIT LOAD',
                                                         ' ',
                                                         ' ',
                                                         '19000101',
                                                         ' ',
                                                         '19000101',
                                                         '19000101',
                                                         0,
                                                         @w_error output,
                                                         @w_msg_id output, 
                                                         ' ',
                                                         'N'
              
   if @w_return                                     = 1
   begin
      --rollback tran
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Check Approval) '

      goto goto_select
   end

   set rowcount 1

   delete #contrato

   select @w_contract_nbr                           = contract_nbr,
          @w_contract_type                          = contract_type
   from #contrato

end
*/
SET ROWCOUNT 0
declare @w_process_id                               nvarchar(30) 
declare @w_seq                                      int
declare @w_business                                 varchar(35)

select @w_seq                                       = 0

--drop table #business


create table #business
(seq                                                int,
 business                                           varchar(35))

insert into #business
select distinct 1, business_type
from lp_account..account

insert into #business
select distinct 2, business_activity
from lp_account..account

declare @t_seq                                      int
select @t_seq                                       = 20000

set rowcount 1

select @w_seq                                       = seq,
       @w_business                                  = business
from #business

select @w_rowcount                                  = @@rowcount
/*
while @w_rowcount                                  <> 0
begin

   set rowcount 0

   select @w_process_id                             = 'BUSINESS ACTIVITY'

   if @w_seq                                        = 1
   begin
      select @w_process_id                          = 'BUSINESS TYPE'
   end

   if not exists(select option_id
                 from lp_common..common_views
                 where process_id                = @w_process_id
                 and   option_id                 = upper(@w_business))
   begin
      
      insert into lp_common..common_views
      select @w_process_id,
             @t_seq,
             upper(@w_business),
             upper(@w_business)

      select @t_seq                                = @t_seq + 1
   end

   set rowcount 1

   delete #business

   select @w_seq                                       = seq,
          @w_business                                  = business
   from #business

   select @w_rowcount                                  = @@rowcount

end
*/
set rowcount 0

create table #contrato_2
(contract_nbr                                       char(12))

insert into #contrato_2
select distinct contract_nbr
from lp_account..account

declare @w_customer_id                              varchar(10)
select @w_customer_id                               = ' '


set rowcount 1

select @w_contract_nbr                              = contract_nbr
from #contrato_2
/*
while @@rowcount                                   <> 0
begin

   set rowcount 0


   exec @w_return = lp_account..usp_get_key @w_username,
                                            'CUSTOMER ID',
                                            @w_customer_id output, 
                                            'N'

   if @w_return                                    <> 0
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = ' (Insert Customer Account) '

      goto goto_select
   end

   insert into lp_account..customer_account
   select @w_customer_id,
          @w_contract_nbr


   set rowcount 1

   delete #contrato_2

   select @w_contract_nbr                           = contract_nbr
   from #contrato_2

end

*/
set rowcount 0
select @w_return                                    = 0

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
   select @w_descp                                  = ltrim(rtrim(@w_descp))
                                                    + ''
                                                    + @w_descp_add 
end
 
select flag_error                                   = @w_error,
       code_error                                   = @w_msg_id,
       message_error                                = @w_descp


return @w_return


