﻿-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/26/2013
-- Description:	Get External References
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityByIdSelect] 34
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityByIdSelect]
	@Id int = null
--	, @IncludeInactive bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  *     
	FROM LibertyPower..vw_ExternalEntity (NOLOCK) 
	WHERE 1 =1 
		AND ID = ISNULL(@Id, ID)
--		AND (Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

END