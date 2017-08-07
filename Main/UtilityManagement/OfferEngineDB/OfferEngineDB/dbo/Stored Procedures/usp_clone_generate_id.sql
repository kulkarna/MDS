

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_generate_id]

@p_key_type	varchar(50),
@p_new_id	varchar(50) output

AS

DECLARE	@w_last_number	int,
		@w_prefix		varchar(20)

SELECT	@w_last_number	= last_number, @w_prefix = prefix
FROM	OE_KEYS WITH (NOLOCK)
WHERE	key_type		= @p_key_type

SET		@w_last_number	= @w_last_number + 1
SET		@p_new_id		= @w_prefix + CAST(@w_last_number AS varchar(20))

UPDATE	OE_KEYS
SET		last_number		= @w_last_number
WHERE	key_type		= @p_key_type
