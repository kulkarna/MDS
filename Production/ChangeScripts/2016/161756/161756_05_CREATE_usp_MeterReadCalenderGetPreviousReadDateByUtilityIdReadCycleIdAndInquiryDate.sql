USE [DataSync]
GO
/****** Object:  StoredProcedure [dbo].[usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate]    Script Date: 01/13/2017 12:34:03 ******/
DROP PROCEDURE [dbo].[usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate]
GO
/****** Object:  StoredProcedure [dbo].[usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate]    Script Date: 01/13/2017 12:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************************************************************************************************
EXEC usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate
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


CREATE PROC [dbo].[usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate]
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
		AND MRC.lpc_read_date <= @InquiryDate
		AND MRC.lpc_isamr = @IsAmr
		AND MRC.statecode = 0
	ORDER BY
		ReadDate DESC

	SET NOCOUNT OFF;

END
GO
