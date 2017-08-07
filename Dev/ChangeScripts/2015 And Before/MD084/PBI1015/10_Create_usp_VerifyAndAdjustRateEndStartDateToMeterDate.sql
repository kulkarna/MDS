USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VerifyAndAdjustRateEndStartDateToMeterDate]    Script Date: 09/13/2012 15:48:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/06/2012>
-- Description:	<Verify And Adjust RateEndDate and following RateStartDate To MeterDate>
-- =============================================
CREATE PROCEDURE [dbo].[usp_VerifyAndAdjustRateEndStartDateToMeterDate] 
(
	@UserId int
)
AS
DECLARE @PendingStatusId int;
DECLARE @RateEndStartDateToBeAjustedStatusId int;
DECLARE @ReadyToIstaStatusId int;
DECLARE @RateEndStartDateAjustedByService bit;

SET @PendingStatusId=1;
SET @RateEndStartDateToBeAjustedStatusId=2;
SET @ReadyToIstaStatusId=3;
SET @RateEndStartDateAjustedByService=1;

BEGIN
		--Only Records with NewAccountContractRateId is not null will be processed by this service otherwise it is

		--Update Status for records having a corrected oldRateEnd and newrateStart dates
		UPDATE dbo.MultiTermWinServiceData
		SET MultiTermWinServiceStatusId=@ReadyToIstaStatusId --Ready for Submit to ISTA
		, ModifiedBy=@UserId
		, DateModified=GETDATE() 
		WHERE ID IN
		(
		SELECT sl.ID as RecordId
		FROM dbo.MultiTermWinServiceData as sl
			INNER JOIN dbo.AccountContractRate acrOld 
				ON acrOld.AccountContractRateID=sl.ToBeExpiredAccountContactRateId
			INNER JOIN dbo.AccountContractRate acrNew 
				ON acrNew.AccountContractRateID=sl.NewAccountContractRateId
		WHERE sl.MultiTermWinServiceStatusId=@PendingStatusId and sl.MeterReadDate=acrOld.RateEnd 
			and acrNew.RateStart=DATEADD(D,1,acrOld.RateEnd)
		)

		--Update Status for records where oldRateEnd and newrateStart dates should be corrected
		UPDATE dbo.MultiTermWinServiceData
		SET MultiTermWinServiceStatusId=@RateEndStartDateToBeAjustedStatusId --RateEndDate and Following RateStartDate Selected for Adjustment
		, ModifiedBy=@UserId
		, DateModified=GETDATE()
		WHERE ID IN
		(
		SELECT sl.ID as RecordId
		FROM dbo.MultiTermWinServiceData as sl with(nolock)
			INNER JOIN dbo.AccountContractRate acrOld with(nolock)
				ON acrOld.AccountContractRateID=sl.ToBeExpiredAccountContactRateId
			INNER JOIN dbo.AccountContractRate acrNew with(nolock)
				ON acrNew.AccountContractRateID=sl.NewAccountContractRateId
		WHERE sl.MultiTermWinServiceStatusId=@PendingStatusId and sl.MeterReadDate!=acrOld.RateEnd 
			and acrNew.RateStart=DATEADD(D,1,acrOld.RateEnd)
		)

		BEGIN TRAN
		--Update RateEndDate in accordingly with MeterReadDate:
		UPDATE dbo.AccountContractRate 
		SET RateEnd=sl.MeterReadDate
			, ModifiedBy=@UserId
			, Modified=GETDATE()
		FROM dbo.MultiTermWinServiceData as sl
			INNER JOIN dbo.AccountContractRate acrOld 
				ON acrOld.AccountContractRateID=sl.ToBeExpiredAccountContactRateId
		WHERE (sl.MultiTermWinServiceStatusId=@RateEndStartDateToBeAjustedStatusId) and (sl.MeterReadDate!=acrOld.RateEnd)
		IF @@ERROR<>0 GOTO onError
		
		--Update following RateStartDate in accordingly with MeterReadDate:
		UPDATE dbo.AccountContractRate 
		SET RateStart=DATEADD(d,1,sl.MeterReadDate)
			, ModifiedBy=@UserId
			, Modified=GETDATE()
		FROM dbo.MultiTermWinServiceData as sl
			INNER JOIN dbo.AccountContractRate acrNew 
				ON acrNew.AccountContractRateID=sl.NewAccountContractRateId
		WHERE (sl.MultiTermWinServiceStatusId=@RateEndStartDateToBeAjustedStatusId) and (DATEADD(d,1,sl.MeterReadDate)!=acrNew.RateStart)
		IF @@ERROR<>0 GOTO onError

		--Update Status for records having a corrected oldRateEnd and newrateStart dates
		UPDATE dbo.MultiTermWinServiceData
		SET MultiTermWinServiceStatusId=@ReadyToIstaStatusId		--Ready for Submit to ISTA
			, RateEndDateAjustedByService=@RateEndStartDateAjustedByService	--RateEndDate and Following RateStartDate have been Adjusted
			, ModifiedBy=@UserId
			, DateModified=GETDATE()
		WHERE ID IN
		(
		SELECT sl.ID as RecordId
		FROM dbo.MultiTermWinServiceData as sl with(nolock)
			INNER JOIN dbo.AccountContractRate acrOld with(nolock)
				ON acrOld.AccountContractRateID=sl.ToBeExpiredAccountContactRateId
			INNER JOIN dbo.AccountContractRate acrNew with(nolock)
				ON acrNew.AccountContractRateID=sl.NewAccountContractRateId
		WHERE sl.MultiTermWinServiceStatusId=@RateEndStartDateToBeAjustedStatusId and sl.MeterReadDate=acrOld.RateEnd 
			and acrNew.RateStart=DATEADD(D,1,acrOld.RateEnd)
		)
		IF @@ERROR<>0 GOTO onError
		
		COMMIT TRAN
		RETURN;
		
		onError:
		ROLLBACK TRAN
		RETURN;
END

GO

