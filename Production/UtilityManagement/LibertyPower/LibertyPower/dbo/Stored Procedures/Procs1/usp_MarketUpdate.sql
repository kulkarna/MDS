/*******************************************************************************
 * usp_MarketUpdate
 * Updates market record
 *
 * History
 *******************************************************************************
 * 2/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MarketUpdate]
	@ID							int,
	@MarketCode					varchar(50),
	@RetailMktDescp				varchar(50),
	@WholesaleMktId				int,
	@PucCertification			varchar(50),
	@Username					varchar(200),
	@InactiveInd				char(1),
	@ActiveDate					datetime,
	@Chgstamp					smallint,
	@TransferOwnershipEnabled	smallint,
	@EnableTieredPricing		tinyint
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE	Libertypower..Market
	SET		MarketCode					= @MarketCode, 
			RetailMktDescp				= @RetailMktDescp, 
			WholesaleMktId				= @WholesaleMktId, 
			PucCertification_number		= @PucCertification, 
			Username					= @Username,
			InactiveInd					= @InactiveInd, 
			ActiveDate					= @ActiveDate, 
			Chgstamp					= @Chgstamp, 
			TransferOwnershipEnabled	= @TransferOwnershipEnabled,
			EnableTieredPricing			= @EnableTieredPricing
	WHERE	ID							= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
