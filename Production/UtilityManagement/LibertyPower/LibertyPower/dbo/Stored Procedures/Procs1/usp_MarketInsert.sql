/*******************************************************************************
 * usp_MarketInsert
 * Inserts market record
 *
 * History
 *******************************************************************************
 * 2/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MarketInsert]
	@MarketCode					varchar(50),
	@RetailMktDescp				varchar(50),
	@WholesaleMktId				int,
	@PucCertification			varchar(50),
	@DateCreated				datetime,
	@Username					varchar(200),
	@InactiveInd				char(1),
	@ActiveDate					datetime,
	@Chgstamp					smallint,
	@TransferOwnershipEnabled	smallint,
	@EnableTieredPricing		tinyint
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	Libertypower..Market (MarketCode, RetailMktDescp, WholesaleMktId, PucCertification_number, 
				DateCreated, Username, InactiveInd, ActiveDate, Chgstamp, TransferOwnershipEnabled, EnableTieredPricing)
	VALUES		(@MarketCode, @RetailMktDescp, @WholesaleMktId, @PucCertification, @DateCreated, 
				@Username, @InactiveInd, @ActiveDate, @Chgstamp, @TransferOwnershipEnabled, @EnableTieredPricing)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
