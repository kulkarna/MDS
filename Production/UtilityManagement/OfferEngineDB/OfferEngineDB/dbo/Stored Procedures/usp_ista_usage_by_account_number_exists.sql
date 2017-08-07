

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/9/2008
-- Description:	Check if usage exists in ISTA database for account number
-- =============================================
CREATE PROCEDURE [dbo].[usp_ista_usage_by_account_number_exists]

@p_account_number	varchar(50)

AS

IF(	SELECT	COUNT(Quantity)
	FROM	ISTA..Usage WITH (NOLOCK)  
	WHERE	AccountNumber = @p_account_number
) > 0
	BEGIN
		SELECT 'TRUE'
	END
ELSE
	BEGIN
		SELECT 'FALSE'
	END


