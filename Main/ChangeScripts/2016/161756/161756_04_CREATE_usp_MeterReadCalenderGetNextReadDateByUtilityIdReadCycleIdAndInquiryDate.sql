USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate]    Script Date: 01/13/2017 12:29:11 ******/
DROP PROCEDURE [dbo].[usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate]
GO
/****** Object:  StoredProcedure [dbo].[usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate]    Script Date: 01/13/2017 12:29:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************************************************************************************************
EXEC usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate
@UtilityID = 18,
	@ReadCycleID  = '1',
	@IsAmr = 0,
	@InquiryDate  = '2/15/2015'
* Returns the next Meter Read Date 
* History
**************************************************************************************************************************************************************
* 05/09/2016 - Anil Chelasani 
* Created.
**************************************************************************************************************************************************************/


CREATE PROC [dbo].[usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate]
	@UtilityID INT,
	@ReadCycleID NVARCHAR(255),
	@IsAmr BIT,
	@InquiryDate DATE
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1 
		MRC.lpc_read_date ReadDate 
	FROM 
		LibertyCrm_MSCRM.[dbo].lpc_meter_read_calendar (NOLOCK) MRC
		INNER JOIN LibertyCrm_MSCRM.dbo.lpc_Utility (NOLOCK) U
			ON MRC.lpc_utility = U.lpc_utilityId
	WHERE
		U.lpc_utility_id = @UtilityId
		AND REPLACE(LTRIM(REPLACE(MRC.lpc_read_cycle,'0',' ')),' ','0') = 
			REPLACE(LTRIM(REPLACE(@ReadCycleID ,'0',' ')),' ','0')
		AND MRC.lpc_read_date > @InquiryDate
		AND MRC.lpc_isamr = @IsAmr
		AND MRC.statecode = 0
	ORDER BY
		ReadDate

	SET NOCOUNT OFF;

END
GO
