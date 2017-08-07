USE [Lp_Account]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_account_upd' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_account_upd];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_account_upd]
 * PURPOSE:		To update the account details 
 * HISTORY:		 
 *******************************************************************************
 
 * 11/04/2014 - Pradeep Katiyar
 * Updated. Added the inactive check for market table.
 *******************************************************************************

 */


CREATE procedure [dbo].[usp_account_upd]      
(@p_username                                        nchar(100),      
 @p_account_id                                      char(12),      
 @p_account_number                                  varchar(30),      
 @p_account_type                                    varchar(25),      
 @p_status                                          varchar(15),      
 @p_sub_status                                      varchar(15),      
 @p_customer_id                                     varchar(10),      
 @p_entity_id     char(15),      
 @p_contract_nbr                                    char(12),      
 @p_contract_type                                   varchar(25),      
 @p_retail_mkt_id                                   char(02),      
 @p_utility_id                                      char(15),      
 @p_product_id                                      char(20),      
 @p_rate_id                                         int,       
 @p_rate                                            float,      
 @p_business_type                                   varchar(35),      
 @p_enrollmenttype_int        int = 1,      
 @p_business_activity                               varchar(35),      
 @p_db_group_id          int = null,      
 @p_additional_id_nbr_type                          varchar(10),      
 @p_additional_id_nbr                               varchar(30),      
 @p_contract_eff_start_date                         datetime,      
 @p_term_months                                     int,      
 @p_date_end                                        datetime,      
 @p_date_deal                                       datetime,      
 @p_date_created                                    datetime,      
 @p_date_submit                                     datetime,      
 @p_sales_channel_role                              nvarchar(50),      
 @p_sales_rep                                       varchar(100),      
 @p_origin                                          varchar(50),      
 @p_annual_usage                                    int,      
 @p_date_flow_start                                 datetime,      
 @p_date_por_enrollment                             datetime,      
 @p_date_deenrollment                               datetime,      
 @p_date_reenrollment                               datetime,      
 @p_tax_status                                      varchar(20),      
 @p_tax_rate                                        float,      
 @p_credit_score                                    real,      
 @p_credit_agency                                   varchar(30),      
 @p_por_option                                      varchar(03) = '',      
 @p_billing_type                                    varchar(15) = '',      
 @p_requested_flow_start_date                       datetime = '19000101',      
 @p_deal_type                                       char(20) = '',      
 @p_enrollment_type                                 int = 0,      
 @p_customer_code                                   char(05) = '',      
 @p_customer_group                                  char(100) = '',      
 @p_old_chgstamp                                    smallint,      
 @p_error                                           char(01),      
 @p_msg_id                                          char(08),      
 @p_descp                                           varchar(250),      
 @p_result_ind                                      char(01) = 'Y',      
 @p_paymentTerm          int = 0,      
 @p_ssnEncrypted         nvarchar(512) = null, --added for IT002      
 @p_credit_score_encrypted       nvarchar(512) = null,  --added for IT002      
 @p_heat_index_source_ID       int = 0,  -- Project IT037      
 @p_heat_rate          float = 0, -- Project IT037      
 --ticket 15504      
 @p_tax_type_id1         int = 0,      
 @p_percent_taxable1        varchar(10) = '',      
 @p_tax_type_id2         int = 0,      
 @p_percent_taxable2        varchar(10) = '',      
 @p_tax_type_id3         int = 0,      
 @p_percent_taxable3        varchar(10) = '',      
 @p_tax_type_id4         int = 0,      
 @p_percent_taxable4        varchar(10) = '',      
 @p_tax_type_id5         int = 0,      
 @p_percent_taxable5        varchar(10) = '',      
 @p_tax_type_id6         int = 0,      
 @p_percent_taxable6        varchar(10) = '',      
 @p_tax_type_id7         int = 0,      
 @p_percent_taxable7        varchar(10) = '',
 @p_CreditInsured BIT    
 )      
AS     
BEGIN     
    
 SET NOCOUNT ON    
       
declare @w_error                                    char(01)      
declare @w_msg_id                                   char(08)      
declare @w_descp                                    varchar(250)      
declare @w_return                                   int      
declare @w_descp_add                                varchar(200)      
  ,@w_rate_cap        float -- ADDED ticket 24169      
      
      
       
