


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/16/2007
-- Description:	Self-explanatory
-- =============================================
CREATE PROCEDURE [dbo].[usp_print_contract_multi_ins]

@p_request_id				varchar(20),
@p_utility_id				char(15),
@p_utility_descp			varchar(50),
@p_product_id				char(20),
@p_product_descp			varchar(50),
@p_rate_id					int,
@p_rate						float,
@p_rate_descp				varchar(50)

AS

DECLARE @w_contract_nbr		char(12)

DECLARE cur CURSOR FOR

	SELECT 
		contract_nbr
	FROM
		deal_contract_print
	WHERE
		request_id = @p_request_id

OPEN cur 

FETCH NEXT FROM cur INTO @w_contract_nbr

WHILE (@@FETCH_STATUS <> -1) 
	BEGIN 
		
		INSERT INTO
			multi_rates
		SELECT
			@w_contract_nbr, @p_utility_id, @p_utility_descp, @p_product_id, @p_product_descp, @p_rate_id, @p_rate, @p_rate_descp

		FETCH NEXT FROM cur INTO @w_contract_nbr
	END

CLOSE cur 
DEALLOCATE cur 



