USE LibertyPower 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PropertyInternalRefByExtValueSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_PropertyInternalRefByExtValueSelect]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================
-- Author:  CGHAZAL    
-- Create date: 4/5/2013    
-- Description: Get the internal Reference value for a give external value
-- ========================================================================
-- exec LibertyPower..usp_PropertyInternalRefByExtValueSelect 1 , 8, 'J' , 1
-- =======================================================================
CREATE	PROCEDURE	usp_PropertyInternalRefByExtValueSelect
	@PropertyID AS INT,
	@ExternalEntityID AS INT,
	@ExternalValue AS VARCHAR(100)
	, @IncludeInactive bit = 0 
AS

BEGIN

SET NOCOUNT ON;    

	SELECT	pir.*
	FROM	/*LibertyPowerUat..PropertyType pt (NOLOCK) 
	INNER	JOIN */LibertyPower..PropertyInternalRef pir (NOLOCK) 
	--ON		pt.ID = pir.PropertyTypeID
	--AND		pt.PropertyID = pir.PropertyID
	INNER	JOIN LibertyPower..PropertyValue pv (NOLOCK) 
	ON		pir.ID = pv.InternalRefID
	INNER	JOIN LibertyPower..ExternalEntityValue eev (NOLOCK) 
	ON		eev.PropertyValueID = pv.ID
	--AND		eev.Inactive = 0 
	WHERE	pir.PropertyID = @PropertyID
	AND		pv.Value = @ExternalValue
	AND		eeV.ExternalEntityID = @ExternalEntityID
	
	AND (eev.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
	AND (pv.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
	AND (pir.Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
		
SET NOCOUNT OFF;

END