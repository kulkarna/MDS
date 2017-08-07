
CREATE PROCEDURE [dbo].[usp_DailyPricing_UpdateLegacyRates_Job]
AS
BEGIN

	DECLARE @ProductId			varchar(20)
		,@RateId				int
		,@Rate					float
		,@Terms					int
		,@EffDate				dateTime
		,@DueDate				dateTime
		,@GrossMargin			decimal(9,6)
		,@RateDescription		varchar(250)
		,@i						int
		,@TotalRecords			int
		,@Counter				int
		,@Message				varchar(100)
		,@ErrorMessage			NVARCHAR(1000)
		,@ErrorMessageext		NVARCHAR(1000)
		,@ErrorSeverity			INT
		,@ErrorState			INT 
		,@ErrorNumber			int

	Select top 1 @i = StagingID from DailyPricingUpdateLegacyRates_Stage (nolock) where IsProcessed = 0 order by StagingID

	SELECT @TotalRecords = COUNT(StagingID) FROM DailyPricingUpdateLegacyRates_Stage WITH (NOLOCK) WHERE IsProcessed = 0

	SET	@Counter = 0
	
	if @i is null
		Select @i = max(StagingID) + 1 from DailyPricingUpdateLegacyRates_Stage (nolock)

	While  @i <= (Select max(StagingID) from DailyPricingUpdateLegacyRates_Stage (nolock))
	begin
		BEGIN TRY
			select @ProductId = ProductID, @RateId = RateId, @Rate = Rate, @Terms = Terms, 
			@EffDate = EffDate, @DueDate = DueDate, @GrossMargin = GrossMargin, @RateDescription = RateDescription
			from DailyPricingUpdateLegacyRates_Stage WITH (NOLOCK) where StagingId = @i;

			BEGIN TRANSACTION
     
			EXEC usp_DailyPricing_UpdateLegacyRates @ProductId, @RateId, @Rate, @Terms, @EffDate, @DueDate, @GrossMargin, @RateDescription;
    
			UPDATE dbo.DailyPricingUpdateLegacyRates_Stage SET IsProcessed = 1 WHERE StagingID = @i;
     
			SET @Counter = @Counter + 1

			IF @Counter % 10000 = 0
			BEGIN
				--	write progress to log
				SET @Message = 'Legacy rate update - ' + CAST(@Counter AS varchar(10)) + ' of ' + CAST(@TotalRecords AS varchar(10)) + ' rates updated.'
				exec usp_DailyPricingLogInsert_New 3, 8, @Message, NULL, 0		
			END

			COMMIT TRANSACTION
    
			Set @i = @i + 1;
		END TRY
		BEGIN CATCH
			-- temporary, do not handle error, rollback transaction, continue
			
			--SELECT  @ErrorNumber		= ERROR_NUMBER(),
			--	@ErrorMessage			= ERROR_MESSAGE(), 
			--	@ErrorMessageext		= Case 
			--			when ERROR_PROCEDURE() is  null then 'SQLError#: ' + convert(varchar,@ErrorNumber) + 
			--			', "' + ERROR_MESSAGE() + '"' + ', Sql in Procedure: ' + isnull(OBJECT_NAME(@@PROCID),'') + 
			--			', Line#: ' + convert(varchar,ERROR_LINE())
			--			else 'SQLError#: ' + convert(varchar,@ErrorNumber) + ', "' + ERROR_MESSAGE() + '"' + ', Procedure: ' + 
			--			isnull(ERROR_PROCEDURE(),'') + ', Line#: ' + convert(varchar,ERROR_LINE())
			--			end,
			--	@ErrorSeverity			= ERROR_SEVERITY(),
			--	@ErrorState				= ERROR_STATE();

			--EXEC usp_DailyPricingLogInsert_New 1, 8, @ErrorMessageext, NULL, 0	
      
			IF @@TRANCOUNT >0
				ROLLBACK TRANSACTION

			--drop table #tempProduct 
			      
			--RAISERROR (@ErrorMessageext, @ErrorSeverity, @ErrorState);
			--BREAK;
		END CATCH
	end
  
	--	write progress to log
	SET @Message = 'Legacy rate update - ' + CAST(@Counter AS varchar(10)) + ' of ' + CAST(@TotalRecords AS varchar(10)) + ' rates updated.'
	exec usp_DailyPricingLogInsert_New 3, 8, @Message, NULL, 0		
			  
	--	write to log
	exec usp_DailyPricingLogInsert_New 3, 8, 'Legacy rate update - update job completed.', NULL, 0	


END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricing_UpdateLegacyRates_Job';

