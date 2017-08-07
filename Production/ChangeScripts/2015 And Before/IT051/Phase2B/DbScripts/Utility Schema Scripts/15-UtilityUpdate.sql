Use Libertypower
GO

	SELECT	pir.ID, pir.Value as InternalValue, pv.Value as ZainetValue
	INTO	#Properties
	FROM	PropertyType pt (NOLOCK) 
	INNER	JOIN PropertyInternalRef pir (NOLOCK) 
	ON		pt.ID = pir.PropertyTypeID
	AND		pt.PropertyID = pir.PropertyID
	INNER	JOIN PropertyValue pv (NOLOCK) 
	ON		pir.ID = pv.InternalRefID
	INNER	JOIN ExternalEntityValue eev (NOLOCK) 
	ON		eev.PropertyValueID = pv.ID
	WHERE	pt.PropertyID = 1
	AND		eeV.ExternalEntityID = 9
	
	AND (eev.Inactive = 0)
	AND (pv.Inactive = 0 )
	AND (pir.Inactive = 0 )

GO
	UPDATE	u
	SET		u.DeliveryLocationRefID = p.ID
	from	Utility u
	Inner	Join lp_common..zone z
	On		u.ZoneDefault = z.zone_id
	Inner	Join #Properties p
	on		u.UtilityCode + '-'+ z.zone = p.InternalValue

GO

	SELECT	pir.ID, pir.Value as InternalValue
	INTO	#PropertiesProfile
	FROM	PropertyInternalRef pir (NOLOCK) 
	WHERE	pir.PropertyID = 2
	AND		(pir.Inactive = 0 )

GO

	SELECT * 
	INTO #ProfileLookUp
	FROM OPENDATASOURCE('SQLNCLI',  'Data Source=LPCNOCSQL9\TRANSACTIONS;Initial Catalog=LP_MtM;user id=MtMWsAccess;password=MtMWsAccess@9').lp_mtm.dbo.ProfileLookUp

GO

	UPDATE	u
	SET		u.DefaultProfileRefID = f.ID
	FROM	Utility u
	INNER	JOIN #ProfileLookUp p
	ON		u.UtilityCode = p.UtilityId
	INNER	Join #PropertiesProfile f
	On		f.InternalValue = p.UtilityID +'-' + p.ProfileId
	WHERE	ListType = 'UD'
	


GO
	-- ERCOT
	UPDATE	u
	SET		u.DefaultProfileRefID = f.ID
	FROM	Utility u
	INNER	JOIN #ProfileLookUp p
	ON		u.WholeSaleMktID = p.ISO
	INNER	Join #PropertiesProfile f
	On		f.InternalValue = u.UtilityCode +'-' + p.ProfileId
	WHERE	ListType = 'ID'
	
GO
	--CONED
	UPDATE	u
	SET		u.DefaultProfileRefID = f.ID
	FROM	Utility u
	INNER	Join #PropertiesProfile f
	On		f.InternalValue = '9-999999'
	WHERE	u.UtilityCode = 'CONED'

GO
