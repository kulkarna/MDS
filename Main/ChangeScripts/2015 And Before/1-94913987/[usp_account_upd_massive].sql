USE [lp_account]

GO 

-- ========================================================  
-- Agata Studzinska
-- Modified date: 2013-08-01  
-- Description: Included update of the Billing Phone Number
-- SR1-94913987 
-- ======================================================== 
  
ALTER procedure [dbo].[usp_account_upd_massive]  
(@p_account_id          varchar(12), --account  
 --@p_account_name         varchar(100),--account_name  
 @p_customer_id                                     varchar(10) = 0, --account  
 --Comments (call the usp_accounts_comments_ins)  
 --Note (call the usp_accounts_comments_ins)  
 @p_billing_account_number       varchar(50) = '', --account_info  
 @p_account_type         varchar(35) = '0', --account  
 @p_account_rate         float = 0,  --account  
 @p_product_id          varchar(20) = '', --account  
 @p_account_rate_id         int = 0,  --account  
 @p_send_enrollment_after_date      datetime = '19000101',  --account  
 @p_billing_type         varchar(15) = '0', --account  
 @p_sales_channel         nvarchar(50) = '0',--account  
 @p_sales_rep          varchar(100) = '',  --account  
 @p_deal_date          datetime = '19000101', --account  
 @p_tax_status          varchar(20) = '0', --account  
   
   
 --@p_address           varchar(50), --account_address  
 --@p_suite                varchar(10), --account_address  
 --@p_city                              varchar(28), --account_address  
 --@p_state           varchar(2) = '0',  --account_address  
 --@p_zip                  varchar(10), --account_address  
 --@p_county               varchar(10), --account_address  
 --@p_state_fips          varchar(2),  --account_address  
 --@p_county_fips          varchar(3),  --account_address   
   
 @p_credit_score         real = 0,  --account  
 @p_credit_agency         varchar(30) = '', --account  
 @p_first_contact_name        varchar(50) = '', --account_contact  
 @p_last_contact_name        varchar(50) = '', --account_contact  
 @p_phone            varchar(20) = '',  --account_contact 
 
 @p_billing_phone	varchar(20) = '', --account_billing_contact
   
 @p_business_type         varchar(35) = '0', --account  
 @p_enrollment_type         int   = 0, --account  
 @p_fax            varchar(20) = '', --account_contact  
 @p_email           nvarchar(512) = '', --account_contact  
 @p_eff_start_date         datetime = '19000101', --account  
   
 @p_username                                        nchar(100)  = ''  
)  
as  
   
 set nocount on  
 declare @error   int  
   
 set @error = 0  
  
 begin tran  
  
-- 1. Account name   
 --update Account_Name  
 --set full_name  = case when @p_account_name  <> '' then @p_account_name else full_name end    
 --where account_id = @p_account_id  
   
 --if @@error <> 0   
 --begin  
 -- set @error = @@error  
 -- goto exitProcess  
 --end   
   
 -- 5. Billing Account Number  
 update Account_Info  
 set BillingAccount = case when @p_billing_account_number  <> '' then @p_billing_account_number else BillingAccount end    
 where account_id = @p_account_id  
   
 if @@error <> 0   
 begin  
  set @error = @@error  
  goto exitProcess  
 end   
   
-- 2. Customer id  
-- 6. Account type   
-- 7. Account rate   
-- 8. Product   
-- 9. Rate ID   
-- 10. Send enrollment after date   
-- 11. Billing type   
-- 12. sales channel   
-- 13. sales rep   
-- 14. tax status   
-- 16. Credit Score   
-- 17. Credit Agency  
 update Account  
 set customer_id  = case when @p_customer_id  <> 0 then @p_customer_id else customer_id end,  
  account_type = case when @p_account_type  <> '0' then @p_account_type else account_type end,  
  rate   = case when @p_account_rate  <> 0 then @p_account_rate else rate end,  
  product_id  = case when @p_product_id  <> '' then @p_product_id else product_id end,  
  rate_id   = case when @p_account_rate_id  <> 0 then @p_account_rate_id else rate_id end,   
  date_por_enrollment = case when @p_send_enrollment_after_date <> '19000101' then @p_send_enrollment_after_date else date_por_enrollment end,     
  billing_type = case when @p_billing_type <> '0' then @p_billing_type else billing_type end,     
  sales_channel_role = case when @p_sales_channel <> '0' then @p_sales_channel else sales_channel_role end,    
  sales_rep  = case when @p_sales_rep <> '' then @p_sales_rep else sales_rep end,    
  date_deal  = case when @p_deal_date <> '19000101' then @p_deal_date else date_deal end,     
  tax_status  = case when @p_tax_status <> '0' then @p_tax_status else tax_status end,    
  --credit_score = case when @p_suite <> 0 then @p_suite else credit_score end,      
  credit_agency = case when @p_credit_agency <> '' then @p_credit_agency else credit_agency end,  
  contract_eff_start_date = case when @p_eff_start_date <> '19000101' then @p_eff_start_date else contract_eff_start_date end,  
  business_type = case when @p_business_type  <> '0' then @p_business_type else business_type end,  
  enrollment_type = case when @p_enrollment_type  <> 0 then @p_enrollment_type else enrollment_type end,  
  ModifiedBy  = @p_username  
 where account_id = @p_account_id  
   
 if @@error <> 0   
 begin  
  set @error = @@error  
  goto exitProcess  
 end   
   
-- 15. Billing address (all fields)   
 --update Account_Address   
 --set [address]  = case when @p_address  <> '' then @p_address else [address] end,  
 -- suite   = case when @p_suite <> '' then @p_suite else suite end,  
 -- city   = case when @p_city <> '' then @p_city else city end,  
 -- [state]   = case when @p_state <> '0' then @p_state else [state] end,  
 -- zip    = case when @p_zip <> '' then @p_zip else zip end  
 -- --county   = case when @p_county <> '' then @p_county else county end,  
 -- --state_fips  = case when @p_state_fips <> '' then @p_state_fips else state_fips end,  
 -- --county_fips  = case when @p_county_fips <> '' then @p_county_fips else county_fips end  
 --where account_id = @p_account_id  
   
 --if @@error <> 0   
 --begin  
 -- set @error = @@error  
 -- goto exitProcess  
 --end   
    
-- 18. Contact name   
-- 19. Telephone number  
 update Account_Contact  
 set first_name  = case when @p_first_contact_name  <> '' then @p_first_contact_name else first_name end,  
  last_name  = case when @p_last_contact_name <> '' then @p_last_contact_name else last_name end,    
  phone   = case when @p_phone <> '' then @p_phone else phone end,  
  fax   = case when @p_fax <> '' then @p_fax else fax end,  
  email   = case when @p_email <> '' then @p_email else email end  
 where account_id = @p_account_id  
 
 if @@error <> 0   
 begin  
  set @error = @@error  
  goto exitProcess  
 end  
 
 --Billing phone number
 UPDATE Account_Billing_Contact
 SET phone  = case when @p_billing_phone <> '' then @p_billing_phone else phone end
 WHERE account_id = @p_account_id
	if @@error <> 0  
 begin  
  set @error = @@error  
  goto exitProcess  
 end   
  
  
exitProcess:  
if @error = 0  
begin
 commit tran  
 select 'Process sucessful'
end
else  
begin
 select ERROR_MESSAGE()
 rollback tran  
end
   
  
set nocount off  

  
  
  
  
  
  
  