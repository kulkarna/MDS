
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 2/01/2012
-- Description:	Add Re-Enrolled Account To Multi-Term service Processing Table
-- =============================================

CREATE PROCEDURE [dbo].[usp_AddRecordForReEnrolledAccountToMultiTermProcessingTable]
(
	@AccountIdLegacy varchar(12)
	, @ReenrollmentDate datetime
	, @SubmitterUserId int=1770
)

AS

DECLARE @CurrContractId int;
DECLARE @CurrAccountId int;
DECLARE @DaysAfterMeterDateDefault int;
DECLARE @DeenrollmentDate DateTime;
DECLARE @ContractStatusId int;

SET @DaysAfterMeterDateDefault=2;
SET @ContractStatusId=3;


BEGIN
	SET NOCOUNT ON;
	BEGIN TRAN
	BEGIN TRY 
		--Get De-enrollment date:
		SELECT @DeenrollmentDate=Max(AccSrvc.EndDate)
		FROM dbo.AccountService as AccSrvc with (nolock)
		WHERE AccSrvc.account_id=@AccountIdLegacy

		DECLARE @AccountContractId int
		DECLARE @DeenrollmentSubTermEndDate DateTime
		DECLARE @ReenrollmentSubTermEndDate DateTime
		DECLARE @ReenrollmentSubTermStartDate DateTime
		DECLARE @DeenrollmentAccountContactRateId int
		DECLARE @ReenrollmentAccountContactRateId int

		SELECT @DeenrollmentSubTermEndDate=ACR.RateEnd,  @DeenrollmentAccountContactRateId=ACR.AccountContractRateId
		FROM [Libertypower].dbo.[AccountContractRate] ACR with (nolock)
		INNER JOIN [Libertypower].dbo.[AccountContract] AC with (nolock) ON AC.AccountContractID=ACR.AccountContractID
		INNER JOIN
		(
		  SELECT MAX(c.ContractID) as CurrContractId, a.AccountId as CurrAccountId
		  FROM [Libertypower].dbo.[Contract] c with (nolock)
			INNER JOIN [Libertypower].dbo.AccountContract ac with (nolock) ON ac.ContractID=c.ContractID
			INNER JOIN [Libertypower].dbo.Account a with (nolock) ON a.AccountID=ac.AccountID
			
		  WHERE a.AccountIdLegacy=@AccountIdLegacy
			and c.ContractStatusID = @ContractStatusId 
			and c.StartDate <= @ReenrollmentDate
		  Group By a.AccountId
		) Crnt ON Crnt.CurrContractId=AC.ContractId AND Crnt.CurrAccountId=AC.AccountId
		WHERE ACR.RateStart<=@DeenrollmentDate and ACR.RateEnd>@DeenrollmentDate
		
		--SELECT @DeenrollmentSubTermEndDate as DeenrollmentSubTermEndDate, @DeenrollmentAccountContactRateId as DeenrollmentAccountContactRateId
		
		  
		SELECT @ReenrollmentSubTermStartDate = ACR.RateStart, @ReenrollmentSubTermEndDate=ACR.RateEnd,  @ReenrollmentAccountContactRateId=ACR.AccountContractRateId, @AccountContractId=ACR.AccountContractId
		FROM [Libertypower].dbo.[AccountContractRate] ACR with (nolock)
		INNER JOIN [Libertypower].dbo.[AccountContract] AC with (nolock) ON AC.AccountContractID=ACR.AccountContractID
		INNER JOIN
		(
		  SELECT MAX(c.ContractID) as CurrContractId, a.AccountId as CurrAccountId
		  FROM [Libertypower].dbo.[Contract] c with (nolock)
			INNER JOIN [Libertypower].dbo.AccountContract ac with (nolock) ON ac.ContractID=c.ContractID
			INNER JOIN [Libertypower].dbo.Account a with (nolock) ON a.AccountID=ac.AccountID
			
		  WHERE a.AccountIdLegacy=@AccountIdLegacy
			and c.ContractStatusID = 3 
			and c.StartDate <= @ReenrollmentDate
		  Group By a.AccountId
		) Crnt ON Crnt.CurrContractId=AC.ContractId AND Crnt.CurrAccountId=AC.AccountId
		WHERE ACR.RateStart<=@ReenrollmentDate and ACR.RateEnd>@ReenrollmentDate
		
		--SELECT @ReenrollmentSubTermStartDate as ReenrollmentSubTermStartDate, @ReenrollmentSubTermEndDate as ReenrollmentSubTermEndDate
		--, @ReenrollmentAccountContactRateId as ReenrollmentAccountContactRateId, @AccountContractId as AccountContractId
		

		DECLARE @FollowingReenrollmentMeterDate as DateTime
		DECLARE @MeterDateForReenrollmentSubTermStartDate as DateTime
		DECLARE @MeterDateForReenrollmentSubTermEndDate as DateTime
		DECLARE @FollowingAccountContactRateId int
		 
		-- Make adjustment of RateEnd Date of following after ReenrollmentDate and following (if it is exists) RateStart Date into AccountContractRate table
		SELECT @MeterDateForReenrollmentSubTermStartDate=lp_c_mrc.read_date
		FROM LibertyPower..Account a with (nolock)
			INNER JOIN LibertyPower..Utility u with (nolock)
				on u.ID=a.UtilityID
			INNER JOIN LibertyPower..AccountContract ac with (nolock)
				on a.AccountID=ac.AccountID
			INNER JOIN LibertyPower..[Contract] c with (nolock)
				on c.ContractID=ac.ContractID
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				on accsts.AccountContractID=ac.AccountContractID 
			INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
				on ac.AccountContractID = acr.AccountContractID 
			LEFT OUTER JOIN 
			(
				SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
				FROM Lp_common.dbo.meter_read_calendar with (nolock)
				GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
			) lp_c_mrc
			ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(ACR.RateStart) and lp_c_mrc.calendar_month=MONTH(ACR.RateStart)
		WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId

		DECLARE @Msg varchar(200);
		IF (@MeterDateForReenrollmentSubTermStartDate is null)
		BEGIN
			SET @Msg='The meter date does not exists for ReenrollmentSubTermStartDate=' + Convert(varchar(10),@ReenrollmentSubTermStartDate,101) + '.'
			RAISERROR (@Msg , 11, 1);
		END

		SELECT @MeterDateForReenrollmentSubTermEndDate=lp_c_mrc.read_date
		FROM LibertyPower..Account a with (nolock)
			INNER JOIN LibertyPower..Utility u with (nolock)
				on u.ID=a.UtilityID
			INNER JOIN LibertyPower..AccountContract ac with (nolock)
				on a.AccountID=ac.AccountID
			INNER JOIN LibertyPower..[Contract] c with (nolock)
				on c.ContractID=ac.ContractID
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				on accsts.AccountContractID=ac.AccountContractID 
			INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
				on ac.AccountContractID = acr.AccountContractID 
			LEFT OUTER JOIN 
			(
				SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
				FROM Lp_common.dbo.meter_read_calendar with (nolock)
				GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
			) lp_c_mrc
			ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(ACR.RateEnd) and lp_c_mrc.calendar_month=MONTH(ACR.RateEnd)
		WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId

		IF (@MeterDateForReenrollmentSubTermEndDate is null)
		BEGIN
			SET @Msg='The meter date does not exists for ReenrollmentSubTermEndDate=' + Convert(varchar(10),@ReenrollmentSubTermEndDate,101) +'.'
			RAISERROR ( @Msg, 11, 1);
		END
		
		--Used just test. Should be removed [Lev Rosenblum 2/6/2013]
		--SELECT @MeterDateForReenrollmentSubTermStartDate as MeterDateForReenrollmentSubTermStartDate, @MeterDateForReenrollmentSubTermEndDate as MeterDateForReenrollmentSubTermEndDate
		--, @ReenrollmentSubTermEndDate as ReenrollmentSubTermEndDate, @DeenrollmentAccountContactRateId as DeenrollmentAccountContactRateId, @ReenrollmentAccountContactRateId as ReenrollmentAccountContactRateId
		--, @AccountContractId as AccountContractId

			
		IF (@DeenrollmentAccountContactRateId <= @ReenrollmentAccountContactRateId)
		BEGIN
			IF (@MeterDateForReenrollmentSubTermEndDate!=@ReenrollmentSubTermEndDate)
			BEGIN
				DECLARE @AccountContractRateId int
				
				SELECT @AccountContractRateId=Min(AccountContractRateId)
				FROM LibertyPower.dbo.AccountContractRate with (nolock)
				WHERE AccountContractID=@AccountContractId and RateStart>@ReenrollmentSubTermEndDate
				
				--TODO: Add later in BEGIN/COMMIT/ROLLBACK transaction
				---------------------------------------------------------
				UPDATE LibertyPower.dbo.AccountContractRate
				SET RateEnd=@MeterDateForReenrollmentSubTermEndDate
				WHERE AccountContractRateId=@ReenrollmentAccountContactRateId		
				IF (@AccountContractRateId>0)
				BEGIN
					UPDATE LibertyPower.dbo.AccountContractRate
					SET RateStart=DATEADD(d,1,@MeterDateForReenrollmentSubTermEndDate)
					WHERE AccountContractRateId=@AccountContractRateId	
				END
				---------------------------------------------------------	
			END
		--  ELSE
		--		Do Nothing
		END
		--ELSE
		--	Imposiable case


		
		 /* Below the RateEnd and RateStart date are corresponding the MeterDates */ 

		DECLARE @FollowingMeterDate DateTime;
		SELECT @FollowingMeterDate=lp_c_mrc.read_date
		FROM LibertyPower..Account a with (nolock)
			INNER JOIN LibertyPower..Utility u with (nolock)
				on u.ID=a.UtilityID
			INNER JOIN LibertyPower..AccountContract ac with (nolock)
				on a.AccountID=ac.AccountID
			INNER JOIN LibertyPower..[Contract] c with (nolock)
				on c.ContractID=ac.ContractID
			INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
				on accsts.AccountContractID=ac.AccountContractID 
			INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
				on ac.AccountContractID = acr.AccountContractID 
			LEFT OUTER JOIN 
			(
				SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
				FROM Lp_common.dbo.meter_read_calendar with (nolock)
				GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
			) lp_c_mrc
			ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(@ReenrollmentDate) and lp_c_mrc.calendar_month=MONTH(@ReenrollmentDate)
		WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId
		
		IF (@FollowingMeterDate<@ReenrollmentDate)
		BEGIN
			DECLARE @CalendarYear int
			DECLARE @CalendarMonth int
			SET @CalendarMonth=MONTH(@ReenrollmentDate)
			IF (@CalendarMonth<12)
			BEGIN
				SET @CalendarMonth=@CalendarMonth + 1
				SET @CalendarYear=Year(@ReenrollmentDate)
			END
			ELSE
			BEGIN
				SET @CalendarMonth=1
				SET @CalendarYear=Year(@ReenrollmentDate)+1
			END
			
			SELECT @FollowingMeterDate=lp_c_mrc.read_date
			FROM LibertyPower..Account a with (nolock)
				INNER JOIN LibertyPower..Utility u with (nolock)
					on u.ID=a.UtilityID
				INNER JOIN LibertyPower..AccountContract ac with (nolock)
					on a.AccountID=ac.AccountID
				INNER JOIN LibertyPower..[Contract] c with (nolock)
					on c.ContractID=ac.ContractID
				INNER JOIN LibertyPower..AccountStatus accsts with (nolock)
					on accsts.AccountContractID=ac.AccountContractID 
				INNER JOIN LibertyPower..AccountContractRate acr with (nolock)
					on ac.AccountContractID = acr.AccountContractID 
				LEFT OUTER JOIN 
				(
					SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
					FROM Lp_common.dbo.meter_read_calendar with (nolock)
					GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
				) lp_c_mrc
				ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=@CalendarYear and lp_c_mrc.calendar_month=@CalendarMonth
			WHERE acr.AccountContractRateID=@ReenrollmentAccountContactRateId
		END
		
		IF (@FollowingMeterDate IS NULL)
		BEGIN
			SET @Msg='The following meter date does not exists for reenrollmentdate=' + Convert(varchar(10),@ReenrollmentDate,101) +'.';
			RAISERROR (@Msg, 11, 1);
		END
		 
		IF (@DeenrollmentAccountContactRateId=@ReenrollmentAccountContactRateId)
		BEGIN
			IF (DateDiff(d, @FollowingMeterDate, @ReenrollmentSubTermEndDate)<=1) 
			BEGIN
				IF NOT EXISTS
				(
					SELECT ACR.AccountContractRateId
					FROM [Libertypower].dbo.AccountContractRate ACR with (nolock)
						INNER JOIN [Libertypower].dbo.MultiTermWinServiceData MTWSD with (nolock)
							ON MTWSD.ToBeExpiredAccountContactRateId=ACR.AccountContractRateID
					WHERE ACR.AccountContractId=@AccountContractId
				)
				BEGIN
				 EXEC [Libertypower].[dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollment] 
				 @NumberDaysAfterMeterDateToIstaSubmission=@DaysAfterMeterDateDefault, @UserId=@SubmitterUserId
				 , @AccountContractRateId = @ReenrollmentAccountContactRateId, @ReenrollmentDate=@ReenrollmentDate
				END
				--ELSE --TODO: DoNothing
			END
			--ELSE --TODO: DoNothing
		END
		ELSE
		BEGIN	
			IF (DateDiff(d, @FollowingMeterDate, @ReenrollmentSubTermEndDate)<=1)
			BEGIN 
				BEGIN
					IF NOT EXISTS
					(
						SELECT ACR.AccountContractRateId
						FROM [Libertypower].dbo.AccountContractRate ACR with (nolock)
							INNER JOIN [Libertypower].dbo.MultiTermWinServiceData MTWSD with (nolock)
								ON MTWSD.ToBeExpiredAccountContactRateId=ACR.AccountContractRateId
						WHERE ACR.AccountContractId=@AccountContractId
							-- 
					)
					BEGIN
					 EXEC [Libertypower].[dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollment] 
					 @NumberDaysAfterMeterDateToIstaSubmission=@DaysAfterMeterDateDefault, @UserId=@SubmitterUserId
					 , @AccountContractRateId = @ReenrollmentAccountContactRateId, @ReenrollmentDate=@ReenrollmentDate
					END
					--ELSE --TODO: DoNothing
				END
			END
			ELSE
			BEGIN
				BEGIN
					IF NOT EXISTS
					(
						SELECT ACR.AccountContractRateId
						FROM [Libertypower].dbo.AccountContractRate ACR with (nolock)
							INNER JOIN [Libertypower].dbo.MultiTermWinServiceData MTWSD with (nolock)
								ON MTWSD.NewAccountContractRateId=ACR.AccountContractRateId
						WHERE ACR.AccountContractId=@AccountContractId
							-- 
					)
					BEGIN
					 EXEC [Libertypower].[dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollmentOverloaded] 
					 @NumberDaysAfterMeterDateToIstaSubmission=@DaysAfterMeterDateDefault, @UserId=@SubmitterUserId
					 , @AccountContractRateId = @ReenrollmentAccountContactRateId, @ReenrollmentFollowingMeterDate=@FollowingMeterDate, @ReenrollmentDate=@ReenrollmentDate
					END
					--ELSE --TODO: DoNothing
				END
			END
		END
		COMMIT TRAN
		Return 0;
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage,@ErrorSeverity, @ErrorState);
		Return 1;
	END CATCH
END
