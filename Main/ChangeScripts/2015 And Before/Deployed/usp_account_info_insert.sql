USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_info_insert]    Script Date: 05/14/2012 17:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_account_info_insert]
(
 @p_account_id                                      char(12),
 @p_utility_id                                      char(15),
 @p_customer_code                                   char(50) = '',
 @p_date_created                                    datetime,
 @p_billing_account                                 char(50) = ''
)
as


insert into lp_account..account_info
          ([account_id]
           ,[utility_id]
           ,[name_key]
           ,[BillingAccount]
           ,[Created]
           ,[CreatedBy]
           ,[MeterDataMgmtAgent]
           ,[MeterServiceProvider]
           ,[MeterInstaller]
           ,[MeterReader]
           ,[MeterOwner]
           ,[SchedulingCoordinator])
	  select @p_account_id,
			 @p_utility_id,
			 @p_customer_code,
			 @p_billing_account,
			 @p_date_created
			 ,suser_sname()
			 ,null
			 ,null
			 ,null
			 ,null
			 ,null
			 ,null