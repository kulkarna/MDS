USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_info_update]    Script Date: 05/14/2012 18:16:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_account_info_update]
(
 @p_account_id                                      char(12),
 @p_utility_id                                      char(15),
 @p_customer_code                                   char(50) = '',
 @p_billing_account                                 char(50) = '')
as


update lp_account..account_info
			set utility_id			= @p_utility_id
				,name_key			= @p_customer_code
				,billingaccount    = @p_billing_account 
			where account_id		= @p_account_id