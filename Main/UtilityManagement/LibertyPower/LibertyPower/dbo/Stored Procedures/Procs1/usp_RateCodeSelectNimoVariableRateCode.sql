



/*******************************************************************************
 * [usp_AccountByRateCode]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeSelectNimoVariableRateCode]
	@pricingGroup			varchar(50),
	@serviceClass			varchar(50),
	@zoneCode			varchar(50)
AS
	SELECT Top 1Code from RateCode r
	WHERE r.Utility = 'NIMO'
	AND r.PricingGroup = @pricingGroup
	AND r.ServiceClass = @serviceClass
	AND r.ZoneCode = @zoneCode
   
-- Copyright 2009 Liberty Power




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeSelectNimoVariableRateCode';

