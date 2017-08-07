/*******************************************************************************
 * usp_ForecastMonthlyUsageHeaderInsert
 * Insert forecast usage header record
 *
 * History
 *******************************************************************************
 * 4/1/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ForecastMonthlyUsageHeaderInsert]
	@OfferId			varchar(50),
	@AccountNumber		varchar(50),
	@Created			datetime,
	@CreatedBy			varchar(50)
	

AS

BEGIN
    SET NOCOUNT ON;

	INSERT INTO	ForecastMonthlyUsageHeader (OfferId, AccountNumber, Created, CreatedBy)
	VALUES		(@OfferId, @AccountNumber, @Created, @CreatedBy)

	SELECT	@@IDENTITY

	SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
