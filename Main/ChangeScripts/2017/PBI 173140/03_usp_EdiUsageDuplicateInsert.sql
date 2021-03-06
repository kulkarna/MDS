USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiUsageDuplicateInsert]    Script Date: 4/11/2017 10:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_EdiUsageDuplicateInsert
 * Insert usage from EDI file
 *
 * History
 *******************************************************************************
 * 06/29/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_EdiUsageDuplicateInsert]
	@EdiAccountID					int,
	@EdiFileLogID					int,
	@BeginDate						datetime,
	@EndDate						datetime,
	@Quantity						decimal(15,5),
	@MeterNumber					varchar(50),
	@MeasurementSignificanceCode	varchar(10),
	@TransactionSetPurposeCode		varchar(10),
	@UnitOfMeasurement				varchar(10),
	@ServiceDeliveryPoint			varchar(50) = NULL,
	@PTDLoop			            varchar(10) = NULL,
	@UsageType                      int,
	@HistoricalSection				varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@ID	BIGINT
	-- Identify whether  the exact same duplicate record already present.
			SELECT	@ID = ID
			FROM	EdiUsageDuplicate WITH (NOLOCK)
			WHERE	EdiAccountID				= @EdiAccountID
				AND	BeginDate					= @BeginDate
				AND	EndDate						= @EndDate
				AND	MeterNumber					= @MeterNumber
				AND Quantity                    = @Quantity
				AND	MeasurementSignificanceCode	= @MeasurementSignificanceCode
				AND	TransactionSetPurposeCode	= @TransactionSetPurposeCode
				AND	UnitOfMeasurement			= @UnitOfMeasurement
				AND	(ServiceDeliveryPoint		= @ServiceDeliveryPoint OR ServiceDeliveryPoint IS NULL)
				AND UsageType                   = @UsageType
				AND (PTDLoop                    = @PTDLoop OR PTDLoop IS NULL)
				AND EdiFileLogID                = @EdiFileLogID

			IF @ID IS NULL --If the Extact same row didn't already exist, Insert a new row. This will be later taken to be processed.

				BEGIN
					INSERT INTO	EdiUsageDuplicate(EdiAccountID, BeginDate, EndDate, Quantity, MeterNumber, MeasurementSignificanceCode,
											TransactionSetPurposeCode, UnitOfMeasurement, TimeStampInsert, ServiceDeliveryPoint,
											EdiFileLogID, PTDLoop, UsageType, HistoricalSection)
					VALUES					(@EdiAccountID, @BeginDate, @EndDate, @Quantity, @MeterNumber, @MeasurementSignificanceCode,
						 					@TransactionSetPurposeCode, @UnitOfMeasurement, GETDATE(), @ServiceDeliveryPoint,
											@EdiFileLogID,@PTDLoop, @UsageType, @HistoricalSection)
					SELECT	@ID = SCOPE_IDENTITY()
				END
			SELECT	ID = @ID;

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


