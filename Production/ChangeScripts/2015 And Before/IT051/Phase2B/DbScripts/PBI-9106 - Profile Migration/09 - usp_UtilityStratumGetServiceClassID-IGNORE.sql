Use LibertyPower
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityStratumGetServiceClassID
 * Get the stratum end for a stratum variable.
 * EXEC usp_UtilityStratumGetServiceClassID 901
 *******************************************************************************
 * Created by: Cathy Ghazal
 * Date Created: 5/13/2013
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_UtilityStratumGetServiceClassID]
(
	@ServiceClass AS VARCHAR(50)
)

AS

BEGIN

SET NOCOUNT ON;

	SELECT	LoadShapeServiceClass
	FROM	UtilityStratumServiceClassMapping (nolock)
	WHERE	CustomerServiceClass = @ServiceClass
	
SET NOCOUNT OFF;


END