select @w_error                                     = 'I'      
select @w_msg_id                                    = '00000001'      
select @w_descp                                     = ''      
select @w_return         = 0      
select @w_descp_add                                 = ''      
      
declare @w_application                              varchar(20)      
select @w_application        = 'COMMON'      
      
declare @w_new_chgstamp                             smallint       
      
exec lp_common..usp_calc_chgstamp @p_old_chgstamp,       
                                  @w_new_chgstamp output       
      
select @p_product_id                                = upper(@p_product_id)      
select @p_business_type                             = upper(@p_business_type)      
select @p_business_activity                         = upper(@p_business_activity)      
select @p_additional_id_nbr_type                    = upper(@p_additional_id_nbr_type)      
select @p_additional_id_nbr                         = upper(@p_additional_id_nbr)      
      
declare @w_contract_type                            varchar(15)      
declare @w_rate                                     float      
declare @p_rate_plus_tax                            float      
declare @w_grace_period                             int      
declare @w_invalid_rate        int      
      
declare @w_evergreen_option_id      int      
declare @w_residual_option_id      int      
declare @w_initial_pymt_option_id     int      
declare @w_sales_manager       varchar(100)      
    
DECLARE @w_CurrentContractID     INT    
DECLARE @w_AccountTypeID         INT    
DECLARE @w_ContractTypeID        INT    
DECLARE @w_RetailMktID           INT    
DECLARE @w_UtilityID             INT    
DECLARE @w_BusinessTypeID        INT    
DECLARE @w_BusinessActivityID    INT    
DECLARE @w_SalesChannelID        INT    
DECLARE @w_TaxStatusID           INT    
DECLARE @w_CreditAgencyID        INT    
DECLARE @w_BillingTypeID         INT    
DECLARE @w_ContractDealTypeID    INT    
DECLARE @w_EnrollmentTypeID      INT    
DECLARE @w_SalesManagerID        INT    
DECLARE @w_ModifiedBy            INT    
DECLARE @w_date_flow_start       DATETIME    
DECLARE @w_date_deenrollment     DATETIME  
DECLARE @w_PriceID               bigint  
DECLARE @w_CreditInsured		 BIT
DECLARE @w_AccountContractID			 INT

SELECT @w_AccountContractID = AccountContractID 
FROM Libertypower..AccountContract AC WITH (NOLOCK)
JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
WHERE A.AccountIdLegacy = @p_account_id
      
--begin ticket 1-920833      
select @w_initial_pymt_option_id = initial_pymt_option_id,      
  @w_residual_option_id = residual_option_id,       
  @w_evergreen_option_id = evergreen_option_id,      
  @w_sales_manager = u.FirstName + ' ' + u.LastName       
from lp_commissions..vendor v WITH (NOLOCK)    
left join LibertyPower..SalesChannel sc WITH (NOLOCK) on v.ChannelId = sc.ChannelID      
left join LibertyPower..[User] u WITH (NOLOCK) on sc.ChannelDevelopmentManagerID = u.UserId      
where vendor_system_name = @p_sales_channel_role      
--end ticket 1-920833      
      
-- Check the rate being updated is not lower than the transfer rate in the history table      
set @w_invalid_rate = 0      
      
print 'evaluating history rate'      
  
--***** Start SR- 1-350713456 By Chowdary   ************************  
select @w_PriceID = acr.PriceID  
  from libertypower..AccountContractRate acr WITH(NOLOCK)  
  join libertypower..AccountContract ac WITH(NOLOCK) on ac.AccountContractID = acr.AccountContractID  
  join libertypower..Account a WITH(NOLOCK)          on a.AccountID = ac.AccountID  
  join libertypower..Contract c WITH(NOLOCK)         on c.ContractID = ac.ContractID  
  and a.AccountNumber = @p_account_number   
  and c.Number = @p_contract_nbr  
  
  
select @w_rate = Price  
      from LibertyPower..Price P WITH(NOLOCK)  
      where P.ID = @w_PriceID  
  
--Select @w_rate     = rate      
--  from lp_common..product_rate_history (nolock)      
-- where product_id    = @p_product_id      
--   and rate_id     = @p_rate_id      
--   and eff_date     = dateadd(d, 0, datediff(d, 0, @p_date_deal))     -- Update Jose Muñoz      
--   and contract_eff_start_date = dateadd(d, 0, datediff(d, 0, @p_contract_eff_start_date)) -- Update Jose Muñoz      
   --and eff_date     = convert(varchar(8), @p_date_deal,112)      
   --and contract_eff_start_date = convert(varchar(8), @p_contract_eff_start_date, 112)      
  
--**** END SR-1-350713456  By Chowdary *******************************************  
     
 print 'The contract rate ' + convert(nvarchar(15),@p_rate) + ' and the transfer rate ' + convert(nvarchar(15),@w_rate)      
       
DECLARE @Tax FLOAT      
SELECT @Tax = SalesTax      
FROM LibertyPower..Market M WITH (NOLOCK)    
JOIN LibertyPower..MarketSalesTax MST WITH (NOLOCK) ON M.ID = MST.MarketID      
WHERE M.MarketCode = @p_retail_mkt_id and  M.InactiveInd=0 
      
IF @Tax IS NULL      
 SET @Tax = 0.0      
       
SET @p_rate_plus_tax = ROUND(@p_rate * (1 + @Tax),5)      
       
 If @p_rate_plus_tax < @w_rate      
 Begin      
 print 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is lower than the transfer rate ' + convert(nvarchar(15),@w_rate)      
        
 set @w_error          = 'E'      
 set @w_msg_id          = '00001078'      
 set @w_descp_add         = 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is lower than the transfer rate ' + convert(nvarchar(15),@w_rate)      
 goto goto_select       
      
 End      
       
 -- End check rate validity against history data      
/* Ticket 24169 Begin */      
Select Top 1      
 @w_rate_cap    = rate_cap      
from lp_deal_capture..deal_rate (nolock)      
order by 1 desc      
      
If @p_rate > (@w_rate_cap + @w_rate) -- Changed with ticket 24345      
Begin      
 set @w_error   = 'E'      
 set @w_msg_id   = '00001078'      
 set @w_descp_add  = 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is higher than the max rate cap allowed' + convert(nvarchar(15),(@w_rate_cap + @w_rate))      
 goto goto_select       
End      
/* Ticket 24169 End */       
      
      
if  @w_contract_type         = 'VOICE'      
begin      
   select @p_contract_eff_start_date     = contract_eff_start_date,      
   @p_term_months        = term_months      
   from  lp_common..common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)      
   where product_id         = @p_product_id      
   and  rate_id          = @p_rate_id    
   and  convert(char(08), getdate(), 112)   >= eff_date      
   and  convert(char(08), getdate(), 112)   < due_date      
   and  inactive_ind        = '0'      
end      
      
exec @w_return = usp_account_val @p_username,      
                                'U',        
                                'ALL',      
                                @p_account_id,      
                                @p_account_number,      
                    @p_account_type,      
                                @p_status,      
                                @p_sub_status,      
                                @p_customer_id,      
                                @p_entity_id,      
                                @p_contract_nbr,      
                                @p_contract_type,      
                                @p_retail_mkt_id,      
                                @p_utility_id,      
                                @p_product_id,      
                                @p_rate_id,      
                                @p_rate,      
                                @p_business_type,      
                                @p_business_activity,      
                                @p_additional_id_nbr_type,      
                                @p_additional_id_nbr,      
                                @p_contract_eff_start_date,      
                                @p_term_months,      
                                @p_date_end,      
                                @p_date_deal,      
                                @p_date_created,      
                                @p_date_submit,      
                                @p_sales_channel_role,      
                                @p_sales_rep,      
                                @p_origin,      
        @p_annual_usage,      
                                @p_date_flow_start,      
                                @p_date_por_enrollment,      
                                @p_date_deenrollment,      
                                @p_date_reenrollment,      
                                @p_tax_status,      
                                @p_tax_rate,      
                                @p_credit_score,      
                                @p_credit_agency,      
                                @p_por_option,      
                                @p_billing_type,      
                                @p_requested_flow_start_date,      
                                @p_deal_type,      
                                @p_enrollment_type,      
                                @p_customer_code,      
                                @p_customer_group,      
                                @w_application output,      
                                @w_error output,      
                                @w_msg_id output,      
                                @w_descp_add output      
      
if @w_return                                       <> 0      
begin      
   goto goto_select      
end      
      
