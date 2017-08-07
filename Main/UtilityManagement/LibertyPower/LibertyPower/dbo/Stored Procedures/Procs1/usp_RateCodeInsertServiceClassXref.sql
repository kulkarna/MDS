
/*******************************************************************************
 * usp_RateCodeInsertServiceClassXref
 *
 *
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_RateCodeInsertServiceClassXref]  
	@p_UtilityID				nvarchar(20),                
	@p_AccountNumber  nvarchar(50),                                                                  
	@p_ShortServiceClass	nvarchar(10),
	@p_RawServiceClass		nvarchar(50),
	@p_RateCodeServiceClass	 nvarchar(50)
	
	
AS
BEGIN TRANSACTION

IF NOT EXISTS (SELECT UtilityID, AccountNumber FROM RateCodeServiceClassXref WHERE UtilityID = @p_UtilityID AND AccountNumber = @p_AccountNumber)
BEGIN 
		
	INSERT INTO	 RateCodeServiceClassXref (UtilityID, AccountNumber, ShortServiceClass, RawServiceClass, RateCodeServiceClass)
	VALUES		(@p_UtilityID, @p_AccountNumber, @p_ShortServiceClass, @p_RawServiceClass, @p_RateCodeServiceClass)
					
END

if @@ERROR = 0 
	COMMIT                                                                                                                                       
ELSE
	ROLLBACK
                                                                                                                                          
-- Copyright 2009 Liberty Power




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeInsertServiceClassXref';

