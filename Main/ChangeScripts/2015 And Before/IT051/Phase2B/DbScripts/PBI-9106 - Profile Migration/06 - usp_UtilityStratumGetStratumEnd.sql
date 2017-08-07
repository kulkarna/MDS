USE LibertyPower
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_UtilityStratumGetStratumEnd
 * Get the stratum end for a stratum variable.
 * EXEC usp_UtilityStratumGetStratumEnd 18, 100, '1'
 *******************************************************************************
 * Created by: Cathy Ghazal
 * Date Created: 5/13/2013
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_UtilityStratumGetStratumEnd]
(	@UtilityID AS INT,
	@Stratum AS FLOAT,
	@ServiceClass AS VARCHAR(50)
)

AS

BEGIN
	
	SET NOCOUNT ON;
	
	-- GEt the stratum END a stratum variable belongs to
	SELECT	Min(StratumEnd) as StratumEnd
	FROM	UtilityStratumRange (NOLOCK)
	WHERE	UtilityID = @UtilityID
	AND		SErviceRateClass = @ServiceClass
	AND		@Stratum <= StratumEnd

	SET NOCOUNT OFF;
END