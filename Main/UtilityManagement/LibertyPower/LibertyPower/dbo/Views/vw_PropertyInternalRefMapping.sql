
/************************************************************************************************
 Author:		Gail Mangaroo
 Create date: 4/5/2013
 Description: Display Mappings for Internal reference values..
************************************************************************************************/

CREATE VIEW vw_PropertyInternalRefMapping
AS 
	SELECT     x.entityName, z.LocationType, z.InternalRefID, z.InternalValue, x.entityValue AS ISO_Settlement, Zainet.ZainetValue, MatPrice.MatpriceValue, Pricing.PricingValue, 
                      OfferEngine.OfferEngineValue, RetailOffice.RetailOfficeValue
FROM         (SELECT     pir.Value AS InternalValue, PT.Name AS LocationType, pir.ID AS InternalRefID
                       FROM          dbo.PropertyInternalRef AS pir LEFT OUTER JOIN
                                              dbo.PropertyType AS PT ON PT.ID = pir.propertytypeId
                       WHERE      (pir.propertyId = 1)) AS z LEFT OUTER JOIN
                          (SELECT     ee.name AS entityName, pv.Value AS entityValue, PIR.ID AS InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR INNER JOIN
                                                   dbo.Property AS P ON P.ID = PIR.propertyId INNER JOIN
                                                   dbo.PropertyType AS PT ON PT.ID = PIR.propertytypeId INNER JOIN
                                                   dbo.PropertyValue AS pv ON pv.InternalRefID = PIR.ID INNER JOIN
                                                   dbo.ExternalEntityValue AS ev ON ev.PropertyValueID = pv.ID INNER JOIN
                                                   dbo.vw_ExternalEntity AS ee ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ShowAs = 1)) AS x ON z.InternalRefID = x.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS ZainetValue, pv.InternalRefID
                            FROM          dbo.ExternalEntityValue AS ev LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv ON pv.ID = ev.PropertyValueID
                            WHERE      (ev.ExternalEntityID = 9)) AS Zainet ON z.InternalRefID = Zainet.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS MatpriceValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 10)) AS MatPrice ON z.InternalRefID = MatPrice.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS PricingValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 11)) AS Pricing ON z.InternalRefID = Pricing.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS OfferEngineValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 7)) AS OfferEngine ON z.InternalRefID = OfferEngine.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS RetailOfficeValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 8)) AS RetailOffice ON z.InternalRefID = RetailOffice.InternalRefID

 	-- ORDER BY case when x.entityName IS null then 1 else 0 end , x.entityName 
	
	
