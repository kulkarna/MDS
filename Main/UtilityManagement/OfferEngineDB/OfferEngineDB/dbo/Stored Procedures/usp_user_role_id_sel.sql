
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/16/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_user_role_id_sel]

@p_username		varchar(50)

AS

SELECT	ROL_ID
FROM	AD_USER WITH (NOLOCK)
WHERE	USERNAME = @p_username

