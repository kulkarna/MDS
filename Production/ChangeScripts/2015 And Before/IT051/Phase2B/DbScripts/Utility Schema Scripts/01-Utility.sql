USE LibertyPower
GO 

-- Utility Table 
-- =========================================
IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'Utility' and c.name = 'DeliveryLocationRefID'
			) 
			
ALTER TABLE LibertyPower..Utility 
ADD DeliveryLocationRefID INT NULL 	

--IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
--				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
--				WHERE o.name = 'Utility' and c.name = 'SettlementLocationRefID'
--			) 
--			
--ALTER TABLE LibertyPower..Utility 
--ADD SettlementLocationRefID INT NULL 
			
IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'Utility' and c.name = 'DefaultProfileRefID'
			) 
			
ALTER TABLE LibertyPower..Utility 
ADD DefaultProfileRefID INT NULL 	


-- ZAuditUtility Table 
-- =======================================
IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'zAuditUtility' and c.name = 'DeliveryLocationRefID'
			) 
			
ALTER TABLE LibertyPower..zAuditUtility 
ADD DeliveryLocationRefID INT NULL 	

--IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
--				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
--				WHERE o.name = 'zAuditUtility' and c.name = 'SettlementLocationRefID'
--			) 
--			
--ALTER TABLE LibertyPower..zAuditUtility 
--ADD SettlementLocationRefID INT NULL 
			
IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'zAuditUtility' and c.name = 'DefaultProfileRefID'
			) 
			
ALTER TABLE LibertyPower..zAuditUtility 
ADD DefaultProfileRefID INT NULL 	
						