-- =============================================
-- Author:		Rick Deigsler
-- Create date: 10/23/2007
-- Description:	Get highest contract number for sales channel and market
-- =============================================
CREATE PROCEDURE [dbo].[usp_preprinted_contract_nbr_high_sel]
@p_username				varchar(100),
@p_retail_mkt_id		char(2)

AS

DECLARE	@w_contract_nbr			int,
		@w_request_id			varchar(20),
		@w_contract_nbr_prefix	varchar(20)


SET		@w_contract_nbr_prefix	=	UPPER(@p_retail_mkt_id + CAST(RIGHT(DATEPART(yy, GETDATE()), 2) AS varchar(2)) + '-'
									+ substring(@p_username, 15, len(@p_username) - 14))

SELECT		TOP 1 RIGHT(contract_nbr, 4) AS Nbr 
FROM		deal_contract_print		
WHERE		contract_nbr LIKE '%' + @w_contract_nbr_prefix + '%'
ORDER BY	Nbr DESC
