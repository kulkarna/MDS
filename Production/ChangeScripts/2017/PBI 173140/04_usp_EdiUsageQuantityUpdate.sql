USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiUsageQuantityUpdate]    Script Date: 4/10/2017 11:11:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************
 * usp_EdiUsageQuantityUpdate
 * The Purpose of this Procedure is to do a calcualted update on the usage quantity,
 * if more than one valid quantity came in file for the same interval.This program 
 * will be called after the file is parsed.
 * History
 *******************************************************************************
 * 06/29/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 * 26/04/2017 - Ayane Suarez
 * Updated. Getting use of new Historical section column to distinguiss between
 * historical transactions.
 */

ALTER PROCEDURE [dbo].[usp_EdiUsageQuantityUpdate]
	@EdiFileLogID	int
AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE	@Today datetime
		,@Loop					INT
		,@MaxLoop				INT
		SET  @Today = GETDATE();
		DECLARE @UsageId  INT  = 0;
		DECLARE @UsageDetailId  INT  = 0;
		DECLARE @OldEdiFileLogId  INT  = 0;
		DECLARE @HistoricalSection VARCHAR(10);
		DECLARE @OldHistoricalSection VARCHAR(10);
		
		--Declare a temp table For EDIUsage
		DECLARE @UsageDup	TABLE (					
            [ID] [bigint] IDENTITY(1,1) NOT NULL,
			[EdiAccountID] [int] NULL,
			[BeginDate] [datetime] NULL,
			[EndDate] [datetime] NULL,
			[Quantity] [decimal](15, 5) NULL,
			[MeterNumber] [varchar](50) NULL,
			[MeasurementSignificanceCode] [varchar](10) NULL,
			[TransactionSetPurposeCode] [varchar](10) NULL,
			[UnitOfMeasurement] [varchar](10) NULL,
			[EdiFileLogID] [int] NULL,
			[ServiceDeliveryPoint] [varchar](50) NULL,
			[UsageType] [int] NULL,
			[HistoricalSection] [varchar](10) NULL)

		---Create a Duplicate table for UsageDetail
		DECLARE @UsageDetailDup	TABLE (					
            [ID] [bigint] IDENTITY(1,1) NOT NULL,
			[EdiAccountID] [int] NULL,
			[BeginDate] [datetime] NULL,
			[EndDate] [datetime] NULL,
			[Quantity] [decimal](15, 5) NULL,
			[MeterNumber] [varchar](50) NULL,
			[MeasurementSignificanceCode] [varchar](10) NULL,
			[TransactionSetPurposeCode] [varchar](10) NULL,
			[UnitOfMeasurement] [varchar](10) NULL,
			[EdiFileLogID] [int] NULL,
			[ServiceDeliveryPoint] [varchar](50) NULL,
			[PTDLoop] [varchar](10) NULL,
			[UsageType] [int] NULL)

        ---Process the Data from EdiUsageTable
		INSERT INTO @UsageDup
		SELECT  EdiAccountID,
			BeginDate,
			EndDate,
			Quantity,
			MeterNumber,
			MeasurementSignificanceCode,
			TransactionSetPurposeCode,
			UnitOfMeasurement,
			EdiFileLogID,
			ServiceDeliveryPoint,
			UsageType,
			HistoricalSection
		FROM  EdiUsageDuplicate(nolock) a
		WHERE a.EdiFileLogID = @EdiFileLogID  
			AND a.UsageType  = 1


        IF @@ROWCOUNT > 0
		    SET @Loop		= 1;
			SELECT @MaxLoop		= (SELECT MAX(ID) from  @UsageDup)
            
			WHILE @Loop		<= @MaxLoop	
			   BEGIN
				    SELECT @UsageId = eu.Id, 
						   @OldEdiFileLogId = eu.EdiFileLogID,
						   @OldHistoricalSection = eu.HistoricalSection,
						   @HistoricalSection = eud.HistoricalSection
			      	FROM		EdiUsage eu WITH (NOLOCK)
					INNER JOIN	@UsageDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
								 AND	eu.BeginDate					=eud.BeginDate
								 AND	eu.EndDate						= eud.EndDate
								 --AND    eu.EdiFileLogID                = eud.EdiFileLogID
								 AND	eu.MeterNumber					= eud.MeterNumber
								 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
								 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
								 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
								 AND	(eu.ServiceDeliveryPoint		= eud.ServiceDeliveryPoint OR eud.ServiceDeliveryPoint IS NULL)
					 WHERE		eud.ID = @Loop

                    ---IF same FilelogId and HistoricalSection - Add up the quantity and update the record
					IF(( @UsageId > 0) AND (@OldEdiFileLogId = @EdiFileLogID) AND (@OldHistoricalSection = @HistoricalSection)) 
					     BEGIN
						   UPDATE EdiUsage
							SET			Quantity = eu.Quantity + eud.Quantity,
										EdiFileLogID = @EdiFileLogID,
										TimeStampUpdate	= @Today
							FROM		EdiUsage eu WITH (NOLOCK)
							INNER JOIN	@UsageDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
										 AND	eu.BeginDate					=eud.BeginDate
										 AND	eu.EndDate						= eud.EndDate
										 AND    eu.EdiFileLogID                = eud.EdiFileLogID
										 AND	eu.MeterNumber					= eud.MeterNumber
										 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
										 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
										 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
										 AND	(eu.ServiceDeliveryPoint		= eud.ServiceDeliveryPoint OR eud.ServiceDeliveryPoint IS NULL)
										 AND	eu.HistoricalSection			= eud.HistoricalSection
							 WHERE		eud.ID = @Loop;

							 SELECT	ID = @UsageId;
						 END
                     --- Here there  may be  a row Exists to be added but later changed to be updated as exact duplicate.
					 ELSE IF(( @UsageId > 0) AND (@OldEdiFileLogId != @EdiFileLogID))
					      BEGIN
						   UPDATE EdiUsage
							SET			Quantity =  eud.Quantity,
										EdiFileLogID = @EdiFileLogID,
										TimeStampUpdate	= @Today
							FROM		EdiUsage eu WITH (NOLOCK)
							INNER JOIN	@UsageDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
										 AND	eu.BeginDate					=eud.BeginDate
										 AND	eu.EndDate						= eud.EndDate
										 AND    eu.EdiFileLogID                = @OldEdiFileLogId
										 AND	eu.MeterNumber					= eud.MeterNumber
										 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
										 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
										 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
										 AND	(eu.ServiceDeliveryPoint		= eud.ServiceDeliveryPoint OR eud.ServiceDeliveryPoint IS NULL)
							 WHERE		eud.ID = @Loop;

							 SELECT	ID = @UsageId;
						 END
					 
					 --
					 ELSE IF (( @UsageId > 0) AND (@OldEdiFileLogId = @EdiFileLogID) AND (@HistoricalSection = 'HU'))
						BEGIN
							UPDATE EdiUsage
								SET		Quantity =  eud.Quantity,
										TimeStampUpdate	= @Today,
										HistoricalSection = @HistoricalSection
								FROM	EdiUsage eu WITH (NOLOCK)
								INNER JOIN	@UsageDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
										 AND	eu.BeginDate					=eud.BeginDate
										 AND	eu.EndDate						= eud.EndDate
										 AND    eu.EdiFileLogID                = eud.EdiFileLogID
										 AND	eu.MeterNumber					= eud.MeterNumber
										 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
										 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
										 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
										 AND	(eu.ServiceDeliveryPoint		= eud.ServiceDeliveryPoint OR eud.ServiceDeliveryPoint IS NULL)
										 AND	eu.HistoricalSection			<> eud.HistoricalSection
							 WHERE		eud.ID = @Loop;
							 SELECT	ID = @UsageId;
						END
					 	
                     ELSE  --Insert the row as a new row.
						BEGIN						

							     INSERT INTO	EdiUsage 
								   SELECT EdiAccountID,
										BeginDate,
										EndDate,
										Quantity,
										MeterNumber,
										MeasurementSignificanceCode,
										TransactionSetPurposeCode,
										UnitOfMeasurement,
										GETDATE(),
										GETDATE(), 
										EdiFileLogID,
										ServiceDeliveryPoint,
										HistoricalSection
									FROM  @UsageDup
									WHERE ID = @Loop AND HistoricalSection <> 'HI';
										 
							       SELECT	ID = SCOPE_IDENTITY()
					    END

					SET @Loop		= @Loop + 1
					
			   END
