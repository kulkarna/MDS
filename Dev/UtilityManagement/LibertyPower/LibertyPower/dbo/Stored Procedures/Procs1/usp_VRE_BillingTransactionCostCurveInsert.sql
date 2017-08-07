
CREATE procedure [dbo].[usp_VRE_BillingTransactionCostCurveInsert] ( 
	 @FileContextGuid								   UNIQUEIDENTIFIER
	,@BillingType                                      VARCHAR(50)
	,@Cost                                             DECIMAL(18,6)
	,@CreatedBy										   INT)
AS

BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO VREBillingTransactionCostCurve (		
		FileContextGuid
		,BillingType
		,Cost
		,CreatedBy)
	VALUES (
		 @FileContextGuid		
		,@BillingType
		,@Cost
		,@CreatedBy)
	
	SELECT SCOPE_IDENTITY();
	
	SET NOCOUNT OFF;
END

-- Copywrite LibertyPower 01/27/2010


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_BillingTransactionCostCurveInsert';

