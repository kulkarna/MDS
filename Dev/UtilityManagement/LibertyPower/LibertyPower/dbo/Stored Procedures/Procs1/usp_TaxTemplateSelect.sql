
CREATE PROCEDURE usp_TaxTemplateSelect
	@UtilityID INT = 0
AS
set nocount on
SELECT TOP 1000 [TaxTemplateID]
      ,tt.[UtilityID]
      ,tt.[Template]
      ,tt.[TaxTypeID]
      ,tt.[PercentTaxable]
      ,ty.TypeOfTax
  FROM [LibertyPower].[dbo].[TaxTemplate] tt
  inner join [LibertyPower].[dbo].TaxType ty ON ty.TaxTypeID = tt.TaxTypeID
  WHERE (tt.UtilityID = @UtilityID OR @UtilityID =0) 
