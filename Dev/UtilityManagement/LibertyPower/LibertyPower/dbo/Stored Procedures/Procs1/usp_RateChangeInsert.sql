

CREATE PROCEDURE [dbo].[usp_RateChangeInsert]
(
	@AccountNumber [varchar](50),
	@EffectiveBillingCycleStart datetime,
	@EffectiveBillingCycleEnd datetime,
	@EffectiveDate datetime,
	@Usage decimal(18,10) = NULL,
	@AverageEnergy decimal(18,10) = NULL,
	@AncillaryService decimal(18,10) = NULL,
	@OtherAncillary decimal(18,10) = NULL,
	@RPSPrice decimal(18,10) = NULL,
	@Energy decimal(18,10) = NULL,
	@EnergyLoss decimal(18,10) = NULL,
	@Ucap decimal(18,10) = NULL,
	@Tcap decimal(18,10) = NULL,
	@IcapMethod int,
	@IcapScalar decimal(18,10) = NULL,
	@TcapMethod int,
	@TcapScalar decimal(18,10) = NULL,
	@BillingTransactionFee decimal(18,10) = NULL,
	@ARRCharge decimal(18,10) = NULL,
	@MiscAdder decimal(18,10) = NULL,
	@VREEngineVersion varchar(50),
	@Markup decimal(18,10),
	@MeterType [varchar](50) = NULL,
	@PreviousRate decimal(18,10),
	@Rate decimal(18,10),
	@RateCode [varchar](50) = NULL,
	@RateUpdateType [int],
	@ServiceClass [varchar](50) = NULL,
	@UtilityID [varchar](50),
	@Zone [varchar](50) = NULL,
	@ContextDate datetime = NULL,
	@FileGuid [uniqueidentifier],
	@Status [int],
	@StatusNotes [varchar](512) = NULL,
	@RateChangeQueueID int = NULL,
	@CreatedBy [int],
	@RawStartingDate DateTime = NULL,
	@RawEndingDate DateTime = NULL,
	@PlanType int = NULL,
	@DateFrom1ReadBack	datetime = NULL,
	@DateTo1ReadBack datetime = NULL,
	@PastUsage1 decimal(18, 10) = NULL,
	@DateFrom2ReadBack	datetime = NULL,
	@DateTo2ReadBack datetime = NULL,
	@PastUsage2 decimal(18, 10) = NULL,
	@DateFrom3ReadBack	datetime = NULL,
	@DateTo3ReadBack datetime = NULL,
	@PastUsage3 decimal(18, 10) = NULL,
	@SplitDate datetime = null,
	@IsRateReady bit = NULL,
	@VreAccountTypeID int = NULL,
	@SimpleIndexAdder decimal(18, 10) = 0
 )
 
AS

BEGIN
  SET NOCOUNT ON ;

  DECLARE @Status_Processing int
  DECLARE @Status_Unsent int
  DECLARE @Status_Failed int
  DECLARE @Status_Accepted int

  SET @Status_Processing = 3
  SET @Status_Unsent = 0
  SET @Status_Failed = 2
  SET @Status_Accepted = 1

  DECLARE @ID int

	IF @Status = @Status_Unsent and 
	   Exists ( SELECT
					   [ID]
				   FROM
					   [RateChange]
				   WHERE
					   [AccountNumber] = @AccountNumber
					   AND [UtilityID] = @UtilityID
					   AND [RateUpdateType] = @RateUpdateType
					   AND [EffectiveBillingCycleStart] = @EffectiveBillingCycleStart
					   AND [EffectiveBillingCycleEnd] = @EffectiveBillingCycleEnd
					   AND ( [Status] IN ( @Status_Processing , @Status_Unsent )
							 OR ( [Status] = @Status_Accepted
								  AND CAST([DateModified] AS datetime) = CAST(GETDATE() AS datetime) )  -- Transactions done today
						   ) )
		 BEGIN
			-- THERE is a job for the same account already
		   SET @StatusNotes = 'Existing job in progress or Rate Update was already sent today.' ;
		   SET @Status = @Status_Failed ;
		 END

		INSERT INTO	[RateChange]
			([AccountNumber] , [EffectiveBillingCycleStart] , [EffectiveBillingCycleEnd] , [EffectiveDate] , [Usage] , [AverageEnergy] , [AncillaryService] , [OtherAncillary] , [RPSPrice] , [Energy] , [EnergyLoss] , [Ucap] , [Tcap] , [IcapMethod] , [IcapScalar] , [TcapMethod] , [TcapScalar] , [BillingTransactionFee] , [ARRCharge] , [MiscAdder] , [VREEngineVersion] , [ContextDate] , [Markup] , [MeterType] , [PreviousRate] , [Rate] , [RateCode] , [RateUpdateType] , [ServiceClass] , [UtilityID] , [Zone] , [FileGuid] , [Status] , [StatusNotes] , [RateChangeQueueID] , [CreatedBy] , [DateCreated] , [ModifiedBy] , [DateModified],[RawStartingDate],[RawEndingDate],[PlanType], [DateFrom1ReadBack],[DateTo1ReadBack],[PastUsage1],[DateFrom2ReadBack],[DateTo2ReadBack],[PastUsage2],[DateFrom3ReadBack],[DateTo3ReadBack],[PastUsage3],[SplitDate],[IsRateReady],[VreAccountTypeID],[SimpleIndexAdder])
		Values (@AccountNumber , @EffectiveBillingCycleStart , @EffectiveBillingCycleEnd , @EffectiveDate , @Usage , @AverageEnergy , @AncillaryService , @OtherAncillary , @RPSPrice , @Energy , @EnergyLoss , @Ucap , @Tcap , @IcapMethod , @IcapScalar , @TCapMethod , @TcapScalar , @BillingTransactionFee , @ARRCharge , @MiscAdder , @VREEngineVersion , @ContextDate , @Markup , @MeterType , @PreviousRate , @Rate , @RateCode , @RateUpdateType , @ServiceClass , @UtilityID , @Zone , @FileGuid , @Status , @StatusNotes , @RateChangeQueueID , @CreatedBy , GETDATE() , @CreatedBy , GETDATE(),@RawStartingDate,@RawEndingDate,@PlanType,@DateFrom1ReadBack,@DateTo1ReadBack,@PastUsage1,@DateFrom2ReadBack,@DateTo2ReadBack,@PastUsage2,@DateFrom3ReadBack,@DateTo3ReadBack,@PastUsage3,@SplitDate,@IsRateReady,@VreAccountTypeID,@SimpleIndexAdder)

	SET @ID = SCOPE_IDENTITY() ;

	  IF @ID IS NOT NULL
		 BEGIN
	   

			   SELECT
				   U.Firstname , U.Lastname , RC.*
			   FROM
				   [RateChange] RC
				   LEFT JOIN [User] U
				   ON  U.UserID = RC.CreatedBy
			   WHERE
				   RC.ID = @ID ;

		 END

END


