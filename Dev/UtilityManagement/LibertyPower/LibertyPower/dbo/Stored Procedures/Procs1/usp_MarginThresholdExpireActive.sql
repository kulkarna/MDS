
CREATE PROCEDURE [dbo].[usp_MarginThresholdExpireActive]
	@ID INT,
	@UserID INT,
	@MarginLow DECIMAL,
	@MarginHigh DECIMAL,
	@EffectiveDate DATETIME
AS
BEGIN
	DECLARE @MarginThresholdID INT;
	UPDATE [Libertypower].[dbo].[MarginThreshold]
    SET    [ExpirationDate] = @EffectiveDate
    WHERE	[MarginThresholdID] <> @ID
    AND		[UserID] = @UserID
    AND		[MarginLow] <= @MarginHigh
    AND		[MarginHigh] >= @MarginLow
    AND		[EffectiveDate] <= @EffectiveDate
    AND		[ExpirationDate] IS NULL
    
END
