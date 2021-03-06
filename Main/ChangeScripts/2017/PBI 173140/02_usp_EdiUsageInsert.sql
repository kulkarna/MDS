USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiUsageInsert]    Script Date: 4/10/2017 2:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_EdiUsageInsert
 * Insert usage from EDI file
 *
 * History
 *******************************************************************************
 * 3/25/2010 - Rick Deigsler
 * Created.
 * Modified. for the files parsed from Edi process, Redirected to a new process
 * so that, it will do a duplicate elimnation and  combine multiple data records
 * comes in the file. Did this re-direction because don't want to affect other flow 
 * with the Change, as the  changes were across the file 
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_EdiUsageInsert]
	@EdiAccountID					int,
	@EdiFileLogID					int,
	@BeginDate						datetime,
	@EndDate						datetime,
	@Quantity						decimal(15,5),
	@MeterNumber					varchar(50),
	@MeasurementSignificanceCode	varchar(10),
	@TransactionSetPurposeCode		varchar(10),
	@UnitOfMeasurement				varchar(10),
	@ServiceDeliveryPoint			varchar(50),
	@HistoricalSection				varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	  
	   DECLARE	@ID	BIGINT 

		SELECT	@ID = ID
		FROM	EdiUsage WITH (NOLOCK)
		WHERE	EdiAccountID				= @EdiAccountID
			AND	BeginDate					= @BeginDate
			AND	EndDate						= @EndDate
			AND	MeterNumber					= @MeterNumber
			AND	MeasurementSignificanceCode	= @MeasurementSignificanceCode
			AND	TransactionSetPurposeCode	= @TransactionSetPurposeCode
			AND	UnitOfMeasurement			= @UnitOfMeasurement
			AND	(ServiceDeliveryPoint		= @ServiceDeliveryPoint OR ServiceDeliveryPoint IS NULL)

		IF @ID IS NOT NULL
			BEGIN
				UPDATE	EdiUsage
				SET		Quantity		= @Quantity,
						EdiFileLogID	= @EdiFileLogID,
						TimeStampUpdate	= GETDATE(),
						HistoricalSection = @HistoricalSection
				WHERE	ID				= @ID

				SELECT	ID	= @ID
			END
		ELSE
			BEGIN
				INSERT INTO	EdiUsage	(EdiAccountID, BeginDate, EndDate, Quantity, MeterNumber, MeasurementSignificanceCode,
										TransactionSetPurposeCode, UnitOfMeasurement, TimeStampInsert, ServiceDeliveryPoint, HistoricalSection,
										EdiFileLogID)
				VALUES					(@EdiAccountID, @BeginDate, @EndDate, @Quantity, @MeterNumber, @MeasurementSignificanceCode,
										@TransactionSetPurposeCode, @UnitOfMeasurement, GETDATE(), @ServiceDeliveryPoint, @HistoricalSection,
										@EdiFileLogID)
				SELECT	ID = SCOPE_IDENTITY()
			END

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

