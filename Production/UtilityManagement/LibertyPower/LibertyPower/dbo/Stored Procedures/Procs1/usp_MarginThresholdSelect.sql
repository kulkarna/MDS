
CREATE PROCEDURE [dbo].[usp_MarginThresholdSelect]
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT m.*
	FROM LibertyPower.dbo.MarginThreshold m with (nolock)
	JOIN LibertyPower.dbo.[User] u ON m.UserID = u.UserID
	ORDER BY u.FirstName, m.MarginLow
	
END	
