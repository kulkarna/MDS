
CREATE PROCEDURE [dbo].[usp_ProfilingQueueInsert]  

@OfferID varchar(50),
@Owner varchar(50)

AS

DECLARE @OfferExists bit

SET @OfferExists = 0

IF (SELECT COUNT(*) FROM ProfilingQueue WHERE OfferID = @OfferID AND [Status] <= 3) > 0
    SET @OfferExists = 1


IF @OfferExists = 0
BEGIN
    INSERT INTO ProfilingQueue (OfferID, [Owner]) VALUES (@OfferID, @Owner)

    DECLARE @ID INT
    SET @ID = SCOPE_IDENTITY()
	
    SELECT ID, OfferID, [Owner], [Status], NumberOfAccountsTotal, NumberOfAccountsRemaining, DateStarted, DateCompletedOrCanceled, CanceledBy, DateCreated, ResultOutput
    FROM ProfilingQueue 
    WHERE ID = @ID
END
ELSE
BEGIN
    SELECT ID, OfferID, [Owner], [Status], NumberOfAccountsTotal, NumberOfAccountsRemaining, DateStarted, DateCompletedOrCanceled, CanceledBy, DateCreated, ResultOutput
    FROM ProfilingQueue 
    WHERE OfferID = @OfferID AND [Status] = 0 OR [Status] = 1
END
