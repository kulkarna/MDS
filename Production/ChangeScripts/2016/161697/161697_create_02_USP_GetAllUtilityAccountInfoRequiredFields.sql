USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllUtilityAccountInfoRequiredFields]    Script Date: 02/16/2017 09:29:15 ******/
if object_id('USP_GetAllUtilityAccountInfoRequiredFields') is not null
begin
DROP PROCEDURE [dbo].[USP_GetAllUtilityAccountInfoRequiredFields]
End
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllUtilityAccountInfoRequiredFields]    Script Date: 02/16/2017 09:29:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC [USP_GetAllUtilityAccountInfoRequiredFields]
*/

CREATE PROCEDURE [dbo].[USP_GetAllUtilityAccountInfoRequiredFields]
AS
BEGIN

	SELECT
		CASE WHEN URF.lpc_grid = 1 THEN 'Yes' Else 'No' END Grid,
		CASE WHEN URF.lpc_i_cap = 1 THEN 'Yes' Else 'No' END ICap,
		CASE WHEN URF.lpc_lbmp_zone = 1 THEN 'Yes' Else 'No' END LBMPZone,
		CASE WHEN URF.lpc_load_profile = 1 THEN 'Yes' Else 'No' END LoadProfile,
		CASE WHEN URF.lpc_meter_owner = 1 THEN 'Yes' Else 'No' END MeterOwner,
		CASE WHEN URF.lpc_meter_type = 1 THEN 'Yes' Else 'No' END MeterType,
		CASE WHEN URF.lpc_rate_class = 1 THEN 'Yes' Else 'No' END RateClass,
		CASE WHEN URF.lpc_tariff_code = 1 THEN 'Yes' Else 'No' END TariffCode,
		CASE WHEN URF.lpc_t_cap = 1 THEN 'Yes' Else 'No' END TCap,
		CASE WHEN URF.lpc_voltage = 1 THEN 'Yes' Else 'No' END Voltage,
		CASE WHEN URF.lpc_zone = 1 THEN 'Yes' Else 'No' END Zone,
		UC.lpc_UtilityCode AS UtilityCode,
		UC.lpc_utility_id as UtilityId
	FROM
		LIBERTYCRM_MSCRM.dbo.lpc_account_info_field_required URF WITH (NOLOCK)
		INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC WITH (NOLOCK) ON URF.lpc_utility = UC.lpc_utilityId
	WHERE 
		UC.statecode = 0

END
GO
