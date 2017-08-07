
CREATE PROCEDURE [dbo].[usp_MarginThresholdInsert]
	@UserID INT,
	@MarginLow DECIMAL(18, 10),
	@MarginHigh DECIMAL(18, 10),
	@MarginLimit DECIMAL(18, 10),
	@EffectiveDate DATETIME,
	@ExpirationDate DATETIME = NULL
AS
BEGIN
	DECLARE @MarginThresholdID INT;
	INSERT INTO [Libertypower].[dbo].[MarginThreshold]
           (	[UserID],
				[MarginLow],
				[MarginHigh],
				[MarginLimit],
				[EffectiveDate],
				[ExpirationDate])
     VALUES
           (
            @UserID,
            @MarginLow,
            @MarginHigh,
            @MarginLimit,
            @EffectiveDate,
            @ExpirationDate
            )
    ;
	SET @MarginThresholdID  = SCOPE_IDENTITY();
	
	RETURN @MarginThresholdID;
END
