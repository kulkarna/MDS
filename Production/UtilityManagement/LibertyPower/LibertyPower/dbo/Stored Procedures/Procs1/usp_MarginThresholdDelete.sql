
CREATE PROCEDURE [dbo].[usp_MarginThresholdDelete]
	@ID INT
AS
BEGIN
	DELETE FROM [Libertypower].[dbo].[MarginThreshold]
    WHERE [MarginThresholdID] = @ID
END