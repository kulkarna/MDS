

CREATE PROCEDURE [dbo].[usp_VRE_SupplierPremiumCurveHeaderInsert]

	@FileContextGUID UNIQUEIDENTIFIER,
    @ISO INT,
    @Zone VARCHAR(50),
    @Market VARCHAR(50),
    @UpdatedDate DateTime,
    @VrePriceType INT,
    @CreatedBy INT,
	@ID int out
   
AS
BEGIN
   INSERT INTO [VreSupplierPremiumCurveHeader]
           (          
			[FileContextGUID]
           ,[ISO]
           ,[Zone]      
           ,[Market]
           ,[UpdatedDate]
           ,[VrePriceType]
           ,[CreatedBy]           
           )
     VALUES
           (
			@FileContextGUID,
			@ISO,
			@Zone,	
			@Market,		
			@UpdatedDate,			
			@VrePriceType,
			@CreatedBy			
			);
			
	Set @ID = SCOPE_IDENTITY();

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_SupplierPremiumCurveHeaderInsert';

