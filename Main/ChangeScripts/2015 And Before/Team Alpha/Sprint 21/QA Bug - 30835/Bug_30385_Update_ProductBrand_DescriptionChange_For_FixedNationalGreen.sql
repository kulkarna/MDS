USE onlineenrollment
GO

UPDATE ProductBrand 
Set Name = 'Fixed National Green-E Energy 100%',
Description = 'Offset your energy usage with Liberty Power''s Liberty Green Plan. Power-Up for the Planet with 100% Green-e Energy Certified Renewable Energy Credits (REC). Enjoy price certainty and protect the environment. Up to 60 month terms available.'
WHERE ProductBrandID = 19
--SELECT pb.* FROM ProductBrand pb WHERE pb.ProductBrandID = 19


