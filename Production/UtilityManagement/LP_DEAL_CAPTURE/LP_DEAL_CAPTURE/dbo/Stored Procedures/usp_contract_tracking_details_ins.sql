﻿
CREATE procedure [dbo].[usp_contract_tracking_details_ins]
(@p_username                                        nchar(100),
 @p_transaction_id                                  varchar(50),
 @p_account_number                                  varchar(30),
 @p_account_name                                    varchar(100),
 @p_retail_mkt_id                                   char(02),
 @p_utility_id                                      char(15),
 @p_entity_id                                       char(15),
 @p_product_id                                      char(20),
 @p_rate_id                                         int,
 @p_rate                                            float,
 @p_por_option                                      varchar(03),
 @p_account_type                                    varchar(25),
 @p_business_activity                               varchar(35),
 @p_customer_id                                     varchar(10),
 @p_contract_type                                   varchar(25),
 @p_contract_nbr                                    char(12),
 @p_sales_rep                                       varchar(100),
 @p_sales_channel_role                              nvarchar(50),
 @p_eff_start_date                                  datetime,
 @p_end_date                                        datetime,
 @p_term_months                                     int,
 @p_deal_date                                       datetime,
 @p_submit_date                                     datetime,
 @p_flow_start_date                                 datetime,
 @p_enrollment_type                                 int,
 @p_tax_status                                      varchar(20),
 @p_tax_float                                       int = 0,
 @p_annual_usage                                    int,
 @p_date_created                                    datetime,
 @p_service_address                                 char(50),
 @p_service_suite                                   char(50),
 @p_service_city                                    char(50),
 @p_service_state                                   char(02),
 @p_service_zip                                     char(10),
 @p_billing_address                                 char(50),
 @p_billing_suite                                   char(50),
 @p_billing_city                                    char(50),
 @p_billing_state                                   char(02),
 @p_billing_zip                                     char(10),
 @p_origin                                          varchar(15),
 @p_status                                          varchar(15))
as

/*
insert contract_tracking_details
select @p_transaction_id,
       @p_account_number,
       @p_account_name,
       @p_retail_mkt_id,
       @p_utility_id,
       @p_entity_id,
       @p_product_id,
       @p_rate_id,
       @p_rate,
       @p_por_option,
       @p_account_type,
       @p_business_activity,
       @p_customer_id,
       @p_contract_type,
       @p_contract_nbr,
       @p_sales_rep,
       @p_sales_channel_role,
       @p_eff_start_date,
       @p_end_date,
       @p_term_months,
       @p_deal_date,
       @p_submit_date,
       @p_flow_start_date,
       @p_enrollment_type,
       @p_tax_status,
       @p_tax_float,
       @p_annual_usage,
       @p_date_created,
       @p_service_address,
       @p_service_suite,
       @p_service_city,
       @p_service_state,
       @p_service_zip,
       @p_billing_address,
       @p_billing_suite,
       @p_billing_city,
       @p_billing_state,
       @p_billing_zip,
       @p_origin,
       @p_status

*/


