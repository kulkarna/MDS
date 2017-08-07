USE LibertyPower
GO

IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE Name = 'Fixed CT Green')
	BEGIN
		INSERT	INTO Libertypower..ProductBrand
		SELECT	8, 'Fixed CT Green', 0, 0, 3, 1, 'libertypower\rideigsler', '2013-09-27', 0
	END
	
IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE Name = 'Fixed MD Green')
	BEGIN
		INSERT	INTO Libertypower..ProductBrand
		SELECT	8, 'Fixed MD Green', 0, 0, 3, 1, 'libertypower\rideigsler', '2013-09-27', 0
	END
	
IF NOT EXISTS (SELECT 1 FROM Libertypower..ProductBrand WHERE Name = 'Fixed PA Green')
	BEGIN
		INSERT	INTO Libertypower..ProductBrand
		SELECT	8, 'Fixed PA Green', 0, 0, 3, 1, 'libertypower\rideigsler', '2013-09-27', 0
	END		