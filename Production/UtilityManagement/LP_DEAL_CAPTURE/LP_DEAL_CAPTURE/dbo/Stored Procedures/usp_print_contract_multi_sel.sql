

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/16/2007
-- Description:	Select multi-rates
-- =============================================
-- Modified By Gail Mangaroo	
-- Modified 3/12/2008
-- Added Contract_rate_type field
-- ============================================
CREATE PROCEDURE [dbo].[usp_print_contract_multi_sel] 

@p_contract_nbr		char(12)

AS

SELECT
	r.utility_id, r.utility_descp, r.product_id, r.product_descp, r.rate_id, r.rate, r.rate_descp
	,d.contract_rate_type
FROM
	multi_rates r 
	LEFT OUTER JOIN deal_contract_print d ON r.contract_nbr = d.contract_nbr 
WHERE
	r.contract_nbr = @p_contract_nbr


