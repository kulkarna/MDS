USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateUpdate]    Script Date: 12/18/2012 11:28:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_AccountContractRateUpdate]
*
* DEFINITION:  Updates a record into AccountContractRate Table
*
* RETURN CODE: 
*
* REVISIONS:	
10/12/2012 Gabor - Add @ProductCrossPriceMultiID
6/24/2011 Jaime Forero
-- =============================================
-- Modified Rick Deigsler 10/17/2012
-- Added MD084 multi-term check/update
-- =============================================
*/

ALTER PROCEDURE [dbo].[usp_AccountContractRateUpdate]
	 @AccountContractRateID	INT = NULL
	,@AccountContractID		INT 
	,@LegacyProductID		CHAR(20) 
    ,@Term					INT 
	,@RateID				INT
	,@Rate					FLOAT
	,@RateCode				VARCHAR(50)
	,@RateStart				DATETIME
	,@RateEnd				DATETIME
	,@IsContractedRate		BIT
	,@HeatIndexSourceID		INT	= NULL
	,@HeatRate				DECIMAL(9,2) = NULL
	,@TransferRate			FLOAT = NULL
	,@GrossMargin			FLOAT = NULL
	,@CommissionRate		FLOAT = NULL
	,@AdditionalGrossMargin	FLOAT = NULL
	,@ModifiedBy			INT
	,@IsSilent				BIT = 0
	,@PriceID				bigint = NULL
	,@ProductCrossPriceMultiID bigint = NULL
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	IF @AccountContractRateID IS NULL OR @AccountContractID IS NULL
		RAISERROR ('Missing required values: @AccountContractRateID or @AccountContractID' , 11, 1);
	
	--IF @AccountContractRateID IS NULL AND @AccountContractID IS NULL
	--	RAISERROR ('Need at least one of the 2: @AccountContractRateID or @AccountContractID' , 11, 1);
	
	--IF @AccountContractRateID IS NULL
	--BEGIN 
	--	SELECT @AccountContractRateID = ACR.AccountContractRateID FROM Libertypower.dbo.AccountContractRate ACR WHERE ACR.AccountContractID = @AccountContractID;
	--END
	
	SET @Rate = CONVERT(DECIMAL(10,5), @Rate)

	------ Multi-term MD084 ---------------------------------------------------------------------
	IF @ProductCrossPriceMultiID IS NOT NULL
		BEGIN
			DECLARE	@ProductCrossPriceMultiIDCurrent	bigint
			
			SELECT	@ProductCrossPriceMultiIDCurrent = ProductCrossPriceMultiID
			FROM	Libertypower..AccountContractRate WITH (NOLOCK)
			WHERE	AccountContractRateID = @AccountContractRateID 
			
			IF @ProductCrossPriceMultiIDCurrent <> @ProductCrossPriceMultiID
				BEGIN
					DECLARE @ACR_RateStart DATETIME;
					DECLARE @ACR_RateEnd DATETIME;
					DECLARE @ACR_Rate FLOAT;
					DECLARE @ACR_Term INT;
					DECLARE @ACR_GrossMargin FLOAT;	
									
					SELECT	@ACR_RateStart				= StartDate,
							@ACR_RateEnd				= DATEADD(dd, -1, DATEADD(mm, Term, StartDate)),
							@ACR_Rate					= Price,
							@ACR_Term					= Term,
							@ACR_GrossMargin			= MarkupRate
					FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK)
					WHERE	ProductCrossPriceMultiID	= @ProductCrossPriceMultiID

					IF @ACR_RateStart IS NOT NULL
						BEGIN
							SET	@RateStart		= @ACR_RateStart
							SET	@RateEnd		= @ACR_RateEnd
							SET	@Rate			= @ACR_Rate
							SET	@Term			= @ACR_Term
							SET	@GrossMargin	= @ACR_GrossMargin
						END				
				END
		END
----------------------------------------------------------------------------------------------
	
	UPDATE [LibertyPower].[dbo].[AccountContractRate]
    SET  [AccountContractID] = @AccountContractID
		,[LegacyProductID] = @LegacyProductID
		,[Term] = @Term
		,[RateID] = @RateID
		,[Rate] = @Rate
		,[RateCode] = ISNULL(@RateCode,RateCode)
		,[RateStart] = @RateStart
		,[RateEnd] = @RateEnd
		,[IsContractedRate] = ISNULL(@IsContractedRate,[IsContractedRate] )
		,[HeatIndexSourceID] = @HeatIndexSourceID
		,[HeatRate] = @HeatRate
		,[TransferRate] = @TransferRate
		,[GrossMargin] = @GrossMargin
		,[CommissionRate] = @CommissionRate
		,[AdditionalGrossMargin] = @AdditionalGrossMargin
		,[Modified] = GETDATE()
		,[ModifiedBy] = @ModifiedBy
		,[PriceID] = ISNULL(@PriceID, [PriceID])
		,[ProductCrossPriceMultiID] = ISNULL(@ProductCrossPriceMultiID, ProductCrossPriceMultiID)
     WHERE AccountContractRateID = @AccountContractRateID 
	;
	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractRateSelect @AccountContractRateID  ;
	
	RETURN @AccountContractRateID;
	
END