if  @w_contract_type                                = 'VOICE'      
begin      
   select @w_grace_period                           = grace_period      
   from lp_common..common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)      
   where product_id                                 = @p_product_id      
   and   rate_id                                    = @p_rate_id      
   and   inactive_ind                               = '0'      
   and   eff_date                                  <= convert(char(08), getdate(), 112)      
   and   due_date                                  >= convert(char(08), getdate(), 112)      
end      
      
-- If the enrollment type is non-standard, then we set the "date to send" according to certain busines rules.      
declare @w_lead_time                                int      
select @w_lead_time                                 = 0      
      
declare @w_date_por_enrollment                      datetime      
select @w_date_por_enrollment                       = @p_date_por_enrollment      
      
if @p_enrollment_type                              <> 1      
begin      
   if @p_enrollment_type                            = 5      
   begin      
      set @w_lead_time                              = -15      
   end      
   else       
   begin      
      if @p_enrollment_type                        in (3,4)      
      begin          
         set @w_lead_time                        = -4      
      end      
   end      
end    
    
--IT124 BEGIN    
SELECT  @w_CurrentContractID = ContractID    
FROM Libertypower..Contract WITH (NOLOCK)     
WHERE Number = @p_contract_nbr    
    
SELECT @w_AccountTypeID =  ID    
FROM Libertypower..AccountType WITH (NOLOCK)    
WHERE AccountType = CASE WHEN ltrim(rtrim(@p_account_type)) = 'RESIDENTIAL' THEN 'RES' ELSE ltrim(rtrim(@p_account_type)) END    
--Begin PBI 42151 Diogo Lima  
IF @w_AccountTypeID is null   
BEGIN  
 SELECT @w_AccountTypeID = AccountTypeId  
 FROM Libertypower..Account  
 where AccountIdLegacy = @p_account_id    
END  
--End PBI 42151 Diogo Lima  
SELECT @w_ContractTypeID = ContractTypeID    
FROM LibertyPower.dbo.ContractType  WITH (NOLOCK)     
WHERE Type = @p_contract_type    
    
SELECT @w_RetailMktID = ID    
FROM Libertypower..Market WITH (NOLOCK)    
WHERE MarketCode = UPPER(@p_retail_mkt_id)  
		and InactiveInd=0  --PBI 52745 - Added
    
SELECT @w_UtilityID = ID    
FROM Libertypower..Utility WITH (NOLOCK)     
WHERE UtilityCode = UPPER(@p_utility_id)    
    
SELECT @w_BusinessTypeID = BusinessTypeID    
FROM Libertypower..BusinessType WITH (NOLOCK)    
WHERE Type = CASE WHEN (@p_business_type IS NULL)     
      THEN 'NONE'     
      ELSE @p_business_type     
    END    
    
SELECT @w_BusinessActivityID = BusinessActivityID    
FROM Libertypower..BusinessActivity WITH (NOLOCK)    
WHERE Activity = CASE WHEN (@p_business_activity IS NULL)     
       THEN 'NONE'     
       ELSE @p_business_activity     
     END    
    
SELECT @w_SalesChannelID = ChannelID    
FROM Libertypower..SalesChannel WITH (NOLOCK)    
WHERE 'SALES CHANNEL/' + ChannelName = @p_sales_channel_role    
    
SELECT @w_TaxStatusID = TaxStatusID    
FROM Libertypower..TaxStatus WITH (NOLOCK)    
WHERE Status =  @p_tax_status     
               
SELECT @w_CreditAgencyID = CreditAgencyID    
FROM Libertypower..CreditAgency WITH (NOLOCK)    
WHERE Code = @p_credit_agency    
    
SELECT @w_BillingTypeID = BillingTypeID    
FROM Libertypower..BillingType WITH (NOLOCK)    
WHERE Type = @p_billing_type    
    
SELECT @w_ContractDealTypeID = ContractDealTypeID    
FROM Libertypower..ContractDealType WITH (NOLOCK)    
WHERE DealType = @p_deal_type    
    
SELECT @w_ModifiedBy = UserID    
FROM Libertypower..[User] WITH (NOLOCK)    
WHERE UserName = @p_username    
    
SELECT @w_SalesManagerID = UserID    
FROM Libertypower..[User] WITH (NOLOCK)    
WHERE Firstname + ' ' + Lastname = @w_sales_manager    
    
