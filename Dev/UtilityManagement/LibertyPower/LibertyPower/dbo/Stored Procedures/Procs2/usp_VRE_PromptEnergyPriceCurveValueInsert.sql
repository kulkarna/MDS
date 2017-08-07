
-- Batch submitted through debugger: SQLQuery6.sql|7|0|C:\Users\gkovacs\AppData\Local\Temp\~vs5159.sql

CREATE PROCEDURE [dbo].[usp_VRE_PromptEnergyPriceCurveValueInsert]
	
    @VrePromptEnergyPriceCurveHeaderID INT,    
    @Date datetime=NULL,
    @Value DECIMAL(5,2)
   
AS
BEGIN
   INSERT INTO [VrePromptEnergyPriceCurveValues]
           (          			
           VrePromptEnergyPriceCurveHeaderID,
           [Date],
           Value
           )
     VALUES
           (			
			@VrePromptEnergyPriceCurveHeaderID,
			@Date,
			@Value
			);			

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_PromptEnergyPriceCurveValueInsert';

