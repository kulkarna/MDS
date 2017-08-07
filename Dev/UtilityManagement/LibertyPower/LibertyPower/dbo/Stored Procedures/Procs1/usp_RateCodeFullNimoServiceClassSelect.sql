


/*******************************************************************************
 * [usp_RateCodeFullNimoServiceClassSelect]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeFullNimoServiceClassSelect]  
                                                                        
	@accountNumber	varchar(50)

AS

select lp_enrollment..RateCodeServiceClassXref.ID,
lp_enrollment..RateCodeServiceClassXref.UtilityID as [UtilityID],
lp_enrollment..RateCodeServiceClassXref.RateCodeServiceClass as [RateCodeServiceClass],
lp_enrollment..RateCodeServiceClassXref.RawServiceClass as [RawServiceClass],
lp_enrollment..RateCodeServiceClassXref.ShortServiceClass as [ShortServiceClass]
from lp_enrollment..RateCodeServiceClassXref
where lp_enrollment..RateCodeServiceClassXref.AccountNumber = @accountNumber
	                                                                                                                                
-- Copyright 2009 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeFullNimoServiceClassSelect';

