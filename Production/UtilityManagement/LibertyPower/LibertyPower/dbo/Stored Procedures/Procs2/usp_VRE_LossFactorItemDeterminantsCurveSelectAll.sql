
CREATE PROCEDURE [dbo].[usp_VRE_LossFactorItemDeterminantsCurveSelectAll]
	@ContextDate	DATETIME = NULL
AS

Begin
	SET NOCOUNT ON;
	
	SELECT 
	       ID
	      ,UtilityCode
		  ,ServiceClass
		  ,ZoneID 
		  ,Voltage
		  ,LossFactorId
		  ,FileContextGuid
		  ,DateCreated
		  ,CreatedBy
	FROM  VRELossFactorItemDeterminantsCurve 
	WHERE ID IN
	(SELECT MAX(ID)
	FROM VRELossFactorItemDeterminantsCurve a WITH (NOLOCK)
	WHERE	(@ContextDate IS NULL OR a.DateCreated < @ContextDate)
	GROUP BY a.ID, a.UtilityCode, a.Voltage, a.ServiceClass
	)
		
	SET NOCOUNT OFF;
	
End



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_LossFactorItemDeterminantsCurveSelectAll';

