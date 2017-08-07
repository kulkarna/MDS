USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GenerateGasPrice]    Script Date: 10/13/2014 10:18:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

BEGIN TRY
BEGIN TRANSACTION;
DECLARE @productBrandId int , @marketId int

Select @productBrandId = ProductBrandId from ProductBrand with(nolock) where Name='Fixed Gas';
Select @marketId = ID from Market with(nolock) where MarketCode='NJ';

	IF NOT EXISTS (SELECT 1 from MarketProducts with(nolock) where MarketID=@marketId and ProductBrandID=@productBrandId)
	BEGIN
		INSERT INTO MarketProducts(MarketID,ProductBrandID,CreatedBy,CreatedDate) values(@marketId,@productBrandId,1949,GETDATE());
	END
Select @marketId = ID from Market with(nolock) where MarketCode='NY';
	IF NOT EXISTS (SELECT 1 from MarketProducts with(nolock) where MarketID=@marketId and ProductBrandID=@productBrandId)
	BEGIN
		INSERT INTO MarketProducts(MarketID,ProductBrandID,CreatedBy,CreatedDate) values(@marketId,@productBrandId,1949,GETDATE());
	END

END TRY

BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;    






