 
IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductType WHERE Name LIKE '%multi%')
BEGIN
	INSERT INTO Libertypower..ProductType
	SELECT 'Multi-Term', 1, 'libertypower\rideigsler', GETDATE()
END

DECLARE	@ProductTypeID	int
SELECT @ProductTypeID = ProductTypeID FROM Libertypower..ProductType WHERE Name LIKE '%multi%'

IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE ProductTypeID = @ProductTypeID)
BEGIN
	INSERT INTO Libertypower..ProductBrand
	SELECT @ProductTypeID, 'Independence Plan Multi-Term', 0, 0, 3, 1, 'libertypower\rideigsler', GETDATE()
END