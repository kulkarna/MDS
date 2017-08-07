/*******************************************************************************  
 * adding fields CapPLCPrev, TransPLCPrev, 
			CapPLCEffectiveDt, CapPLCPrevEffectiveDt, TransPLCEffectiveDt, 
			TransPLCPrevEffectiveDt - by Felipe Medeiros
 *******************************************************************************  
*/
USE lp_TRANSACTION
GO

ALTER TABLE BgeAccount
ADD CapPLCPrev decimal(12,6)
GO

ALTER TABLE BgeAccount
ADD TransPLCPrev decimal(12,6)
GO

ALTER TABLE BgeAccount
ADD CapPLCEffectiveDt datetime
GO

ALTER TABLE BgeAccount
ADD TransPLCEffectiveDt datetime
GO

ALTER TABLE BgeAccount
ADD CapPLCPrevEffectiveDt datetime
GO

ALTER TABLE BgeAccount
ADD TransPLCPrevEffectiveDt datetime
GO
