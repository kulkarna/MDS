
CREATE PROCEDURE [dbo].[usp_MarginThresholdUpdate]
	@ID INT,
	@UserID INT,
	@MarginLow DECIMAL(18, 10),
	@MarginHigh DECIMAL(18, 10),
	@MarginLimit DECIMAL(18, 10),
	@EffectiveDate DATETIME,
	@ExpirationDate DATETIME = NULL
AS
BEGIN
	UPDATE [Libertypower].[dbo].[MarginThreshold]
	SET 	[UserID] = @UserID,
            [MarginLow] = @MarginLow,
            [MarginHigh] = @MarginHigh,
            [MarginLimit] = @MarginLimit,
            [EffectiveDate] = @EffectiveDate,
            [ExpirationDate] = @ExpirationDate
    WHERE [MarginThresholdID] = @ID
END