USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ExternalEntity]'))
	DROP VIEW [dbo].[vw_ExternalEntity]
GO

-- 
CREATE View vw_ExternalEntity
AS 

SELECT     e.* 
, Name = case when e.EntityTypeID = 1 then w.WholesaleMktId
				when e.EntityTypeID = 2 then u.UtilityCode
				when e.EntityTypeID = 3 then tp.Name 
				else ''
				end  						
, ParentExtEntityID = UParentEntity.ID 
FROM         LibertyPower..ExternalEntity e (NOLOCK)
LEFT OUTER JOIN LibertyPower..WholesaleMarket W (NOLOCK) on W.ID = e.EntityKey and e.EntitytypeID = 1
LEFT OUTER JOIN LibertyPower..Utility U (NOLOCK) on U.ID = e.EntityKey and e.EntitytypeID = 2
LEFT OUTER JOIN LibertyPower..WholesaleMarket UParent (NOLOCK) on UParent.WholesaleMktId = u.WholeSaleMktID
LEFT OUTER JOIN LibertyPower..ExternalEntity UParentEntity (NOLOCK) ON UParentEntity.ID = UParent.ID and UParentEntity.EntityTypeID = 1
LEFT OUTER JOIN LibertyPower..ThirdPartyApplications TP (NOLOCK) on TP.ID = e.EntityKey and e.EntitytypeID = 3

