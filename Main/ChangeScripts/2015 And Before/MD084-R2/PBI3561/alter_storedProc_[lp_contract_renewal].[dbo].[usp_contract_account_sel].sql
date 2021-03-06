USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_account_sel]    Script Date: 01/28/2013 17:24:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------
/*
alter by Lev Rosenblum
Date: 1/29/2010
description: Rate and RatesString has been added to output
*/
---------------------------------------------------------

ALTER procedure [dbo].[usp_contract_account_sel]
(
	@p_account_number                  varchar(30),
	@p_contract_nbr                    char(12)
 )
as

Select
		contract_nbr
		, contract_type
		, account_number
		, sales_channel_role
		, evergreen_option_id 
		, evergreen_commission_end 
		, residual_option_id 
		, residual_commission_end 
		, initial_pymt_option_id  
		, evergreen_commission_rate
		, rate
		, RatesString 
   
From deal_contract_account with (NOLOCK)
Where contract_nbr = @p_contract_nbr
And account_number = @p_account_number



