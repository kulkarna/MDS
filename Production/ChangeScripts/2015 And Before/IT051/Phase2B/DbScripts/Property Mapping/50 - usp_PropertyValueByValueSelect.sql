USE LibertyPower 
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyValueByValueSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyValueByValueSelect]
GO


-- =============================================    
-- Author:  Gail Mangaroo    
-- Create date: 4/5/2013    
-- Description: Get the Target Value for the specified Externanl Entity    
-- =============================================   
-- exec LibertyPower..[usp_PropertyValueByValueSelect] 'AECO' , 1, null , null , null , 0
-- ============================================= 
CREATE PROCEDURE [dbo].[usp_PropertyValueByValueSelect]
(
@srcValue varchar(100) 
, @propertyId int  = null
, @propertyTypeId int = null

, @srcEntityId int = null 
, @trgtEntityId int = null
, @IncludeInactive bit = 0 
)
AS 
BEGIN 

	SET NOCOUNT ON;		
	
	Select DISTINCT tgtPV.* 
	FROM LibertyPower..PropertyInternalRef pir  (NOLOCK) 
		JOIN LibertyPower..PropertyValue srcPV (NOLOCK)  on srcPV.InternalRefID = pir.ID 
		JOIN LibertyPower..ExternalEntityValue srcEV  (NOLOCK) on srcEV.PropertyValueID = srcPV.ID  
		
		JOIN LibertyPower..PropertyValue tgtPV (NOLOCK)  on tgtPV.InternalRefID = pir.ID 
		JOIN LibertyPower..ExternalEntityValue tgtEV (NOLOCK)  on tgtEV.PropertyValueID = tgtPV.ID  
				
	WHERE srcPV.Value = @srcValue
		AND srcPV.PropertyId = ISNULL ( @propertyId, srcPV.PropertyId ) 
		AND ISNULL(srcPV.PropertyTypeId, 0) = ISNULL(@propertytypeId , ISNULL(srcPV.PropertyTypeId, 0) ) 
		
		AND srcEv.ExternalEntityID = ISNULL ( @srcEntityId , srcEv.ExternalEntityID ) 
		AND tgtEV.ExternalEntityID = ISNULL( @trgtEntityId , tgtEV.ExternalEntityID ) 

		--AND srcEV.Inactive = 0 
		--AND tgtEV.Inactive = 0 
		--AND srcPV.Inactive = 0 
		--and tgtPV.Inactive = 0 
		
		AND (srcEV.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (tgtEV.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (srcPV.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		AND (tgtPV.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated

	SET NOCOUNT OFF;		
	
END 
GO 