----Update EdiUsageDetail Table if there is any record Exist to Update.		   
	  
	   INSERT INTO @UsageDetailDup
		    SELECT  EdiAccountID,
				BeginDate,
				EndDate,
				Quantity,
				MeterNumber,
				MeasurementSignificanceCode,
				TransactionSetPurposeCode,
				UnitOfMeasurement,
				EdiFileLogID,
				ServiceDeliveryPoint,
				PTDLoop,
				UsageType
			FROM  EdiUsageDuplicate(nolock) a
			WHERE a.EdiFileLogID = @EdiFileLogID
				AND a.UsageType  = 2

			IF @@ROWCOUNT > 0
					 SET @Loop		= 1;
					 SELECT @MaxLoop		= (SELECT MAX(ID) from  @UsageDetailDup)

						WHILE @Loop		<= @MaxLoop
						   BEGIN
						   ---Update the EDIUsage  Table with calculated Quantity.

						            SELECT  @UsageDetailId  = eu.Id, @OldEdiFileLogId = eu.EdiFileLogID
									FROM		EdiUsageDetail eu WITH (NOLOCK)
									INNER JOIN	@UsageDetailDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
												 AND	eu.BeginDate					=eud.BeginDate
												 AND	eu.EndDate						= eud.EndDate
												 --AND    eu.EdiFileLogID                = eud.EdiFileLogID
												 AND	eu.MeterNumber					= eud.MeterNumber
												 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
												 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
												 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
												 AND	eu.PTDLoop			= eud.PTDLoop
									WHERE		eud.ID = @Loop  
									    
		                           ---IF same FilelogId - Add up the quantity and update the record
									   
									IF(( @UsageDetailId > 0) AND (@OldEdiFileLogId = @EdiFileLogID))
									    BEGIN
									
											UPDATE EdiUsageDetail
											SET			Quantity = eu.Quantity + eud.quantity,
														TimeStampUpdate	= @Today
											FROM		EdiUsageDetail eu WITH (NOLOCK)
											INNER JOIN	@UsageDetailDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
														 AND	eu.BeginDate					=eud.BeginDate
														 AND	eu.EndDate						= eud.EndDate
														 AND    eu.EdiFileLogID                = eud.EdiFileLogID
														 AND	eu.MeterNumber					= eud.MeterNumber
														 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
														 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
														 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
														 AND	eu.PTDLoop			= eud.PTDLoop
											WHERE		eud.ID = @Loop 

											SELECT	ID = @UsageDetailId;
									   END    
									   --- Here there  may be  a row Exists to be added but later changed to be updated as exact duplicate
									ELSE IF(( @UsageDetailId > 0) AND (@OldEdiFileLogId != @EdiFileLogID))
									    BEGIN
									
											UPDATE EdiUsageDetail
											SET			Quantity = eud.quantity,
														TimeStampUpdate	= @Today,
														EdiFileLogID = @EdiFileLogID
											FROM		EdiUsageDetail eu WITH (NOLOCK)
											INNER JOIN	@UsageDetailDup eud  ON eu.EdiAccountID = eud.EdiAccountID  
														 AND	eu.BeginDate					=eud.BeginDate
														 AND	eu.EndDate						= eud.EndDate
														 AND    eu.EdiFileLogID                 = @OldEdiFileLogId
														 AND	eu.MeterNumber					= eud.MeterNumber
														 AND	eu.MeasurementSignificanceCode	=eud.MeasurementSignificanceCode
														 AND	eu.TransactionSetPurposeCode	= eud.TransactionSetPurposeCode
														 AND	eu.UnitOfMeasurement			= eud.UnitOfMeasurement
														 AND	eu.PTDLoop			= eud.PTDLoop
											WHERE		eud.ID = @Loop 

											SELECT	ID = @UsageDetailId;
									   END         
			                        ELSE --Insert the row as a new row.
									   BEGIN
									            INSERT INTO	EdiUsageDetail
													SELECT EdiAccountID,PTDLoop,BeginDate,EndDate,Quantity,MeterNumber,MeasurementSignificanceCode,TransactionSetPurposeCode,
													UnitOfMeasurement,GETDATE(),GETDATE(),EdiFileLogID
													FROM  @UsageDetailDup  
													where ID = @Loop;

												SELECT	ID = SCOPE_IDENTITY()
									   END
									   
									 SET @Loop		= @Loop + 1
							 END
		
			SET NOCOUNT OFF;
	END
	


