
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/8/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_account_name_key_sel]

@p_account_number		varchar(50)

AS

SELECT	TOP 1 NAME_KEY
FROM	OE_ACCOUNT WITH (NOLOCK)
WHERE	ACCOUNT_NUMBER = @p_account_number
AND		NAME_KEY IS NOT NULL
AND		LEN(NAME_KEY) > 0
ORDER BY ID DESC

