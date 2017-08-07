USE Genie
GO

IF NOT EXISTS (SELECT top 1 1 from LK_Brand where Brand='FIXED GAS')
INSERT INTO [Genie].[dbo].[LK_Brand]
([Brand]
,[BrandDescription]
,[IsFlex]
,[LPBrandID])
VALUES
('FIXED GAS','FIXED GAS',0,33)
GO
