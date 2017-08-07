
CREATE PROCEDURE [dbo].[usp_HeatIndexSourceList]
AS
SELECT [HeatIndexSourceID] 
	,[Code] 
	,[Name]
FROM [LibertyPower].[dbo].[HeatIndexSource] WITH (NOLOCK)
ORDER BY 2
