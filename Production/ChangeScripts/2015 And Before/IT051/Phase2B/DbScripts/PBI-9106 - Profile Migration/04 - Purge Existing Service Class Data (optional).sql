USE [LibertyPower]
GO

/***** Purge Existing Location Data  ******/

-- select * from libertypower..property
DELETE ev
FROM LibertyPower..ExternalEntityValue ev
	JOIN LibertyPower..PropertyValue pv on ev.PropertyValueID = pv.ID
WHERE pv.propertyId = 3 -- service class only 


DELETE LibertyPower..PropertyValue
WHERE propertyId = 3 -- service class only


DELETE LibertyPower..PropertyInternalRef
WHERE propertyId = 3 -- service class only