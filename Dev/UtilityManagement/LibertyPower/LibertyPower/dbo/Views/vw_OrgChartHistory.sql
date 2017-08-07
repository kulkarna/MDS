







CREATE VIEW [dbo].[vw_OrgChartHistory]
AS
SELECT
	OrgID
	, CASE
		WHEN ChannelCategory ='Internal' THEN SalesMgrChannel 
		ELSE NULL
	END SalesChannel
	, CASE
		WHEN ChannelCategory = 'ALL' THEN SalesMgrChannel
		ELSE NULL
	END SalesChannelManager
	, ChannelType Department
	, DirectReport DepartmentManager
	, EffectiveDate
FROM
	LibertyPower.dbo.OrgChartHistory