SELECT @w_date_flow_start = CASE WHEN ((@p_date_flow_start = '') OR (@p_date_flow_start = '19000101'))    
         THEN NULL    
         ELSE @p_date_flow_start    
       END    
           
SELECT @w_date_deenrollment = CASE WHEN ((@p_date_deenrollment = '') OR (@p_date_deenrollment = '19000101'))    
           THEN NULL    
              ELSE @p_date_deenrollment    
         END    
           
    
--UPDATE ACCOUNT    
UPDATE Libertypower..Account     
SET   AccountNumber  = @p_account_number    
  ,CurrentContractID = @w_CurrentContractID    
  ,AccountTypeID  = @w_AccountTypeID    
  ,RetailMktID  = @w_RetailMktID    
  ,CustomerIdLegacy = @p_customer_id    
  ,UtilityID   = @w_UtilityID    
  ,EntityID   = @p_entity_id    
  ,TaxStatusID  = @w_TaxStatusID    
  ,PorOption   = CASE WHEN @p_por_option = 'YES' THEN 1 ELSE 0 END    
  ,BillingTypeID  = @w_BillingTypeID    
  ,ModifiedBy  = @w_ModifiedBy    
WHERE AccountIdLegacy = @p_account_id    
    
--UPDATE CONTRACT    
UPDATE Libertypower..Contract    
SET  ContractTypeID  = ISNULL(@w_ContractTypeID, ContractTypeID)    
 ,SignedDate   = @p_date_deal    
 ,SubmitDate   = @p_date_submit    
 ,SalesChannelID  = @w_SalesChannelID    
 ,SalesRep   = @p_sales_rep    
 ,ContractDealTypeID = ISNULL(@w_ContractDealTypeID, ContractDealTypeID)    
 ,ModifiedBy   = @w_ModifiedBy    
 ,SalesManagerID  = ISNULL(@w_SalesManagerID,SalesManagerID)    
WHERE Number   = @p_contract_nbr     
    
--UPDATE AccountContractRate    
UPDATE Libertypower..AccountContractRate     
SET  LegacyProductID = @p_product_id    
 ,RateID    = @p_rate_id    
 ,Rate    = @p_rate    
 ,RateStart   = @p_contract_eff_start_date    
 ,Term    = @p_term_months    
 ,RateEnd   = @p_date_end    
 ,ModifiedBy   = @w_ModifiedBy    
 ,HeatIndexSourceID = @p_heat_index_source_ID    
 ,HeatRate   = @p_heat_rate    
WHERE AccountContractRateID IN (SELECT AAA.AccountContractRateID    
        FROM (SELECT AA.AccountID, MAX(ACR.AccountContractRateID) AS AccountContractRateID    
           FROM Libertypower..AccountContractRate ACR WITH (NOLOCK)    
          INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)    
          ON ACR.AccountContractID  = AC.AccountContractID     
          INNER JOIN Libertypower..Account AA WITH (NOLOCK)    
          ON AA.AccountID     = AC.AccountID    
          AND AA.CurrentContractID  = AC.ContractID    
          INNER JOIN Libertypower..[Contract] CC WITH (NOLOCK)    
          ON AC.ContractID    = CC.ContractID     
          WHERE CC.NUMBER     = @p_contract_nbr    
          AND AA.AccountIdLegacy   = @p_account_id    
          GROUP BY AA.AccountID) AS AAA)    
    
--UPDATE CUSTOMER     
UPDATE Libertypower..Customer    
SET BusinessTypeID    = @w_BusinessTypeID    
 ,BusinessActivityID   = @w_BusinessActivityID     
 ,CreditAgencyID    = @w_CreditAgencyID    
 ,SsnEncrypted    = CASE WHEN @p_ssnEncrypted IS NOT NULL      
         THEN @p_ssnEncrypted      
         ELSE SSNEncrypted      
       END    
 ,CreditScoreEncrypted = CASE WHEN @p_credit_score_encrypted IS NOT NULL      
         THEN @p_credit_score_encrypted      
         ELSE CreditScoreEncrypted      
       END    
FROM Libertypower..Customer CUST WITH (NOLOCK)    
JOIN Libertypower..Account A WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID    
WHERE A.AccountIdLegacy = @p_account_id    
    
