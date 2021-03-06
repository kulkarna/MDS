USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_MeterReadCalendar_GetByUtilityCode]    Script Date: 01/13/2017 12:38:26 ******/
DROP PROCEDURE [dbo].[usp_MeterReadCalendar_GetByUtilityCode]
GO
/****** Object:  StoredProcedure [dbo].[usp_MeterReadCalendar_GetByUtilityCode]    Script Date: 01/13/2017 12:38:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Stored Procedure: usp_MeterReadCalendar_GetByUtilityCode
-- Created: Anil Chelasani 05/09/2016        
-- Description: Selects the records from the Meter Read Calendar table for the specified Utility Code
--EXEC [usp_MeterReadCalendar_GetByUtilityCode] @UtilityCode = 'CONED'
-- ====================================================================================================================================================================================

CREATE PROC [dbo].[usp_MeterReadCalendar_GetByUtilityCode]
	@UtilityCode VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		UC.lpc_UtilityCode UtilityCode,
		SMYear.Value [Year],
		SMMonth.Value [Month],
		MRC.lpc_read_cycle ReadCycleId,
		MRC.lpc_read_date ReadDate,
		MRC.lpc_isamr IsAmr,
		MRC.statecode Inactive,
		MRC.CreatedByName CreatedBy,
		MRC.CreatedOn CreatedDate,
		MRC.ModifiedByName LastModifiedBy,
		MRC.ModifiedOn LastModifiedDate
	FROM
		LibertyCrm_MSCRM.dbo.lpc_meter_read_calendar MRC
		INNER JOIN LibertyCrm_MSCRM.dbo.StringMap SMYear ON MRC.lpc_year = SMYear.AttributeValue
		INNER JOIN LibertyCrm_MSCRM.dbo.EntityView EVY ON EVY.name = 'lpc_meter_read_calendar' AND SMYear.ObjectTypeCode = EVY.ObjectTypeCode
		INNER JOIN LibertyCrm_MSCRM.dbo.StringMap SMMonth ON MRC.lpc_month = SMMonth.AttributeValue
		INNER JOIN LibertyCrm_MSCRM.dbo.EntityView EVM ON EVM.name = 'lpc_meter_read_calendar' AND SMMonth.ObjectTypeCode = EVM.ObjectTypeCode
		INNER JOIN LibertyCrm_MSCRM.dbo.lpc_utility UC ON UC.lpc_utilityId = MRC.lpc_utility


	WHERE
		UC.lpc_UtilityCode = @UtilityCode 
	ORDER BY
		UtilityCode, [Year], [Month], ReadCycleId

	SET NOCOUNT OFF;

END
GO
