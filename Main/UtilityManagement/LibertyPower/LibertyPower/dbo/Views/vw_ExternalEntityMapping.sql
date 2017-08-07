

CREATE VIEW vw_ExternalEntityMapping
AS
	SELECT vee.EntityTypeID as ExtEntityTypeID 
		, eet.name as ExtEntityType 
		, vee.ID as ExtEntityID
		, vee.Name as ExtEntityName
		, p.ID as [ExtEntityPropertyID] 
		, p.Name as [ExtEntityProperty] 
		, eev.ID as ExtEntityValueID
		, pv.ID as ExtPropertyValueID
		, pv.Value as ExtEntityValue 
		, ISNULL(pt.ID,0) as ExtEntityPropertyTypeID 
		, ISNULL(pt.Name, '') as ExtEntityPropertyType
		, p.Name + case when ltrim(isnull(pt.Name, '')) = '' then '' else  ' (' + LTRIM(rtrim(pt.Name)) + ')' end as ExtEntityPropertyDescp
		
		, eev.Inactive as ExtEntityValueInactive 
		, pv.Inactive as PropertyValueInactive
		, vee.Inactive as ExternalEntityInactive
		
		, pir.ID as InternalRefID
		, pir.InternalRefProperty
		, pir.Value as InternalRef 
		, pir.InternalRefPropertyType
		, pir.InternalRefProperty + case when ltrim(isnull(pir.InternalRefPropertyType, '')) = '' then '' else  ' (' + LTRIM(rtrim(pir.InternalRefPropertyType)) + ')' end as InternalRefPropertyDescp
		, pir.PropertyId as InternalRefPropertyID
		, ISNULL(pir.PropertyTypeId,0) as InternalRefPropertyTypeID
		, pir.Inactive as InternalrefInactive
		
	FROM LibertyPower..ExternalEntityValue eev (NOLOCK)
		JOIN LibertyPower..vw_ExternalEntity vee  (NOLOCK)
			ON eev.ExternalEntityID = vee.ID
		JOIN LibertyPower..ExternalEntityType eet (NOLOCK)
			ON vee.EntityTypeID = eet.ID
		JOIN LibertyPower..PropertyValue pv (NOLOCK)
			ON pv.ID = eev.PropertyValueID 
		LEFT JOIN LibertyPower..Property p (NOLOCK)
			ON p.ID = pv.PropertyId
		LEFT JOIN LibertyPower..PropertyType pt (NOLOCK)
			ON pt.ID = pv.PropertyTypeId
		LEFT JOIN 
			( SELECT pir.* , p.Name as InternalRefProperty, ISNULL(pt.Name, '') as InternalRefPropertyType
				FROM LibertyPower..PropertyInternalRef pir (NOLOCK)
					LEFT JOIN LibertyPower..Property p (NOLOCK)
						ON pir.PropertyId = p.ID
					LEFT JOIN LibertyPower..PropertyType pt (NOLOCK)
						ON pir.PropertyTypeId = pt.ID
				--WHERE pir.Inactive = 0 
			) pir  
			ON pir.ID = pv.InternalRefID

	--WHERE eev.Inactive = 0 
	--	AND pv.Inactive = 0 
