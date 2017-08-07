USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_PropertyInternalRefMapping]'))
	DROP VIEW [dbo].[vw_PropertyInternalRefMapping]
GO

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
                       FROM          dbo.PropertyInternalRef AS pir (NOLOCK) LEFT OUTER JOIN
                                              dbo.PropertyType AS PT (NOLOCK) ON PT.ID = pir.propertytypeId
                       WHERE      (pir.propertyId = 1)) AS z LEFT OUTER JOIN
                          (SELECT     ee.name AS entityName, pv.Value AS entityValue, PIR.ID AS InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR (NOLOCK) INNER JOIN
                                                   dbo.PropertyName AS P (NOLOCK) ON P.ID = PIR.propertyId INNER JOIN
                                                   dbo.PropertyType AS PT (NOLOCK) ON PT.ID = PIR.propertytypeId INNER JOIN
                                                   dbo.PropertyValue AS pv (NOLOCK) ON pv.InternalRefID = PIR.ID INNER JOIN
                                                   dbo.ExternalEntityValue AS ev (NOLOCK) ON ev.PropertyValueID = pv.ID INNER JOIN
                                                   dbo.vw_ExternalEntity AS ee (NOLOCK) ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ShowAs = 1)) AS x ON z.InternalRefID = x.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS ZainetValue, pv.InternalRefID
                            FROM          dbo.ExternalEntityValue AS ev (NOLOCK) LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv (NOLOCK) ON pv.ID = ev.PropertyValueID
                            WHERE      (ev.ExternalEntityID = 9)) AS Zainet ON z.InternalRefID = Zainet.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS MatpriceValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR (NOLOCK) LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv (NOLOCK) ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev (NOLOCK) ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee (NOLOCK) ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 10)) AS MatPrice ON z.InternalRefID = MatPrice.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS PricingValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR (NOLOCK) LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv (NOLOCK) ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev (NOLOCK) ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee (NOLOCK) ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 11)) AS Pricing ON z.InternalRefID = Pricing.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS OfferEngineValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR (NOLOCK) LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv (NOLOCK) ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev (NOLOCK) ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee (NOLOCK) ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 7)) AS OfferEngine ON z.InternalRefID = OfferEngine.InternalRefID LEFT OUTER JOIN
                          (SELECT     pv.Value AS RetailOfficeValue, pv.InternalRefID
                            FROM          dbo.PropertyInternalRef AS PIR (NOLOCK) LEFT OUTER JOIN
                                                   dbo.PropertyValue AS pv (NOLOCK) ON pv.InternalRefID = PIR.ID LEFT OUTER JOIN
                                                   dbo.ExternalEntityValue AS ev (NOLOCK) ON ev.PropertyValueID = pv.ID LEFT OUTER JOIN
                                                   dbo.vw_ExternalEntity AS ee (NOLOCK) ON ee.ID = ev.ExternalEntityID
                            WHERE      (ee.ID = 8)) AS RetailOffice ON z.InternalRefID = RetailOffice.InternalRefID

 	-- ORDER BY case when x.entityName IS null then 1 else 0 end , x.entityName 
	
	
