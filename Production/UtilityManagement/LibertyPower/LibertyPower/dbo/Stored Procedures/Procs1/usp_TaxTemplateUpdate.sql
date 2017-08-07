CREATE PROCEDURE	[dbo].usp_TaxTemplateUpdate
	 @TaxTemplateID INT	
	,@PercentTaxable INT
AS
BEGIN
	UPDATE  
		[LibertyPower].[dbo].[TaxTemplate]
	SET	
      [PercentTaxable] = @PercentTaxable
	WHERE (TaxTemplateID = @TaxTemplateID)
END
