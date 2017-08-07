-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 1/28/2013
-- Description:	select records corresponding @ContractNmbr
-- =============================================
CREATE PROCEDURE dbo.usp_deal_contract_sel
(
	@ContractNmbr char(12)
)
AS
BEGIN

SET NOCOUNT ON;

SELECT [contract_nbr]
      ,[contract_type]
      ,[status]
      ,[retail_mkt_id]
      ,[utility_id]
      ,[account_type]
      ,[product_id]
      ,[rate_id]
      ,[rate]
      ,[customer_name_link]
      ,[customer_address_link]
      ,[customer_contact_link]
      ,[billing_address_link]
      ,[billing_contact_link]
      ,[owner_name_link]
      ,[service_address_link]
      ,[business_type]
      ,[business_activity]
      ,[additional_id_nbr_type]
      ,[additional_id_nbr]
      ,[contract_eff_start_date]
      ,[term_months]
      ,[date_end]
      ,[date_deal]
      ,[date_created]
      ,[date_submit]
      ,[sales_channel_role]
      ,[username]
      ,[sales_rep]
      ,[origin]
      ,[anual_usage]
      ,[grace_period]
      ,[chgstamp]
      ,[renew]
      ,[original_contract_nbr]
      ,[SSNClear]
      ,[SSNEncrypted]
      ,[CreditScoreEncrypted]
      ,[HeatIndexSourceID]
      ,[HeatRate]
      ,[evergreen_option_id]
      ,[evergreen_commission_end]
      ,[residual_option_id]
      ,[residual_commission_end]
      ,[initial_pymt_option_id]
      ,[sales_manager]
      ,[evergreen_commission_rate]
      ,[PriceID]
      ,[PriceTier]
      , RatesString
  FROM [lp_contract_renewal].[dbo].[deal_contract]
  WHERE Contract_nbr=@ContractNmbr
END
GO
