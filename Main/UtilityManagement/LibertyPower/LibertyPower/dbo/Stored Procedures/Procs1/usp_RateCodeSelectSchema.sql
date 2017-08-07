

/*******************************************************************************
 * usp_RateCodeSelectSchema *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeSelectSchema]  
	                          
AS
Select RateCodeSchema.ID, RateCodeSchema.UtilityCode, RateCodeSchema.FieldNameID, 
RateCodeSchema.IsColumnRequired, RateCodeSchema.IsValueRequired, 
RateCodeSchema.CreatedBy, RateCodeSchema.DateCreated, RateCodeSchema.ModifiedBy, 
RateCodeSchema.DateModified, 
RateCodeSchemaColumn.ID,
RateCodeSchemaColumn.FieldName,
RateCodeSchemaColumn.CreatedBy,
RateCodeSchemaColumn.DateCreated,
RateCodeSchemaColumn.ModifiedBy,
RateCodeSchemaColumn.DateModified
From RateCodeSchema left join RateCodeSchemaColumn on RateCodeSchema.FieldNameID = RateCodeSchemaColumn.ID


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeSelectSchema';

