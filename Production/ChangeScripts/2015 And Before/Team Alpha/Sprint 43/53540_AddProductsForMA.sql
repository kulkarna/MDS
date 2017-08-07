USE LIBERTYPOWER
GO

BEGIN TRANSACTION;
BEGIN TRY
declare @marketIdMA int;
Select @marketIdMA = id from Market (nolock) where MarketCode='MA' ;
IF Exists (SELECT top 1 1 from MarketProducts (nolock) where MarketID=@marketIdMA)
BEGIN
    DELETE from MarketProducts where marketID=@marketIdMA;
    Print'Deleted Existing combinations.'
END

BEGIN 
    INSERT into MarketProducts(MarketID,ProductBrandID,IsActive,CreatedBy,CreatedDate)
    Select @marketIdMA as MarketID, 
    productBrand.ProductBrandID,1 as IsActive,
    1949 as CreatedBy, 
    GETDATE() as CreateDate
	from ProductBrand (nolock) where Name 
	in('Independence Plan','Super Saver','Liberty Flex',
    'Freedom To Save','Fixed National Green E');

    Print'Inserted market product combinations.'
END
--Select * from MarketProducts where marketid=4
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

