USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId]    Script Date: 11/05/2012 13:14:16 ******/
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
-- Modified by Lev Rosenblum at 11/5/2012 rework for PBI1015
-- Process just records having currently accountStatus not in de-enrolled status 
-- =============================================

ALTER PROCEDURE [dbo].[usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId] 
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
		FROM dbo.MultiTermWinServiceData mtwsd with(nolock)
		INNER JOIN dbo.AccountContractRate acr with(nolock) ON acr.AccountContractRateID=mtwsd.ToBeExpiredAccountContactRateId
		INNER JOIN LibertyPower..AccountStatus accsts with(nolock)
			on accsts.AccountContractID=acr.AccountContractID
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			AND accsts.[Status]=@DeEnrollmentAccountContractStatusNumber
			

		SELECT mtwsd.ID, mtwsd.LeadTime, mtwsd.StartToSubmitDate, mtwsd.ToBeExpiredAccountContactRateId, mtwsd.MeterReadDate, mtwsd.NewAccountContractRateId
				, mtwsd.RateEndDateAjustedByService, mtwsd.MultiTermWinServiceStatusId, mtwsd.ServiceLastRunDate
				, mtwsd.DateCreated, mtwsd.CreatedBy, mtwsd.DateModified, mtwsd.ModifiedBy, convert(bit,1) as UpdateSucceeded
		FROM dbo.MultiTermWinServiceData mtwsd with(nolock) 
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			
	END TRY
	
	BEGIN CATCH

		SELECT mtwsd.ID, mtwsd.LeadTime, mtwsd.StartToSubmitDate, mtwsd.ToBeExpiredAccountContactRateId, mtwsd.MeterReadDate, mtwsd.NewAccountContractRateId
				, mtwsd.RateEndDateAjustedByService, mtwsd.MultiTermWinServiceStatusId, mtwsd.ServiceLastRunDate
				, mtwsd.DateCreated, mtwsd.CreatedBy, mtwsd.DateModified, mtwsd.ModifiedBy, convert(bit,0) as UpdateSucceeded
		FROM dbo.MultiTermWinServiceData mtwsd with(nolock) 
		INNER JOIN dbo.AccountContractRate acr with(nolock) ON acr.AccountContractRateID=mtwsd.ToBeExpiredAccountContactRateId
		INNER JOIN LibertyPower..AccountStatus accsts with(nolock)
			on accsts.AccountContractID=acr.AccountContractID
		WHERE MultiTermWinServiceStatusId=@ProcessStatusId
			AND StartToSubmitDate<=@SubmittionDate
			AND accsts.[Status]!=@DeEnrollmentAccountContractStatusNumber
		
		IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	
	END CATCH
	
	IF @@TRANCOUNT > 0
        COMMIT TRANSACTION;

END

