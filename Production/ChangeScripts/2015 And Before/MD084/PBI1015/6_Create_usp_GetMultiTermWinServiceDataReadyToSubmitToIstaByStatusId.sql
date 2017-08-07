USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId]    Script Date: 09/13/2012 15:45:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/07/2012>
-- Description:	<Select Records from MultiTermWinService table to be submitted to ISTA>
-- Description:	<Pulling just records having StartToSubmitDate<=today>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId] 
(
	@ProcessStatusId int
	,@SubmittionDate datetime
)

AS
BEGIN
	SET NOCOUNT ON;

    SELECT ID, LeadTime, StartToSubmitDate, ToBeExpiredAccountContactRateId, MeterReadDate, NewAccountContractRateId
			, RateEndDateAjustedByService, MultiTermWinServiceStatusId, ServiceLastRunDate
			, DateCreated, CreatedBy, DateModified, ModifiedBy
	FROM dbo.MultiTermWinServiceData with (nolock)
	WHERE MultiTermWinServiceStatusId=@ProcessStatusId
		AND StartToSubmitDate<=@SubmittionDate
END

GO

