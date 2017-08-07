
/***** Purge Existing Location Data  ******/

DELETE ev
FROM LibertyPower..ExternalEntityValue ev
	JOIN LibertyPower..PropertyValue pv on ev.PropertyValueID = pv.ID
WHERE pv.propertyId = 1 -- locations only 


DELETE LibertyPower..PropertyValue
WHERE propertyId = 1 -- locations only 


DELETE LibertyPower..PropertyInternalRef
WHERE propertyId = 1 -- locations only 