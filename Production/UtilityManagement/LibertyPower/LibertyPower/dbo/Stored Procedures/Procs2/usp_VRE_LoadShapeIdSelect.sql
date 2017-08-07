
CREATE PROCEDURE [dbo].[usp_VRE_LoadShapeIdSelect]
AS
BEGIN
			SELECT  utility_id, rate_class_lpc, load_shape_id, StratumVariable  from lp_historical_info..UtilityEDIMapping a WHERE a.load_shape_id IS NOT NULL
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_LoadShapeIdSelect';