IF (LTRIM(RTRIM(@p_additional_id_nbr_type)) = 'DUNSNBR')    
BEGIN     
 UPDATE Libertypower..Customer    
 SET  Duns   = @p_additional_id_nbr    
  ,EmployerId  = ''    
  ,TaxId   = ''    
  ,SsnEncrypted = ''    
 FROM Libertypower..Customer CUST WITH (NOLOCK)    
 JOIN Libertypower..Account A WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID    
 WHERE A.AccountIdLegacy = @p_account_id    
END    
    
ELSE IF (LTRIM(RTRIM(@p_additional_id_nbr_type)) = 'EMPLID')    
BEGIN     
 UPDATE Libertypower..Customer    
 SET  EmployerId  = @p_additional_id_nbr    
  ,Duns   = ''    
  ,TaxId   = ''    
  ,SsnEncrypted = ''    
 FROM Libertypower..Customer CUST WITH (NOLOCK)    
 JOIN Libertypower..Account A WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID    
 WHERE A.AccountIdLegacy = @p_account_id    
END    
    
ELSE IF (LTRIM(RTRIM(@p_additional_id_nbr_type)) = 'TAX ID')    
BEGIN     
 UPDATE Libertypower..Customer    
 SET  TaxId   = @p_additional_id_nbr    
  ,Duns   = ''    
  ,EmployerId  = ''    
  ,SsnEncrypted = ''    
 FROM Libertypower..Customer CUST WITH (NOLOCK)    
 JOIN Libertypower..Account A WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID    
 WHERE A.AccountIdLegacy = @p_account_id    
END    
    
ELSE IF (LTRIM(RTRIM(@p_additional_id_nbr_type)) = 'SSN')    
BEGIN     
 UPDATE Libertypower..Customer    
 SET Duns   = ''    
    ,EmployerId  = ''    
    ,TaxId   = ''    
 FROM Libertypower..Customer CUST WITH (NOLOCK)    
 JOIN Libertypower..Account A WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID    
 WHERE A.AccountIdLegacy = @p_account_id    
END    
    
ELSE IF (LTRIM(RTRIM(@p_additional_id_nbr_type)) = 'NONE')    
BEGIN     
 UPDATE Libertypower..Customer    
 SET    Duns   = ''    
    ,EmployerId  = ''    
    ,TaxId   = ''    
    ,SsnEncrypted = ''     
 FROM Libertypower..Customer CUST WITH (NOLOCK)    
 JOIN Libertypower..Account A WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID    
 WHERE A.AccountIdLegacy = @p_account_id    
END    
    
    
--UPDATE USAGE    
UPDATE Libertypower..AccountUsage    
SET    AnnualUsage = @p_annual_usage    
FROM Libertypower..AccountUsage AU WITH (NOLOCK)    
JOIN Libertypower..Account A       WITH (NOLOCK) ON A.AccountID = AU.AccountID    
LEFT JOIN Libertypower..Contract C WITH (NOLOCK) ON C.ContractID = A.CurrentContractID     
          AND C.StartDate = AU.EffectiveDate    
WHERE A.AccountIdLegacy = @p_account_id    
    
--UPDATE SERVICE DATES    
 UPDATE Libertypower..AccountService        
 SET  StartDate  = @w_date_flow_start        
  ,EndDate = @w_date_deenrollment            
 WHERE AccountServiceID = (SELECT TOP 1 AccountServiceID FROM Libertypower..AccountService WITH (NOLOCK)      
         WHERE account_id = @p_account_id         
         ORDER BY StartDate DESC,EndDate DESC,AccountServiceID DESC)    
    
--UPDATE POR_ENROLLMENT DATE    
UPDATE Libertypower..AccountContract     
SET    SendEnrollmentDate = CASE WHEN @w_lead_time = 0     
         THEN @w_date_por_enrollment      
         ELSE dateadd(dd, @w_lead_time, @p_contract_eff_start_date)     
       END     
   ,RequestedStartDate = @p_requested_flow_start_date    
FROM Libertypower..AccountContract AC WITH (NOLOCK)    
JOIN Libertypower..Account A    WITH (NOLOCK) ON A.AccountID = AC.AccountID    
             AND A.CurrentContractID = AC.ContractID    
WHERE A.AccountIdLegacy = @p_account_id    
    
