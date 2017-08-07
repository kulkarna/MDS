
CREATE PROCEDURE [dbo].[usp_VRE_ManualRateInsert]
	
	@AccountNumber VarChar(100),
    @ExistingRate DECIMAL(8,6),
    @ManualRate DECIMAL(8,6),   
    @CreatedBy INT
	   
AS

BEGIN
   INSERT INTO ManualRateUpdates
           (          
			[AccountNumber],
			[ExistingRate],
            [ManualRate],
            [CreatedBy]
           )
     VALUES
           (
			 @AccountNumber,
			 @ExistingRate,
             @ManualRate,
             @CreatedBy		
			)			

	Select SCOPE_IDENTITY()
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ManualRateInsert';

