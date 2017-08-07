-- =============================================
-- Author:		<Author,,Name>
-- Create date: 5/30/2007
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_account_meters_sel_by_account_number]

@p_account_number	varchar(30)

AS

SELECT	m.meter_number
FROM	account_meters m
		INNER JOIN deal_contract_account a WITH (NOLOCK) ON m.account_id = a.account_id
WHERE	a.account_number = @p_account_number
--ORDER BY m.meter_number ASC