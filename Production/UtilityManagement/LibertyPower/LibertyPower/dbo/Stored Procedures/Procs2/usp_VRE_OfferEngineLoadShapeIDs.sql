
CREATE PROCEDURE [dbo].[usp_VRE_OfferEngineLoadShapeIDs]	
AS
BEGIN
    SET NOCOUNT ON;
	
	SELECT  UTILITY as UtilityCode, ACCOUNT_NUMBER as AccountNumber, LOAD_SHAPE_ID as LoadShapeId FROM OfferEngineDB..OE_ACCOUNT WITH (NOLOCK)			
	
	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power







GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_OfferEngineLoadShapeIDs';

