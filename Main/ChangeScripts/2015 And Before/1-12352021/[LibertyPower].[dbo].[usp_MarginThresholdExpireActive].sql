USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_MarginThresholdExpireActive]    Script Date: 08/02/2012 17:19:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_MarginThresholdExpireActive]
	@UserID INT,
	@MarginLow DECIMAL,
	@MarginHigh DECIMAL,
	@EffectiveDate DATETIME
AS
BEGIN
	DECLARE @MarginThresholdID INT;
	UPDATE [Libertypower].[dbo].[MarginThreshold]
    SET    [ExpirationDate] = @EffectiveDate
    WHERE	[UserID] = @UserID
    AND		[MarginLow] = @MarginLow
    AND		[MarginHigh] = @MarginHigh
    AND		[EffectiveDate] <= @EffectiveDate
    AND		[ExpirationDate] IS NULL
    
END
