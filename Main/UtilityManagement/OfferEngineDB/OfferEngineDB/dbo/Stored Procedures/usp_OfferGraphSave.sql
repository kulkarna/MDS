CREATE PROCEDURE [dbo].[usp_OfferGraphSave]
@p_xml AS XML,
@p_is_refresh TINYINT = 0,
@p_use_int_tran BIT = 1,
@p_offer_id VARCHAR(50) = NULL OUTPUT

AS
SET NOCOUNT ON;

DECLARE 
	@terms AS dbo.tvp_ocou_terms_prices_flow_dates,
	@accounts AS dbo.tvp_ocou_accounts,
	@offerSuffix VARCHAR(50),
	@pricingRequestId VARCHAR(50),
	@product NVARCHAR(50),
	@p_offer_id_temp VARCHAR(50),
	@status NVARCHAR(50);

SELECT @p_offer_id_temp =
	'OF-' + REPLACE(STR(
		ISNULL((
			SELECT 
				CAST(substring(offer_id,4,6) AS INT) 
			FROM 
				dbo.OE_OFFER (NOLOCK) 
			WHERE 
				DATE_CREATED = 
				(
					SELECT 
						MAX(DATE_CREATED) 
					FROM 
						OE_OFFER (NOLOCK) 
					WHERE 
						OFFER_ID LIKE 'of%'
				)
		),0) + 1, 6, 0), ' ', '0') + '-1'
SELECT 
		 @pricingRequestId = M.Item.query('./PricingRequestId').value('.','VARCHAR(50)')
		,@p_offer_id = ISNULL(M.Item.query('./OfferId').value('.','VARCHAR(50)'),@p_offer_id_temp)
		,@offerSuffix = M.Item.query('./SuffixId').value('.','VARCHAR(50)')
		,@product = M.Item.query('./Product').value('.','NVARCHAR(50)')
		,@status = M.Item.query('./Status').value('.','NVARCHAR(50)')
FROM @p_xml.nodes('/Offer') AS M(Item);
IF (@p_offer_id IS NULL OR LTRIM(RTRIM(@p_offer_id)) = '')
	SET @p_offer_id = @p_offer_id_temp

INSERT INTO @accounts (AccountNumber)
SELECT 
		M.Item.query('./AccountNumber').value('.','varchar(50)') AccountNumber
FROM @p_xml.nodes('/Offer/Accounts/OfferAccount') AS M(Item);

INSERT INTO @terms (Term, Price, FlowStartDate)
SELECT 
		M.Item.query('./Term').value('.','int') Term
		,M.Item.query('./Price').value('.','decimal(16,2)') Price
		,M.Item.query('./FlowStartDate').value('.','datetime') FlowStartDate
FROM @p_xml.nodes('/Offer/Terms/OfferTerm') AS M(Item);


BEGIN TRY
	IF @p_use_int_tran = 1 BEGIN TRAN
SET @p_offer_id = ISNULL(@p_offer_id,@p_offer_id_temp)

		EXECUTE [dbo].[usp_offer_create_or_update] 
		   @p_accounts = @accounts
		  ,@terms_prices_flow_dates = @terms
		  ,@p_pricing_request_id = @pricingRequestId
		  ,@p_offer_id = @p_offer_id OUTPUT
		  ,@p_product = @product
		  ,@p_is_refresh = @p_is_refresh
		  ,@p_use_int_tran = 0
		  ,@p_offer_id_suffix = @offerSuffix
		  ,@p_status = @status;

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

