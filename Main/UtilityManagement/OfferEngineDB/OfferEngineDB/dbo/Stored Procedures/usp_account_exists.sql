
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/1/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_account_exists]

@p_account_number		varchar(50)

AS

IF EXISTS (	SELECT	NULL
			FROM	OE_ACCOUNT WITH (NOLOCK)
			WHERE	ACCOUNT_NUMBER = @p_account_number )
	SELECT	'TRUE'
ELSE
	SELECT	'FALSE'

