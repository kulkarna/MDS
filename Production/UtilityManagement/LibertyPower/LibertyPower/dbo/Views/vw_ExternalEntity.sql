
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
FROM         LibertyPower..ExternalEntity e
LEFT OUTER JOIN LibertyPower..WholesaleMarket W on W.ID = e.EntityKey and e.EntitytypeID = 1
LEFT OUTER JOIN LibertyPower..Utility U on U.ID = e.EntityKey and e.EntitytypeID = 2
LEFT OUTER JOIN LibertyPower..WholesaleMarket UParent on UParent.WholesaleMktId = u.WholeSaleMktID
LEFT OUTER JOIN LibertyPower..ExternalEntity UParentEntity ON UParentEntity.ID = UParent.ID and UParentEntity.EntityTypeID = 1
LEFT OUTER JOIN LibertyPower..ThirdPartyApplications TP on TP.ID = e.EntityKey and e.EntitytypeID = 3

