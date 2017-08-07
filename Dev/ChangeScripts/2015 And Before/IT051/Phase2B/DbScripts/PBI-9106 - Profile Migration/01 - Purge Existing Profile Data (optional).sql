USE [LibertyPower]
GO

/***** Purge Existing Location Data  ******/

-- select * from libertypower..property
DELETE ev
FROM LibertyPower..ExternalEntityValue ev
	JOIN LibertyPower..PropertyValue pv on ev.PropertyValueID = pv.ID
WHERE pv.propertyId = 2 -- profile only 


DELETE LibertyPower..PropertyValue
WHERE propertyId = 2 -- profile only


DELETE LibertyPower..PropertyInternalRef
WHERE propertyId = 2 -- profile only