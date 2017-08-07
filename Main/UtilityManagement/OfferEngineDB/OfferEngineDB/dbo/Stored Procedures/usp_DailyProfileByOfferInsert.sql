
/*******************************************************************************
 * usp_DailyProfileByOfferInsert
 * Stores the daily profiles used by offer/account number
 *
 * History
 *******************************************************************************
 * 03/06/2009 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyProfileByOfferInsert]
	@AccountNumber	varchar(50),
	@DailyProfileId	int,
	@OfferId		varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (
		SELECT	AccountNumber
		FROM	DailyProfileByOffer (nolock)
		WHERE	OfferId = @OfferId
			AND	AccountNumber = @AccountNumber
			AND DailyProfileId = @DailyProfileId
			AND BeginDate = @BeginDate
			AND EndDate = @EndDate )

	  BEGIN
		INSERT INTO	DailyProfileByOffer
				(AccountNumber, DailyProfileId, OfferId, BeginDate, EndDate)
		VALUES (RTRIM(@AccountNumber), @DailyProfileId, UPPER(RTRIM(@OfferId)), @BeginDate, @EndDate)
	  END

	SELECT	ID, AccountNumber, DailyProfileId, OfferId, BeginDate, EndDate
	FROM	DailyProfileByOffer (nolock)
	WHERE	OfferId = @OfferId
		AND	AccountNumber = @AccountNumber
		AND DailyProfileId = @DailyProfileId
		AND BeginDate = @BeginDate
		AND EndDate = @EndDate

    SET NOCOUNT OFF;
  END                                                                                                                                              
-- Copyright 2009 Liberty Power

