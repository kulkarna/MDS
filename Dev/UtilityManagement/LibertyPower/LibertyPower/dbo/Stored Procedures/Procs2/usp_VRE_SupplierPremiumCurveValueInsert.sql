

Create PROCEDURE [dbo].[usp_VRE_SupplierPremiumCurveValueInsert]
	
    @VreSupplierPremiumCurveHeaderID INT,    
    @Date datetime=NULL,
    @Value DECIMAL(5,2)
   
AS
BEGIN
   INSERT INTO [VreSupplierPremiumCurveValues]
           (          			
           VreSupplierPremiumCurveHeaderID,
           [Date],
           Value
           )
     VALUES
           (			
			@VreSupplierPremiumCurveHeaderID,
			@Date,
			@Value
			);			

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_SupplierPremiumCurveValueInsert';