--UPDATE ACCOUNT DETAIL    
UPDATE Libertypower..AccountDetail    
SET    EnrollmentTypeID = @p_enrollment_type    
FROM Libertypower..AccountDetail AD WITH (NOLOCK)    
JOIN Libertypower..Account A  WITH (NOLOCK) ON A.AccountID = AD.AccountID    
WHERE A.AccountIdLegacy = @p_account_id    
    
--UPDATE AccountContractCommision    
UPDATE Libertypower..AccountContractCommission    
SET    InitialPymtOptionID = @w_initial_pymt_option_id    
   ,ResidualOptionID  = @w_residual_option_id    
   ,EvergreenOptionID = @w_evergreen_option_id    
FROM Libertypower..AccountContractCommission ACC WITH (NOLOCK)    
JOIN Libertypower..AccountContract AC WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID    
JOIN Libertypower..Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID     
             AND A.CurrentContractID = AC.ContractID    
WHERE A.AccountIdLegacy = @p_account_id    
--IT124 END     
      
if @@rowcount                                       = 0       
begin       
   if exists(select * from Libertypower..Account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx)       
   where AccountIdLegacy = @p_account_id)      
   begin      
      select @w_error                               = 'E',       
             @w_msg_id                              = '00000003',       
             @w_return                              = 1      
   end      
   else      
   begin      
      select @w_error                               = 'E',       
             @w_msg_id                              = '00000004',       
             @w_return                              = 1      
   end      
   goto goto_select       
end       
      
-- 1-56646248      
-- insert payment term record if one does not exist      
INSERT INTO AccountPaymentTerm      
select a.AccountIdLegacy, @p_paymentTerm, GETDATE()      
from libertypower..account    a (nolock)      
join libertypower..[contract] c (nolock) on a.currentcontractid = c.contractid      
where c.number = @p_contract_nbr      
and a.AccountIdLegacy not in      
(      
 select apt.accountId      
 from lp_account..AccountPaymentTerm apt (nolock)      
 join libertypower..account    a (nolock) on a.AccountIdLegacy = apt.accountid      
 join libertypower..[contract] c (nolock) on a.currentcontractid = c.contractid      
 where c.number = @p_contract_nbr      
)      
      
-- Begin of PBI 41637 - Diogo Lima  
DECLARE @w_PaymentTerm int  
SELECT @w_PaymentTerm = up.ARTerms from LibertyPower.dbo.UtilityPaymentTerms up WITH (NOLOCK)   WHERE up.MarketId = @w_RetailMktID      
      AND (up.UtilityId = @w_UtilityID OR up.UtilityId = 0)       
      AND (up.BillingTypeID = @w_BillingTypeID       
                        OR (up.BillingTypeID IS NULL AND NOT EXISTS       
                                    (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms ut WITH (NOLOCK)      
                                     WHERE ut.utilityid    = up.utilityid      
                  and ut.marketid       = up.marketid      
                                                and ut.BillingTypeID = @w_BillingTypeID      
                                    )    
                              )    
              )      
      AND (up.AccountTypeID = @w_AccountTypeID       
           OR (up.AccountTypeID IS NULL AND NOT EXISTS     
                                    (SELECT 1 FROM LibertyPower.dbo.UtilityPaymentTerms uta WITH (NOLOCK)      
                   WHERE uta.utilityid = up.utilityid      
                   and uta.marketid = up.marketid      
                                      and uta.AccountTypeID   = @w_AccountTypeID)    
                     )    
                  )  
if @w_PaymentTerm <> @p_paymentTerm    
begin  
--ticket 8139 - update payment term      
--SR1-25299925 --update payment term for the whole contract      
 update AccountPaymentTerm       
 set paymentTerm = @p_paymentTerm      
 from lp_account..AccountPaymentTerm apt WITH (NOLOCK)     
 join libertypower..account    a (nolock) on a.AccountIdLegacy = apt.accountid      
 join libertypower..[contract] c (nolock) on a.currentcontractid = c.contractid      
 where c.number = @p_contract_nbr      
end  
--end of PBI 41637 - Diogo Lima     
      
-- Update any account's usage that has been added to a renewal      
--update account_renewal set annual_usage = @p_annual_usage  --1-187289441    
--where account_id                                    = @p_account_id      
      
-- We remove the DB relationships that the account has and insert the one that was just saved.      
delete from account_deutsche_link       
where account_id                                    = @p_account_id      
insert into account_deutsche_link (account_id, deutsche_bank_group_id)       
values (@p_account_id, @p_db_group_id)      
      
