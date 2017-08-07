/*******************************************************************************
 * usp_EflContractDataSelect
 * Gets data neccessary to create EFL
 *
 * History
 *******************************************************************************
 * 8/10/2009 - Rick Deigsler
 * Created.
 *
 * History
 * 2/15/2010 - Rick Deigsler
 * Added fields needed for MCPE products
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflContractDataSelect]
	@ContractNumber	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF (	SELECT	COUNT(utility_id) 
			FROM	lp_account..account WITH (NOLOCK) 
			WHERE	contract_nbr = @ContractNumber ) > 0
		BEGIN -- new deal
			SELECT	DISTINCT a.retail_mkt_id AS MarketCode, a.utility_id AS UtilityCode, a.product_id AS ProductId,  
					a.term_months AS Term, rate AS Rate, a.account_type AS AccountType, a.sales_channel_role AS SalesChannelRole, 
					CAST(CAST(DATEPART(mm, a.date_deal) AS varchar(2)) + '/' + CAST(DATEPART(dd, a.date_deal) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, a.date_deal) AS varchar(4)) AS datetime) AS DealDate,
					product_category AS ProductCategory, product_sub_category AS ProductSubCategory,
					contract_eff_start_date AS ContractStartDate, IsCustom
			FROM	lp_account..account a WITH (NOLOCK)
					INNER JOIN lp_common..common_product p WITH (NOLOCK) ON a.product_id = p.product_id
			WHERE	contract_nbr = @ContractNumber
			ORDER BY a.term_months, a.utility_id
		END
	ELSE	
		BEGIN -- renewal
			SELECT	DISTINCT a.retail_mkt_id AS MarketCode, a.utility_id AS UtilityCode, a.product_id AS ProductId,  
					a.term_months AS Term, rate AS Rate, a.account_type AS AccountType, a.sales_channel_role AS SalesChannelRole, 
					CAST(CAST(DATEPART(mm, a.date_deal) AS varchar(2)) + '/' + CAST(DATEPART(dd, a.date_deal) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, a.date_deal) AS varchar(4)) AS datetime) AS DealDate,
					product_category AS ProductCategory, product_sub_category AS ProductSubCategory,
					contract_eff_start_date AS ContractStartDate, IsCustom
			FROM	lp_account..account_renewal a WITH (NOLOCK)
					INNER JOIN lp_common..common_product p WITH (NOLOCK) ON a.product_id = p.product_id
			WHERE	contract_nbr = @ContractNumber
			ORDER BY a.term_months, a.utility_id	
		END
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
