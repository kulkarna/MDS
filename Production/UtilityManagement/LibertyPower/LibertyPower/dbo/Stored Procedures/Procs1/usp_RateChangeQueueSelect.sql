-- =============================================
-- Author:		Jaime Forero
-- Create date: 07-12-2010
-- =============================================
CREATE PROCEDURE [dbo].[usp_RateChangeQueueSelect]
	@ID INT = NULL,
	@CurrentRateChangeId INT = NULL,
	@NumUpdates INT = NULL,
	@ActualUpdates INT = NULL,
	@Finished BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM [RateChangeQueue]
	WHERE [ID] = ISNULL(@ID, [ID])
	AND [CurrentRateChangeId] = ISNULL(@CurrentRateChangeId, [CurrentRateChangeId])
	AND [NumUpdates] = ISNULL(@NumUpdates, [NumUpdates])
	AND [ActualUpdates] = ISNULL(@ActualUpdates, [ActualUpdates])
	AND [Finished] = ISNULL(@Finished, [Finished])
	;
	
END


