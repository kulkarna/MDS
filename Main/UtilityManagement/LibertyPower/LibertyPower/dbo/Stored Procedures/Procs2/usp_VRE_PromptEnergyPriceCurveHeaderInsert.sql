

CREATE PROCEDURE [dbo].[usp_VRE_PromptEnergyPriceCurveHeaderInsert]

	@FileContextGUID UNIQUEIDENTIFIER,
    @ISO INT,
    @Zone VARCHAR(50),   
    @EffectiveDate DateTime,
    @SpotBOMPrice DECIMAL(5,2) = NULL,
    @VrePriceType INT,
    @CreatedBy INT,
	@ID int out
   
AS
BEGIN
   INSERT INTO [VrePromptEnergyPriceCurveHeader]
           (          
			[FileContextGUID]
           ,[ISO]
           ,[Zone]           
           ,[EffectiveDate]
           ,[SpotBOMPrice]
           ,[VrePriceType]
           ,[CreatedBy]           
           )
     VALUES
           (
			@FileContextGUID,
			@ISO,
			@Zone,			
			@EffectiveDate,
			@SpotBOMPrice,
			@VrePriceType,
			@CreatedBy			
			);
			
	Set @ID = SCOPE_IDENTITY();

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_PromptEnergyPriceCurveHeaderInsert';

