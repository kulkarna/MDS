

/*******************************************************************************
 * usp_RateCodeSelectRequiredColumns *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeSelectRequiredColumns]  
	                          
AS
Select ID, FieldName, CreatedBy, DateCreated, ModifiedBy, DateModified
From RateCodeSchemaColumn


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeSelectRequiredColumns';

