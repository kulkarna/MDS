

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	04/24/2012																		*
 *	Descp:		Get the zone value from the zone table in common table for the text specified	*
 *	Modified:																					*
 ********************************************************************************************** */

CREATE	PROCEDURE	usp_ZoneMappingSelect
		@UtilityID	AS INT,
		@Text		AS nchar(50)

AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	TOP 1 
			c.Zone
	FROM	ZoneMapping m (nolock)
	INNER	JOIN lp_common..zone c (nolock)
	ON		m.ZoneID = c.zone_id
	WHERE	m.Text		= @TEXT
	AND		m.UtilityID = @UtilityID

	SET NOCOUNT OFF;
END

