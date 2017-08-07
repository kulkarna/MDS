USE LibertyPower
GO 

-- Main Tables 
-- ==========================================================================
IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'AccountContract' and c.name = 'SettlementLocationRefID'
				) 
				
ALTER TABLE LibertyPower..AccountContract 
ADD SettlementLocationRefID INT NULL 	

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'Account' and c.name = 'DeliveryLocationRefID'
			) 
ALTER TABLE LibertyPower..Account 
ADD DeliveryLocationRefID INT NULL 		

GO

ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_DeliveryLocationRefID]  DEFAULT ((0)) FOR [DeliveryLocationRefID]

GO

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'Account' and c.name = 'LoadProfileRefID'
				) 			
ALTER TABLE LibertyPower..Account
ADD LoadProfileRefID INT NULL 	

GO

ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_LoadProfileRefID]  DEFAULT ((0)) FOR [LoadProfileRefID]

GO

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'Account' and c.name = 'ServiceClassRefID'
				) 
ALTER TABLE LibertyPower..Account
ADD ServiceClassRefID INT NULL 	
GO

ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_ServiceClassRefID]  DEFAULT ((0)) FOR [ServiceClassRefID]

GO

-- Audit Tables 
-- ========================================================================

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'zAuditAccountContract' and c.name = 'SettlementLocationRefID'
				) 
				
ALTER TABLE LibertyPower..zAuditAccountContract 
ADD SettlementLocationRefID INT NULL 	

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'zAuditAccount' and c.name = 'DeliveryLocationRefID'
			) 
			
ALTER TABLE LibertyPower..zAuditAccount 
ADD DeliveryLocationRefID INT NULL 		

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'zAuditAccount' and c.name = 'LoadProfileRefID'
				) 
				
ALTER TABLE LibertyPower..zAuditAccount
ADD LoadProfileRefID INT NULL 	

IF NOT EXISTS ( SELECT * FROM Libertypower.sys.objects o
				JOIN  Libertypower.sys.columns c on o.object_id = c.object_id 
				WHERE o.name = 'zAuditAccount' and c.name = 'ServiceClassRefID'
				) 
				
ALTER TABLE LibertyPower..zAuditAccount
ADD ServiceClassRefID INT NULL 	
