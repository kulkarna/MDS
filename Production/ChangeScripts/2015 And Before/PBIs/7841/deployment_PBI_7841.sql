USE [LibertyPower]
GO

CREATE VIEW [dbo].[vw_zone]
AS
SELECT        zone_id, zone, retail_mkt_id, utility_id, ratecode_file_mapping, ista_mapping, date_created
FROM            Lp_common.dbo.zone with(nolock)

GO


CREATE VIEW [dbo].[vw_service_rate_class]
AS
SELECT        service_rate_class_id, service_rate_class, retail_mkt_id, utility_id, ratecode_file_mapping, ista_mapping, date_created
FROM            Lp_common.dbo.service_rate_class with(nolock)

GO


CREATE TABLE [dbo].[RateClassMappings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Market] [nvarchar](255) NULL,
	[Utility] [nvarchar](255) NULL,
	[Utility Service Class] [nvarchar](255) NULL,
	[LP Service Class LP Price] [nvarchar](255) NULL,
	[CustomerType] [nvarchar](255) NULL,
	[LP Zone Name] [nvarchar](255) NULL	
) ON [PRIMARY]

GO