-- ticket 15504      
-- Insert or update 'account tax detail'      
--if @p_tax_type_id <> 0       
-- begin      
-- ticket 20278       
-- ticket 20582        
if @p_percent_taxable1 <> ''      
begin      
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id1, @p_percent_taxable1, @p_account_id      
end      
if @p_percent_taxable2 <> ''      
begin      
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id2, @p_percent_taxable2, @p_account_id      
end      
if @p_percent_taxable3 <> ''      
begin       
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id3, @p_percent_taxable3, @p_account_id      
end      
if @p_percent_taxable4 <> ''      
begin       
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id4, @p_percent_taxable4, @p_account_id      
end      
if @p_percent_taxable5 <> ''      
begin       
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id5, @p_percent_taxable5, @p_account_id      
end      
if @p_percent_taxable6 <> ''      
begin       
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id6, @p_percent_taxable6, @p_account_id      
end      
if @p_percent_taxable7 <> ''      
begin       
 exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id7, @p_percent_taxable7, @p_account_id      
end      
--end      

--BEGIN TFS 42728 7/9/2014
SELECT @w_CreditInsured = IsCreditInsured
FROM Libertypower..AccountCreditInsurance WITH (NOLOCK)
WHERE AccountContractID = @w_AccountContractID

IF @w_CreditInsured <> @p_CreditInsured 
BEGIN
	IF 	EXISTS (
			SELECT 1 FROM lp_enrollment..check_account WITH (NOLOCK)
			WHERE contract_nbr = @p_contract_nbr 
			AND check_type = 'Credit Check' AND approval_status IN ('PENDING', 'PENDINGSYS', 'ON HOLD')
			)
		BEGIN
			 set @w_error   = 'E'      
			 set @w_msg_id   = '00001080'      
			 set @w_descp_add  = '. This flag cannot be modified until credit decision has been set in Credit Check queue. Please complete this step prior to making an update.'    
			 goto goto_select 
		END
	ELSE IF @w_CreditInsured = 0 AND @p_CreditInsured = 1 
		AND EXISTS (
			SELECT 1 FROM lp_enrollment..check_account WITH (NOLOCK)
			WHERE contract_nbr = @p_contract_nbr 
			AND check_type = 'Credit Check' AND approval_status IN ('APPROVED', 'REJECTED'))
			BEGIN
				 set @w_error   = 'E'      
				 set @w_msg_id   = '00001080'      
				 set @w_descp_add  = '. This account cannot qualify for Credit Insurance if it has been declined through the LP credit check. Please review the Credit Check queue.'    
				 goto goto_select 
			END
	ELSE
	BEGIN
		EXEC [Libertypower].[dbo].[usp_CreditInsuranceInsertUpdate] @p_CreditInsured, @p_contract_nbr, @p_username
	END
END
--END TFS 42728 

       
-- Ticket 20866        
-- Added this line since we shouldnt have multiple of these records if they are the same     
IF (@w_date_flow_start IS NOT NULL) AND NOT EXISTS (SELECT * FROM LibertyPower..AccountService WITH (NOLOCK)     
             WHERE account_id = @p_account_id     
             AND StartDate = @w_date_flow_start     
             AND ((EndDate = @w_date_deenrollment) OR (EndDate IS NULL)))      
 INSERT INTO LibertyPower..AccountService (account_id, StartDate, EndDate) VALUES (@p_account_id,@w_date_flow_start,@w_date_deenrollment)       
       
select @w_return = 0      
    
      
goto_select:      
      
if @w_error <> 'N'      
begin      
   exec lp_common..usp_messages_sel @w_msg_id,       
                                    @w_descp output,       
                                    @w_application      
      
   select @w_descp                                  = ltrim(rtrim(@w_descp))       
                                                    + ' '       
                                                    + @w_descp_add       
end      
       
if @p_result_ind                                    = 'Y'      
begin      
   select flag_error                                = @w_error,       
          code_error                                = @w_msg_id,       
          message_error                             = @w_descp      
   goto goto_return      
end      
      
      
select @p_error                                      = @w_error,       
       @p_msg_id									 = @w_msg_id,       
       @p_descp                                      = @w_descp      
       
goto_return:      
return @w_return      
    
 SET NOCOUNT OFF    
    
END 

