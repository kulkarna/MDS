-- =============================================
-- Author:		Jaime Forero
-- Create date: 07-07-2010
-- =============================================
CREATE PROCEDURE [dbo].usp_RateChangeQueueInsert
	@NumUpdates INT,
	@CreatedBy INT
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO RateChangeQueue ([NumUpdates],[CreatedBy]) VALUES (@NumUpdates, @CreatedBy);
	
	DECLARE @ID int;
    SET @ID = SCOPE_IDENTITY();

	IF @ID IS NOT NULL
	BEGIN
	   SELECT * FROM [RateChangeQueue]
	   WHERE [RateChangeQueue].ID = @ID;
	END
END

