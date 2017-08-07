USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_ZonesByUtilitySelect]    Script Date: 09/14/2011 10:09:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ZonesByUtilitySelect]
	@UtilityCode	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	zone_id, zone, retail_mkt_id, utility_id
	FROM	zone
	WHERE	utility_id = @UtilityCode
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
