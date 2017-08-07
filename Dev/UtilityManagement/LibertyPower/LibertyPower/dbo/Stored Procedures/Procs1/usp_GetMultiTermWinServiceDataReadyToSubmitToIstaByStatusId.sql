
-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/07/2012>
-- Description:	<Select Records from MultiTermWinService table to be submitted to ISTA>
-- Description:	<Pulling just records having StartToSubmitDate<=today>
-- =============================================
-- Modified by Lev Rosenblum at 11/5/2012 rework for PBI1015
-- Process just records having currently accountStatus not in de-enrolled status 
-- =============================================

CREATE PROCEDURE [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId] 
(
	@ProcessStatusId int
	,@SubmittionDate datetime
)

AS

DECLARE @DeEnrollmentAccountContractStatusNumber varchar(15)
, @MultiTermWinServiceStatusId int

SET @DeEnrollmentAccountContractStatusNumber='911000'--'account DE-ENROLLED'
SET @MultiTermWinServiceStatusId=8--MultiTermWinServiceStatus.Name='NotSubmittedToESTADueToDeEnrollment'

BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION;
	BEGIN TRY

		UPDATE dbo.MultiTermWinServiceData
		SET MultiTermWinServiceStatusId = @MultiTermWinServiceStatusId
		FROM dbo.MultiTermWinServiceData mtwsd with (nolock)
			INNER JOIN dbo.AccountContractRate acr with (nolock) 
				ON acr.AccountContractRateID=mtwsd.ToBeExpiredAccountContactRateId
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				ON accsts.AccountContractID=acr.AccountContractID
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			AND accsts.[Status]=@DeEnrollmentAccountContractStatusNumber
			

		SELECT mtwsd.ID, mtwsd.LeadTime, mtwsd.StartToSubmitDate, mtwsd.ToBeExpiredAccountContactRateId, mtwsd.MeterReadDate, mtwsd.NewAccountContractRateId
				, mtwsd.RateEndDateAjustedByService, mtwsd.MultiTermWinServiceStatusId, mtwsd.ServiceLastRunDate
				, mtwsd.DateCreated, mtwsd.CreatedBy, mtwsd.DateModified, mtwsd.ModifiedBy, mtwsd.ReenrollmentFollowingMeterDate, convert(bit,1) as UpdateSucceeded
		FROM dbo.MultiTermWinServiceData mtwsd with (nolock) 
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate

		COMMIT TRANSACTION;
			
	END TRY
	
	BEGIN CATCH

		SELECT mtwsd.ID, mtwsd.LeadTime, mtwsd.StartToSubmitDate, mtwsd.ToBeExpiredAccountContactRateId, mtwsd.MeterReadDate, mtwsd.NewAccountContractRateId
				, mtwsd.RateEndDateAjustedByService, mtwsd.MultiTermWinServiceStatusId, mtwsd.ServiceLastRunDate
				, mtwsd.DateCreated, mtwsd.CreatedBy, mtwsd.DateModified, mtwsd.ModifiedBy, mtwsd.ReenrollmentFollowingMeterDate, convert(bit,0) as UpdateSucceeded
		FROM dbo.MultiTermWinServiceData mtwsd with (nolock) 
			INNER JOIN dbo.AccountContractRate acr with (nolock) 
				ON acr.AccountContractRateID=mtwsd.ToBeExpiredAccountContactRateId
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				ON accsts.AccountContractID=acr.AccountContractID
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			AND accsts.[Status]!=@DeEnrollmentAccountContractStatusNumber

		ROLLBACK TRANSACTION;
	END CATCH
	
END
