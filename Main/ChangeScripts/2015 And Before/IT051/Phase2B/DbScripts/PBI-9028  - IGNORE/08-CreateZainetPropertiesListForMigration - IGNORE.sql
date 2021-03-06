Use Libertypower
GO

	SELECT	pir.ID, pir.Value as InternalValue, pv.Value as ZainetValue
	INTO	Properties
	FROM	LibertyPower..PropertyType pt (NOLOCK) 
	INNER	JOIN LibertyPower..PropertyInternalRef pir (NOLOCK) 
	ON		pt.ID = pir.PropertyTypeID
	AND		pt.PropertyID = pir.PropertyID
	INNER	JOIN LibertyPower..PropertyValue pv (NOLOCK) 
	ON		pir.ID = pv.InternalRefID
	INNER	JOIN LibertyPower..ExternalEntityValue eev (NOLOCK) 
	ON		eev.PropertyValueID = pv.ID
	--AND		eev.Inactive = 0 
	WHERE	pt.PropertyID = 1
	--AND		pv.Value = @ExternalValue
	AND		eeV.ExternalEntityID = 9
	
	AND (eev.Inactive = 0)
	AND (pv.Inactive = 0 )
	AND (pir.Inactive = 0 )
