

CREATE PROCEDURE [dbo].[usp_offer_add_terms_prices_flow_dates]
@terms_prices_flow_dates dbo.tvp_ocou_terms_prices_flow_dates READONLY,
@p_offer_id	VARCHAR(50),
@p_use_int_tran BIT = 1,
@p_debug BIT = 0

AS
SET NOCOUNT ON;

DECLARE @Dates TABLE (
	[Count] [int] IDENTITY(1,1) NOT NULL,
	[FLOW_START_DATE] [date] NOT NULL,
	[FLOW_START_DATE_ID] NVARCHAR(50) NULL
);
INSERT  INTO @Dates (FLOW_START_DATE) SELECT  DISTINCT FlowStartDate FROM @terms_prices_flow_dates;

DECLARE @Terms TABLE (
	[Count] [int] IDENTITY(1,1) NOT NULL,
	[FLOW_START_DATE_ID] NVARCHAR(50) NULL,
	[TERMS_AND_PRICES_ID] VARCHAR(50) NULL,
	[FLOW_START_DATE] DATE,
	[TERM] [int] NULL,
	[PRICE] decimal(16,2) NULL
);
INSERT INTO @Terms (FLOW_START_DATE, TERM, PRICE) SELECT DISTINCT FlowStartDate, Term, Price FROM @terms_prices_flow_dates;

BEGIN TRY
	IF @p_use_int_tran = 1 BEGIN TRAN
	
		DECLARE
			@dates_count INT = (SELECT MAX([Count]) FROM @Dates),
			@flow_start_date_id  nvarchar(50),
			@flow_start_date DATE,
			@current_date_count INT = 1;
			
		WHILE @current_date_count <= @dates_count BEGIN
			EXEC dbo.usp_generate_id 'FLOW_START_DATE_ID', @flow_start_date_id OUTPUT;
			UPDATE @Dates SET FLOW_START_DATE_ID = @flow_start_date_id WHERE [Count] = @current_date_count
			SET @current_date_count = @current_date_count + 1;
		END
		IF @p_debug = 1 SELECT * FROM @Dates
		
		DECLARE
			@total_terms INT = (SELECT MAX([Count]) FROM @Terms),
			@terms_and_prices_id  nvarchar(50),
			@current_term INT = 1;
		
		WHILE @current_term <= @total_terms BEGIN
			EXEC dbo.usp_generate_id 'TERMS_AND_PRICES_ID', @terms_and_prices_id OUTPUT;
			UPDATE @terms SET TERMS_AND_PRICES_ID = @terms_and_prices_id WHERE [Count] = @current_term
			SET @current_term = @current_term + 1;
		END
		IF @p_debug = 1 SELECT * FROM @Terms

		INSERT INTO [dbo].[OE_OFFER_FLOW_DATES] SELECT FLOW_START_DATE_ID, @p_offer_id, FLOW_START_DATE FROM @Dates
		INSERT INTO [dbo].[OE_TERMS_AND_PRICES]
           ([TERMS_AND_PRICES_ID]
           ,[FLOW_START_DATE_ID]
           ,[TERM]
           ,[PRICE])
		 SELECT 
			t.TERMS_AND_PRICES_ID,
			d.FLOW_START_DATE_ID,
			t.TERM,
			t.PRICE
		 FROM
			@terms_prices_flow_dates td 
			INNER JOIN @Dates d ON td.FlowStartDate = d.FLOW_START_DATE
			INNER JOIN @Terms t ON 
			(
				td.FlowStartDate = t.FLOW_START_DATE
				AND td.Term = t.TERM
				AND td.Price = t.PRICE
			);
    IF @p_use_int_tran = 1 COMMIT TRAN
END TRY
BEGIN CATCH
	IF @p_use_int_tran = 1 ROLLBACK TRAN
	DECLARE 
		@ErrorMessage NVARCHAR(4000),
		@ErrorSeverity INT,
		@ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();
           
    RAISERROR (@ErrorMessage,
               @ErrorSeverity,
               @ErrorState );
END CATCH


